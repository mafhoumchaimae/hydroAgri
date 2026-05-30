#' Cartographie spatiale des besoins en irrigation
#'
#' Cree des cartes des besoins en irrigation, deficit hydrique
#' et ETo spatial a partir de donnees de stations.
#'
#' @param stations_data Dataframe avec les colonnes :
#'   lon, lat, et la variable a cartographier
#' @param variable Variable a cartographier :
#'   "Irrigation", "Deficit", "ETo". Par defaut "Irrigation"
#' @param titre Titre de la carte. Par defaut NULL
#'
#' @return Un objet ggplot
#'
#' @examples
#' stations <- data.frame(
#'   lon       = c(-8.0, -7.5, -7.0, -8.5, -7.8),
#'   lat       = c(31.5, 31.8, 32.0, 31.2, 32.2),
#'   Irrigation = c(120, 95, 140, 88, 110)
#' )
#' plot_irrigation_map(stations, variable = "Irrigation")
#'
#' @export
plot_irrigation_map <- function(stations_data,
                                variable = "Irrigation",
                                titre = NULL) {
  if (!requireNamespace("ggplot2", quietly = TRUE))
    stop("Package 'ggplot2' requis.")

  if (!(variable %in% names(stations_data)))
    stop(paste("Variable", variable, "non trouvee dans stations_data."))

  if (is.null(titre)) titre <- paste("Carte :", variable)

  p <- ggplot2::ggplot(stations_data,
                       ggplot2::aes(x = lon, y = lat,
                                    color = .data[[variable]],
                                    size  = .data[[variable]])) +
    ggplot2::geom_point(alpha = 0.8) +
    ggplot2::scale_color_gradient(low = "yellow", high = "red",
                                  name = paste(variable, "(mm)")) +
    ggplot2::scale_size_continuous(range = c(3, 10)) +
    ggplot2::labs(
      title = titre,
      x = "Longitude",
      y = "Latitude"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.position = "right")

  print(p)
  return(invisible(p))
}
