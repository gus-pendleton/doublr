ui <- fluidPage(
  titlePanel("Hello! First choose your data file"),
  fluidRow(column(3,fileInput("datafile",label = "Choose a .csv or .xlsx file")),
           column(3,style = "margin-top: 25px",actionButton(inputId = "filego",label = "Go!"))),
  fluidRow(conditionalPanel("input.filego!=0",
                            column(8,fluidRow(column(4,radioButtons(inputId = "forg",label = "Grouping or Filtering?",
                                                                    c("Grouping" = "g",
                                                                      "Filtering" = "f"))),
                                              conditionalPanel("input.forg=='g'",column(4,textInput(value = "",inputId = "gro.var",label = "Group by?"))),
                                              conditionalPanel("input.forg=='f'",column(4,textInput(value = "",inputId = "fil.var",label = "Filter by?"))),
                                              conditionalPanel("input.forg=='f'",column(4,textInput(value = "",inputId = "fil.value",label = "Filter Value")))),
                                   column(12,dataTableOutput("table"),style = "height:400px; overflow-y: scroll;overflow-x: scroll;")),
                            column(4,
                                   fluidRow(
                                     column(6,textInput(inputId = "t",label = "Time Column?")),
                                     column(6,textInput(inputId = "od",label = "OD Column?"))),
                                   sliderInput(inputId = "slider",label = "Choose upper and lower x limits",
                                               min = 0, max = 1000, value = c(0,10) ),
                                   plotOutput("plot")))),
  fluidRow(conditionalPanel("input.filego!=0",
                            column(3,actionButton("button","Run that regression!")),
                            column(3,downloadButton("dlbutton","Download results")))),
  tableOutput(outputId = "savedvalues")
)
