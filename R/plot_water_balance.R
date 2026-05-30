#' Visualisation du bilan hydrique
#'
#' Cree des graphiques du bilan hydrique : pluie, ETo, ETc,
#' irrigation et humidite du sol.
#'
#' @param bilan Dataframe issu de soil_water_balance() avec
#'   les colonnes : ETc, Rain, Irrigation, Stockage, Deficit
#' @param dates Vecteur de dates. Par defaut NULL
#' @param titre Titre du graphique. Par defaut "Bilan Hydrique"
#' @param save_plot Sauvegarder le graphique ? Par defaut FALSE
#' @param fichier Nom du fichier de sortie. Par defaut "bilan.png"
#'
#' @return Un objet ggplot
#'
#' @examples
#' etc  <- runif(90, 2, 5)
#' rain <- ifelse(runif(90) > 0.8, runif(90, 5, 20), 0)
#' bilan <- soil_water_balance(etc, rain, RU = 100)
#' plot_water_balance(bilan)
#'
#' @export
plot_water_balance <- function(bilan, dates = NULL,
                               titre = "Bilan Hydrique",
                               save_plot = FALSE,
                               fichier = "bilan.png") {
  if (!requireNamespace("ggplot2", quietly = TRUE))
    stop("Package 'ggplot2' requis.")

  if (is.null(dates)) {
    bilan$jour <- seq_len(nrow(bilan))
    x_lab <- "Jour"
    x_col <- "jour"
  } else {
    bilan$jour <- dates
    x_lab <- "Date"
    x_col <- "jour"
  }

  p1 <- ggplot2::ggplot(bilan, ggplot2::aes(x = jour)) +
    ggplot2::geom_bar(ggplot2::aes(y = Rain),
                      stat = "identity", fill = "#2196F3", alpha = 0.6) +
    ggplot2::geom_line(ggplot2::aes(y = ETc), color = "red", size = 1) +
    ggplot2::geom_line(ggplot2::aes(y = Irrigation),
                       color = "orange", size = 1, linetype = "dashed") +
    ggplot2::labs(title = titre,
                  x = x_lab,
                  y = "mm/jour",
                  caption = "Bleu = Pluie | Rouge = ETc | Orange = Irrigation") +
    ggplot2::theme_minimal()

  p2 <- ggplot2::ggplot(bilan, ggplot2::aes(x = jour)) +
    ggplot2::geom_line(ggplot2::aes(y = Stockage), color = "green", size = 1) +
    ggplot2::geom_line(ggplot2::aes(y = Deficit), color = "red",
                       size = 1, linetype = "dashed") +
    ggplot2::labs(x = x_lab, y = "mm",
                  caption = "Vert = Stockage | Rouge = Deficit") +
    ggplot2::theme_minimal()

  if (requireNamespace("gridExtra", quietly = TRUE)) {
    p <- gridExtra::grid.arrange(p1, p2, ncol = 1)
  } else {
    print(p1)
    print(p2)
    p <- p1
  }

  if (save_plot) {
    ggplot2::ggsave(fichier, plot = p1, width = 10, height = 6)
    message(paste("Graphique sauvegarde :", fichier))
  }

  return(invisible(p1))
}
