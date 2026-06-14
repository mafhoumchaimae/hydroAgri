test_that("load_raster_eto leve une erreur si le fichier n'existe pas", {
  skip_if_not_installed("raster")

  expect_error(load_raster_eto("fichier_inexistant.tif"))
})

test_that("load_raster_eto charge et decoupe un raster local", {
  skip_if_not_installed("raster")

  r_path <- tempfile(fileext = ".tif")
  r <- raster::raster(nrows = 10, ncols = 10,
                       xmn = -10, xmx = 0, ymn = 28, ymx = 36)
  raster::values(r) <- runif(100, 3, 6)
  raster::writeRaster(r, r_path, overwrite = TRUE)

  r_loaded <- load_raster_eto(r_path)
  expect_s4_class(r_loaded, "Raster")

  r_crop <- load_raster_eto(r_path, extent_zone = c(-6, -4, 31, 33))
  expect_s4_class(r_crop, "Raster")

  unlink(r_path)
})
