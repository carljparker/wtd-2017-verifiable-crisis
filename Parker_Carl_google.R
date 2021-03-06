
#
# --- Library Dependencies ---
#
library( magrittr )
library( dplyr )
library( ggplot2 )
library( maps )
library( googlesheets )

viz_state_affiliation <- function( state.to.party.map.df ) {
  #
  # Get the vector of names from the the "state" database.
  # Some states are duplicated.
  #
  states <- map_data( "state" )
  state.map.df <- data.frame( unique( cbind( states$region, states$subregion ) )[ , 1 ] )
  names( state.map.df ) <- c( "state.name" )

  #
  # Merge in the state-to-party mapping.
  #
  state.map.party.df <- merge( state.map.df, state.party.df )
  state.map.party.df$party <- as.character( state.map.party.df$party )

  #
  # Render
  #
  states <- map(database = "state", fill = TRUE, col = state.map.party.df$party )
}

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

red.state  <- tolower( filter( votes.df, Trump > Clinton )$State )
blue.state <- tolower( filter( votes.df, Trump < Clinton )$State )

red.state.col  <- cbind( red.state, "red" ) 
blue.state.col <- cbind( blue.state, "blue" )  
state.party.df <- ( data.frame( rbind( red.state.col, blue.state.col ) ) )
names( state.party.df ) <- c( "state.name", "party" )

viz_state_affiliation( state.party.df )


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


#
# Map a color to each state based on its party.
#
red.state.col  <- cbind( red.state, "red" ) 
blue.state.col <- cbind( blue.state, "blue" )  
state.party.df <- ( data.frame( rbind( red.state.col, blue.state.col ) ) )
names( state.party.df ) <- c( "state.name", "party" )

viz_state_affiliation( state.party.df )


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

