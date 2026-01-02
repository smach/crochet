

create_written_instructions <- function(df_value) {
  # Custom function to replace knitr::combine_words
  combine_words_custom <- function(words) {
    if (length(words) == 0) return("")
    if (length(words) == 1) return(words)
    if (length(words) == 2) return(paste(words, collapse = " and "))
    paste(paste(words[-length(words)], collapse = ", "), "and", words[length(words)])
  }
  
  # Need to reverse data frame
  df_value$Rw <- NULL
  df_value <- df_value[ ,
                        lapply(
                          .SD, function(x){gsub("&nbsp;", "sc", x, fixed = TRUE)}
                        )]
  df_value <- df_value[ ,
                        lapply(
                          .SD, function(x){gsub(" ", "sc", x, fixed = TRUE)}
                        )]
  df_value <- df_value[ ,
                        lapply(
                          .SD, function(x){gsub("X", "dc", x, fixed = TRUE)}
                        )]
  df_value_revcols <- rev(df_value)
  df_value_revrows <- apply(df_value_revcols, 2, rev)
  df_value_revrows <- as.data.frame(df_value_revrows)
  setDT(df_value_revrows)
  
  written_values <- data.table(Row = 1:nrow(df_value_revrows), Instructions = rep("", nrow(df_value_revrows)))
  
  for(i in 1:nrow(df_value_revrows)) {
    streaks <- rle(as.vector(as.matrix(df_value_revrows[i])))
    setDT(streaks)
    streaks[, Instruction := paste(lengths, values)]
    
    # Use custom function instead of knitr::combine_words
    row_inst <- paste0("Row ", i, ": ", combine_words_custom(streaks[["Instruction"]]), "<br />")
    
    written_values[i][["Instructions"]] <- row_inst
  }
  return(paste(written_values$Instructions, collapse = ' '))
}

# x <- c("W", "W", "L", "L", "L", "L", "L", "W", "W", "W", "W", "L", "W", "W", "L", "W", "L")
# streaks <- rle(x)
# str(streaks)
# data.table::setDT(streaks)
# str(streaks)
# streaks

