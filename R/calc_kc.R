#' Calcul des coefficients culturaux Kc
#'
#' Genere une serie journaliere de coefficients Kc selon les stades
#' phenologiques de la culture, basee sur les valeurs FAO-56.
#'
#' @param culture Nom de la culture : "ble", "mais", "tomate",
#'   "olivier", "pomme_de_terre"
#' @param date_debut Date de debut de la culture (format "AAAA-MM-JJ")
#' @param duree_stades Vecteur de 4 durees en jours pour les stades :
#'   initial, developpement, mi-saison, fin saison
#'
#' @return Un dataframe avec les colonnes : date, stade, Kc
#'
#' @examples
#' kc <- calc_kc(culture = "ble", date_debut = "2023-11-01",
#'               duree_stades = c(30, 40, 40, 20))
#' head(kc)
#'
#' @export
calc_kc <- function(culture = "ble", date_debut, duree_stades = NULL) {

  fao_data <- list(
    ble            = list(kc = c(0.30, 1.15, 0.25), durees = c(25, 50, 60, 30)),
    mais           = list(kc = c(0.30, 1.20, 0.35), durees = c(30, 40, 50, 30)),
    tomate         = list(kc = c(0.40, 1.15, 0.70), durees = c(30, 40, 45, 25)),
    olivier        = list(kc = c(0.65, 0.70, 0.65), durees = c(30, 60, 90, 30)),
    pomme_de_terre = list(kc = c(0.50, 1.15, 0.75), durees = c(25, 30, 45, 30))
  )

  kc_vals <- fao_data[[culture]]$kc
  durees  <- if (!is.null(duree_stades)) duree_stades else fao_data[[culture]]$durees
  duree_tot <- sum(durees)
  dates <- seq(as.Date(date_debut), by = "day", length.out = duree_tot)

  stade_days <- cumsum(durees)
  kc_points  <- c(kc_vals[1], kc_vals[1], kc_vals[2], kc_vals[2], kc_vals[3])
  jour_points <- c(1, stade_days[1], stade_days[2], stade_days[3], duree_tot)
  kc_seq <- approx(jour_points, kc_points, xout = seq_len(duree_tot))$y

  stade_seq <- ifelse(seq_len(duree_tot) <= stade_days[1], "initial",
                      ifelse(seq_len(duree_tot) <= stade_days[2], "developpement",
                             ifelse(seq_len(duree_tot) <= stade_days[3], "mi-saison", "fin_saison")))

  data.frame(date = dates, stade = stade_seq, Kc = round(kc_seq, 3))
}
