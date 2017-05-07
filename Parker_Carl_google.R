
#
# --- Library Dependencies ---
#
library( magrittr )
library( googlesheets )


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

names( electoral.votes.df ) <- c( "Electoral.Votes", "State" )
electoral.votes.df$State <- gsub( "\\*", "", electoral.votes.df$State )
head( electoral.votes.df )

sum( electoral.votes.df$Electoral.Votes )

official.gs <- gs_url( c( "https://docs.google.com/spreadsheets/d/133Eb4qQmOxNvtesw2hdVns073R68EZx4SfCnP4IGQf8/" ) ) 

official.gs %>% gs_read( range = "A12:D24" )

swing.df   <- official.gs %>% gs_read( range = "A12:D24", col_names = FALSE ) %>% data.frame()
noswing.df <- official.gs %>% gs_read( range = "A27:D64", col_names = FALSE ) %>% data.frame()

votes.all.states.df <- rbind( swing.df, noswing.df )
names( votes.all.states.df  )<- c( "State", "Clinton", "Trump", "Other" )
head( votes.all.states.df )
votes.all.states.df$State <- gsub( "\\*", "", votes.all.states.df$State )

pop.elect.votes.all.states.df <- merge( votes.all.states.df, electoral.votes.df )
head( pop.elect.votes.all.states.df )

sum( pop.elect.votes.all.states.df[ votes.all.states.df$Trump > votes.all.states.df$Clinton, ]$Electoral.Votes )
sum( pop.elect.votes.all.states.df[ votes.all.states.df$Trump < votes.all.states.df$Clinton, ]$Electoral.Votes )

votes.all.states.df$trump.one.pct <- floor( votes.all.states.df$Trump * 0.1 )
votes.all.states.df$Clinton.retally <- votes.all.states.df$Clinton + votes.all.states.df$trump.one.pct
votes.all.states.df$Trump.retally   <- votes.all.states.df$Trump   - votes.all.states.df$trump.one.pct

votes.all.states.df$winner.retally  <- ifelse( votes.all.states.df$Trump.retally > votes.all.states.df$Clinton.retally, "Trump", "Clinton" )

sum( pop.elect.votes.all.states.df[ votes.all.states.df$Trump.retally > votes.all.states.df$Clinton.retally, ]$Electoral.Votes )
sum( pop.elect.votes.all.states.df[ votes.all.states.df$Trump.retally < votes.all.states.df$Clinton.retally, ]$Electoral.Votes )

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

