shinyServer(function(input, output) {

    reactiv <- shiny::reactiveValues()
    reactiv$reactiv_data <- NULL
    reactiv$counts <- NULL
    reactiv$viz_airbnb <- NULL
    reactiv$amenities_airbnb <- NULL
    

    observe({ 

        if (is.null(reactiv$reactiv_data)) {

            load_data = data.table::fread(file = file.path(dir_data, 'new_project_data.csv'),
                                          header = T,
                                          stringsAsFactors = F,
                                          nThread = parallel::detectCores())

            reactiv$reactiv_data = load_data

            output$home_rating = shiny::renderUI({

                unq_rating = unique(sort(load_data$home_rating))

                shiny::selectInput(inputId = 'home_rating',
                                   label = 'Select a Home Rating:',
                                   choices = c('all_data', unq_rating),
                                   multiple = FALSE,
                                   width="150px",
                                   selected = 'all_data')
            })


            output$keep_neighbourhoods = shiny::renderUI({
                
                unq_neighb = as.character(unique(sort(load_data$neighbourhood_cleansed)))

                shiny::selectInput(inputId = 'keep_neighbourhoods',
                                   label = 'Select Neighbourhood:',
                                   choices = c('all_data', unq_neighb),
                                   multiple = FALSE,
                                   width="200px",
                                   selected = 'all_data')
            })
        }
    })


    observe({

        if (is.null(reactiv$counts)) {

            dat_counts = data.table::fread(file = file.path(dir_data, 'word_count.csv'),
                                           header = T,
                                           stringsAsFactors = F,
                                           nThread = parallel::detectCores())

            cols_wordcloud = c('words', 'n')
            dat_counts = dat_counts[, ..cols_wordcloud]
            dat_counts = dat_counts[, .(frequency = sum(n)), by = 'words']
            dat_counts = dat_counts[order(dat_counts$frequency, decreasing = T), ]

            reactiv$counts = dat_counts

            output$max_words <- renderUI({

                sliderInput(inputId = "max_words",
                            label = "Word Cloud Slider",
                            min = 5,
                            # max   = max(dat_counts$frequency),
                            max = 1000,
                            value = 25)
            })
        }
    })
    
    
    observe({
        
        if (is.null(reactiv$viz_airbnb)) {
            
            # read the file 
            data <- read.csv(file.path(dir_data, 'visualization_airbnb.csv'))
            data <- as_tibble(data)
            # names(data)
            # dim(data) #400000     48
            
            # summary(data)
            # remove the first columns
            data$X <- NULL
            data$Unnamed..0 <- NULL
            data$property_type_new <- NULL
            
            reactiv$viz_airbnb = data
        }
    })
    
    
    observe({
        
        if (is.null(reactiv$amenities_airbnb)) {
            
            # create a bar plot for the amenities to count frequency of each amenity
            amenities <- read.csv(file.path(dir_data, 'top_50_amenities_airbnb.csv'))
            amenities$X <- NULL
            
            sorted <- amenities %>%
                mutate(amenity=str_replace_all(amenity, "[^[:alnum:]]", "")) %>%
                mutate(amenity = sort(amenity,decreasing=TRUE)) 

            reactiv$amenities_airbnb = sorted
        }
    })
    
    
    observeEvent(c(reactiv$reactiv_data,
                   input$home_rating), {

                       if (shiny::isTruthy(reactiv$reactiv_data)) {
                           if (shiny::isTruthy(input$home_rating)) {
                               
                               if (input$home_rating == 'all_data') {
                                   param_rating = ''
                               }
                               else {
                                   param_rating = input$home_rating
                               }

                               dat_scat = scatter_bubble_plot(dat_all = reactiv$reactiv_data, home_rating = param_rating)

                               output$scat_plot <- renderPlot({
                                   dat_scat
                               })
                           }
                       }
                   })


    observeEvent(c(reactiv$counts,
                   input$max_words), {

                       if (shiny::isTruthy(reactiv$counts)) {

                           inp_value = nrow(reactiv$counts)
                           if (!is.null(input$max_words)) {
                               inp_value = as.integer(input$max_words)
                           }

                           output$wordcloud2 <- renderPlot({
                               wordcloud::wordcloud(words = reactiv$counts$words,
                                                    freq = reactiv$counts$frequency,
                                                    max.words = inp_value,
                                                    random.order = FALSE,
                                                    scale = c(5, 0),
                                                    colors = RColorBrewer::brewer.pal(8, "Dark2"))
                           })
                       }
                   })
    
    
    observeEvent(c(reactiv$reactiv_data,
                   input$max_words), {
                       
                       if (shiny::isTruthy(reactiv$reactiv_data)) {
                           if (shiny::isTruthy(input$max_words)) {

                               # word cloud by Jack:
                               ##Subsetting
                               df_visual1 <- reactiv$reactiv_data %>%
                                   select("neighbourhood_cleansed",'home_rating','text') %>%
                                   filter(home_rating == 'poor')
                               
                               ##Tokenize
                               tokenized_data <- df_visual1 %>%
                                   unnest_tokens(word,text)
                               
                               #####Word Cloud

                               output$wordcloud_jack <- renderPlot({
                                   
                                   tokenized_data %>%
                                       select(neighbourhood_cleansed,word)%>%
                                       anti_join(get_stopwords())%>%
                                       count(word,sort=TRUE)%>%
                                       with(wordcloud(words = word,
                                                      freq = n,
                                                      random.order = FALSE,
                                                      scale = c(5, 0),
                                                      max.words=input$max_words))
                               })
                           }
                       }
                   })

    
    observeEvent(c(reactiv$reactiv_data,
                   input$keep_neighbourhoods), {
                       
                       if (shiny::isTruthy(reactiv$reactiv_data)) {
                           if (shiny::isTruthy(input$keep_neighbourhoods)) {
                               
                               if (input$keep_neighbourhoods == 'all_data') {
                                   subs_neighb = reactiv$reactiv_data
                                   idx_room = 1:nrow(subs_neighb)
                               }
                               else {
                                   idx_neighb = which(reactiv$reactiv_data$neighbourhood_cleansed == input$keep_neighbourhoods)
                                   subs_neighb = reactiv$reactiv_data[idx_neighb, ]
                                   idx_room = which(subs_neighb$room_type == "Entire home/apt")           # this takes too long because it has 296.792  obs.
                               }
                               
                               if (length(idx_room) > 0) {
                                   
                                   # idx_room = which(subs_neighb$room_type == "Private room")                # this has 102.124
                                   subs_dat = subs_neighb[idx_room, ]
                                   subs_dat$beds = as.factor(subs_dat$beds)
                                   
                                   subs_dat$price = gsub('[$]', '', subs_dat$price)
                                   subs_dat$price = gsub('[,]', '', subs_dat$price)
                                   subs_dat$price = as.numeric(subs_dat$price)
                                   # subs_dat$price = round(subs_dat$price)
                                   
                                   plt = ggplot(subs_dat, aes(x = beds, y = price)) +
                                       geom_boxplot() +
                                       # scale_x_discrete(name = "beds") +
                                       # geom_point(shape=21, color="blue", fill='white') + 
                                       geom_smooth(method = lm, se=TRUE) +
                                       scale_x_discrete(name="Number of Beds", limits = c("1","2","3","4","5","6","7","8","9")) +
                                       scale_y_continuous(name="Price ($)") +
                                       labs(title = "Property price versus number of beds")
                                   
                                   # summary(lm(price~beds, data=df_entirehome))
                                   
                                   output$lm_plot <- renderPlot({
                                       plt
                                   })
                               }
                               else {
                                   this_msg = glue::glue("There are no 'Entire home/apt' for the neighbourhood:  '{input$keep_neighbourhoods}'!")
                                   shiny::showNotification(this_msg, type = "error")
                                   print(this_msg)
                               }
                           }
                       }
                   })

    
    observeEvent(c(reactiv$reactiv_data,
                   input$home_rating), {

                       if (shiny::isTruthy(reactiv$reactiv_data)) {
                           if (shiny::isTruthy(input$home_rating)) {
                               
                               if (input$home_rating == 'all_data') {
                                   df_visual2 <- reactiv$reactiv_data %>%
                                       select("neighbourhood_cleansed",'home_rating')
                                   
                                   idx_rating = 1:nrow(df_visual2)
                               }
                               else {
                                   df_visual2 <- reactiv$reactiv_data %>%
                                       select("neighbourhood_cleansed",'home_rating')
                                   
                                   idx_rating = which(df_visual2$home_rating == input$home_rating)
                               }
                               
                               if (length(idx_rating) > 0) {
                                   
                                   df_visual2 = df_visual2[idx_rating, ]
                                   
                                   bar <- ggplot(df_visual2,
                                                 aes(neighbourhood_cleansed, fill = home_rating))+
                                       geom_bar(color = 'black') +
                                       scale_fill_brewer(palette = 'Blues') +
                                       ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 30, vjust = 1.0, hjust = 1.0)) +
                                       labs(
                                           title = 'Neighbourhood vs Review Sentiments',
                                           x = 'Neighbourhoods',
                                           y = 'Number of Reviews',
                                           fill = 'Review Sentiments'
                                       ) +
                                       ggplot2::theme(plot.title = ggplot2::element_text(size = 9))
                                   
                                   bar = ggplotly(bar) %>%
                                       config(displayModeBar = F)
                                   
                                   output$plotly_jack <- renderPlotly({
                                       bar
                                   })
                               }
                               else {
                                   this_msg = glue::glue("There are no observations for home rating: '{input$home_rating}'!")
                                   shiny::showNotification(this_msg, type = "error")
                                   print(this_msg)
                               }
                           }
                       }
                   })
    
    
    #.................................................................................................................................  airbnb data
    
    
    observeEvent(reactiv$amenities_airbnb, {
        
        if (shiny::isTruthy(reactiv$amenities_airbnb)) {
            
            plt_am = ggplot(reactiv$amenities_airbnb, aes(x=count,y=amenity)) +
                geom_bar(stat='identity',show.legend=FALSE) +
                geom_col() + 
                labs(title='The Amenity Counts',
                     x='Counts',
                     y='Amenities')
            
            output$airb_amenities <- renderPlot({
                plt_am
            })
        }
    })
    
    
    observeEvent(reactiv$viz_airbnb, {
        
        if (shiny::isTruthy(reactiv$viz_airbnb)) {
            
            select_data <- reactiv$viz_airbnb %>% 
                select(listing_id,amenities,count_amenities,price) %>%
                distinct() %>%
                mutate(median_amenities = case_when(count_amenities > 29  ~ "Yes", 
                                                    count_amenities <= 29  ~ "No"))%>%
                group_by(median_amenities) %>%
                summarize(median_price = median(price))
            
            plt_med = ggplot(select_data,aes(x=median_amenities,y=median_price,
                                             fill=median_amenities)) +
                geom_bar(stat='identity',show.legend=FALSE) +
                scale_fill_brewer(palette = 'PuRd')+
                labs(title='The Relationship Between The Number of Amenities and Price ',
                     x='The Number of Amenities Provided are above 29 ?',
                     y='Median Price')
            
            output$viz_airb_med <- renderPlot({
                plt_med
            })
        }
    })
    
    
    observeEvent(reactiv$viz_airbnb, {
        
        if (shiny::isTruthy(reactiv$viz_airbnb)) {
            
            review_score <- reactiv$viz_airbnb %>% 
                select(review_scores_rating,home_rating,price) %>%
                distinct() %>%
                group_by(home_rating) %>%
                summarize(avg_price=mean(price)) %>%
                mutate(avg_price = sort(avg_price,decreasing=TRUE))
            
            pltly_price = ggplotly(ggplot(review_score,aes(x=home_rating,y=avg_price,
                                                           fill=home_rating)) +
                                       geom_bar(stat='identity',show.legend=FALSE)+
                                       scale_fill_brewer(palette = 'Blues')+
                                       labs(title='The Relationship Between Home Rating and Price ',
                                            x='Home Rating',
                                            y='Average Price')) %>%
                config(displayModeBar = F)
            
            output$viz_airb_plotl_price <- renderPlotly({
                pltly_price
            })
        }
    })
    
    
    observeEvent(reactiv$viz_airbnb, {
        
        if (shiny::isTruthy(reactiv$viz_airbnb)) {
            
            instant_price <- reactiv$viz_airbnb %>%
                select(listing_id,instant_bookable,price) %>%
                distinct() %>%
                group_by(instant_bookable) %>%
                summarize(avg_price=mean(price))
            
            label <- c("False", "True")
            
            plt_bookable = ggplot(instant_price,aes(x=instant_bookable,y=avg_price,
                                                    fill=instant_bookable))+
                geom_bar(stat='identity',show.legend=FALSE)+
                scale_x_discrete(labels= label)+
                scale_fill_brewer(palette = 'Blues')+
                labs(title='If Instant Bookable Will Affect The Listing Price? ',
                     x='Instant Bookable',
                     y='Average Price')
            
            output$viz_airb_bookable <- renderPlot({
                plt_bookable
            })
        }
    })
    
    
    observeEvent(c(reactiv$viz_airbnb,
                   input$keep_neighbourhoods), {
                       
                       if (shiny::isTruthy(reactiv$viz_airbnb)) {
                           if (shiny::isTruthy(input$keep_neighbourhoods)) {
                               
                               if (input$keep_neighbourhoods == 'all_data') {
                                   idx_neighb = 1:nrow(reactiv$viz_airbnb)
                               }
                               else {
                                   idx_neighb = which(reactiv$viz_airbnb$neighbourhood_cleansed == input$keep_neighbourhoods)
                               }
                               
                               if (length(idx_neighb) > 0) {
                                   
                                   subs_neighb = reactiv$viz_airbnb[idx_neighb, ]
                                   
                                   identity_price <- subs_neighb %>%
                                       select(listing_id,host_identity_verified,price) %>%
                                       distinct() %>%
                                       group_by(host_identity_verified) %>%
                                       summarize(median_price=median(price))
                                   
                                   label <- c("False", "True")
                                   
                                   plt_ident_price = ggplot(identity_price,aes(x=host_identity_verified,y=median_price,
                                                                               fill=host_identity_verified))+
                                       geom_bar(stat='identity',show.legend=FALSE)+
                                       scale_x_discrete(labels= label)+
                                       scale_fill_brewer(palette = 'Blues')+
                                       labs(title='Host Identity Verification vs Price',
                                            x='If Hosts Verify Their Identities?',
                                            y='Median Price')
                                   
                                   output$viz_airb_ident <- renderPlot({
                                       plt_ident_price
                                   })
                               }
                               else {
                                   this_msg = glue::glue("There are no observations for the neighbourhood:  '{input$keep_neighbourhoods}'!")
                                   shiny::showNotification(this_msg, type = "error")
                                   print(this_msg)
                               }
                           }
                       }
                   })
    
    
    observeEvent(c(reactiv$viz_airbnb,
                   input$keep_neighbourhoods), {
                       
                       if (shiny::isTruthy(reactiv$viz_airbnb)) {
                           if (shiny::isTruthy(input$keep_neighbourhoods)) {
                               
                               if (input$keep_neighbourhoods == 'all_data') {
                                   idx_neighb = 1:nrow(reactiv$viz_airbnb)
                               }
                               else {
                                   idx_neighb = which(reactiv$viz_airbnb$neighbourhood_cleansed == input$keep_neighbourhoods)
                               }
                               
                               if (length(idx_neighb) > 0) {
                                   
                                   subs_neighb = reactiv$viz_airbnb[idx_neighb, ]
                                   
                                   pos <- subs_neighb %>%
                                       select(listing_id,measure,senti_sentiment,review_scores_rating) %>%
                                       distinct()
                                   
                                   plt_pos = ggplot(pos,aes(x = senti_sentiment,y=jitter(review_scores_rating), color =measure))+
                                       geom_point(alpha = 0.3)+
                                       labs(
                                           title = "Review Scores vs Review Sentiment",
                                           
                                           x = "Review Sentiment",
                                           y = "Rewview Score",
                                           color = "measure")
                                   
                                   output$viz_airb_pos <- renderPlot({
                                       plt_pos
                                   })
                               }
                               else {
                                   this_msg = glue::glue("There are no observations for the neighbourhood:  '{input$keep_neighbourhoods}'!")
                                   shiny::showNotification(this_msg, type = "error")
                                   print(this_msg)
                               }
                           }
                       }
                   })
})