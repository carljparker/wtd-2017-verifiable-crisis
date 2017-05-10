
library( rvest )

wiki.elect.votes <-  paste( 
                            "https://en.wikipedia.org/wiki/",
                            "Electoral_College_(United_States)",
                            "#Current_electoral_vote_distribution",
                            sep = ""
                          )

html.parsed <- read_html( wiki.elect.votes )
html_nodes( html.parsed, "table.wikitable:nth-child(103)" )

