library(shiny)
shinyUI(pageWithSidebar(
      headerPanel("Trainer Assistant"),
      sidebarPanel(
            h4('Description'),
            p('This assistant helps you with BMI, HR max and HR training zones calculation.'),
            p('It takes your sex, age, weight and height and calculates BMI and HR max (Sally Edwards formula).
              Additionally it creates dynamic charts to indicate your calculated BMI group and 
              HR training zones according to your calculated maximal heart rate.'),
            p('Please note that it is only DEMO version for needs of Coursera Developing Data Products course. If
              you want to start physical exercises please consult your doctor first! '),
            h4('User input'),
            selectInput('id1', 'Sex',c("Male" = "Male", "Female" = "Female"),selected = "Female"),
            numericInput('id2', 'Age [years]', 20, min = 1, max = 100, step = 1),
            numericInput('id3', 'Weight [kg]', 70, min = 1, max = 250, step = 1),
            numericInput('id4', 'Height [m]', 1.8, min = 1, max = 2.5, step = 0.1),
            submitButton('Calculate')
      ),
      mainPanel(
            h4("BMI"),
            textOutput("BMI"),
            textOutput("BMIcategory"),
            plotOutput('BMIplot',width = "600px",height = "300px"),
            p('Black dashed line represent your BMI.'),
            br(),
            h4("Training zones"),
            textOutput("HRmax"),
            plotOutput('TZplot',width = "600px",height = "300px"),
            p('The Energy Efficient or Recovery Zone - 60% to 70% of HR max - Training within 
              this zone helps you to lose weight and build endurance.'),
            p('The Aerobic Zone - 70% to 80% HRmax - Training in this zone will develop your cardiovascular system.
              You become fitter and stronger and you burn fat and improve aerobic capacity.'),
            p('The Anaerobic Zone - 80% to 90% HRmax - Training in this zone will develop your lactic acid system, 
              you get faster and fitter.'),
            p('The Red Line Zone 90% to 100% HRmax - Training zone reserved only for very fit for very short time.
              Increases fast twitch muscle fibres and helps to develop speed.')
      )
))