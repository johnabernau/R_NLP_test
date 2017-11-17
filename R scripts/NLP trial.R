# Trial with NLP and R

# install.packages("openNLP")
# installed.packages("NLP")

require(rJava)
require(NLP)
require(openNLP)
require(tidytext)

text <- as.String("This project examines how Americans talk about death. As each of these examples demonstrate, our discussions of death play a critical role in shaping both our understanding and behavior when confronting mortality. From the ‘age of denial’ that Kübler-Ross documents, to the shared narratives of hospice professionals, to the identity struggles of today’s healthcare chaplains, our approach to death is fundamentally tied to our discussion of it. While the discussion of death has traditionally taken place under the umbrella of religion, the rise of medical sciences in the 18th century increasingly made death a concern for modern medicine.")

class(text)


## Need sentence and word token annotations.
sent_token_annotator <- Maxent_Sent_Token_Annotator()
word_token_annotator <- Maxent_Word_Token_Annotator()


a2 <- annotate(text, list(sent_token_annotator, word_token_annotator))
a2

pos_tag_annotator <- Maxent_POS_Tag_Annotator()
pos_tag_annotator
a3 <- annotate(text, pos_tag_annotator, a2)
a4 <- as.data.frame(a3)



## Determine the distribution of POS tags for word tokens.
a3w <- subset(a3, type == "word")
tags <- sapply(a3w$features, `[[`, "POS")
tags
table(tags)

## Extract token/POS pairs (all of them): easy.
pos <- sprintf("%s/%s", text[a3w], tags)
pos <- sprintf("%s/%s", text[a3w], tags)

pos2 <- strsplit(pos, "/")
as.matrix(pos2, byrow=T)

text2 <- unlist(strsplit(text, " "))

text2

pos2 <- strsplit(pos, "/")
pos3 <- unlist(pos2)

it <- as.matrix(pos2)

pos4 <- as.list(pos3)
as.matrix(pos4)
col1 <- pos3
col2 <- pos3

# How get POS as a seperate column?? Words in col1, POS in col2. 



mat <- as.matrix(c(col1, col2), byrow=F, ncol=2)
## Extract pairs of word tokens and POS tags for second sentence:
a3ws2 <- annotations_in_spans(subset(a3, type == "word"),
                              subset(a3, type == "sentence")[2L])[[1L]]
sprintf("%s/%s", s[a3ws2], sapply(a3ws2$features, `[[`, "POS"))
