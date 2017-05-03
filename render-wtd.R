#
# The test presentation in this directory is derived from what is show
# at the following URL:
#
#   <http://rmarkdown.rstudio.com/ioslides_presentation_format.html>
#

library( "rmarkdown" )
library( "knitr" )

#
# Output to HTML or PDF is controlled by the YAML header in the .Rmd
# file. You need to specify the output file here only if you want to 
# change the name to something other than the default.
#
render( "./slides-wtd-2017.Rmd" )


# --- END ---

