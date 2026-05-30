#' Charger des donnees raster ETo
#'
#' Importe un fichier raster d'evapotranspiration de reference
#' (MODIS, WorldClim ou raster local), le reprojette et le decoupe.
#'
#' @param file Chemin vers le fichier raster (.tif, .nc, .grd)
#' @param extent_zone Vecteur de 4 valeurs (xmin, xmax, ymin, ymax).
#'   Si NULL, conserve l'etendue originale
#' @param crs_target Systeme de coordonnees cible. Par defaut WGS84
#'
#' @return Un objet raster
#'
#' @examples
#' \dontrun{
#' r <- load_raster_eto("eto_maroc.tif",
#'                      extent_zone = c(-6, -4, 31, 33))
#' raster::plot(r)
#' }
#'
#' @export
load_raster_eto <- function(file,
                            extent_zone = NULL,
                            crs_target = "+proj=longlat +datum=WGS84") {
  if (!requireNamespace("raster", quietly = TRUE))
    stop("Package 'raster' requis. Installez-le avec install.packages('raster')")
  if (!file.exists(file))
    stop(paste("Fichier introuvable :", file))

  r <- raster::raster(file)
  message(paste("Raster charge :", raster::ncol(r), "x", raster::nrow(r), "cellules"))

  if (!is.null(extent_zone)) {
    ext <- raster::extent(extent_zone)
    r   <- raster::crop(r, ext)
    message("Raster decoupe selon la zone d'etude.")
  }

  return(r)
}
