#install.packages("xlsx")
#install.packages("stringr")
#library(xlsx)
#library(stringr)
has.data <-function(acol){
  if(length(acol)<1) return(FALSE)
  res = length(acol)!=length(which(is.na(acol)))
  res
}

outlier_summary <- function(file=fp,trait,sheetname="Summary by clone"){
  
  sheetname <- as.character(sheetname)
  filename <- as.character(file)
  data <- xlsx::read.xlsx(file=file,sheetName = sheetname,stringsAsFactors=FALSE)
  trait <- as.character(trait)
  #dict <- get.data.dict()
  #trait <- trait[trait %in% names(data)]
  
  nmean <- "_Mean"
  sd <- "_sd"
  
  trait_mean <- paste(trait,nmean,sep="")
  trait_sd <- paste(trait,sd,sep="")
  
  col_mean <- data[,trait_mean]
  col_sd <- data[,trait_sd]
  
  trait_mean <- trait_mean[trait_mean %in% names(data)]
  trait_sd <- trait_sd[trait_sd %in% names(data)]
   
  if(has.data(col_mean) & has.data(col_sd)){
    if(is.numeric(col_mean) & is.numeric(col_sd)){
      #lwr = as.numeric(dict[dict$ABBR==trait,"LOWER"])
      #upr = as.numeric(dict[dict$ABBR==trait,"UPPER"])
      #cds = get.codes(dict,trait)
      ### if(!(is.na(lwr) & is.na(upr) & is.na(cds))){
      
      d <- data  
      pos_mean <- which(names(d)==trait_mean)
      pos_sd <- which(names(d)==trait_sd)
      cols<-length(d[1,])
      
      wb <- xlsx::loadWorkbook(file)              # load workbook
      fo2 <- xlsx::Fill(foregroundColor="red")    # create fill object # 2
      cs2 <- xlsx::CellStyle(wb, fill=fo2)        # create cell style # 2 
      sheets <- xlsx::getSheets(wb)               # get all sheets
      sheet <- sheets[[sheetname]]                # get specific sheet
      
      rows <- xlsx::getRows(sheet, rowIndex=2:(nrow(d)+1))     # get rows
      cells_mean <- xlsx::getCells(rows, colIndex = pos_mean)         # get cells
      values_mean <- lapply(cells_mean, xlsx::getCellValue) # extract the cell values        
      
      rows <- xlsx::getRows(sheet, rowIndex=2:(nrow(d)+1))     # get rows
      cells_sd <- xlsx::getCells(rows, colIndex = pos_sd)         # get cells
      values_sd <- lapply(cells_sd, xlsx::getCellValue) # extract the cell values
      
      
      #summary_outlier <- (std_val)-(mean_val/2)>0
      # find cells meeting conditional criteria < 5
      highlightred <- NULL
      for (i in 1:length(values_mean)) {
        x_mean <- as.numeric(values_mean[i])
        
        x_sd <- as.numeric(values_sd[i])
        
        if(!is.na(x_mean) & !is.na(x_sd)){
          #             if (x<lwr || x>upr){
          #               highlightred <- c(highlightred, i)
          #             }
          #             
          #             if(!is.na(cds)){
          #               if (!(x %in% cds)){highlightred <- c(highlightred, i)}
          #             }
          if ((x_sd)>(x_mean/2)){
            highlightred <- c(highlightred, i)
          } 
          
          
        }
      }
      #Finally, apply the formatting and save the workbook.
      
      #   lapply(names(cells[highlightblue]),
      #          function(ii)xlsx::setCellStyle(cells[[ii]],cs1))
      
      lapply(names(cells_mean[highlightred]),
             function(ii)xlsx::setCellStyle(cells_mean[[ii]],cs2))
      
      lapply(names(cells_sd[highlightred]),
             function(ii)xlsx::setCellStyle(cells_sd[[ii]],cs2))
      
      
      xlsx::saveWorkbook(wb, file)
      ###} 
    }
    #shell.exec(file)
  }
}

# fp<-file.choose() 
# 
# wb <- loadWorkbook(fp)
# sheets <- getSheets(wb)
# sheets <- names(sheets)   
# #sheetName <- "Summary by clone"   
# #sheetName <- "Summary by treatment"
# 
# if("Summary by clone" %in% names(sheets)){
#   trait_names <- read.xlsx(fp,sheetName="Summary by clone",startRow = 1,endRow = 2,header = TRUE)
#   trait_names <- names(trait_names)
#   trait_names <- stringr::str_replace_all(string = trait_names,pattern = "_Mean||_sd||_n",replacement = "") 
#   trait_names <-  unique(trait_names)[-1] #remove INSTN
#   for(i in 1:length(trait_names)){
#     outlier_summary(fp,trait_names[i],"Summary by clone")   
#   }  
# }
# 
# if("Summary by treatment" %in% names(sheets)){
#   trait_names <- read.xlsx(fp,sheetName="Summary by treatment",startRow = 1,endRow = 2,header = TRUE)
#   trait_names <- names(trait_names)
#   trait_names <- stringr::str_replace_all(string = trait_names,pattern = "_Mean||_sd||_n",replacement = "") 
#   trait_names <-  unique(trait_names)[-c(1,2)] #remove INSTN y FACTOR
#   for(i in 1:length(trait_names)){
#     outlier_summary(fp,trait_names[i],"Summary by treatment")   
#   }    
# }  

#Summary by clone
#NNoMTP  
#MTYA
#outlier_summary(fp,"NNoMTP,"Summary by treatment")
