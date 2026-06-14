#' Donnees climatiques d'exemple (region du Souss-Massa, Maroc)
#'
#' Jeu de donnees climatiques journalieres d'exemple, utilise pour
#' illustrer le fonctionnement des fonctions du package hydroAgri
#' (import, calcul de l'ETo, bilan hydrique, etc.). Les valeurs sont
#' simulees a partir des normales climatiques mensuelles (1991-2020)
#' de la region du Souss-Massa (zone d'Agadir, lat. ~30.4 N), publiees
#' par la Direction Generale de la Meteorologie (DGM, Maroc) et par
#' la base de donnees NASA POWER (\url{https://power.larc.nasa.gov}).
#' Une variabilite journaliere aleatoire est ajoutee autour de ces
#' normales mensuelles afin de reproduire un cycle saisonnier
#' realiste sur une annee complete.
#'
#' @format Un dataframe de 365 lignes et des colonnes suivantes :
#' \describe{
#'   \item{date}{Date de l'observation (objet \code{Date})}
#'   \item{Tmax}{Temperature maximale journaliere (degres C)}
#'   \item{Tmin}{Temperature minimale journaliere (degres C)}
#'   \item{RH}{Humidite relative moyenne journaliere (\%)}
#'   \item{Wind}{Vitesse du vent a 2 m (m/s)}
#'   \item{Rs}{Rayonnement solaire journalier (MJ/m2/jour)}
#'   \item{Rain}{Precipitations journalieres (mm)}
#' }
#'
#' @source Normales climatiques mensuelles 1991-2020, Direction Generale
#'   de la Meteorologie (Maroc) et NASA POWER
#'   (\url{https://power.larc.nasa.gov}), region du Souss-Massa.
#'
#' @examples
#' data(climat_exemple)
#' head(climat_exemple)
#'
#' @docType data
#' @name climat_exemple
#' @usage data(climat_exemple)
"climat_exemple"
