test_that("generate_report cree un fichier HTML", {
  etc  <- rep(4, 10)
  rain <- rep(0, 10)
  bilan    <- soil_water_balance(etc, rain, RU = 100)
  planning <- irrigation_schedule(etc, rain, RU = 100)

  out_file <- tempfile(fileext = ".html")
  result <- generate_report(bilan, planning, culture = "ble",
                             station = "Test", output_file = out_file)

  expect_true(file.exists(out_file))
  expect_equal(result, out_file)

  content <- readLines(out_file)
  expect_true(any(grepl("Rapport Bilan Hydrique", content)))

  unlink(out_file)
})
