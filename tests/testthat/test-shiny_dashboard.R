test_that("shiny_dashboard retourne un objet shiny.appobj", {
  skip_if_not_installed("shiny")

  app <- shiny_dashboard()
  expect_s3_class(app, "shiny.appobj")
})
