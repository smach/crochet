library(testthat)
sample_selected <- data.frame(Row = c(1,6,5,7,5,5,3,7,5,2,10), Column = c(1,8,8,4,4,2,2,2,6,9,10))
sample_df1 <- create_df(10, 10)
sample_df_long <- update_df_with_selected_long(sample_df1, sample_selected)
sample_df_wide <- get_updated_with_selected_wide(sample_df_long, "HTMLValue")

test_that("odd even work", {
  expect_true(is.odd(3))
  expect_false(is.odd(8))
  expect_true(is.even(12))
  expect_false(is.even(7))
})


test_that("create data frame works", {
  expect_equal(dim(create_df(25, 20)), c(25, 20 + 1))
  expect_type(create_df(25,20), "list")
  expect_equal(class(create_df(20,25)), c("data.frame"))
})

test_that("check classes for updated data frame") {
  expect_equal(sample_df_long$Selected[sample_df_long$Row == 6 & sample_df_long$Column == 8], "Yes")
  expect_equal(sample_df_long$Selected[sample_df_long$Row == 4 & sample_df_long$Column == 8], "No")
  expect_equal(sample_df_long$Selected[sample_df_long$Row == 5 & sample_df_long$Column == 6], "Yes")
  expect_equal(sample_df_long$Selected[sample_df_long$Row == 9 & sample_df_long$Column == 10], "No")
  expect_equal(sample_df_long$Value[sample_df_long$Row == 6-1 & sample_df_long$Column == 8], "X")
  expect_equal(sample_df_long$Value[sample_df_long$Row == 6 & sample_df_long$Column == 8], " ")
  expect_equal(sample_df_long$Class[sample_df_long$Row == 5 & sample_df_long$Column == 8], "Danger")
  expect_equal(sample_df_long$Class[sample_df_long$Row == 6 & sample_df_long$Column == 8], "OppositeEven")
  expect_equal(sample_df_long$Class[sample_df_long$Row == 3 & sample_df_long$Column == 3], "RegularOdd")
  expect_equal(sample_df_long$Class[sample_df_long$Row == 10 & sample_df_long$Column == 6], "RegularEven")
  expect_equal(sample_df_long$Class[sample_df_long$Row == 3 & sample_df_long$Column == 2], "OppositeOdd")
  expect_equal(sample_df_long$Value[sample_df_long$Row == 3 & sample_df_long$Column == 2], " ")
  expect_equal(sample_df_long$HTMLValue[sample_df_long$Row == 6 & sample_df_long$Column == 8], "<div class = 'OppositeEven'> </div>")
}
