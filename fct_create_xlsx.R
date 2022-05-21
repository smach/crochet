
fct_create_xlsx <- function(df_html, df_value, mymaincolor = "white", mypatterncolor = "cornflowerblue") {
  df_value <- df_value[ ,
    lapply(
      .SD, function(x){gsub("(^.*?)&nbsp;(.*?$)", "\\1 \\2", x)}
    )]
  df_value[, Rw := gsub(".*?(\\d{1,2}).*?$", "\\1", Rw)]
 # df_value$Rw <- NULL
 #  df_html$Rw <- NULL
  
  pattern_color_cells <- apply(df_html, 1, function(x) which(grepl("OppositeOdd|RegularEven", x)))
  main_color_cells <- apply(df_html, 1, function(x) which(grepl("OppositeEven|RegularOdd", x)))
  danger_color_cells <- apply(df_html, 1, function(x) which(grepl("Danger", x)))
  
  
  mainColorStyle <- createStyle(fgFill = mymaincolor, borderStyle = "thick", border = c("top", "left", "bottom", "right"))
  patternColorStyle <- createStyle(fgFill = mypatterncolor, borderStyle = "thick", border = c("top", "left", "bottom", "right"))
  dangerColorStyle <- createStyle(fgFill = "red", borderStyle = "thick", border = c("top", "left", "bottom", "right"))
  
  wb <- createWorkbook()
  addWorksheet(wb, "pattern")
  writeData(wb, 1, df_value, borders = "all", colNames = FALSE)
  


  for(i in 1:length(pattern_color_cells)) {
    if(length(pattern_color_cells[[i]]) > 0) {
      addStyle(wb, "pattern", cols = unlist(pattern_color_cells[i]), rows = i, style = patternColorStyle)
    }
  }

  for(i in 1:length(main_color_cells)) {
    if(length(main_color_cells[[i]]) > 0) {
      addStyle(wb, "pattern", cols = unlist(main_color_cells[i]), rows = i, style = mainColorStyle)
    }
  }
  
if(length(danger_color_cells) > 0) {  
  for(i in 1:length(danger_color_cells)) {
    if(length(danger_color_cells[[i]]) > 0) {
      addStyle(wb, "pattern", cols = unlist(danger_color_cells[i]), rows = i, style = dangerColorStyle)
    }
  }
}
  
  # writeData(wb, 1, df_value, colNames = FALSE)
  return(wb)
  
}
