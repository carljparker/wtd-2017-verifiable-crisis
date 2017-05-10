
library( rvest )

wiki.elect.votes <-  paste( 
                            "https://en.wikipedia.org/wiki/",
                            "Electoral_College_(United_States)",
                            "#Current_electoral_vote_distribution",
                            sep = ""
                          )

evotes.by.state.li <- read_html( wiki.elect.votes ) %>%
  html_nodes( "table.wikitable:nth-child(103)" )    %>% 
  html_table()

evotes.by.state.df <- evotes.by.state.li[[1]]
names( evotes.by.state.df ) <- c( "EV", "State" )

evotes.by.state.df <- evotes.by.state.df[ -( 20 ), ] 
evotes.by.state.df$EV <- strsplit( evotes.by.state.df$EV, " " )

lapply( evotes.by.state.df$EV, function( li ) as.numeric( unlist( li )[ 1 ] ) )
evotes.by.state.df$EV <- as.numeric( unlist( evotes.by.state.df$EV )[ 1 ] )

