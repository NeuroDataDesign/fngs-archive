arfull <- function(order, graph850, graph49) {
  
  ar <- vector("list", 34)
  for (i in 1:34) { ar[[i]] <- ar(graph850[,,i], aic=FALSE, order.max = order)}
  arpred <- vector("list", 34)
  for (i in 1:34) {arpred[[i]] <- predict(object=ar[[i]], newdata=graph850[,,i], n.ahead = 49)$pred}
  pred = array(dim=c(49, 70, 34))
  for (i in 1:34) {pred[,,i] = arpred[[i]]}
  plots = arplotter(graph49, pred)
  multiplot(plots[[1]],plots[[2]],plots[[3]],plots[[4]],plots[[35]],plots[[36]],plots[[37]],plots[[38]],plots[[69]],plots[[70]],plots[[71]],plots[[72]],plots[[103]],plots[[104]],plots[[105]],plots[[106]], cols=4)
  R2 = array(dim=c(70,34))
  for (i in 1:34) {
    for (j in 1:70) {
      test = pred[1:49, j, i]
      test2 = graph49[1:49, j, i]
      R2[j, i] = 1 - (sum((test2-test)^2)/sum((test2-mean(test2))^2))
    }
  }
  return(R2)
}