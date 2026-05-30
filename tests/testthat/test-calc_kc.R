test_that("calc_kc retourne un dataframe", {
  kc <- calc_kc(culture = "ble", date_debut = "2023-11-01",
                duree_stades = c(25, 40, 40, 20))
  expect_true(is.data.frame(kc))
})

test_that("calc_kc a les bonnes colonnes", {
  kc <- calc_kc(culture = "ble", date_debut = "2023-11-01",
                duree_stades = c(25, 40, 40, 20))
  expect_true(all(c("date", "stade", "Kc") %in% names(kc)))
})

test_that("calc_kc Kc sont positifs", {
  kc <- calc_kc(culture = "mais", date_debut = "2023-04-01",
                duree_stades = c(30, 40, 50, 30))
  expect_true(all(kc$Kc > 0))
})
