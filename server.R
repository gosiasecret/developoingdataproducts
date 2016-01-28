library(shiny)
library(ggplot2)

shinyServer(
      function(input, output) {
            #reading user inputs
            Sex <- reactive({input$id1})
            Age <- reactive({as.numeric(input$id2)})
            Weight <- reactive({as.numeric(input$id3)})
            Height <- reactive({as.numeric(input$id4)})
            
            #calculations BMI
            BMI <- reactive({Weight()/(Height()^2)})
            output$BMI <- renderText({
                  paste('Your Body Mass Index is: ',round(BMI(),1))
            })
            
            BMIcategory<- reactive({ 
                  if (BMI()<15) {BMIcategory <- "Very severely underweight"}
                  else if (BMI()<16) {BMIcategoryTemp <- "Severely underweight"}
                  else if (BMI()<18.5) {BMIcategoryTemp <- "Underweight"}
                  else if (BMI()<25) {BMIcategoryTemp <- "Normal (healthy weight)"}
                  else if (BMI()<30) {BMIcategoryTemp <- "Overweight"}
                  else if (BMI()<35) {BMIcategoryTemp <- "Obese Class I (Moderately obese)"}
                  else if (BMI()<40) {BMIcategoryTemp <- "Obese Class II (Severely obese)"}
                  else if (BMI()>=40) {BMIcategoryTemp <- "Obese Class III (Very severely obese)"}
                  BMIcategory <- BMIcategoryTemp
            })
            output$BMIcategory <- renderText({
                  paste('Your BMI category is: ',BMIcategory(),".")
            })
            
            #calculations: HR max (according to Sally Edwards) and training zones
            
            HRmax<- reactive({ 
                  if (Sex()=="Male") {
                        HRmaxtemp <- 210 - 0.5*Age()-0.022*Weight()+4    
                  }
                  else if (Sex()=="Female") {
                        HRmaxtemp <- 210 - 0.5*Age()-0.022*Weight()     
                  }
                  HRmax <- HRmaxtemp
            })
            
            output$HRmax <- renderText({
                  paste('Your HR max is: ',round(HRmax(),0),".")
            })
            
            
            # plot of BMI
            output$BMIplot <- renderPlot({
                  
                  BMIdf <- data.frame(
                        BMI_group = c("Very severely underweight","Severely underweight","Underweight","Normal (healthy weight)",
                                  "Overweight","Obese Class I (Moderately obese)","Obese Class II (Severely obese)",
                                  "Obese Class III (Very severely obese)"),
                        # value = c(15, 16,18.5,25,30,35,40,60)
                        value = c(15, 1, 2.5, 6.5, 5, 5, 5, 15),
                        order=c(1,2,3,4,5,6,7,8)
                  )
                  BMIdf$BMI_group <- reorder(BMIdf$BMI_group,BMIdf$order)
                  
                  # Barplot
                  BMIbp <- ggplot(BMIdf, aes(x='', y=value, fill=BMI_group))+geom_bar(width = 1, stat = "identity")+xlab("")+ylab("BMI")
                  BMIbp <- BMIbp+ scale_fill_manual(values=c("orange1", "yellow2", "greenyellow", "green1", "greenyellow", "yellow2", "orange1", "red1"))
                  BMIbp <- BMIbp+geom_hline(yintercept=BMI(),size=2,linetype=2)+coord_cartesian(ylim = c(0, 55)) 
                  BMIbp <- BMIbp + scale_y_continuous(breaks=seq(0, 100, 5))  
                  print(BMIbp)
            })
            
            
            # plot of Training zones
            output$TZplot <- renderPlot({
                  
                  TZdf <- data.frame(
                        Zone = c("","Recovery Zone - 60% to 70% HRmax","The Aerobic Zone - 70% to 80% HRmax",
                                 "The Anaerobic Zone - 80% to 90% HRmax","The Red Line Zone 90% to 100% HRmax"),
                        # value = c(0.6*HRmax, 0.7*HRmax, 0.8*HRmax, 0.9*HRmax),
                        value = c(0.6*HRmax(), 0.1*HRmax(), 0.1*HRmax(), 0.1*HRmax(), 0.1*HRmax()),
                        order=c(1,2,3,4,5)
                  )
                  
                  TZdf$group <- reorder(TZdf$Zone,TZdf$order)
                  
                  # Barplot
                  TZbp <- ggplot(TZdf, aes(x='', y=value, fill=Zone))+geom_bar(width = 1, stat = "identity")+xlab("")+ylab("Heart Rate")
                  TZbp <- TZbp+scale_fill_manual(values=c("royalblue1","greenyellow", "yellow2", "orange1", "red1"))
                  TZbp <- TZbp+coord_cartesian(ylim = c(0.55*HRmax(), HRmax())) 
                  TZbp <- TZbp + scale_y_continuous(breaks=seq(0, 300, 5)) 
                  print(TZbp)
            })
            
        }
)