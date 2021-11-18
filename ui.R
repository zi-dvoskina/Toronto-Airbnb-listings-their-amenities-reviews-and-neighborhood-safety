shinyUI(fluidPage(
    
    titlePanel("Shiny Dashboard"),
    
    sidebarLayout(
        sidebarPanel(width = 2,
                     
                     shiny::uiOutput(outputId = "max_words"),
                     shiny::uiOutput(outputId = "home_rating"),
                     shiny::uiOutput(outputId = "keep_neighbourhoods")
                     
        ),
        
        mainPanel(
            
            tabsetPanel(type = "tabs",

                        tabPanel("rating filter",
                                 shiny::fluidRow(
                                     shiny::column(width = 5, height = 5, offset = 0, style = "padding-left:0px; padding-right:5px; padding-top:5px; padding-bottom:20px",
                                                   plotlyOutput(outputId = "plotly_jack")
                                     ),
                                     shiny::column(width = 5, height = 5, offset = 0, style="padding-left:0px; padding-right:5px; padding-top:5px; padding-bottom:20px",
                                                   plotOutput(outputId = "scat_plot")
                                     )
                                 )
                        ),
                        
                        tabPanel("neighbourhood filter",
                                 shiny::fluidRow(
                                     shiny::column(width = 5, height = 5, offset = 0, style = "padding-left:0px; padding-right:5px; padding-top:5px; padding-bottom:20px",
                                                   plotOutput(outputId = "viz_airb_pos"),
                                                   br(),
                                                   br(),
                                                   plotOutput(outputId = "lm_plot")
                                                   
                                     ),
                                     shiny::column(width = 5, height = 5, offset = 0, style="padding-left:0px; padding-right:5px; padding-top:5px; padding-bottom:20px",
                                                   plotOutput(outputId = "viz_airb_ident")
                                     )
                                 )
                        ),
                        
                        tabPanel("word clouds",
                                 shiny::fluidRow(
                                     shiny::column(width = 5, height = 5, offset = 0, style = "padding-left:0px; padding-right:5px; padding-top:5px; padding-bottom:20px",
                                                   plotOutput(outputId = "wordcloud2")
                                     ),
                                     shiny::column(width = 5, height = 5, offset = 0, style="padding-left:0px; padding-right:5px; padding-top:5px; padding-bottom:20px",
                                                   plotOutput(outputId = "wordcloud_jack")
                                     )
                                 )
                        ),
                        
                        tabPanel("other",
                                 shiny::fluidRow(
                                     shiny::column(width = 5, height = 5, offset = 0, style = "padding-left:0px; padding-right:5px; padding-top:5px; padding-bottom:20px",
                                                   plotlyOutput(outputId = "viz_airb_plotl_price"),
                                                   br(),
                                                   br(),
                                                   plotOutput(outputId = "viz_airb_bookable")
                                     ),
                                     shiny::column(width = 5, height = 5, offset = 0, style = "padding-left:0px; padding-right:5px; padding-top:5px; padding-bottom:20px",
                                                   plotOutput(outputId = "viz_airb_med")
                                     )
                                 ),
                                 shiny::fluidRow(
                                     shiny::column(width = 12, height = 8, offset = 0, style="padding-left:0px; padding-right:5px; padding-top:5px; padding-bottom:20px",
                                                   plotOutput(outputId = "airb_amenities")
                                     )
                                 )
                        )
            )
        )
    )
))