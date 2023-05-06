#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(data.table)
library(ggplot2)

load(file="ngrams")
load(file="contractions")


##### FUNCTIONS #####
predict <- function(text_input){
  
  # 1. Remove upper case
  text_input <- tolower(text_input)
  
  # 2. Remove dots in acronyms
  pattern <- "(?<!\\w)([a-z])\\." # this pattern matches a letter follow by a period ".", but only if it's not preceded by a word character
  text_input <- gsub(pattern = pattern, "\\1", text_input, perl=T)
  
  # 3. Replace contractions (e.g. "it's")
  string_with_apostr <- stringr::str_detect(text_input, "'")
  
  for (k in 1:length(contractions$contraction)) {
    text_input[string_with_apostr] <- gsub(contractions$contraction[k], contractions$Meaning[k], text_input[string_with_apostr],fixed=T)
  }
  
  # 4. Substitute numbers with a string identifier
  text_input <- gsub("[0-9]+[0-9]?", "NUM", text_input)
  
  # 5. Simplify decimals
  text_input <- gsub("NUM[\\.,: ]NUM","NUM",text_input)
  
  # 6. Split by white space and remove additional white spaces (empty strings)
  split <- strsplit(text_input," ")[[1]]
  split <- split[split!=""]
  
  # 7. Check length and separate by last 3, 2, and 1 words
  split_length <- length(split)
  if(split_length > 3){
    last_3_words <- paste(split[(split_length-2):split_length], collapse=" ")
  } else {last_3_words <- paste(split, collapse=" ")}
  
  if(split_length > 2){
    last_2_words <- paste(split[(split_length-1):split_length], collapse=" ")
  } else {last_2_words <- paste(split, collapse=" ")}
  
  if(split_length > 1){
    last_word <- paste(split[split_length], collapse=" ")
  } else {last_word<- paste(split, collapse=" ")}
  
  # 8. Search in the 3-words ngram exists, otherwise reduce to 2 and eventually 1. Otherwise put standard output
  df_input <- data.table(ngrams=last_3_words)
  output <- ngrams[df_input][1:3][,.(words,freq)][!is.na(freq)]
  
  if(nrow(output)<3){
    df_input <- data.table(ngrams=last_2_words)
    output <- rbind(output, ngrams[df_input][,.(words,freq)])[1:3][!is.na(freq)]
  }
  
  if(nrow(output)<3){
    df_input <- data.table(ngrams=last_word)
    output <- rbind(output, ngrams[df_input][,.(words,freq)][1:3][!is.na(freq)])
  }
  
  ## Standard output when everything fails and we cry
  if(nrow(output)<3){
    output <- rbind(output,data.table(words=c("the","to","a"), freq=c(18357,16290,13970)))
  }
  
  names(output)<- c("Next word","Occurences found")
  
  output
}

##### SERVER LOGIC #####
function(input, output) {
  output$value <- renderDataTable(options=list(paging = FALSE, searching = FALSE, info=F),
                                  if(nrow(predict(input$text))==0){
                                    data.table("Oups!"="No prediction (T_T)")
                                  } else {
                                    predict(input$text)
                                  }
  )
  
  output$plot <- renderPlot({
    pred.table <- predict(input$text)
    
    if(nrow(pred.table)==0){
      data.table("Oups!"="No prediction (T_T)")
    } else {
      # Barplot
      ggplot(pred.table,
             aes(reorder(`Next word`, `Occurences found`),
                 y=`Occurences found`,
                 fill=`Occurences found`)) +
        geom_bar(stat="identity") +
        theme(text = element_text(size=20)) +
        ggtitle(label="Most common words following your input") +
        labs(x="",y="",fill="Occurences found\n") +
        scale_fill_gradient(low = "lavender", high = "violet") +
        coord_flip()
    }
  })
}

