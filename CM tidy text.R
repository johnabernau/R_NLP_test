#############################
# Country Music dataset
# John Bernau
# 11.7.17
# Experimenting with tidy text principles
#############################
#install.packages("readstata13")
require(readxl)
require(readstata13)
require(ggplot2)
require(psych)
require(plotly)
require(dplyr)
require(tidyr)
require(stringr)
require(xlsx)
require(tidytext)
?geom_jitter
?geom_smooth
#####################################################
# Load Data
#####################################################
cm <- read_excel("/Users/johnbernau/Box Sync/1.Desktop/Country Music/DATA/22. final dataset 6.16.17.xlsx")

# Try on first 1,000 rows
cm_sub <- cm[3:1003,]

# Tokenize by word
cm_tidy <- cm_sub %>%
  # Transform the non-tidy text data to tidy text data
  unnest_tokens(word, lyrics)

newdataset <- unnest_tokens(orignaldata, newcolumn, text)


# Look at word counts (mostly stop words)
count(cm_tidy, word) %>% 
  arrange(desc(n))


# Access bing lexicon: bing
bing <- get_sentiments("bing")

nrc <- get_sentiments("nrc")
count(nrc, sentiment)

# Do innerjoin for cm data and bing sentiment:
cm_tidy_joined <- cm_tidy %>%
  inner_join(bing)
# This takes word count (rows) down from original 217,316 to the 15,625 words that ALSO appear in the bing sentiment dictionary.


counts <- cm_tidy_joined %>% 
  count(word, sentiment) %>% 
  arrange(desc(n))

# Count by sentiment for each song
another <- cm_tidy_joined %>% 
  count(artist, stitle, sentiment)
  
# Create a sentiment ratio and sort
another2 <- another %>% 
  group_by(stitle) %>% 
  mutate(length = sum(n),
         ratio=n/length) %>% 
  arrange(desc(ratio)) %>% 
  ungroup()

# Still need to examine this... if it only observes 4 positive words is it "100% positive"? 

# How would you recreate the ID variables in R? A number for each artist, a number for each album, and a number for each song.

# This creates songID number.
trial <- cm_sub %>% 
  group_by(artist, albumtitle) %>% 
  mutate(t_songID=row_number()) %>% 
  ungroup()
# Comparing...
trial <- select(trial, t_songID, everything())
trial$t_songID == trial$id_song

# Creating artist number
artistsub <- trial %>% 
  count(artist) %>% 
  mutate(t_artistID = row_number())
# Join together and compare! 
trial2 <- inner_join(trial, artistsub, by="artist")
trial2 <- select(trial2, t_artistID, Id_artist, t_songID, id_song, everything())
trial2$t_artistID == trial2$Id_artist


# Creating album number
albumsub <- trial2 %>% 
  count(artist, albumtitle) %>% 
  group_by(artist) %>% 
  mutate(t_albumID = row_number()) %>% 
  ungroup()
# Join together and compare! 
trial3 <- inner_join(trial2, albumsub, by="albumtitle")
trial3 <- select(trial3, t_artistID, Id_artist, t_songID, id_song, t_albumID, id_album, everything())
trial3$t_albumID == trial3$id_album
