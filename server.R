library(shiny)
library(datasets)
library('plyr')
library('ggplot2')

# We tweak the "am" field to have nicer factor labels. Since this doesn't
# rely on any user inputs we can do this once at startup and then use the
# value throughout the lifetime of the application
#mpgData <- mtcars
#mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))

# read data
dat = read.delim(file='~/Downloads/University-returns_for_figshare_FINAL-xlsx.tsv')
names(dat) <- c('PMID','Publisher','Journal','Article','cost')

# calc mean & SD cost by publisher
new = ddply(dat,~Publisher,summarise,mean=mean(cost),sd=sd(cost))
# count no. of observations
pub.dat = cbind(new,count=ddply(dat,~Publisher,nrow)[,2])
# calc the total cost
pub.dat = cbind(pub.dat,total=pub.dat$mean*pub.dat$count)

# calc mean & SD by journal
new = ddply(dat,~Journal,summarise,mean=mean(cost),sd=sd(cost))
jrnl.dat = cbind(new,count=ddply(dat,~Journal,nrow)[,2])
jrnl.dat = cbind(jrnl.dat,total=jrnl.dat$mean*jrnl.dat$count)

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
 
  dataToPlot <- reactive({
    paste(input$type)
  })
 
  numberToPlot <- reactive({
    as.numeric(paste(input$number))
  })
 
  valueToPlot <- reactive({
    print(input$costCalc)
  })
 
  output$pubPlot <- renderPlot({
  
    ## TODO - all these ifs are a bit nasty. Make more generic
    if (dataToPlot() == 'pub') {
      if (valueToPlot() == "mean") {
        print(ggplot(head(pub.dat[order(pub.dat$mean,decreasing=input$decreasing),],n=numberToPlot()),aes(x=Publisher,y=mean)) 
              + geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.1) 
              + geom_point()
              + scale_x_discrete(limits = head(pub.dat[order(pub.dat$mean,decreasing=input$decreasing),1],n=numberToPlot()))
              + scale_y_continuous(name="Mean Cost (GBP)")
              + coord_flip()
        )
      } else {
        print(ggplot(head(pub.dat[order(pub.dat$total,decreasing=input$decreasing),],n=numberToPlot()),aes(x=Publisher,y=total)) 
              + geom_bar(stat="identity") 
              + scale_y_continuous(name="Total Cost (GBP)")
              + coord_flip()
        )
  
      }
    } else {
      if (valueToPlot() == "mean") {
        print(ggplot(head(jrnl.dat[order(jrnl.dat$mean,decreasing=input$decreasing),],n=numberToPlot()),aes(x=Journal,y=mean)) 
              + geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.1) 
              + geom_point()
              + scale_x_discrete(limits = head(jrnl.dat[order(jrnl.dat$mean,decreasing=input$decreasing),1],n=numberToPlot()))
              + scale_y_continuous(name="Mean Cost (GBP)")
              + coord_flip()
        )
      } else {
        print(ggplot(head(jrnl.dat[order(jrnl.dat$total,decreasing=input$decreasing),],n=numberToPlot()),aes(x=Journal,y=total)) 
              + geom_bar(stat="identity")
              + scale_y_continuous(name="Total Cost (GBP)")
              + coord_flip()
        )
    
      }
   
    }
  })
})
