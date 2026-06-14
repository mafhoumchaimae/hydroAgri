# hydroAgri

Package R pour le bilan hydrique des cultures et le calcul des besoins
en irrigation selon la methode **FAO-56** (Allen et al., 1998).

hydroAgri permet de :

- calculer l'evapotranspiration de reference (ETo) selon Penman-Monteith,
- generer les coefficients culturaux Kc selon les stades phenologiques,
- calculer l'evapotranspiration culturale (ETc),
- simuler le bilan hydrique journalier du sol,
- determiner un calendrier optimal d'irrigation,
- comparer des donnees stations vs raster ETo, interpoler des donnees
  climatiques spatialement et cartographier les besoins en irrigation,
- generer un rapport HTML automatique et un dashboard Shiny interactif.

## Installation

```r
# Installer depuis GitHub
remotes::install_github("mafhoumchaimae/hydroAgri")
```

Certaines fonctionnalites avancees (donnees raster, interpolation spatiale,
dashboard Shiny) necessitent des packages supplementaires :

```r
install.packages(c("raster", "sp", "gstat", "shiny", "gridExtra", "readxl"))
```

## Fonctions principales

| Fonction | Description |
|---|---|
| `import_weather_data()` | Import des donnees meteorologiques (CSV, Excel, dataframe) |
| `calc_eto()` | Calcul de l'ETo (Penman-Monteith FAO-56) |
| `calc_kc()` | Coefficients culturaux Kc par stade phenologique |
| `calc_etc()` | Evapotranspiration culturale ETc = Kc x ETo |
| `soil_water_balance()` | Bilan hydrique journalier du sol |
| `irrigation_schedule()` | Calendrier et doses d'irrigation |
| `summarize_water_balance()` | Resume saisonnier du bilan hydrique |
| `plot_water_balance()` | Visualisation du bilan hydrique |
| `interpolate_climate()` | Interpolation spatiale (IDW, krigeage) |
| `load_raster_eto()` | Import et decoupe de rasters ETo (MODIS, WorldClim) |
| `compare_station_vs_raster()` | Validation station meteo vs raster ETo |
| `plot_irrigation_map()` | Cartographie des besoins en irrigation |
| `generate_report()` | Rapport HTML automatique |
| `shiny_dashboard()` | Dashboard Shiny interactif |

## Exemple d'utilisation

```r
library(hydroAgri)

# 1. Calcul de l'ETo (Penman-Monteith FAO-56)
eto <- calc_eto(tmax = 32, tmin = 18, solar_rad = 22,
                 wind_speed = 2.5, humidity = 45)
print(paste("ETo =", eto, "mm/jour"))

# 2. Coefficients Kc pour le ble
kc <- calc_kc(culture = "ble", date_debut = "2023-11-01",
               duree_stades = c(25, 40, 40, 20))
head(kc)

# 3. Evapotranspiration culturale (ETc)
eto_serie <- rep(eto, nrow(kc))
etc <- calc_etc(eto_serie, kc$Kc)

# 4. Bilan hydrique du sol
rain <- ifelse(runif(nrow(kc)) > 0.8, runif(nrow(kc), 5, 20), 0)
bilan <- soil_water_balance(etc, rain, RU = 100)
head(bilan)

# 5. Calendrier d'irrigation
planning <- irrigation_schedule(etc, rain, RU = 100)
cat("Total irrigue :", planning$total_irrigation, "mm\n")

# 6. Resume saisonnier
summarize_water_balance(bilan)

# 7. Visualisation
plot_water_balance(bilan)
```

## Jeu de donnees d'exemple

Le package fournit un jeu de donnees climatiques d'exemple, utilisable avec
`import_weather_data()` :

```r
data(climat_exemple)
head(climat_exemple)
```

## Vignette

Un workflow complet et reproductible (import meteo -> ETo -> Kc -> ETc ->
bilan hydrique -> irrigation -> resume -> graphiques) est disponible dans la
vignette :

```r
vignette("hydroAgri", package = "hydroAgri")
```

## Tests

Le package est couvert par des tests unitaires (`testthat`) pour l'ensemble
des fonctions. Pour les executer :

```r
devtools::test()
```

## Cultures supportees

- Ble
- Mais
- Tomate
- Olivier
- Pomme de terre

## Methode

Ce package suit la methode **FAO-56** (Allen et al., 1998) pour le
calcul de l'evapotranspiration et du bilan hydrique :

```
ETo = [0.408 * Delta * (Rn - G) + gamma * (900 / (T + 273)) * u2 * (es - ea)] /
      [Delta + gamma * (1 + 0.34 * u2)]

ETc = Kc * ETo
```

## Auteur

Mafhoum Chaimae
