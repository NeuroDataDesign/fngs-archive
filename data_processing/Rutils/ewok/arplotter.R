arplotter <- function(arg1, arg2) {
  
  y = c(1:49)
  plots = vector("list", 2380)
 
  for (i in 1:34) {
    for (j in 1:70) {
      vals = arg1[1:49, j, i]
      pred = arg2[1:49, j, i]
      dfval = data.frame(value=vals, timestep=y)
      dfprd = data.frame(value=pred, timestep=y)
      plots[[34*(j-1)+i]] = ggplot() + geom_point(data = dfval, aes(x = timestep, y = value)) +
      geom_line(data = dfprd, aes(x = timestep, y = value)) +
      ggtitle(sprintf("Subject No. %i, ROI %i", i, j))
    }
  }
  return(plots)
}

#plots[[70*(i-1)+j]]