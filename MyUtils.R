# given path to a .txt file the function readCorpus loads
# all sentences into a character vector and returns it
readCorpus <- function(pathToFile){
  con <- file(pathToFile) 
  # readLine throws a warning if the last line of the text file is not terminated 
  # by caridge return
  sentences <- readLines(con, encoding = "UTF-8")
  close(con)
  return(sentences)
}
# given a string vector and size of ngrams this function returns ngrams

createNgram <-function(stringVector, ngramSize){
  library(tau) 
  library(data.table)
  ngram <- data.table()
  
  ng <- textcnt(stringVector, method = "string", n=ngramSize, tolower = FALSE)
  
  if(ngramSize==1){
    ngram <- data.table(w1 = names(ng), freq = unclass(ng), length=nchar(names(ng)))  
  }
  else {
    ngram <- data.table(w1w2 = names(ng), freq = unclass(ng), length=nchar(names(ng)))
  }
  return(ngram)
}

# given a charVector this function returns a datatable with 13 variables including bigrams 
# and their Mutual Info
computeMI <- function(charVector){
  n1gram <- createNgram(charVector, 1)
  w1sum <- sum(n1gram$freq)
  # data.table(w1w2 = names(ng2), freq = unclass(ng2), length=nchar(names(ng2)))
  n2gram <- createNgram(charVector, 2)
  w1w2sum <- sum(n2gram$freq)
  library(reshape)
  # splits the bigram column w1w2 to two columns result.w1 and result.w2
  temp <- transform(n2gram, result = colsplit(n2gram$w1w2, split= " ", names=c("w1", "w2")))
  # performs a two join to lookup freq for w1 and w2 in n1gram
  result <- temp[n1gram, on=c(result.w1 = "w1"), nomatch = 0][n1gram, on=c(result.w2 = "w1"), nomatch = 0]
  # rename columns in result
  setnames(result, "result.w1", "w1")
  setnames(result, "result.w2", "w2")
  setnames(result, "i.freq", "freq_w1")
  setnames(result, "i.length", "length_w1")
  setnames(result, "i.freq.1", "freq_w2")
  setnames(result, "i.length.1", "length_w2")
  # maximum likelihood estimate of bigrams = prw1w2
  result <- result[, prw1w2 := freq / w1w2sum]
  # maximum likelihood estimate of unigram = prw1
  result <- result[, prw1 := freq_w1 / w1sum]
  # maximum likelihood estimate of unigram = prw2
  result <- result[, prw2 := freq_w2 / w1sum]
  # mutual info = logbase2(prw1w2 / (prw1 * prw2 ))
  result <- result[, MutualInfo := log2( ( prw1w2 / (prw1 * prw2)) )]
  result <- result[, prw2gw1 := freq / freq_w1]
  result$N1B <- factor(sapply(result$w1, boundarychar,1))
  result$N2B <- factor(sapply(result$w2, boundarychar,2))
  result <- renameColumns(result)
  return(as.data.frame(result))
}

renameColumns <- function(df){
  names(df)[names(df)=="prw1w2"] <- "Max.Likelihood"
  names(df)[names(df)=="MutualInfo"] <- "Mutual.Info"
  names(df)[names(df)=="length"] <- "Length"
  names(df)[names(df)=="length_w1"] <- "n1"
  names(df)[names(df)=="length_w2"] <- "n2"
  names(df)[names(df)=="freq"] <- "Count"
  names(df)[names(df)=="freq_w1"] <- "n1count"
  names(df)[names(df)=="freq_w2"] <- "n2count"
  names(df)[names(df)=="prw2gw1"] <- "PrN2GN1"
  #names(df)[names(df)=="N1B"] <- "N1B"
  #names(df)[names(df)=="N2B"] <- "N2B"
  return(df)
}

# The following function determines whether the boundary character of
# the string argument is 
boundarychar <- function(string, n){
  nonjoiners <- c("آ","ں","ء","ے","و","ز","ژ","ڑ","ر","ذ","ڈ","د","ا")
  temp <- as.character(string)
  if(n==1){
  char <- substr(temp, nchar(temp) , nchar(temp))
  }
  else if(n==2){
    char <- substr(temp,1,1)
  }
  if(char %in% nonjoiners || char %in% LETTERS || char %in% letters || char %in% 0:9 ){
    result <- "nj"
    return(result)
  } 
  else {
    result <- "j"
    return(result)
  }
}