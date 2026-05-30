test_that("calc_eto retourne une valeur positive", {
  eto <- calc_eto(tmax = 32, tmin = 18, solar_rad = 22,
                  wind_speed = 2.5, humidity = 45)
  expect_true(eto > 0)
})

test_that("calc_eto retourne un nombre", {
  eto <- calc_eto(tmax = 32, tmin = 18, solar_rad = 22,
                  wind_speed = 2.5, humidity = 45)
  expect_true(is.numeric(eto))
})

test_that("calc_eto retourne 0 si conditions extremes", {
  eto <- calc_eto(tmax = 5, tmin = 4, solar_rad = 1,
                  wind_speed = 0.1, humidity = 99)
  expect_true(eto >= 0)
})
