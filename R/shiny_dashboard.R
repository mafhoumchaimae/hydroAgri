#' Dashboard Shiny interactif
#'
#' Lance une application Shiny interactive pour visualiser
#' le bilan hydrique et les besoins en irrigation.
#'
#' @return Lance l'application Shiny
#'
#' @examples
#' \dontrun{
#' shiny_dashboard()
#' }
#'
#' @export
shiny_dashboard <- function() {
  if (!requireNamespace("shiny", quietly = TRUE))
    stop("Package 'shiny' requis. Installez-le avec install.packages('shiny')")

  ui <- shiny::fluidPage(
    shiny::titlePanel("hydroAgri - Bilan Hydrique des Cultures"),

    shiny::sidebarLayout(
      shiny::sidebarPanel(
        shiny::selectInput("culture", "Culture :",
                           choices = c("ble", "mais", "tomate",
                                       "olivier", "pomme_de_terre"),
                           selected = "ble"),
        shiny::numericInput("RU", "Reserve Utile (mm) :", value = 100),
        shiny::numericInput("nb_jours", "Nombre de jours :", value = 90),
        shiny::sliderInput("eto_moy", "ETo moyenne (mm/jour) :",
                           min = 1, max = 10, value = 5),
        shiny::sliderInput("pluie_prob", "Probabilite de pluie :",
                           min = 0, max = 1, value = 0.2),
        shiny::actionButton("calculer", "Calculer",
                            class = "btn-success")
      ),

      shiny::mainPanel(
        shiny::tabsetPanel(
          shiny::tabPanel("Bilan Hydrique",
                          shiny::plotOutput("plot_bilan")),
          shiny::tabPanel("Calendrier Irrigation",
                          shiny::tableOutput("table_irrigation")),
          shiny::tabPanel("Resume",
                          shiny::tableOutput("table_resume"))
        )
      )
    )
  )

  server <- function(input, output, session) {
    data <- shiny::eventReactive(input$calculer, {
      n    <- input$nb_jours
      etc  <- runif(n, input$eto_moy * 0.6, input$eto_moy * 1.2)
      rain <- ifelse(runif(n) > (1 - input$pluie_prob),
                     runif(n, 5, 25), 0)
      bilan   <- soil_water_balance(etc, rain, RU = input$RU)
      planning <- irrigation_schedule(etc, rain, RU = input$RU)
      list(bilan = bilan, planning = planning)
    })

    output$plot_bilan <- shiny::renderPlot({
      shiny::req(data())
      plot_water_balance(data()$bilan,
                         titre = paste("Bilan -", input$culture))
    })

    output$table_irrigation <- shiny::renderTable({
      shiny::req(data())
      data()$planning$evenements
    })

    output$table_resume <- shiny::renderTable({
      shiny::req(data())
      summarize_water_balance(data()$bilan)
    })
  }

  shiny::shinyApp(ui = ui, server = server)
}
