my_packages = c("data.table","twitteR","RColorBrewer","plotly","Ckmeans.1d.dp","survival",
"dplyr","ggplot2","ggfortify")


install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p, dependencies = TRUE)
  }
  else {
    cat(paste("Skipping already installed package:", p, "\n"))
  }
}
invisible(sapply(my_packages, install_if_missing))