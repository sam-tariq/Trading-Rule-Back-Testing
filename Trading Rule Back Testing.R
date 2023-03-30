#Inputs Function 1
tick<-'JNJ'
begin_date<-'20140101'
end_date<-'20171231'
dvi_threshold<-0.5

#Defining Function 1
func1<-function(tick,begin_date,end_date,dvi_threshold){
  #Importing Libraries
  library(quantmod)
  library(TTR)
  library(tidyverse)
  library(PerformanceAnalytics)
  
  #Getting Stock data
  Price<-getSymbols(tick,auto.assign = F,
                    from = str_replace(begin_date,"(\\d{4})(\\d{2})(\\d{2})$","\\1-\\2-\\3"),
                    to = str_replace(end_date,"(\\d{4})(\\d{2})(\\d{2})$","\\1-\\2-\\3"),
                    periodicity='daily')
  
  #Getting Close stock data column
  Price<-Price[,4]
  
  #Getting Stock return data
  Retn <- periodReturn(Price, period = 'daily',
                       type = 'arithmetic')
  #Calculating DVI of Stock
  dvi<-DVI(Price)
  
  #Defining The signal for the strategy
  sig<-ifelse(dvi$dvi<dvi_threshold,1,-1)
  lagSig<-stats::lag(ifelse(dvi$dvi<dvi_threshold,1,-1))
  
  #Number of total, long and short transactions
  total_transactions<-ifelse(sig == lagSig,0,1)
  
  long_transactions<-total_transactions[sig==1]
  num_of_long_trades<-sum(long_transactions, na.rm = T)+1
  
  short_transactions<-total_transactions[sig==-1]
  num_of_short_trades<-sum(short_transactions, na.rm = T)
  
  #Number of days in long and short
  a<-table(lagSig)
  Short_days<-a[[1]]
  Long_days<-a[[2]]
  Total_days<-sum(a)
  
  #Percentage of days in long and short
  long_days_perct<-(Long_days/Total_days)*100
  short_days_perct<-(Short_days/Total_days)*100
  
  #Total Cumulative Return of Trading Strategy 
  cumret<-round(Return.cumulative(Retn*lagSig),digits = 4)
  cumret <- unname(cumret)
  
  df<- data.frame(num_of_long_trades,num_of_short_trades,long_days_perct,short_days_perct,cumret)
  
  colnames(df) <- c('Number of Long Trades','Number of Short Trades','Long Days Percentage','Short Days Percentage','Cumulative Return')
  return(df)
}
func1(tick,begin_date,end_date,dvi_threshold)


#Inputs for function 2
tick<-'JNJ'
testing_period<-3 #3 years
date_range<-c('2010','2016') #divide them into periods of 3 years
dvi_threshold<-0.5


#Defining Function 2
func2<-function(tick,testing_period,date_range,dvi_threshold){
  #Starting and Ending of the Time Range provided
  start<-as.numeric(date_range[[1]])
  end<-as.numeric(date_range[[2]])
  #Sequence of the time perids for running function 1
  q<-seq(start,end,(testing_period-2))
  #Defining an empty function for storing results
  df1<-data.frame('Number of Long Trades'= numeric(0),'Number of Short Trades'= numeric(0),'Long Days Percentage'=numeric(0),'Short Days Percentage'=numeric(0),'Cumulative_Return' =numeric(0))
  #Part of Time period Strings for running function 1
  bdat<-'0101'
  edat<-'1231'
  #Counter for the loop
  c1<-0
  c2<-1
  for (i in 1:(length(q)-2)){
    #Determing the start of period from the sequence for each time period
    start_of_period<-toString(q[1+c1])
    bdat1<-paste(start_of_period,bdat,sep='')
    #Determing the end of period from the sequence for each time period
    end_of_period<-toString(q[2+c2])
    edat1<-paste(end_of_period,edat,sep='')
    #Calling function 1 for each time period
    x<-func1(tick,bdat1,edat1,dvi_threshold)
    #Storing the results in the empty data frame
    df1[i,]<-x
    #Incrementing the counters
    c1<-c1+1
    c2<-c2+1
    }
  df1
  #Calculating the mean of the time periods
  df2<-colMeans(df1)
  #Plotting the returns for the time periods
  plot1<-ggplot(df1, aes(x= rownames(df1),y=Cumulative_Return)) +
    geom_bar(stat = "identity", aes(fill=Cumulative_Return),show.legend = TRUE) + 
    ggtitle("Cumulative Returns for Multiple Backtesting Periods") +
    theme(plot.title = element_text(hjust =  0.5)) +
    xlab("Number of Testing Period") + 
    ylab("Cumlative Returns") 
  #Printing the outputs 
  print(df1)
  print(df2)
  print(plot1)
}
func2(tick,testing_period,date_range,dvi_threshold)

#Input for Function 3
bdat2<-'20140101'
edat2<-'20171231'
dvi_lower_limit<-0.4
dvi_upper_limit<-0.6
dvi_increment<-0.01

#Defining Function 3
func3<-function(tick,bdat2,edat2,dvi_lower_limit,dvi_upper_limit,dvi_increment){
  dvi_threshold_range<-seq(dvi_lower_limit,dvi_upper_limit,dvi_increment)
  df3<-data.frame('Number of Long Trades'= numeric(0),'Number of Short Trades'= numeric(0),'Long Days Percentage'=numeric(0),'Short Days Percentage'=numeric(0),'Cumulative_Return' =numeric(0))
  for (i in 1:length(dvi_threshold_range)){
    y<-func1(tick,bdat2,edat2,dvi_threshold_range[i])
    df3[i,]<-y
  }
  df3<-df3[-c(3:4)]
  df4<-data.frame(DVI_Value = dvi_threshold_range, df3)
  plot2<-ggplot(df4, aes(x= dvi_threshold_range,y=Cumulative_Return)) +
    geom_bar(stat = "identity", aes(fill=Cumulative_Return),show.legend = TRUE) + 
    scale_x_continuous(breaks=seq(0.4, 0.6, 0.02)) +
    ggtitle("Cumulative Returns for Multiple Backtesting Periods") +
    theme(plot.title = element_text(hjust =  0.5)) +
    xlab("Number of Testing Period") + 
    ylab("Cumlative Returns") 
  print(plot2)
  print(df4)
}
func3(tick,bdat2,edat2,dvi_lower_limit,dvi_upper_limit,dvi_increment)



