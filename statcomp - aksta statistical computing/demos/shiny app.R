# -------------------------------------------------------------------------- applets with shiny
if (!require("shiny")) install.packages("shiny")
library("shiny")

# define ui components
ui <- fluidPage(
  "Hello, world!"
)

# run
# you can also run the file with shiny::runApp("path/to/file.R")
server <- function(input, output, session) {}
shinyApp(ui, server)
