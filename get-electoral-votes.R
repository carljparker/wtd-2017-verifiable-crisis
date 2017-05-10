
library( rvest )

wiki.elect.votes <-  paste( 
                            "https://en.wikipedia.org/wiki/",
                            "Electoral_College_(United_States)",
                            "#Current_electoral_vote_distribution",
                            sep = ""
                          )

evotes.by.state.li <- read_html( wiki.elect.votes ) %>%
  html_nodes( "table.wikitable:nth-child(103)" ) %>% 
  html_table()

evotes.by.state.df <- evotes.by.state.li[[1]]

