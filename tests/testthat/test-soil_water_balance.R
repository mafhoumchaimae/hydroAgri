test_that("soil_water_balance retourne un dataframe", {
  etc  <- runif(30, 2, 5)
  rain <- rep(0, 30)
  bilan <- soil_water_balance(etc, rain, RU = 100)
  expect_true(is.data.frame(bilan))
})

test_that("soil_water_balance a les bonnes colonnes", {
  etc  <- runif(30, 2, 5)
  rain <- rep(0, 30)
  bilan <- soil_water_balance(etc, rain, RU = 100)
  expect_true(all(c("ETc", "Rain", "Stockage", "Deficit") %in% names(bilan)))
})

test_that("Stockage ne depasse pas RU", {
  etc  <- rep(0, 30)
  rain <- rep(10, 30)
  bilan <- soil_water_balance(etc, rain, RU = 100)
  expect_true(all(bilan$Stockage <= 100))
})
