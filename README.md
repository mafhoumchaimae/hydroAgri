# hydroAgri

Package R pour le bilan hydrique des cultures et le calcul des besoins 
en irrigation selon la methode FAO-56.

## Installation

```r
# Installer depuis GitHub
remotes::install_github("mafhoumchaimae/hydroAgri")
```

## Fonctions principales

| Fonction | Description |
|---|---|
| `import_weather_data()` | Import des donnees meteorologiques |
| `calc_eto()` | Calcul de l'ETo (Penman-Monteith FAO-56) |
| `calc_kc()` | Coefficients culturaux Kc |
| `calc_etc()` | Evapotranspiration culturale ETc |
| `soil_water_balance()` | Bilan hydrique du sol |
| `irrigation_schedule()` | Calendrier d'irrigation |
| `summarize_water_balance()` | Resume du bilan hydrique |
| `plot_water_balance()` | Visualisation du bilan hydrique |
| `generate_report()` | Rapport HTML automatique |
| `shiny_dashboard()` | Dashboard Shiny interactif |

## Exemple d'utilisation

```r
library(hydroAgri)

# Calcul de l'ETo
eto <- calc_eto(tmax = 32, tmin = 18, solar_rad = 22,
                wind_speed = 2.5, humidity = 45)
print(paste("ETo =", eto, "mm/jour"))

# Coefficients Kc pour le ble
kc  0.8, runif(90, 5, 20), 0)
bilan <- soil_water_balance(etc, rain, RU = 100)
head(bilan)

# Calendrier d'irrigation
planning <- irrigation_schedule(etc, rain, RU = 100)
cat("Total irrigue :", planning$total_irrigation, "mm")
```

## Cultures supportees

- Ble
- Mais
- Tomate
- Olivier
- Pomme de terre

## Methode

Ce package suit la methode **FAO-56** (Allen et al., 1998) pour le 
calcul de l'evapotranspiration et du bilan hydrique.

## Auteur

Mafhoum Chaimae
