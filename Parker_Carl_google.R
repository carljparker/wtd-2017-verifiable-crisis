
#
# --- Library Dependencies ---
#
library( magrittr )
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

pop.elect.votes.df <- merge( votes.df, electoral.votes.df )

sum( pop.elect.votes.df[ votes.df$Trump > votes.df$Clinton, ]$Electoral.Votes )
sum( pop.elect.votes.df[ votes.df$Trump < votes.df$Clinton, ]$Electoral.Votes )

votes.df$trump.one.pct <- floor( votes.df$Trump * 0.1 )
votes.df$Clinton.retally <- votes.df$Clinton + votes.df$trump.one.pct
votes.df$Trump.retally   <- votes.df$Trump   - votes.df$trump.one.pct

votes.df$winner.retally  <- ifelse( votes.df$Trump.retally > votes.df$Clinton.retally, "Trump", "Clinton" )

sum( pop.elect.votes.df[ votes.df$Trump.retally > votes.df$Clinton.retally, ]$Electoral.Votes )
sum( pop.elect.votes.df[ votes.df$Trump.retally < votes.df$Clinton.retally, ]$Electoral.Votes )

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

