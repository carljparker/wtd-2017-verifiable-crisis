

#
# --- Library Dependencies ---
#
library( tidyr )
library( googlesheets )


## @knitr q1a 
#
# Set working directory for this knitr chunk
#
setwd( "/Users/cparker/git/gtwork/talks/wtd/7102-wtd/google-sheets" )


#
# Update the following line with the name of the CSV file to read.
#
electoral.votes.file.ch <- "data/electoral-college.csv"
electoral.votes.df <- read.csv( 
                         electoral.votes.file.ch, 
                         header = FALSE, 
                         quote="\"",
                         sep = ",", 
                         na.strings = c( "NA", "-" ),
                         allowEscapes = TRUE,
                         strip.white  = TRUE,
                         stringsAsFactors = TRUE,
                         comment.char="#" 
                       )

#
# --- Explore the data ---
#

#
# The following line is a nice way to set off 
# data exploration code inside a production
# context.
#

# -*- -*- -*- #

names( electoral.votes.df ) <- c( "electoral.votes", "state" )

sum( electoral.votes.df$electoral.votes )

# -*- -*- -*- #


## @knitr q1b 
#
# Set working directory for this knitr chunk
#
setwd( "/Users/cparker/git/gtwork/talks/wtd/7102-wtd/google-sheets" )


gs_ls()

official.gs <- gs_url( c( "https://docs.google.com/spreadsheets/d/133Eb4qQmOxNvtesw2hdVns073R68EZx4SfCnP4IGQf8/" ) ) 

official.gs %>% gs_read( range = "A12:D24" )

#
# Include the (mostly) blank row above the range that we want because
# the googlesheets package treats the first row of the range specified
# as a header row that contains column names.
#
official.gs %>% gs_read( range = "A11:D24" )

#
# Or . . . you can specify col_names = FALSE . . .
#
swing.df   <- official.gs %>% gs_read( range = "A12:D24", col_names = FALSE ) %>% data.frame()

noswing.df <- official.gs %>% gs_read( range = "A27:D64", col_names = FALSE ) %>% data.frame()

votes.all.states.df <- rbind( swing.df, noswing.df )
names( votes.all.states.df  )<- c( "State", "Clinton", "Trump", "Other" )

head( votes.all.states.df )

votes.all.states.df$winner <- ifelse( votes.all.states.df$Trump > votes.all.states.df$Clinton, "Trump", "Clinton" )
votes.all.states.df$trump.one.pct <- floor( votes.all.states.df$Trump * 0.0075 )

votes.all.states.df$Clinton.retally <- votes.all.states.df$Clinton + votes.all.states.df$trump.one.pct
votes.all.states.df$Trump.retally   <- votes.all.states.df$Trump   - votes.all.states.df$trump.one.pct

votes.all.states.df$winner.retally  <- ifelse( votes.all.states.df$Trump.retally > votes.all.states.df$Clinton.retally, "Trump", "Clinton" )

votes.all.states.df$State[ votes.all.states.df$winner != votes.all.states.df$winner.retally ]

#
# NYT Election Results
# <http://www.nytimes.com/elections/results/president>
# 
# NYT Electoral College Results
# <https://www.nytimes.com/interactive/2016/12/19/us/elections/electoral-college-results.html>
# 
# NYT Clinton Archipelego
# <https://www.nytimes.com/interactive/2016/11/16/us/politics/the-two-americas-of-2016.html>
#


# --- END ---

