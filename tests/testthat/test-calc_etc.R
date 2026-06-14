test_that("calc_etc calcule ETc = Kc x ETo", {
  eto <- c(4.5, 5.0, 4.8, 5.2, 4.9)
  kc  <- c(0.4, 0.5, 0.6, 0.7, 0.8)
  etc <- calc_etc(eto, kc)
  expect_equal(etc, round(eto * kc, 2))
})

test_that("calc_etc accepte un Kc scalaire", {
  eto <- c(4.0, 5.0, 6.0)
  etc <- calc_etc(eto, kc = 0.5)
  expect_equal(etc, round(eto * 0.5, 2))
})

test_that("calc_etc renvoie une erreur si longueurs incompatibles", {
  expect_error(calc_etc(eto = c(1, 2, 3), kc = c(0.5, 0.6)))
})
