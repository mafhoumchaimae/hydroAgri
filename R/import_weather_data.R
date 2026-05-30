#' Importer les donnees meteorologiques
#'
#' Importe et prepare les donnees meteo depuis un fichier CSV ou Excel.
#' Gere les dates, detecte les valeurs manquantes et convertit les unites.
#'
#' @param file Chemin vers le fichier CSV ou Excel
#' @param format Format du fichier : "csv" ou "excel". Par defaut "csv"
#' @param fill_missing Methode pour les valeurs manquantes :
#'   "interpolate" ou "mean". Par defaut "interpolate"
#'
#' @return Un dataframe avec les colonnes :
#'   date, Tmax, Tmin, Tmean, RH, Wind, Rs, Rain
#'
#' @examples
#' meteo <- data.frame(
#'   date = seq(as.Date("2023-01-01"), as.Date("2023-12-31"), by = "day"),
#'   Tmax = runif(365, 20, 38),
#'   Tmin = runif(365, 10, 22),
#'   RH   = runif(365, 40, 80),
#'   Wind = runif(365, 1, 4),
#'   Rs   = runif(365, 15, 25),
#'   Rain = ifelse(runif(365) > 0.85, runif(365, 0, 20), 0)
#' )
#' weather <- import_weather_data(data = meteo, format = "dataframe")
#' head(weather)
#'
#' @export
import_weather_data <- function(file = NULL, format = "csv",
                                fill_missing = "interpolate",
                                data = NULL) {
  if (!is.null(data)) {
    df <- data
  } else if (!is.null(file)) {
    if (format == "csv") {
      df <- read.csv(file)
    } else if (format == "excel") {
      df <- readxl::read_excel(file)
    } else {
      stop("Format non reconnu. Utilisez 'csv' ou 'excel'.")
    }
  } else {
    stop("Fournissez un fichier ou un dataframe.")
  }

  if (!inherits(df$date, "Date")) {
    df$date <- as.Date(df$date)
  }

  df$Tmean <- (df$Tmax + df$Tmin) / 2

  missing_count <- sum(is.na(df))
  if (missing_count > 0 && fill_missing == "interpolate") {
    for (col in c("Tmax", "Tmin", "Tmean", "RH", "Wind", "Rs", "Rain")) {
      if (col %in% names(df)) {
        df[[col]][is.na(df[[col]])] <- mean(df[[col]], na.rm = TRUE)
      }
    }
  }

  df <- df[order(df$date), ]
  return(df)
}
