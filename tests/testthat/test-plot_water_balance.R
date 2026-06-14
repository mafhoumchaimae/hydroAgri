test_that("plot_water_balance retourne un objet ggplot", {
  etc  <- rep(4, 30)
  rain <- rep(0, 30)
  bilan <- soil_water_balance(etc, rain, RU = 100)

  p <- plot_water_balance(bilan)
  expect_s3_class(p, "ggplot")
})

test_that("plot_water_balance fonctionne avec un vecteur de dates", {
  etc   <- rep(3, 15)
  rain  <- rep(0, 15)
  bilan <- soil_water_balance(etc, rain, RU = 100)
  dates <- seq(as.Date("2024-01-01"), by = "day", length.out = 15)

  p <- plot_water_balance(bilan, dates = dates, titre = "Test")
  expect_s3_class(p, "ggplot")
})
