## Basic script to plot

library(tidyverse)

## Get bamlist

bamlist<-read_csv("bamlists/allrapture1.bamlist", col_names=c("Path"))

###  gsub to make a meta file
bamlist$Sample<-gsub("/home/amilzz/projects/LCT/SOMM371/bam/","",bamlist$Path)
bamlist$Sample<-gsub("_sorted_proper_rmdup.bam","",bamlist$Sample)

meta<-bamlist %>% separate(Sample, sep="_", into=c("MajorBasin","MinorBasin","Year","Number"), remove=FALSE)

head(meta)

write_csv(meta, "meta/meta.csv" )

## Get qopt
q2<-read_delim("data/stru_k2.qopt", delim=" ", col_names=FALSE) %>% dplyr::select(X1, X2) %>%
  rename(Q1=X1, Q2=X2)

df2<-bind_cols(q2, meta)            

### reorder somehow? Data can now be sorted, numerically by Q or by defining factors for df2$MajorBasin, not reordering at the moment
### Tidying up data frame
q2s<-df2 %>% select(MajorBasin, MinorBasin, Q1, Q2) %>% mutate(Index=1:n()) %>% gather(key=Ancestry, value=Q, 3:4) %>% mutate(K=2)

## Coming up with labels, because of grouping variables, keepint Minor Basin and Major Basin variables.
pops2<-q2s  %>% group_by(MajorBasin, MinorBasin) %>% mutate(Start=min(Index), Stop=max(Index)) %>% 
  select(MajorBasin,Start,Stop) %>% unique() %>% 
  mutate(Position=round((Start+Stop)/2)) %>% ungroup() %>% unique()

## plotting
p2 <- ggplot(q2s) + 
  geom_col(aes(x=Index,y=Q, fill=Ancestry), color="NA", size = 0, width = 1) +
  geom_segment(data=pops2, x = pops2$Start - 0.5, y=0, xend = pops2$Start-0.5, yend=1, alpha=0.9, size=0.25) +
  geom_segment(data=pops2, x = pops2$Stop[length(pops2$Stop)]  + 0.5, y=0, xend= pops2$Stop[length(pops2$Stop)] + 0.5, yend=1,  alpha=0.9,
               size=0.25) +
  geom_segment(x=0+.5, xend= max(pops2$Stop)+.5, y=1, yend=1, alpha=0.9, size=0.25) +
  geom_segment(x=0+.5, xend= max(pops2$Stop)+.5, y=0, yend=0, alpha=0.9, size=0.25) +
  ylim(-0.1,1.01) +
  xlim(-0.1, pops2$Stop[length(pops2$Stop)]+1) +
  theme(panel.background = element_blank()) +
  xlab("") +
  #scale_fill_manual(values=c(cols[5], cols[1])) +
  theme(legend.position = "") +
#  theme(axis.text.x = element_blank(), axis.ticks.x=element_blank()) +
  scale_x_continuous(breaks=pops2$Position, labels=pops2$MajorBasin) +
  theme(axis.text.x=element_text(angle=45, vjust=0, hjust=.5, size=6))


p2

ggsave("outputs/100/bamlist-1336-k2.jpeg", width=12, height=4)
