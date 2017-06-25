#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
shinyServer(function(input, output) {
        data_full1 <- read.csv("testr.csv",na.strings = c( 0, " "))
        data_full <- head(data_full1,79434)
        usmle <- data.frame(usmledate= format(as.Date(data_full$USMLE_TEST_DATE, format="%Y.%m.%d"),"%Y"),
                            usmlescore=data_full$USMLE_SCORE,finalgrade=data_full$FINAL_GRADE,
                            ogpa=data_full$OVERALL_GPA,sgpa=data_full$SCIENCE_GPA,
                            mcatscore=data_full$MCAT_SCORE,
                            mcatdays=data_full$DAYS_BETWEEN_MCAT_USMLE,
                            priordg_days=data_full$DAYS_BETWEEN_PRIOR_DEGREE_USMLE,
                            subjectcode=data_full$SSBSECT_SUBJ_CODE,
                            priormajor=data_full$PRIOR_MAJOR)

        usmle <- na.omit(usmle)


        usmle$sgpasp <- ifelse(usmle$sgpa - 5 > 0, usmle$sgpa - 5, 0)
        model1 <- lm(usmlescore ~ sgpa, data = usmle)
        model2 <- lm(usmlescore ~ mcatscore + sgpa, data = usmle)

        model1pred <- reactive({
                sgpaInput <- input$sliderGPA
                predict(model1, newdata = data.frame(sgpa = sgpaInput))
        })

        model2pred <- reactive({
                sgpaInput <- input$sliderGPA
                predict(model2, newdata =
                                data.frame(sgpa = sgpaInput,
                                           mcatscore = ifelse(sgpaInput - 5 > 0,
                                                              sgpaInput - 5, 0)))
        })
        output$plot1 <- renderPlot({
                sgpaInput <- input$sliderGPA

                plot(usmle$sgpa, usmle$usmlescore, xlab = "Science GPA",
                     ylab = "USMLE SCORE", bty = "n", pch = 16,
                     xlim = c(0, 5), ylim = c(0, 300))
                if(input$showModel1){
                        abline(model1, col = "red", lwd = 2)
                }
                if(input$showModel2){
                        model2lines <- predict(model2, newdata = data.frame(
                                sgpa = 0:5, mcatscore = ifelse(0:5 - 5 > 0, 0:5 - 5, 0)
                        ))
                        lines(0:5, model2lines, col = "blue", lwd = 2)
                }
                legend(3, 100, c("Model 1 Prediction", "Model 2 Prediction"), pch = 16,
                       col = c("red", "blue"), bty = "n", cex = 1.2)
                points(sgpaInput, model1pred(), col = "red", pch = 16, cex = 2)
                points(sgpaInput, model2pred(), col = "blue", pch = 16, cex = 2)
        })

        output$pred1 <- renderText({
                model1pred()
        })

        output$pred2 <- renderText({
                model2pred()
        })
})
