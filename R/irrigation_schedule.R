#' Calcul du calendrier d'irrigation
#'
#' Determine les dates et doses d'irrigation optimales selon le seuil
#' de la Reserve Facilement Utilisable (RFU).
#'
#' @param etc Vecteur des ETc journalieres (mm/jour)
#' @param rain Vecteur des precipitations journalieres (mm)
#' @param RU Reserve utile totale du sol (mm). Par defaut 100
#' @param RFU_ratio Fraction de RU pour la RFU (0 a 1). Par defaut 0.5
#' @param RU_init Humidite initiale (mm). Par defaut egale a RU
#' @param dates Vecteur de dates. Par defaut NULL
#'
#' @return Une liste avec :
#'   \item{calendrier}{Dataframe du calendrier journalier}
#'   \item{evenements}{Dataframe des irrigations uniquement}
#'   \item{total_irrigation}{Volume total irrigue (mm)}
#'
#' @examples
#' etc  <- runif(90, 2, 6)
#' rain <- ifelse(runif(90) > 0.85, runif(90, 5, 20), 0)
#' planning <- irrigation_schedule(etc, rain, RU = 100)
#' planning$evenements
#'
#' @export
irrigation_schedule <- function(etc, rain, RU = 100,
                                RFU_ratio = 0.5,
                                RU_init = NULL,
                                dates = NULL) {
  if (is.null(RU_init)) RU_init <- RU
  if (is.null(dates)) dates <- seq_len(length(etc))
  RFU <- RFU_ratio * RU
  n <- length(etc)
  if (length(rain) == 1) rain <- rep(rain, n)

  stockage   <- numeric(n)
  irrigation <- numeric(n)
  stock_actuel <- RU_init

  for (i in seq_len(n)) {
    stock_test <- stock_actuel + rain[i] - etc[i]
    irrig <- 0
    if (stock_test < RFU) {
      irrig <- RU - (stock_actuel + rain[i])
      irrig <- max(0, irrig)
    }
    stock_new <- stock_actuel + rain[i] + irrig - etc[i]
    stock_new <- max(0, min(RU, stock_new))
    stockage[i]   <- round(stock_new, 2)
    irrigation[i] <- round(irrig, 2)
    stock_actuel  <- stock_new
  }

  calendrier <- data.frame(
    date       = dates,
    ETc        = etc,
    Rain       = rain,
    Irrigation = irrigation,
    Stockage   = stockage
  )

  list(
    calendrier       = calendrier,
    evenements       = calendrier[calendrier$Irrigation > 0, ],
    total_irrigation = round(sum(irrigation), 1)
  )
}
