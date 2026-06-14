test_that("plot_irrigation_map retourne un objet ggplot", {
  stations <- data.frame(
    lon        = c(-8.0, -7.5, -7.0, -8.5, -7.8),
    lat        = c(31.5, 31.8, 32.0, 31.2, 32.2),
    Irrigation = c(120, 95, 140, 88, 110)
  )

  p <- plot_irrigation_map(stations, variable = "Irrigation")
  expect_s3_class(p, "ggplot")
})

test_that("plot_irrigation_map leve une erreur si la variable est absente", {
  stations <- data.frame(lon = -8, lat = 31.5, Irrigation = 100)
  expect_error(plot_irrigation_map(stations, variable = "Deficit"))
})
