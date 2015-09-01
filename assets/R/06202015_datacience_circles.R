# create a multi 
library('ggplot2')

gg <- ggplot() + scale_x_continuous(limits=c(0,1)) + scale_y_continuous(limits=c(0,1))
for(i in 1:10) gg <- gg + geom_point(aes(x=rnorm(1, 0.5, 0.04), y=rnorm(1, 0.5, 0.04)), size=runif(1, 40, 100), color='red', alpha=.15)
plot(gg)

gg <- gg +  geom_point(aes(x=.5, y=.5), size=100, color='black', alpha=.15)
plot(gg)
