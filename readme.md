Toronto Airbnb listings and crime rates.

Project timeline:
Jan 2021 - April 2021

Project team:
- Zinaida Dvoskina (myself)
- Kirill Ilin
- Lichang Tan
- Jack Qu
- Sam Therrien

Gathered datasets on crime rates in the city of Toronto and Toronto Airbnb listings from different sources. Cleaned and wrangled them using dplyr package, among other tidyverse packages.

Conducted text analysis: pre-processed the text data (tokenize, stem, lemmatize, and spell-check each keyword; converted each text message to a single overall sentiment value using SentiWordNet lexicon; conducted a Parts of Speech analysis, and computed for each message the number of verbs, nouns, adjectives, and adverbs. 

Created an R Shiny application dashboard containing the following ggplot2 visualizations:

1. bar chart - Neighbourhood vs Review Sentiments
2. scatterplot - Relation between home_rating, safety_level, price and Assault_Rate_2019
3. scatterplot - Review Scores vs Review Sentiment
4. bar chart - Host Identity Verification vs Price
5. boxplot - Property price versus number of beds
6. word cloud - Positive reviews
7. word cloud - Negative reviews
8. bar chart - The Relationship Between Home Rating and Price
9. bar chart - The Relationship Between The Number of Amenities and Price
10. bar chart - If Instant Bookable Will Affect The Listing Price?
11. bar chart - The Amenity Counts

And the following user controls:

- Word Cloud Slider (number of words)
- Home Rating Selector (poor, acceptable, good, very good, excellent)
- Neighbourhood Selector

<img width="1904" alt="Screen Shot 2021-11-18 at 05 36 20" src="https://user-images.githubusercontent.com/67168908/142423654-2f29a3c8-a306-4e8b-a02a-557c23bb4ca7.png">
<img width="1904" alt="Screen Shot 2021-11-18 at 05 36 08" src="https://user-images.githubusercontent.com/67168908/142423682-c5497ca8-4646-4dbc-a765-a98d1b77e887.png">
<img width="1904" alt="Screen Shot 2021-11-18 at 05 35 56" src="https://user-images.githubusercontent.com/67168908/142423704-5b60295c-6a59-49e1-b962-bc45601153fb.png">
<img width="1904" alt="Screen Shot 2021-11-18 at 05 35 44" src="https://user-images.githubusercontent.com/67168908/142423729-4cfe7a0e-7894-4d4b-b16e-f9d757332177.png">

The dashboard can be used by Toronto-based Airbnb hosts to identify what amenities would yield them most returns and what the listing should include. It’s especially useful for those looking to invest in a property to become a host as they can choose an estate that would maximize their ROI.

❗️ make sure to change the path in the global.R file if you're wishing to run the whole app
❗️ global parameter (directory of the data files)
❗️ dir_data = '~/Documents/NORTHEASTERN UNIVERSITY/MSBA/MISM 6210/Final Project/data
