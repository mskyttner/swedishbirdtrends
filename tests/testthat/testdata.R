library(swedishbirdtrends)
context("Datasets content")

test_that("datasets are not empty", {
  expect_gt(nrow(birdtotals), 0)
  expect_gt(nrow(birdtrends), 0)
})