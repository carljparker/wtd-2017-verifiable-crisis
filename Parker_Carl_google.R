
#
# --- Library Dependencies ---
#
library( magrittr )
library( dplyr )
library( googlesheets )

electoral.votes.df <- read.csv( 
                        "data/electoral-college.csv",
                         header = FALSE, 
                         quote="\"",
                         sep = ",", 
                         na.strings = c( "NA", "-" ),
                         allowEscapes = TRUE,
                         strip.white  = TRUE,
                         stringsAsFactors = TRUE,
                         comment.char="#" 
                       )

names( electoral.votes.df ) <- c( "Electoral.Votes", "State" )
electoral.votes.df$State    <- gsub( "\\*", "", electoral.votes.df$State )


official.gs <- gs_url( c( "https://docs.google.com/spreadsheets/d/133Eb4qQmOxNvtesw2hdVns073R68EZx4SfCnP4IGQf8/" ) ) 

official.gs %>% gs_read( range = "A12:D24" )

swing.df   <- official.gs %>% gs_read( range = "A12:D24", col_names = FALSE ) %>% data.frame()
noswing.df <- official.gs %>% gs_read( range = "A27:D64", col_names = FALSE ) %>% data.frame()

votes.df <- rbind( swing.df, noswing.df )
names( votes.df  )<- c( "State", "Clinton", "Trump", "Other" )
votes.df$State <- gsub( "\\*", "", votes.df$State )

votes.df <- merge( votes.df, electoral.votes.df )

sum( filter( votes.df, Trump > Clinton )$Electoral.Votes ) 
sum( filter( votes.df, Trump < Clinton )$Electoral.Votes ) 

attach( votes.df )

Trump.recount   <- 0
Clinton.recount <- 0

Trump.one.pct <- floor( Trump * 0.01 ) 

votes.df$Trump.recount   <- Trump   - Trump.one.pct 
votes.df$Clinton.recount <- Clinton + Trump.one.pct 

Winner <- ifelse( Trump.recount > Clinton.recount, "Trump", "Clinton" ) 

detach( votes.df )

sum( filter( votes.df, Trump.recount > Clinton.recount )$Electoral.Votes ) 
sum( filter( votes.df, Trump.recount < Clinton.recount )$Electoral.Votes ) 

red.state  <- tolower( filter( votes.df, Trump.recount > Clinton.recount )$State )
blue.state <- tolower( filter( votes.df, Trump.recount < Clinton.recount )$State )

red.state.col  <- t( rbind( red.state, "red" ) ) 
blue.state.col <- t( rbind( blue.state, "blue" ) ) 

state.party.df <- ( data.frame( rbind( red.state.col, blue.state.col ) ) )
names( state.party.df ) <- c( "state.name", "party" )

library(maps)

states <- map(database = "state", fill = TRUE, col = c( "red", "blue" ) )

state.map.df <- data.frame( states$state.name <- unlist( lapply( strsplit( states$names, ":" ), function( l ) return( l[1] ) ) ) )
names( state.map.df ) <- c( "state.name" )

merge( state.map.df, state.party.df )

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

