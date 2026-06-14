test_that("irrigation_schedule retourne une liste avec les bons elements", {
  etc  <- rep(4, 30)
  rain <- rep(0, 30)
  planning <- irrigation_schedule(etc, rain, RU = 100)
  expect_true(is.list(planning))
  expect_true(all(c("calendrier", "evenements", "total_irrigation") %in% names(planning)))
})

test_that("irrigation_schedule declenche l'irrigation quand le sol s'asseche", {
  etc  <- rep(5, 60)
  rain <- rep(0, 60)
  planning <- irrigation_schedule(etc, rain, RU = 100, RFU_ratio = 0.5)
  expect_true(planning$total_irrigation > 0)
  expect_true(nrow(planning$evenements) > 0)
})

test_that("irrigation_schedule n'irrigue pas si la pluie couvre les besoins", {
  etc  <- rep(2, 10)
  rain <- rep(10, 10)
  planning <- irrigation_schedule(etc, rain, RU = 100, RU_init = 100)
  expect_equal(planning$total_irrigation, 0)
})
