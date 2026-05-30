#' Generer un rapport automatique HTML
#'
#' Genere un rapport complet du bilan hydrique en format HTML
#' contenant les donnees meteo, ETo, ETc, bilan hydrique,
#' irrigation, graphiques et recommandations.
#'
#' @param bilan Dataframe issu de soil_water_balance()
#' @param planning Liste issue de irrigation_schedule()
#' @param culture Nom de la culture. Par defaut "ble"
#' @param station Nom de la station. Par defaut "Station"
#' @param output_file Nom du fichier de sortie. Par defaut "rapport_hydroAgri.html"
#'
#' @return Chemin vers le fichier rapport genere
#'
#' @examples
#' \dontrun{
#' etc   <- runif(90, 2, 5)
#' rain  <- ifelse(runif(90) > 0.8, runif(90, 5, 20), 0)
#' bilan <- soil_water_balance(etc, rain, RU = 100)
#' planning <- irrigation_schedule(etc, rain, RU = 100)
#' generate_report(bilan, planning, culture = "ble")
#' }
#'
#' @export
generate_report <- function(bilan, planning,
                            culture = "ble",
                            station = "Station",
                            output_file = "rapport_hydroAgri.html") {

  resume <- summarize_water_balance(bilan)

  html_content <- paste0(
    "<!DOCTYPE html>
<html>
<head>
  <meta charset='UTF-8'>
  <title>Rapport hydroAgri</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
    h1   { color: #2e7d32; }
    h2   { color: #1565c0; }
    table { border-collapse: collapse; width: 60%; }
    th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
    th { background-color: #2e7d32; color: white; }
    .box { background: white; padding: 20px; border-radius: 8px;
           margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
  </style>
</head>
<body>
  <h1>Rapport Bilan Hydrique - hydroAgri</h1>
  <div class='box'>
    <h2>Informations generales</h2>
    <p><b>Culture :</b> ", culture, "</p>
    <p><b>Station :</b> ", station, "</p>
    <p><b>Periode :</b> ", nrow(bilan), " jours</p>
  </div>
  <div class='box'>
    <h2>Resume du Bilan Hydrique</h2>
    <table>
      <tr><th>Parametre</th><th>Valeur (mm)</th></tr>
      <tr><td>ETc totale</td><td>", resume$ETc_totale, "</td></tr>
      <tr><td>Pluie totale</td><td>", resume$Pluie_totale, "</td></tr>
      <tr><td>Irrigation totale</td><td>", resume$Irrigation_totale, "</td></tr>
      <tr><td>Deficit cumule</td><td>", resume$Deficit_cumule, "</td></tr>
      <tr><td>Drainage total</td><td>", resume$Drainage_total, "</td></tr>
    </table>
  </div>
  <div class='box'>
    <h2>Calendrier d'Irrigation</h2>
    <p><b>Nombre d'irrigations :</b> ", nrow(planning$evenements), "</p>
    <p><b>Volume total irrigue :</b> ", planning$total_irrigation, " mm</p>
  </div>
  <div class='box'>
    <h2>Recommandations</h2>
    <p>- Surveiller le deficit hydrique et ajuster l'irrigation.</p>
    <p>- Optimiser les doses selon les stades phenologiques.</p>
    <p>- Privilegier l'irrigation en debut de matinee.</p>
  </div>
</body>
</html>"
  )

  writeLines(html_content, output_file)
  message(paste("Rapport genere :", output_file))
  return(output_file)
}
