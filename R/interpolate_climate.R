#' Interpolation spatiale des donnees climatiques
#'
#' Interpole spatialement les donnees climatiques ponctuelles vers
#' une grille reguliere par la methode IDW ou krigeage.
#'
#' @param stations_data Dataframe avec les colonnes : lon, lat, et la variable
#' @param variable Nom de la variable a interpoler (ex: "ETo", "Tmax", "Rain")
#' @param methode Methode : "idw" ou "krigeage". Par defaut "idw"
#' @param resolution Resolution de la grille en degres. Par defaut 0.1
#'
#' @return Un objet SpatialGridDataFrame (raster interpole)
#'
#' @examples
#' stations <- data.frame(
#'   lon = c(-8.0, -7.5, -7.0, -8.5, -7.8),
#'   lat = c(31.5, 31.8, 32.0, 31.2, 32.2),
#'   ETo = c(5.2, 4.8, 5.5, 4.5, 5.0)
#' )
#' \dontrun{
#' grille <- interpolate_climate(stations, variable = "ETo")
#' }
#'
#' @export
interpolate_climate <- function(stations_data, variable,
                                methode = "idw", resolution = 0.1) {
  if (!requireNamespace("sp", quietly = TRUE))
    stop("Package 'sp' requis. Installez-le avec install.packages('sp')")
  if (!requireNamespace("gstat", quietly = TRUE))
    stop("Package 'gstat' requis. Installez-le avec install.packages('gstat')")

  sp_data <- stations_data
  sp::coordinates(sp_data) <- ~ lon + lat

  bbox_lon <- range(stations_data$lon)
  bbox_lat <- range(stations_data$lat)

  grd <- expand.grid(
    lon = seq(bbox_lon[1], bbox_lon[2], by = resolution),
    lat = seq(bbox_lat[1], bbox_lat[2], by = resolution)
  )
  sp::coordinates(grd) <- ~ lon + lat
  sp::gridded(grd) <- TRUE

  formule <- stats::as.formula(paste(variable, "~ 1"))

  if (methode == "idw") {
    result <- gstat::idw(formule, sp_data, grd)
  } else if (methode == "krigeage") {
    vario     <- gstat::variogram(formule, sp_data)
    vario_fit <- gstat::fit.variogram(vario, gstat::vgm("Sph"))
    result    <- gstat::krige(formule, sp_data, grd, model = vario_fit)
  } else {
    stop("Methode non reconnue. Utilisez 'idw' ou 'krigeage'.")
  }

  return(result)
}
