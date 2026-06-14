test_that("summarize_water_balance retourne un dataframe avec les bonnes colonnes", {
  etc  <- rep(4, 30)
  rain <- rep(0, 30)
  bilan  <- soil_water_balance(etc, rain, RU = 100)
  resume <- summarize_water_balance(bilan)

  expect_true(is.data.frame(resume))
  expect_true(all(c("ETc_totale", "Pluie_totale", "Irrigation_totale",
                     "Deficit_cumule", "Drainage_total", "Nb_jours")
                   %in% names(resume)))
})

test_that("summarize_water_balance calcule correctement ETc_totale", {
  etc  <- rep(4, 10)
  rain <- rep(0, 10)
  bilan  <- soil_water_balance(etc, rain, RU = 100)
  resume <- summarize_water_balance(bilan)

  expect_equal(resume$ETc_totale, round(sum(bilan$ETc), 1))
  expect_equal(resume$Nb_jours, 10)
})
