#' Calcul de l'Evapotranspiration de Reference (ETo) - Methode FAO-56
#'
#' Calcule l'evapotranspiration de reference journaliere selon la methode
#' de Penman-Monteith simplifiee (FAO-56).
#'
#' @param tmax Temperature maximale journaliere (C)
#' @param tmin Temperature minimale journaliere (C)
#' @param solar_rad Rayonnement solaire journalier (MJ/m2/jour)
#' @param wind_speed Vitesse du vent a 2m (m/s)
#' @param humidity Humidite relative moyenne (%)
#' @param altitude Altitude du site (m). Par defaut 0.
#'
#' @return Valeur numerique de l'ETo en mm/jour
#'
#' @examples
#' eto <- calc_eto(tmax = 32, tmin = 18, solar_rad = 22,
#'                 wind_speed = 2.5, humidity = 45)
#' print(eto)
#'
#' @export
calc_eto <- function(tmax, tmin, solar_rad, wind_speed, humidity, altitude = 0) {
  tmean <- (tmax + tmin) / 2
  P <- 101.3 * ((293 - 0.0065 * altitude) / 293)^5.26
  gamma <- 0.000665 * P
  Delta <- 4098 * (0.6108 * exp(17.27 * tmean / (tmean + 237.3))) / (tmean + 237.3)^2
  es <- (0.6108 * exp(17.27 * tmax / (tmax + 237.3)) +
           0.6108 * exp(17.27 * tmin / (tmin + 237.3))) / 2
  ea <- (humidity / 100) * es
  Rns <- (1 - 0.23) * solar_rad
  ETo <- (0.408 * Delta * Rns + gamma * (900 / (tmean + 273)) * wind_speed * (es - ea)) /
    (Delta + gamma * (1 + 0.34 * wind_speed))
  return(round(max(ETo, 0), 2))
}
