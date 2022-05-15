is.odd <- function(myint) {
  ifelse(myint %% 2 == 1, TRUE, FALSE)
}

is.even <- function(myint) {
  ifelse(myint %% 2 == 0, TRUE, FALSE)
}



#' create_df
#'
#' data frame with every value " " based on user input
#'
#' @param input.numrows integer with number of rows
#' @param input.numcols integer with number of columns
#'
#' @description Create a data frame where every column is a space with numrows rows plus a final column with Row numbers as integers in reverse order for Mosaic crochet
#'
#' @return data frame
#'
#' @noRd 

create_df <- function(input.numrows = 12, input.numcols = 12) {
  thematrix <- matrix(" ", nrow = input.numrows, ncol = input.numcols,
                   dimnames = list(
                     seq.int(1,input.numrows,1),
                     seq.int(1, input.numcols, 1)))
 mydf <- data.frame(thematrix)
 mydf$Row <- input.numrows:1
 names(mydf)[1:input.numcols] <- gsub("X", "", names(mydf[1:input.numcols]))
 return(mydf)
}


update_df_with_selected_long <- function(mydf1, myselected) {
  setDT(mydf1)
  setDT(myselected)
  mydf1$Row <- NULL
  myselected[, Row := as.integer(Row)][, Column := as.integer(Column)][, Selected := "Yes"]
  mydf1$Row <- 1:nrow(mydf1)
  mydf_long <- melt(mydf1, id.vars = "Row", variable.name = "Column", value.name = "Value", variable.factor = FALSE, value.factor = FALSE)
  mydf_long[, Column := as.integer(Column)]

  myresult <- merge(mydf_long, myselected, all.x = TRUE, all.y = FALSE)
  myresult[, Selected := ifelse(is.na(Selected), "No", "Yes")]
  setorder(myresult, Column, Row)
  # ehcking if this should be 1 or 0
  myresult[, Value := ifelse(Row > 0 & lead(Selected) == "Yes", "X", "&nbsp;"), by = "Column"][, Value := ifelse(is.na(Value), " ", Value), by = "Column"]
  myresult[, Conflict := ifelse(Value == "X" & (lag(Value) == "X" | lead(Value) == "X"), "Yes", "No"), by = "Column"][, Conflict := ifelse(is.na(Conflict), "No", Conflict)]

  myresult[, Class := fcase(
    Conflict == "Yes", "Danger",
    Conflict == "No" & Selected == "No" ,"Regular",
    Conflict == "No" & Selected == "Yes", "Opposite"
  )]
  myresult[, Class := fcase(
    Class == "Regular" & is.odd(Row), "RegularOdd",
    Class == "Regular" & is.even(Row), "RegularEven",
    Class == "Opposite" & is.even(Row), "OppositeEven",
    Class == "Opposite" & is.odd(Row), "OppositeOdd",
    Class == "Danger", "Danger"
  )]
  myresult[, HTMLValue := paste0("<div class = '", Class, "'>", Value, "</div>")]
  return(myresult)
}




get_updated_with_selected_wide <- function(longdf, mycol) {
  mycols <- c("Row", "Column", mycol)
  mydf <- longdf[, ..mycols]
  # mydf_very_wide <- dcast(longdf, Row ~ Column, value.var = c("Value", "Selected", "Conflict"))
  mydf_wide <- dcast(mydf, Row ~ Column)
  mydf_wide$Rw <- rev(mydf_wide$Row)
  mydf_wide[, Rw := ifelse(Rw %% 2 == 1, 
    paste0("<div class = '", "RegularOdd", "'>", Rw, "</div>"),
    paste0("<div class = '", "RegularEven", "'>", Rw, "</div>"))]
  mydf_wide$Row <- NULL
  return(mydf_wide)
}




#' Create usable data frame from DT selected cells
#' 
#' Accounts for JavaScript indexing starting at zero
#'
#' @param newrows - matrix of selected cells in table
#'
#' @return data frame
#'
created_selected_df <- function(newrows) {
  base_df <- data.frame("Row"= 0, "Column" = 0)
  mydf <- as.data.frame(newrows)
  if(nrow(mydf) > 0 & ncol(mydf) > 0) {
    names(mydf) <- c("Row", "Column")
    mydf$Column <- mydf$Column + 1
    return(mydf)
  } else {
    return(base_df)
  }
}

#' create_drawing table
#'
#' @description Create first table where user clicks to draw pattern
#'
#' @return DT table
#'
#' @noRd
#'
create_drawing_table <- function(mydata, mycellwidth) {
  mytable <- DT::datatable(mydata, selection = list(target = 'cell'), class = 'cell-border compact', rownames = FALSE, escape = FALSE,
                               callback = JS("table.on('click.dt', 'td', function() {
          var row_=table.cell(this).index().row;
          var col=table.cell(this).index().column;
          var data = [row_, col];
          Shiny.onInputChange('rows',data );
                    });"),     
                               options = list(
                                 dom='t',ordering=F, pageLength = nrow(mydata),
                                 autoWidth = TRUE,
                                 columnDefs = list(
                                   list(width = mycellwidth, targets = "_all")
                                 )
                               )
  )
}



create_pattern_table <- function(wide_df, patterncolor = "cornflowerblue"){ 
  # reverse display of column names
  num_cols_minus_one <- ncol(wide_df) - 1
  colnames(wide_df)[1:num_cols_minus_one] <- rev(colnames(wide_df)[1:num_cols_minus_one])
  
  gt(wide_df, rowname_col = NULL) |>
    fmt_markdown(columns = c(names(wide_df))) |> # display HTML as HTML
    cols_width(
      everything() ~ px(32)
    ) |>
    tab_options(data_row.padding = px(0)
             #   row.striping.background_color = patterncolor
    ) |>
    tab_style(
      style = cell_borders(
        sides = c("right", "left"),
        color = "black",
        weight = px(1),
        style = "solid"
      ),
      locations = cells_body(
        columns = everything(),
        rows = everything()
      )
    )  
  #  opt_row_striping()
  #  tab_style(
  #    style = list(
  #      cell_fill(color = "lightcyan")
  #    ),
  # locations = cells_body(
  #  columns = 1:ncol(wide_df),
  #  rows = stringr::str_detect(1:nrow(wide_df), "RegularEven")
  # )
  #  )
  }
  
  
  