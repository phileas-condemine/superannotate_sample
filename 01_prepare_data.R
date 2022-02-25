library(data.table)
library(magrittr)
data = fread("data/raw/french_tweets.csv",encoding="UTF-8")
data$id = sapply(1:nrow(data),function(x)paste(sample(c(LETTERS,1:10),10,replace = T),collapse=""))
setkey(data,id)
all_ids = data$id
sub_ids = sample(all_ids, 100)
sub = data[J(sub_ids)]

sapply(1:nrow(sub),function(i){
  one_id = sub$id[i]
  one_text = sub$text[i]
  writeLines(one_text,file.path("data","documents",paste0(one_id,".txt")))
})

# url_to_files = sub[,.(id)]
url_to_files = data.table(id = list.files("data/documents/")%>%stringr::str_replace(".txt",""))
url_to_files[,url:=sprintf("https://raw.githubusercontent.com/phileas-condemine/superannotate_sample/main/data/documents/%s.txt",id)]

fwrite(url_to_files,"data/url_to_documents_on_github.csv")


