test_that("compare_station_vs_raster calcule les differences station/raster", {
  skip_if_not_installed("raster")
  skip_if_not_installed("sp")

  r <- raster::raster(nrows = 10, ncols = 10,
                       xmn = -10, xmx = 0, ymn = 28, ymx = 36)
  raster::values(r) <- 5

  stations <- data.frame(
    lon = c(-7.5, -8.0, -7.0),
    lat = c(31.6, 31.9, 32.1),
    ETo = c(5.1, 4.8, 5.3)
  )

  validation <- compare_station_vs_raster(stations, r, plot_result = FALSE)

  expect_true(is.data.frame(validation))
  expect_true(all(c("ETo_station", "ETo_raster", "difference") %in% names(validation)))
  expect_equal(validation$ETo_raster, rep(5, 3))
})
