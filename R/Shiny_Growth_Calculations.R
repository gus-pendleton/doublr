#' Calculate doubling time in exponential phase
#' @export
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
