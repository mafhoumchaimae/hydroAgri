#' Comparer les donnees de station meteo avec les donnees raster ETo
#'
#' Compare les valeurs ETo des stations avec celles extraites d'un raster.
#' Calcule les metriques de validation : RMSE, biais et correlation.
#'
#' @param stations_eto Dataframe avec les colonnes : lon, lat, ETo
#' @param raster_eto Objet raster ETo issu de load_raster_eto()
#' @param plot_result Afficher les graphiques ? Par defaut TRUE
#'
#' @return Un dataframe avec : lon, lat, ETo_station, ETo_raster, difference
#'
#' @examples
#' \dontrun{
#' stations <- data.frame(
#'   lon = c(-7.5, -8.0, -7.0),
#'   lat = c(31.6, 31.9, 32.1),
#'   ETo = c(5.1, 4.8, 5.3)
#' )
#' r <- load_raster_eto("eto_maroc.tif")
#' validation <- compare_station_vs_raster(stations, r)
#' }
#'
#' @export
compare_station_vs_raster <- function(stations_eto, raster_eto,
                                      plot_result = TRUE) {
  if (!requireNamespace("raster", quietly = TRUE))
    stop("Package 'raster' requis.")
  if (!requireNamespace("sp", quietly = TRUE))
    stop("Package 'sp' requis.")

  pts    <- stations_eto[, c("lon", "lat")]
  sp_pts <- sp::SpatialPoints(pts,
                              proj4string = sp::CRS("+proj=longlat +datum=WGS84"))
  vals_raster <- raster::extract(raster_eto, sp_pts)

  result <- data.frame(
    lon         = stations_eto$lon,
    lat         = stations_eto$lat,
    ETo_station = stations_eto$ETo,
    ETo_raster  = round(vals_raster, 2),
    difference  = round(stations_eto$ETo - vals_raster, 2)
  )

  rmse  <- sqrt(mean((result$ETo_station - result$ETo_raster)^2, na.rm = TRUE))
  biais <- mean(result$ETo_station - result$ETo_raster, na.rm = TRUE)
  r     <- stats::cor(result$ETo_station, result$ETo_raster, use = "complete.obs")

  cat("=== Validation Station vs Raster ===\n")
  cat(sprintf("RMSE  : %.3f mm/jour\n", rmse))
  cat(sprintf("Biais : %.3f mm/jour\n", biais))
  cat(sprintf("r     : %.3f\n", r))

  if (plot_result) {
    p <- ggplot2::ggplot(result, ggplot2::aes(x = ETo_station, y = ETo_raster)) +
      ggplot2::geom_point(color = "#2196F3", size = 3) +
      ggplot2::geom_abline(slope = 1, intercept = 0,
                           linetype = "dashed", color = "red") +
      ggplot2::labs(title = "Comparaison Station vs Raster ETo",
                    x = "ETo Station (mm/jour)",
                    y = "ETo Raster (mm/jour)") +
      ggplot2::theme_minimal()
    print(p)
  }

  return(result)
}
