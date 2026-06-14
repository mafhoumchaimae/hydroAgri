test_that("interpolate_climate leve une erreur avec une methode inconnue", {
  skip_if_not_installed("sp")
  skip_if_not_installed("gstat")

  stations <- data.frame(
    lon = c(-8.0, -7.5, -7.0, -8.5, -7.8),
    lat = c(31.5, 31.8, 32.0, 31.2, 32.2),
    ETo = c(5.2, 4.8, 5.5, 4.5, 5.0)
  )

  expect_error(interpolate_climate(stations, variable = "ETo", methode = "autre"))
})

test_that("interpolate_climate (idw) retourne un resultat sur une grille reguliere", {
  skip_if_not_installed("sp")
  skip_if_not_installed("gstat")

  stations <- data.frame(
    lon = c(-8.0, -7.5, -7.0, -8.5, -7.8),
    lat = c(31.5, 31.8, 32.0, 31.2, 32.2),
    ETo = c(5.2, 4.8, 5.5, 4.5, 5.0)
  )

  grille <- interpolate_climate(stations, variable = "ETo",
                                  methode = "idw", resolution = 0.5)
  expect_true(!is.null(grille))
})
