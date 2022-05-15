
library(shiny)
library(DT)
library(gt)
library(dplyr)
library(glue)
library(data.table)
source("fct_create_matrix.R")


ui <- navbarPage(title = "BETA Overlay Mosaic Crochet Design Tool",
  tabPanel("Design Tool",
    sidebarLayout(
      sidebarPanel(width = 3,
                   uiOutput("mystyle"),
        h2("Changing any of these deletes any data you've inputted!!!"),
        shiny::numericInput("numrows", "Choose an ODD NUMBER of rows from 5 to 51:", value = 11, min = 5, max = 51, step = 2),
        shiny::numericInput("numcols", "Choose number of columns from 5 to 50:", value = 10, min = 5, max = 50),
        shiny::textInput("patterncolor", "Pattern color:", value = "cornflowerblue"),
       shiny::textInput("maincolor", "Main (background) color:", value = "white"),
       em("Colors can be hex codes or ", a("valid R color names", href="https://r-graph-gallery.com/42-colors-names.html")),
        br(),
        shiny::textInput("title", "Title for your pattern:", value = "Mosaic Crochet Pattern")
                              
                    ),
      mainPanel(
        HTML("<h2><em>Experimental</em> Overlay Mosaic Crochet Pattern Chart Generator</h2>"),
        p("Choose your grid size, main (background) color, pattern color, and optional pattern title at left. **Number of rows must be odd.**"),
        p("To create your pattern, click on grid squares in the table below to toggle cell colors. Click the 'Generate chart' button below your 'drawing table', and the crochet pattern chart will be created in a second grid below."),
        p("Red on the chart means your design has 2 dc stitches in consecuritve rows, which won't work. Also, while the top row is clickable, it won't do anything because there is no row above to add a double crochet."),
        p("This system does not store you work! You may want to download results from time to time. Of course, when finished, download chart as an HTML file."),
        p("You can open the resulting HTML file in your browser. If you want a PDF, I suggest using a free Web tool such as", a(href = 'https://cloudconvert.com/html-to-pdf', 'Cloudconvert.com')),
        p("Tool by Sharon Machlis coded in the R programming language. If you make something cool with this, please feel free to share your pattern with me!"),
        DTOutput("maintable"),
        br(),
        actionButton("createChart", "Generate pattern!", class = "btn btn-success"),
       br(),br(),
        uiOutput("downloadButtonPlaceholder"),
        htmlOutput("headline"),
        gt::gt_output("patterntable"),
        # verbatimTextOutput("myselected"),
        br()
        
      )
    )
                          
  ), # end tab1

  tabPanel("FAQ",
           includeMarkdown("faq.md")                   
                           
  ) #end tab2
) # end UI


server <- function(input, output, session) {
  

  
  output$headline <- renderUI({
     req(input$title, pattern_table_body())
     HTML(paste0("<center><h2>", input$title, "</h2></center>"))
    
  })
  
  
# Create initial data frame with user's requested row and column dimensions ----
  mydf1 <- reactive({
    validate(need(input$numrows >= 5 & input$numrows <= 51 & input$numcols >= 5 & input$numcols <= 50 & input$numrows %% 2 == 1, "Number of rows must be odd and between 5 and 51. Number of columns must be between 5 and 50."))
    req(input$numrows, input$numcols)
    mydf <- create_df(input$numrows, input$numcols)
  })

# Create reactive value for selected cells
  selected_df <- reactive({
    created_selected_df(input$maintable_cells_selected)
  })
  
# Create long data frame combining initial data with selected data
mydf_with_selected_long <- eventReactive(input$createChart, {
  req(mydf1(), selected_df())
  update_df_with_selected_long(mydf1(), selected_df())
})
  
  
# Create the first table where user can click to draw ----
  output$maintable <- renderDT(
     create_drawing_table(mydf1(), 30)
  )

# Create 2nd table in response to user drawing on 1st table ----
 output$patterntable <- gt::render_gt({
  req(pattern_table_body())
  pattern_table_body()
   
 })
  
pattern_table_body <- reactive({
  req(mydf_with_selected_long())
  create_pattern_table(get_updated_with_selected_wide(mydf_with_selected_long(), "HTMLValue"), input$patterncolor)
})

# Download button
output$downloadButtonPlaceholder <- renderUI({
  req(pattern_table_body())
  downloadButton('report', "Download pattern table", class = ".btn .btn-info")
})

# Generate report and needed files/CSS ----
output$report <- shiny::downloadHandler(
  filename = paste0("pattern", Sys.Date(), ".html"),
  content = function(file) {
    tempReport <- file.path(tempdir(), "pattern.Rmd")
    file.copy("pattern.Rmd", tempReport, overwrite = TRUE)
    
    params <- list(
      mytableobject = pattern_table_body(),
      mypatterncolor = input$patterncolor,
      mymaincolor = input$maincolor,
      mytitle = input$title
    )
    
    rmarkdown::render(tempReport, output_file = file,
                      params = params,
                      envir = new.env(parent = globalenv())
                      )
    
  }
  
  
)




  
# Helper functions ----
# .gt_table tr:nth-child(3) > td:nth-child(4)  {{background-color: purple !important;}} # targets cell by location

## Sets colors of first table for user selections only based on user action
  output$mystyle <- renderUI({
    tags$style(HTML(
      glue::glue(
        "table.dataTable tr:nth-child(odd) td {{background-color: {input$maincolor}; }}
        table.dataTable tr:nth-child(even) td {{background-color: {input$patterncolor};}}
        .gt_table .Danger {{background-color: red !important;}}
        .gt_table .gt_row {{padding-right: 0 !important;}}
        .gt_table .gt_row {{padding-left: 0 !important;}}
         .gt_table .gt_row {{text-align: center !important;}}
         .gt_table .gt_row {{font-weight: bold !important;}}
        .gt_table .gt_row .gt_from_md .RegularOdd {{background-color: {input$maincolor} !important;}}
        .gt_table .gt_row .gt_from_md .RegularEven {{background-color: {input$patterncolor} !important;}}
        .gt_table .gt_row .gt_from_md .OppositeOdd {{background-color: {input$patterncolor} !important;}}
        .gt_table .gt_row .gt_from_md .OppositeEven {{background-color: {input$maincolor} !important;}}

        table.dataTable tr:nth-child(odd) td.selected {{background-color: {input$patterncolor} !important;}}
        table.dataTable tr:nth-child(even) td.selected {{background-color: {input$maincolor} !important;}}"
      )
    ))
  })
  




 
  
## Dev ----
# print selected cells wrangled data frame
#  output$myselected = renderPrint(selected_df())
  
  
} # end app

shinyApp(ui = ui, server = server)

