library(lubridate)

tpex_crawler <- function(index = 'reward',
                         start_y = 98,
                         end_y = year(Sys.Date()) - 1911){
  # 爬取櫃買中心指數歷史資料－以富櫃50指數為例
  # 讀取Package
  library(xml2)
  library(dplyr)
  library(lubridate)
  
  # 參數設定
  index_name <- index
  start_year <- start_y
  end_year <- end_y
  year_seq <- start_year:end_year
  
  # 不同指數中間的url不同
  if(index_name == 'reward'){
    index_ch_name <-  '櫃買高殖利率指數'
  }else if(index_name == 'gretai50'){
    index_url <- 'gretai50/inxhis/rihisqry_result'
    index_ch_name <- '富櫃五十指數'
  }else if(index_name == 'gthd'){
    index_url <- 'gthd/inxhis/GTHDINXMONTH_result'
    index_ch_name <- '櫃買高殖利率指數'
  }
  
  # 櫃買指數html url
  # 將年月替換掉即可讀取不同資料
  # EX:@YEAR=107,@MONTH=1，即可讀取107年1月之資料
  # Note:以後可將指數名稱變為參數，爬取不同指數資料
  {
    if(index_name == 'reward'){
      # 櫃買指數的url跟其他指數不同，所以獨立處理
      url = paste('http://www.tpex.org.tw/web/stock/iNdex_info/'
                  ,'reward_index/ROE_result.php?l=zh-tw&t=M&d='
                  ,'@YEAR'
                  ,'/'
                  ,'@MONTH'
                  ,'&s=0,asc,0&o=htm'
                  ,sep = ''
      )
    }else{
      url = paste('http://www.tpex.org.tw/web/stock/iNdex_info/'
                  ,index_url
                  ,'.php?l=zh-tw&d='
                  ,'@YEAR'
                  ,'/'
                  ,'@MONTH'
                  ,'&s=0,asc,0&o=htm'
                  ,sep = ''
      )
    }
  }
  
  
  
  
  
  # 先將所有需要抓取的年份url設定好
  # Note:之後可以將年份的地方改為參數輸入
  pre_url <- vector()
  j = 1
  for(i in year_seq){
    for(y in 1:12){
      new_y <- if_else(nchar(y) == 1, paste(0,y,sep = ''),as.character(y))
      url_new <- gsub('@YEAR',i,url)
      url_new <- gsub('@MONTH',new_y,url_new)
      pre_url[j] <- url_new
      j = j + 1
    }
  }
  
  # 將網站上的資料爬取下來
  res_new <- data.frame()
  for(url_now in pre_url){
    doc <- read_html(url_now)
    # 讀取body中table內我們所需的欄位資料
    target <- xml_find_all(doc, 'body/table/tbody/tr/td')
    # 將此tag下的文字內容取出
    target_text <- xml_text(target)
    # 每三筆資料為一個row
    # 日期|指數|報酬指數
    res <- cbind.data.frame(split(target_text, rep(1:3, times=length(target_text)/3)), stringsAsFactors=F)
    res_new <- bind_rows(res,res_new)
  }
  
  
  colnames(res_new) <- c('AS_OF_DATE','INDEX','RETURN_INDEX')
  
  res_final <- res_new %>% 
    mutate(AS_OF_DATE = ymd(as.numeric(AS_OF_DATE) + 19110000)) %>% 
    arrange(desc(AS_OF_DATE))
  
  return(res_final)
  # write.csv(res_final,'D:\\Desktop\\OTC保證金比率回溯測試問題\\富櫃50資料_櫃買網站.csv')

}

