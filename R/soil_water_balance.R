#' Calcul du bilan hydrique du sol
#'
#' Calcule le bilan hydrique journalier du sol selon la methode FAO-56.
#'
#' @param etc Vecteur des ETc journalieres (mm/jour)
#' @param rain Vecteur des precipitations journalieres (mm)
#' @param irrigation Vecteur des apports d'irrigation (mm). Par defaut 0
#' @param RU Reserve utile totale du sol (mm). Par defaut 100
#' @param RU_init Humidite initiale du sol (mm). Par defaut egale a RU
#'
#' @return Un dataframe avec les colonnes :
#'   ETc, Rain, Irrigation, Stockage, Drainage, Deficit
#'
#' @examples
#' etc  <- runif(30, 2, 5)
#' rain <- ifelse(runif(30) > 0.8, runif(30, 5, 20), 0)
#' bilan <- soil_water_balance(etc, rain, RU = 100)
#' head(bilan)
#'
#' @export
soil_water_balance <- function(etc, rain, irrigation = 0,
                               RU = 100, RU_init = NULL) {
  if (is.null(RU_init)) RU_init <- RU
  n <- length(etc)
  if (length(rain) == 1) rain <- rep(rain, n)
  if (length(irrigation) == 1) irrigation <- rep(irrigation, n)

  stockage  <- numeric(n)
  drainage  <- numeric(n)
  deficit   <- numeric(n)
  stock_actuel <- RU_init

  for (i in seq_len(n)) {
    stock_new <- stock_actuel + rain[i] + irrigation[i] - etc[i]
    if (stock_new > RU) {
      drainage[i] <- stock_new - RU
      stock_new <- RU
    }
    if (stock_new < 0) {
      deficit[i] <- abs(stock_new)
      stock_new <- 0
    } else {
      deficit[i] <- max(0, RU - stock_new)
    }
    stockage[i] <- round(stock_new, 2)
    stock_actuel <- stock_new
  }

  data.frame(
    ETc        = etc,
    Rain       = rain,
    Irrigation = irrigation,
    Stockage   = stockage,
    Drainage   = round(drainage, 2),
    Deficit    = round(deficit, 2)
  )
}
