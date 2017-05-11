
library( rvest )

wiki.elect.votes <-  paste( 
                            "https://en.wikipedia.org/wiki/",
                            "Electoral_College_(United_States)",
                            "#Current_electoral_vote_distribution",
                            sep = ""
                          )

evotes.wiki.li <- read_html( wiki.elect.votes ) %>%
  html_nodes( "table.wikitable:nth-child(103)" )    %>% 
  html_table()

evotes.wiki.df <- evotes.wiki.li[[1]]
names( evotes.wiki.df ) <- c( "EV", "State" )

evotes.wiki.df <- evotes.wiki.df[ -( 20 ), ] 
evotes.wiki.df$EV <- strsplit( evotes.wiki.df$EV, " " )

evotes.wiki.df$EV <- unlist( lapply( evotes.wiki.df$EV, function( li ) as.numeric( unlist( li )[ 1 ] ) ) )

evotes.df <- data.frame()
row <- 1

states.vec <- trimws( unlist( strsplit( evotes.wiki.df[ row, 2 ], "," ) ) )
rbind( evotes.df, cbind( states.vec, evotes.wiki.df[ row, 1] ) )
evotes.df

for( row.idx in 1:nrow( evotes.wiki.df ) ) {
  states.vec <- trimws( unlist( strsplit( evotes.wiki.df[ row.idx, 2 ], "," ) ) )
  evotes.df <- rbind( evotes.df, cbind( states.vec, evotes.wiki.df[ row.idx, 1] ) )
}

evotes.df


