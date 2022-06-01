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

server <- function(input, output, session) {
  data<-reactiveValues(dataframe = NULL)

  observeEvent(input$datafile,{
    data$dataframe<-if(tools::file_ext(input$datafile)=="csv"){
      read_csv(input$datafile$datapath)
    }else{
      readxl::read_excel(input$datafile$datapath)}
  })
  output$table <- renderDataTable({
    if(input$forg=="g"){
      data$dataframe
    }
    else if(input$fil.value==""){
      data$dataframe
    }else{
      filter(data$dataframe,!!as.symbol(input$fil.var)==input$fil.value)
    }

  })
  output$plot<-renderPlot({
    validate(
      need(input$t, ""),
      need(input$od,"")
    )
    if(input$forg=="g"){
      validate(
        need(input$gro.var,"Please choose a grouping variable")
      )
      ggplot(data = data$dataframe,
             aes(x = !!as.symbol(input$t),y = !!as.symbol(input$od),
                 color = factor(!!as.symbol(input$gro.var)),
                 group = factor(!!as.symbol(input$gro.var))))+
        geom_point()+
        stat_smooth(method = "lm",fullrange = F,se=F)+
        ggpubr::stat_cor(aes(label = ..rr.label..))+
        scale_y_continuous(trans = "log2")+
        scale_x_continuous(limits = c(input$slider[1],input$slider[2]))+
        theme_classic()
    }else{
      ggplot(data = filter(data$dataframe,!!as.symbol(input$fil.var)==input$fil.value),
             aes_string(x = input$t,y = input$od))+
        geom_point()+
        stat_smooth(method = "lm",fullrange = F,se=F)+
        ggpubr::stat_cor(aes(label = ..rr.label..))+
        scale_y_continuous(trans = "log2")+
        scale_x_continuous(limits = c(input$slider[1],input$slider[2]))+
        theme_classic()
    }
  })

  dtf<-reactiveValues(
    doubling = NULL
  )
  dtg<-reactiveValues(
    doubling = NULL
  )

  observeEvent(input$button,{
    validate(
      need(input$t, ""),
      need(input$od,"")
    )
    if(input$forg=="f"){
      dtf$doubling<-double_times(
        df = filter(data$dataframe,!!as.symbol(input$fil.var)==input$fil.value),
        time = input$t,
        c1=input$slider[1],
        c2=input$slider[2],
        measure = input$od)
    }else{
      dtg$doubling<-data$dataframe%>%
        nest_by(!!as.symbol(input$gro.var))%>%
        mutate(Doubling = double_times(df = data,time = input$t,
                                       c1 = input$slider[1],c2 = input$slider[2],
                                       measure = input$od),
               Cutoff_Min = input$slider[1],
               Cutoff_Max = input$slider[2])%>%
        select(!!as.symbol(input$gro.var),Doubling,Cutoff_Min, Cutoff_Max)
    }
  })
  resultsf<-reactiveValues(
    df = data.frame(Filtered_On = c(), Filter_Value = c(), Cutoff_Min = c(), Cutoff_Max = c(), Doubling_Time = c())
  )
  resultsg<-reactiveValues(
    df = data.frame()
  )
  observeEvent(input$button,{
    if(input$forg=="f"){
      fil_new<-c(resultsf$df$Filtered_On,input$fil.var)
      val_new<-c(resultsf$df$Filter_Value,input$fil.value)
      cf1_new<-c(resultsf$df$Cutoff_Min,input$slider[1])
      cf2_new<-c(resultsf$df$Cutoff_Max,input$slider[2])
      dt_new<-c(resultsf$df$Doubling_Time, dtf$doubling)
      resultsf$df<-data.frame(Filtered_On = fil_new,
                              Filter_Value = val_new,
                              Cutoff_Min = cf1_new,
                              Cutoff_Max = cf2_new,
                              Doubling_Time = dt_new)
    }else{
      resultsg$df<-dtg$doubling
    }

  })
  output$savedvalues<-renderTable({
    if(input$forg=="f"){
      resultsf$df
    }else{
      resultsg$df
    }
  })
  output$dlbutton<-downloadHandler(
    filename = function(){"DoublingTime_Download.csv"},
    content = function(fname){
      if(input$forg=="f"){
        write.csv(resultsf$df,fname)
      }else{
        write.csv(resultsg$df,fname)
      }
    }
  )
}
