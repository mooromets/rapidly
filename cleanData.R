library(tm)
corp <- SimpleCorpus(DirSource("./data/"))

#remove 2+ puctuation marks in a row 
corp <- tm_map(corp, content_transformer(gsub), 
               pattern = "[[:punct:]]{2,}", 
               replacement = " ")
# leave only letters, numbers and three more puctuation marks that are
# the parts of a language (cost-effective, that's, e.g.)
corp <- tm_map(corp, content_transformer(gsub), 
               pattern = "[^[:alnum:].'-]", 
               replacement = " ")
# remove hanging punctuation marks
corp <- tm_map(corp, content_transformer(gsub), 
               pattern = " [-'.] ", 
               replacement = "")
# remove dots, that are most likely an end of a sentence 
corp <- tm_map(corp, content_transformer(gsub), 
               pattern = "[A-Za-z0-9][.]( +[A-Z]|$)", 
               replacement = " ")
corp <- tm_map(corp, stripWhitespace)