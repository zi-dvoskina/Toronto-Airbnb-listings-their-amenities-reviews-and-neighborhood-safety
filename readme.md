Toronto Airbnb listings, their amenities, reviews,  and neighborhood safety.

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

<img width="1904" alt="1" src="https://user-images.githubusercontent.com/67168908/142513333-97b189dd-9c88-4fc0-95e0-b2660141b8b2.png">
<img width="1904" alt="2" src="https://user-images.githubusercontent.com/67168908/142513339-acabcea7-7d3f-4e2e-97b6-5c61c43a6138.png">
<img width="1904" alt="3" src="https://user-images.githubusercontent.com/67168908/142513343-37b6ebbc-c8ee-488b-84b8-19510e2da4a9.png">
<img width="1904" alt="4" src="https://user-images.githubusercontent.com/67168908/142513350-b085fdb6-0950-463a-b14e-3aca64f4a5aa.png">
<img width="1904" alt="5" src="https://user-images.githubusercontent.com/67168908/142513355-3f244b09-dc01-4870-b4d9-0e8f9dd2c8df.png">

The dashboard can be used by Toronto-based Airbnb hosts to identify what amenities would yield them most returns and what the listing should include. It’s especially useful for those looking to invest in a property to become a host as they can choose an estate that would maximize their ROI.

❗️ make sure to change the path in the global.R file if you're wishing to run the app ❗️

- global parameter (directory of the data files)
- dir_data = '~/Documents/NORTHEASTERN UNIVERSITY/MSBA/MISM 6210/Airbnb/data'
