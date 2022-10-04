library(tidyverse)
library(minpack.lm)
library(cmdstanr)
library(tidyverse)
library(loo)
library(rstan)
library(bayesplot)
library(posterior)
library(tidybayes)
library(ggmcmc)




dat<-readxl::read_excel("D:/Other_program/VBA/Nov_25th_EC50_tutorial.xlsx",sheet = 1,
                        col_names = TRUE) %>% as_tibble()

dat1<-dat[,-1] %>% as_data_frame()

resp_a1<-dat1 %>% dplyr::select(,starts_with("No inhibitor"))
colnames(resp_a1)<-NA
resp_a2<-NULL
for(i in 1:nrow(resp_a1)){
  tmp<-resp_a1[,i]
  resp_a2<-bind_rows(resp_a2,tmp)
}

colnames(resp_a2)<-"Response"
Group<-rep("No inhibitor",nrow(resp_a2))


Conc<-rep(dat$Conc,times=3)
dat_a<-data.frame(Conc,resp_a2,Group)
dat_a_r<-na.omit(dat_a)


a_min <- mean(dat_a[dat_a$Conc==min(dat_a_r$Conc),]$Response)
a_max<-mean(dat_a[dat_a$Conc==max(dat_a_r$Conc),]$Response)

dat_a_r2<-dat_a %>% mutate(Norm_Response=(Response-a_min)/(a_max-a_min)*100)




resp_b1<-dat1 %>% dplyr::select(,starts_with("Inhibitor"))
colnames(resp_b1)<-NA
resp_b2<-NULL
for(i in 1:nrow(resp_b1)){
  tmp<-resp_b1[,i]
  resp_b2<-bind_rows(resp_b2,tmp)
}

colnames(resp_b2)<-"Response"
Group<-rep("Inhibitor",nrow(resp_b2))


Conc<-rep(dat$Conc,times=3)
dat_b<-data.frame(Conc,resp_b2,Group)
dat_b_r<-na.omit(dat_b)

b_min <- mean(dat_b[dat_b$Conc==min(dat_b_r$Conc),]$Response)
b_max<-mean(na.omit(dat_b[dat_b$Conc==max(dat_b_r$Conc),]$Response))

dat_b_r2<-dat_b %>% mutate(Norm_Response=(Response-b_min)/(b_max-b_min)*100)


dat_r<-bind_rows(dat_a_r2,dat_b_r2)

dat_r$Group<-factor(dat_r$Group,levels=unique(dat_r$Group))

saveRDS(dat_r,"./EC50/EC50_tutorial.rds")

readRDS("./EC50/EC50_tutorial.rds")



dat_r

Group2<-as.integer(rep(c(1,0),c(nrow(dat_a_r),nrow(dat_b_r))))


dat_r_OK<-na.omit(dat_r) %>% bind_cols(Group2) %>% mutate(Group2=...5) %>% select(!...5)


Conc<-dat_r_OK$Conc
Obs<-dat_r_OK$Norm_Response
Group<-as.integer(dat_r_OK$Group)-1







pred<-function(parS,xx,group,group2){
  100/(1+10^(parS$b*(parS$c*group-xx+parS$t*group2)))
}

resid<-function(p,observed,xx,group,group2){
  observed-pred(p,xx,group,group2)
}

parStart<-list(b=0.1,t=1,c=1)

nls.out<- nls.lm(par=parStart, fn=resid, observed=Obs,
                 xx=Conc,group=Group2,group2=Group,
                 control=nls.lm.control(maxiter=1024,nprint=1))


r.out<-nls.out$deviance
c<-nls.out$par$c
b<-nls.out$par$b
t<-nls.out$par$t

n_all2<-nrow(dat_r_OK)

df<-n_all2-3

qlevel<-qf(0.95,1,df)

G1<-Group

residB<-function(cont,qlevel){
  f<-sum((Obs-100/(1+10^(b*(cont*Group2-Conc+t*G1))))^2)
  f2<-f-r.out-qlevel*r.out/df
  return(f2)
}


Cont_lower<-uniroot(residB,interval = c(-10,nls.out$par$c),qlevel)$root
Cont_upper<-uniroot(residB,interval = c(nls.out$par$c,-4),qlevel)$root



residC<-function(treat,qlevel){
  f<-sum((Obs-100/(1+10^(b*(c*Group2-Conc+treat*G1))))^2)
  f2<-f-r.out-qlevel*r.out/df
  return(f2)
}



Treat_lower<-uniroot(residC,interval = c(-10,nls.out$par$t),qlevel)$root
Treat_upper<-uniroot(residC,interval = c(nls.out$par$t,-4),qlevel)$root


residD<-function(hill,qlevel){
  f<-sum((Obs-100/(1+10^(hill*(c*Group2-Conc+t*G1))))^2)
  f2<-f-r.out-qlevel*r.out/df
  return(f2)
}


hill_lower<-uniroot(residD,interval = c(0,nls.out$par$b),qlevel)$root
hill_upper<-uniroot(residD,interval = c(nls.out$par$b,2),qlevel)$root


EC50_Cont_est<-nls.out$par$c
EC50_Treat_est<-nls.out$par$t
hill_est<-nls.out$par$b

EC50_est<-matrix(NA,nrow=3,ncol=2)
Hill_est<-matrix(NA,nrow=3,ncol=2)

EC50_est[1,]<-c(Cont_upper,Treat_upper)
EC50_est[2,]<-c(EC50_Cont_est,EC50_Treat_est)
EC50_est[3,]<-c(Cont_lower,Treat_lower)


Hill_est[1,]<-c(hill_lower,hill_lower)
Hill_est[2,]<-c(hill_est,hill_est)
Hill_est[3,]<-c(hill_upper,hill_upper)

rownames(EC50_est)<-c("EC50_upper","EC50","EC50_lower")
colnames(EC50_est)<-c("Cont","Treat")

rownames(Hill_est)<-c("Hill_upper","Hill","Hill_lower")
colnames(Hill_est)<-c("Cont","Treat")

EC50_est
Hill_est










########################################################

conc<-dat_r_OK$Conc
Obs<-dat_r_OK$Norm_Response/100
Group<-as.integer(dat_r_OK$Group)

x_new<-seq(-10,-3.5,0.1)
x_new2<-rep(x_new,2)
k<-length(x_new2)
G_new<-rep(c(levels(dat_r_OK$Group)),each=length(x_new))
G_new<-factor(G_new, levels=unique(G_new))
Group_new<-as.integer(G_new)




l<-nrow(dat_r_OK)
n<-nlevels(dat_r_OK$Group)


Bio <- list(J=l,
            N=n,
            K=k,
            y=Obs,
            x=conc,
            g=Group,
            X_new=x_new2,
            g_new=G_new
)

nChains <- 10
nPost <- 1000 ## Number of post-burn-in samples per chain after thinning
nBurn <- 1000 ## Number of burn-in samples per chain after thinning
nThin <- 10

nIter <- (nPost + nBurn) * nThin
nIter2<-6000
nBurnin <- nBurn * nThin/2




model<-cmdstanr::cmdstan_model("D:/R-analysis/Stan_associated/Stan_code/Stan_test_220722_5.stan")

fit <- model$sample(data=Bio,iter_warmup=nBurnin, 
                    iter_sampling=nIter,thin<-nThin,chains = nChains,
                    adapt_delta=0.8,
                    max_treedepth = 20,
                    seed = 123)


fit$save_object(file = "./Stan_associated/220803fit.RDS")

#fit$output_files()

fit$summary()


fit$cmdstan_diagnose()


fitout<-rstan::read_stan_csv(fit$output_files())

mcmc_sample2<- fitout %>% rstan::extract()

# ggplotやtidyverseで扱いやすく処理する
mcmc_samples = as_draws_df(fit$draws())
# d01のtrace plot
mcmc_samples %>%
  mutate(chain = as.factor(.chain)) %>% 
  ggplot(aes(x = .iteration, y = `beta[1]`, group = .chain, color = chain)) +
  geom_line()



Bio.post <- data.frame(alpha = mcmc_samples$alpha,
                       beta1 = mcmc_samples$`beta[1]`,
                       beta2 = mcmc_samples$`beta[2]`)


Bio.post %>%
  mutate(ld50 = beta1) %>%
  with(quantile(ld50, c(0.005,.025, .25, .5, .75, .975,0.995)))

Bio.post %>%
  mutate(ld50 = beta2) %>%
  with(quantile(ld50, c(0.005,.025, .25, .5, .75, .975,0.995)))

Bio.post %>%
  mutate(hill = alpha) %>%
  with(quantile(hill, c(0.005,.025, .25, .5, .75, .975,0.995)))




mcmc_samples %>% 
  ggplot() +
  geom_histogram(aes(x=`beta[1]`),binwidth = 0.01)

mcmc_samples %>% 
  ggplot() +
  geom_histogram(aes(x=`beta[2]`),binwidth = 0.01)

mcmc_samples %>% 
  ggplot() +
  geom_histogram(aes(x=`alpha`),binwidth = 0.01)



rstan::stan_plot(fitout, pars = "beta", ci_level = 0.99, outer_level = 1, show_density = T, 
                 point_est = "mean")







geom_smooth(method = drm,col = "skyblue", method.args = list(fct = L.4()), se = F) 

dose_resp <- function(x,g1,g2){
  temp<- 1 / (1 + 10^(mcmc_sample2$alpha * (mcmc_sample2$beta[2]*g1+mcmc_sample2$beta[1]*g2- x)))
  print(tmp)
  
}

dat_new<-bind_cols(x_new2,G_new,Group_new)%>% mutate(Conc=x_new2,Group=`...2`)



G1<-Group-1
G2<-Group2


mcmc_samples$theta

dat_out<-apply(mcmc_sample2$theta,2,quantile,probs=c(0.025, 0.50,0.975)) %>%
  #転置してデータフレームに整形する
  t() %>% bind_cols(dat_r_OK,.)



y.pred.interval <- 
  mcmc_sample2$y_new %>% 
  apply(MARGIN=2, quantile, prob=c(0.025, 0.5, 0.975)) %>% 
  t() %>% 
  as_tibble()



plot1<-bind_cols(dat_new,
                 y.pred.interval)%>% ggplot(aes(Conc, `50%`,colour=Group,fill=Group))+
  geom_ribbon(aes(ymin=`2.5%`,y=`50%`,ymax=`97.5%`), alpha=0.1)+
  geom_line()+
  geom_ribbon(data=dat_out,aes(x=Conc,ymin=`2.5%`,ymax=`97.5%`), alpha=0.5)+
  geom_point(data=dat_r_OK, aes(Conc,Norm_Response/100,colour=Group))+theme_classic()





plot2<-plot1+
  scale_y_continuous(limits = c(-0.2,1.25))


plot3<-plot2 + theme(axis.title = element_text(size = 15,
                                               face = "bold"), axis.text = element_text(colour = "black"),
                     axis.text.x = element_text(size = 15),
                     axis.text.y = element_text(size = 15)) +labs(y = "Response")

plot3<-ggplot(data=dat_out,aes(x=Conc,y=`50%`,colour=Group,fill=Group))+
  geom_ribbon(aes(ymin=`2.5%`,ymax=`97.5%`), alpha=0.1)










