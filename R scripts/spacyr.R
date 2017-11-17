# Install spacyr package

#devtools::install_github("kbenoit/spacyr", build_vignettes = FALSE)
require(spacyr)
require(dplyr)

spacy_initialize(python_executable = "/usr/local/bin/python2.7")

txt <- c(d1 = "spaCy excels at large-scale information extraction tasks.",
         d2 = "Mr. Smith goes to North Carolina.")

# Awesome! Look up defaults, but tags are more detailed POS-tags. 
parsedtxt <- spacy_parse(txt, tag=TRUE)
parsedtxt

# Extract entities
entity_extract(parsedtxt)
# Consolidate multi-word entities
entity_consolidate(parsedtxt)

?spacy_parse



text <- ("This project examines how Americans talk about death. As each of these examples demonstrate, our discussions of death play a critical role in shaping both our understanding and behavior when confronting mortality. From the ‘age of denial’ that Kübler-Ross documents, to the shared narratives of hospice professionals, to the identity struggles of today’s healthcare chaplains, our approach to death is fundamentally tied to our discussion of it. While the discussion of death has traditionally taken place under the umbrella of religion, the rise of medical sciences in the 18th century increasingly made death a concern for modern medicine.")

parsed <- spacy_parse(text, tag=TRUE)
parsed2 <- entity_consolidate(parsed)
entity_extract(parsed2)

justverbs <- filter(parsed2, pos == "VERB")
justnouns <- filter(parsed2, pos == "NOUN")


#####################################
# Country Music example
#####################################

# Load data:
load("/Users/johnbernau/Box Sync/1.Desktop/Country Music/DATA/cm_clean.RData")

# Smaller subset
lyrics <- dataset[1:100,]

# Create ID variable
lyrics <- lyrics %>% 
  mutate(id = row_number())

# Create parsed data frame
lyricspar <- spacy_parse(lyrics$cleantext)

# Turn "doc_id" variable into ID variable
lyricspar$id <- as.numeric(gsub("text", "", lyricspar$doc_id))

# Join by ID variable!
joined <- inner_join(lyrics, lyricspar)

spacy_finalize()
