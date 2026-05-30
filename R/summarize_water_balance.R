#' Resume du bilan hydrique
#'
#' Calcule les statistiques saisonnieres du bilan hydrique :
#' ETc totale, irrigation totale, deficit cumule et efficacite.
#'
#' @param bilan Dataframe issu de soil_water_balance() ou
#'   irrigation_schedule()$calendrier
#'
#' @return Un dataframe avec les statistiques saisonnieres
#'
#' @examples
#' etc  <- runif(90, 2, 5)
#' rain <- ifelse(runif(90) > 0.8, runif(90, 5, 20), 0)
#' bilan <- soil_water_balance(etc, rain, RU = 100)
#' resume <- summarize_water_balance(bilan)
#' print(resume)
#'
#' @export
summarize_water_balance <- function(bilan) {

  stats <- data.frame(
    ETc_totale         = round(sum(bilan$ETc, na.rm = TRUE), 1),
    Pluie_totale       = round(sum(bilan$Rain, na.rm = TRUE), 1),
    Irrigation_totale  = round(sum(bilan$Irrigation, na.rm = TRUE), 1),
    Deficit_cumule     = round(sum(bilan$Deficit, na.rm = TRUE), 1),
    Drainage_total     = round(sum(bilan$Drainage, na.rm = TRUE), 1),
    Nb_jours           = nrow(bilan)
  )

  stats$Efficacite_irrigation <- ifelse(
    stats$Irrigation_totale > 0,
    round((stats$ETc_totale - stats$Pluie_totale) /
            stats$Irrigation_totale * 100, 1),
    NA
  )

  cat("=== Resume du Bilan Hydrique ===\n")
  cat(sprintf("ETc totale         : %.1f mm\n", stats$ETc_totale))
  cat(sprintf("Pluie totale       : %.1f mm\n", stats$Pluie_totale))
  cat(sprintf("Irrigation totale  : %.1f mm\n", stats$Irrigation_totale))
  cat(sprintf("Deficit cumule     : %.1f mm\n", stats$Deficit_cumule))
  cat(sprintf("Drainage total     : %.1f mm\n", stats$Drainage_total))

  return(stats)
}
