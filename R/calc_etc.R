#' Calcul de l'evapotranspiration culturale (ETc)
#'
#' Calcule l'ETc journaliere selon la relation ETc = Kc x ETo
#'
#' @param eto Vecteur ou valeur de l'ETo journaliere (mm/jour)
#' @param kc Vecteur ou valeur du coefficient cultural Kc
#'
#' @return Vecteur de valeurs ETc (mm/jour)
#'
#' @examples
#' eto <- c(4.5, 5.0, 4.8, 5.2, 4.9)
#' kc  <- c(0.4, 0.5, 0.6, 0.7, 0.8)
#' etc <- calc_etc(eto, kc)
#' print(etc)
#'
#' @export
calc_etc <- function(eto, kc) {
  if (length(eto) != length(kc) && length(kc) != 1) {
    stop("eto et kc doivent avoir la meme longueur ou kc doit etre une seule valeur.")
  }
  etc <- round(kc * eto, 2)
  return(etc)
}
