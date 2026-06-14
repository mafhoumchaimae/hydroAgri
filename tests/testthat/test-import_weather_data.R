test_that("import_weather_data accepte un dataframe et calcule Tmean", {
  meteo <- data.frame(
    date = seq(as.Date("2023-01-01"), by = "day", length.out = 10),
    Tmax = rep(30, 10),
    Tmin = rep(10, 10),
    RH   = rep(50, 10),
    Wind = rep(2, 10),
    Rs   = rep(20, 10),
    Rain = rep(0, 10)
  )

  weather <- import_weather_data(data = meteo, format = "dataframe")

  expect_true(is.data.frame(weather))
  expect_true("Tmean" %in% names(weather))
  expect_equal(weather$Tmean[1], 20)
})

test_that("import_weather_data trie les donnees par date", {
  meteo <- data.frame(
    date = rev(seq(as.Date("2023-01-01"), by = "day", length.out = 5)),
    Tmax = 1:5, Tmin = 1:5, RH = 1:5, Wind = 1:5, Rs = 1:5, Rain = 1:5
  )

  weather <- import_weather_data(data = meteo, format = "dataframe")

  expect_equal(weather$date, sort(weather$date))
})

test_that("import_weather_data leve une erreur sans fichier ni donnees", {
  expect_error(import_weather_data())
})
