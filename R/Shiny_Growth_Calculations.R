#' Calculate doubling time in exponential phase
#' @export
#'
#' @param df A dataframe
#' @param time The column holding numerical or datetime values for the independent (usually time) variable. Quotation marks necessary
#' @param measure The column holding numerical values for the dependent (e.g. OD) variable, not log-transformed. Quotation marks necessary.
#' @param c1,c2  Cutoffs for the time column that bound the exponential phase of the data.
#'
#' @return A doubling time produced by fitting a linear model between the log2-transformed measure column and the time column and taking the reciprocal of the slope from that model.
#'
#' @examples
#' #Make simple dataframe with exponential data:
#' df<-data.frame(x= c(1:10), y = 2^c(1:10))
#' double_times(df, time = x, measure = y, c1 = 1, c2 = 8)
double_times<-function(df,time, measure, c1,c2){
  exp<-df%>%
    filter(!!as.symbol(time)>=c1, !!as.symbol(time)<=c2)%>%
    mutate(logod = log2(!!as.symbol(measure)),
           form_time = !!as.symbol(time))

  model<-lm(logod~form_time, data = exp)
  slope<-model$coefficients[2]
  names(slope)<-"Slope"
  double<-1/slope
  names(double)<-"Doubling Time:"
  return(double)
}
