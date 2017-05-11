
library( rvest )
library( knitr )

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
evotes.wiki.df <- evotes.wiki.df[ -( 20 ), ] 

names( evotes.wiki.df ) <- c( "EV", "States" )

evotes.wiki.df$EV <- strsplit( evotes.wiki.df$EV, " " )

evotes.wiki.df$EV <- unlist( lapply( evotes.wiki.df$EV, function( li ) as.numeric( unlist( li )[ 1 ] ) ) )

evotes.df <- data.frame()

for( row.idx in 1:nrow( evotes.wiki.df ) ) {
  states.vec <- trimws( unlist( strsplit( evotes.wiki.df[ row.idx, 2 ], "," ) ) )
  evotes.df <- rbind( evotes.df, cbind( states.vec, evotes.wiki.df[ row.idx, 1] ) )
}

names( evotes.df ) <- c( "State", "Electoral.Votes" )

knitr::kable( head( evotes.df ) )




