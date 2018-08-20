class AbundancesController < ApplicationController
  before_action :set_abundance, only: [:show, :edit, :update, :destroy]
  before_filter :set_cache_buster

  # GET /abundances
  # GET /abundances.json
 

  # GET /abundances/1
  # GET /abundances/1.json
  def show
    @ensembl = HTTParty.get('http://rest.ensembl.org' + '/lookup/id/' + @abundance.target_id,
    :headers =>{'Content-Type' => 'application/json'} )
    if @ensembl["display_name"].nil? 
     @name = "1"
    else
      @name = @ensembl["display_name"][0..-5]

      @wikis = HTTParty.get('https://webservice.wikipathways.org/findPathwaysByText?query=' + @name + '&species=homo+sapiens&format=json',
      :headers =>{'Content-Type' => 'application/json'} )

      @pubs = HTTParty.get('https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&retmode=json&term='+ @name,
      :headers =>{'Content-Type' => 'application/json'} )
  
      @omim = HTTParty.get('https://api.omim.org/api/entry/search?search='+ @name+ '&start=0&limit=1&include=text:description&apiKey=6-p06gbQTZiAWNOpPn-CSw&format=xml',:headers =>{'Content-Type' => 'application/xml'} )
      
   

    end
end

  def export1
    @search = Abundance.ransack(params[:q])
    @data = @search.result
    respond_to do |format|
      format.html { redirect_to root_url }
      format.csv { send_data @data.to_csv }
    end
  end
def import
    Abundance.import(params[:file])
    redirect_to abundances_url, notice: "List Imported"
  end
  # GET /abundances/new
  def new
    @abundance = Abundance.new
    respond_to do |format|
    format.html
    format.js
  end
  end

  # GET /abundances/1/edit
  def edit
  end

  # POST /abundances
  # POST /abundances.json
  def create
    @abundance = Abundance.new(abundance_params)

    respond_to do |format|
      if @abundance.save
        format.html { redirect_to @abundance, notice: 'Abundance was successfully created.' }
        format.json { render :show, status: :created, location: @abundance }
      else
        format.html { render :new }
        format.json { render json: @abundance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /abundances/1
  # PATCH/PUT /abundances/1.json
  def update
    respond_to do |format|
      if @abundance.update(abundance_params)
        format.html { redirect_to @abundance, notice: 'Abundance was successfully updated.' }
        format.json { render :show, status: :ok, location: @abundance }
      else
        format.html { render :edit }
        format.json { render json: @abundance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /abundances/1
  # DELETE /abundances/1.json
  def destroy
    @abundance.destroy
    respond_to do |format|
      format.html { redirect_to abundances_url, notice: 'Abundance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
def index
    @search = Abundance.ransack(params[:q])
    @abundances = @search.result
    @abundancez =  @abundances.paginate(:page => params[:page],:per_page => 350)
    @searchab = Abundance.ransack(params[:q]).result
    @white = Sample.ransack(race_eq: "WHITE")
    @whites = @white.result

    CSV.open("app/assets/data.csv", 'w', write_headers: true ) do |csv|
      @abundances.each do |c|
        csv << [c.sample_id,c.tpm,c.target_id,c.sample.race,c.sample.vital_status,c.sample.status_bool,c.sample.death_days_to,c.sample.gender,c.sample.ajcc_pathologic_tumor_stage,c.sample.age_at_initial_pathologic_diagnosis,c.sample.days_to_event,c.sample.event]
  end
end
end
require 'rinruby'
def runR
  if File.exist?('public/TN.html')
File.delete('app/public/TN.html')
end

  if File.exist?('app/assets/data.csv')
  #R.image_path = Rails.root.join("app", "assets","images", "a.png").to_s
  R.eval("library(data.table)")
  R.eval("mydata <- read.table('app/assets/data.csv',sep=',')")
  R.eval("dt <- as.data.table(mydata)")
  R.eval("TU <- dt[!mydata$V1 %like% '-N$']")
  R.eval("N <- dt[mydata$V1 %like% '-N$']")
  R.eval("ttest <- t.test(TU$V2,N$V2)")
  R.eval("names1 <- as.vector(TU$V3[1])")
  #R.eval("png(filename=image_path)")
  #R.eval("boxplot(N$V2,TU$V2, main = sprintf('Expression Levels of %s P-value = %s ',names1,ttest$p.value),at = c(1,2), names = c('Normal', 'Tumor'), las = 2, col = c('green','red'),  log = 'y')")
  #R.eval("dev.off()")
  R.eval("library(plotly)")
  #If you want to us plotly api, uncomment these two lines and provide credentials then uncomment line 133
  #R.eval("Sys.setenv('plotly_username' = username)")
  #R.eval("Sys.setenv('plotly_api_key' = apikey)")
  R.eval("p <- plot_ly(TU, y = TU$V2,type = 'box',name = 'Tumor', yaxis = list(type = 'log')) %>% add_trace(N,y = N$V2, name = 'Normal',yaxis = list(type = 'log')) %>% layout(title=sprintf('Expression Levels of %s \n P-Value  = %s ',names1,ttest$p.value))")
  #R.eval('api_create(p,filename = "r-docs-midwest-boxplots")')
  #R.eval('htmlwidgets::saveWidget(as_widget(p), "TN.html")')
  R.eval("setwd('/home/deploy/apps/diffexdb/current/public')")
  R.eval('htmlwidgets::saveWidget(as_widget(p), "TN.html')
  redirect_to('/TN.html')
  File.delete('app/assets/data.csv')
else
  redirect_to(:back, notice: " Sorry. You are too quick for me! Something went wrong. Please try your request again")
end
end
def runRrace
  if File.exist?('app/public/race.html')
File.delete('app/public/race.html')
end
  if File.exist?('app/assets/data.csv')

  #R.image_path = Rails.root.join("app", "assets","images", "race.png").to_s
  
  R.eval("library(data.table)")
  R.eval("mydata <- read.table('app/assets/data.csv',sep=',')")
  R.eval("dt <- as.data.table(mydata)")
  R.eval("TU <- dt[!mydata$V1 %like% '-N$']")
  R.eval("names1 <- as.vector(dt$V3[1])")
  R.eval("df <- split(mydata, mydata$V4)")
 
  #R.eval("png(filename=image_path)")
  #R.eval("boxplot(df$WHITE,df$notacessed,df$`BLACK OR AFRICAN AMERICAN`,df$ASIAN,df$AmericanIndian, main = sprintf('Expression Levels of %s ',names1), at = c(1,2,3,4,5),names = c('White', 'NA','Black','Asian','American Indian'),las = 2, col = c('green','red'),log = 'y')")
  #R.eval("dev.off()")
  R.eval("res.aov <- aov(TU$V2 ~ TU$V4, data=TU)")
  R.eval('pval <-summary(res.aov)[[1]][["Pr(>F)"]][1]')
  R.eval("library(twitteR)")
  R.eval("library(RColorBrewer)")
  R.eval("library(plotly)")
  R.eval("p <- plot_ly(TU, y = ~TU$V2,color = ~TU$V4, type = 'box') %>% layout(hovermode = 'closest',
          showlegend = T,
          margin = list(r = 20, t = 60, b = 60, l = 60, pad = 1),
          paper_bgcolor = '',
title=sprintf('Expression Levels of %s by race \n P-Value  = %s ',names1,pval),titlefont = list(color = 'rgb(2, 0, 1)', size = 20),xaxis = list(
            gridcolor = 'rgb(255, 255, 255)',
            tickfont = list(color = 'rgb(255, 255, 255)'),
            title = 'Race',
            titlefont = list(color = 'rgb(2, 0, 1)')),
 
          yaxis = list(
            gridcolor = 'rgb(255, 255, 255)',
            tickfont = list(color = 'rgb(255, 255, 255)'),
            title = 'TPM',
            titlefont = list(color = 'rgb(2, 0, 1)')))")

  #R.eval("Sys.setenv('plotly_username' = 'mohmhm1')")
  #R.eval("Sys.setenv('plotly_api_key' = 'Ltj2TVLQJ85c88ZGw0pZ')")
  #R.eval("p")
  R.eval("setwd('/home/deploy/apps/diffexdb/current/public')")
  R.eval('htmlwidgets::saveWidget(as_widget(p), "race.html")')
  redirect_to('/race.html')
  File.delete('app/assets/data.csv')
else
  redirect_to(:back, notice: " Sorry. You are too quick for me! Something went wrong. Please try your request again")
end
  #R.eval("plotly_IMAGE(p, format = 'png', out_file =image_path)") 
  #R.eval("api_create(p, filename ='race.png')")
  #send_file Rails.root.join("app", "assets", "images", "race.png"), type: "image/png", disposition: "inline"
end
def runRrace_file
  if File.exist?('app/public/anova_race.csv')
File.delete('app/public/anova_race.csv')
end
  if File.exist?('app/assets/data.csv')
  #R.image_path = Rails.root.join("app", "assets","images", "alive.png").to_s
  R.eval("library(data.table)")
  R.eval("mydata <- read.table('app/assets/data.csv',sep=',')")
  R.eval("dt <- as.data.table(mydata)")
  R.eval("names1 <- as.vector(dt$V3[1])")
  R.eval("TU <- dt[!mydata$V1 %like% '-N$']")
  R.eval("TPM <- TU$V2")
  R.eval("Race <- TU$V4")
  R.eval("res.aov <- aov(TPM ~ Race, data=TU)")
  R.eval('pval <-summary(res.aov)[[1]][["Pr(>F)"]][1]')
  R.eval('pvalcomp <- TukeyHSD(res.aov)')
  R.eval('TK_data<-as.data.frame(pvalcomp[1:1])')
  R.eval("setwd('/home/deploy/apps/diffexdb/current/public')")
  R.eval("write.csv(TK_data, 'anova_race.csv')")
  send_file("public/anova_race.csv", :disposition => 'attachment')
  File.delete('app/assets/data.csv')
else
  redirect_to(:back, notice: " Sorry. You are too quick for me! Something went wrong. Please try your request again")
end
end
def runRkmeans_cluster
#ckmeans for diffexdb
if File.exist?('app/public/kmeans_cluster.html')
File.delete('app/public/kmeans_cluster.html')
end
if File.exist?('app/assets/data.csv')
#first find optimal clusters

R.eval("library(data.table)")
R.eval("library(Ckmeans.1d.dp)")
R.eval("data <- read.table('app/assets/data.csv', header = FALSE, sep=',')")
R.eval("dt <- as.data.table(data)")
R.eval("TU <- dt[!data$V1 %like% '-N$']")
R.eval("x <- c(TU$V2)")
R.eval("TPM <- as.numeric(unlist(x))")
R.eval("result <- Ckmeans.1d.dp(TPM)")
R.eval("k <- max(result$cluster)")
#now use k to run kmeans clustering
R.eval("library(twitteR)")
R.eval("library(RColorBrewer)")
R.eval("library(plotly)")
R.eval("dat = TU[,c(2)]")
R.eval("km1 = kmeans(dat, k)")
R.eval("TU$cluster <- km1$cluster")
R.eval('a <- plot_ly(TU,y=TU,x=TU$V2, mode = "marker",type= "scatter",
         showlegend = TRUE,
         hoverinfo = "text+x",
         text = ~TU$V1,
         marker = list(opacity = 1,
                       color = TU$cluster,
                       size = 12,
                       line = list(color = "#262626", width = 1)))%>%
 
   layout(hovermode = "closest",
          showlegend = F,
          margin = list(r = 20, t = 60, b = 60, l = 60, pad = 1),
          paper_bgcolor = "",
          title = paste("Kmeans Clustering for",TU$V3[1], "Univariate cluster algorithm found",k, "optimal clusters"),
          titlefont = list(color = "rgb(2, 0, 1)", size = 20),xaxis = list(
            gridcolor = "rgb(255, 255, 255)",
            tickfont = list(color = "rgb(255, 255, 255)"),
            title = "TPM",
            titlefont = list(color = "rgb(2, 0, 1)")),
 
          yaxis = list(
            gridcolor = "rgb(255, 255, 255)",
            tickfont = list(color = "rgb(255, 255, 255)"),
            title = "Sample Number",
            titlefont = list(color = "rgb(2, 0, 1)")))')

R.eval('htmlwidgets::saveWidget(as_widget(a), "kmeans_cluster.html")')
  redirect_to('/kmeans_cluster.html')
  File.delete('app/assets/data.csv')

  #File.delete('/kmeans_cluster.html')
 #R.eval("a")
#redirect_to(:back)
else
  redirect_to(:back, notice: " Sorry. You are too quick for me! Something went wrong. Please try your request again")
end
end

def runRstatus
  if File.exist?('app/public/status.html')
File.delete('public/status.html')
end
  if File.exist?('app/assets/data.csv')
  R.image_path = Rails.root.join("app", "assets","images", "alive.png").to_s
  R.eval("library(data.table)")
  R.eval("mydata <- read.table('app/assets/data.csv',sep=',')")
  R.eval("dt <- as.data.table(mydata)")
  R.eval("TU <- dt[!data$V1 %like% '-N$']")
  R.eval("names1 <- as.vector(dt$V3[1])")
  R.eval("df <- split(mydata, mydata$V5)")
  R.eval("ttest <- t.test(TU$Dead$V2,TU$Alive$V2)")
  #R.eval("png(filename=image_path)")
  #R.eval("boxplot(df$Alive,df$Dead, main = sprintf('Expression Levels of %s ',names1), at = c(1,2,),names = c('alive','dead'),las = 2, col = c('green','red'),log = 'y')")
  #R.eval("dev.off()")
  R.eval("library(twitteR)")
  R.eval("library(RColorBrewer)")
  R.eval("library(plotly)")

  R.eval("p <- plot_ly(TU, y = ~TU$V2,color = ~TU$V5, type = 'box') %>% layout(hovermode = 'closest',
          showlegend = T,
          margin = list(r = 20, t = 60, b = 60, l = 60, pad = 1),
          paper_bgcolor = '',
title=sprintf('Expression Levels of %s \n P-Value  = %s ',names1,ttest$p.value),titlefont = list(color = 'rgb(2, 0, 1)', size = 20),xaxis = list(
            
            tickfont = list(color = 'rgb(255, 255, 255)'),
            title = 'Status',
            titlefont = list(color = 'rgb(2, 0, 1)')),
 
          yaxis = list(
            
            tickfont = list(color = 'rgb(255, 255, 255)'),
            title = 'TPM',
            titlefont = list(color = 'rgb(2, 0, 1)')))")

  #R.eval("p")
  R.eval('htmlwidgets::saveWidget(as_widget(p), "status.html")')
  redirect_to('/status.html')
  File.delete('app/assets/data.csv')
else
  redirect_to(:back, notice: " Sorry. You are too quick for me! Something went wrong. Please try your request again")
end
end
def runRstage
  if File.exist?('app/public/stage.html')
File.delete('public/stage.html')
end
  if File.exist?('app/assets/data.csv')
  R.image_path = Rails.root.join("app", "assets","images", "alive.png").to_s
  R.eval("library(data.table)")
  R.eval("mydata <- read.table('app/assets/data.csv',sep=',')")
  R.eval("dt <- as.data.table(mydata)")
  R.eval("names1 <- as.vector(dt$V3[1])")
  R.eval("TU <- dt[!mydata$V1 %like% '-N$']")
  R.eval("TPM <- TU$V2")
  R.eval("Stage <- TU$V9")
  R.eval("res.aov <- aov(TPM ~ Stage, data=TU)")
  R.eval('pval <-summary(res.aov)[[1]][["Pr(>F)"]][1]')
  #R.eval('pvalcomp <- TukeyHSD(res.aov)')
 # R.eval('TK_data<-as.data.frame(pvalcomp[1:1])')
  #R.eval("write.csv(TK_data, 'anova_stage.csv')")
  #R.eval("png(filename=image_path)")
  #R.eval("boxplot(df$Alive,df$Dead, main = sprintf('Expression Levels of %s ',names1), at = c(1,2,),names = c('alive','dead'),las = 2, col = c('green','red'),log = 'y')")
  #R.eval("dev.off()")
  R.eval("library(twitteR)")
  R.eval("library(RColorBrewer)")
  R.eval("library(plotly)")
  R.eval("p <- plot_ly(TU, y = ~TPM,color = ~Stage, type = 'box') %>% layout(hovermode = 'closest',
          showlegend = T,
          margin = list(r = 20, t = 60, b = 60, l = 60, pad = 1),
          paper_bgcolor = '',title=sprintf('Expression Levels of %s by Stage.\n P-Value  = %s ',names1,pval),titlefont = list(color = 'rgb(2, 0, 1)', size = 20),xaxis = list(
           
            tickfont = list(color = 'rgb(2, 0, 1)'),
            title = 'Stage',
            titlefont = list(color = 'rgb(2, 0, 1)')),
 
          yaxis = list(
            tickfont = list(color = 'rgb(2, 0, 1)'),
            title = 'TPM',
            titlefont = list(color = 'rgb(2, 0, 1)')))")

  #R.eval("p")
  R.eval('htmlwidgets::saveWidget(as_widget(p), "stage.html")')
  redirect_to('/stage.html')
  File.delete('app/assets/data.csv')
else
  redirect_to(:back, notice: " Sorry. You are too quick for me! Something went wrong. Please try your request again")
end
end
def runRstage_file
  if File.exist?('app/public/anova_stage.csv')
File.delete('public/anova_stage.csv')
end
  if File.exist?('app/assets/data.csv')
  R.image_path = Rails.root.join("app", "assets","images", "alive.png").to_s
  R.eval("library(data.table)")
  R.eval("mydata <- read.table('app/assets/data.csv',sep=',')")
  R.eval("dt <- as.data.table(mydata)")
  R.eval("names1 <- as.vector(dt$V3[1])")
  R.eval("TU <- dt[!mydata$V1 %like% '-N$']")
  R.eval("TPM <- TU$V2")
  R.eval("Stage <- TU$V9")
  R.eval("res.aov <- aov(TPM ~ Stage, data=TU)")
  R.eval('pval <-summary(res.aov)[[1]][["Pr(>F)"]][1]')
  R.eval('pvalcomp <- TukeyHSD(res.aov)')
  R.eval('TK_data<-as.data.frame(pvalcomp[1:1])')
  R.eval("setwd('/home/deploy/apps/diffexdb/current/public')")
  R.eval("write.csv(TK_data, 'anova_stage.csv')")
  send_file("public/anova_stage.csv", :disposition => 'attachment')
  File.delete('app/assets/data.csv')
else
  redirect_to(:back, notice: " Sorry. You are too quick for me! Something went wrong. Please try your request again")
end
end
def runRcoxph
if File.exist?('app/public/coxph.html')
File.delete('app/public/coxph.html')
end
if File.exist?('app/assets/data.csv')
#R.eval("rm(list=ls())")
R.eval("library(data.table)")
R.eval("library(survival)")
R.eval("library(ggplot2)")
R.eval("library(dplyr)")
R.eval("library(ggfortify)")
R.eval("library(plotly)")

R.eval("data <- read.table('app/assets/data.csv', header = FALSE, sep=',')")
R.eval("dt <- as.data.table(data)")
R.eval("TU <- dt[!data$V1 %like% '-N$']")
R.eval("TUfin <- TU[!TU$V12 %like% '0$']")
R.eval("cox <- coxph(Surv(TUfin$V11, TUfin$V12) ~ TUfin$V2, data=TUfin)")
R.eval("cox_fit <- survfit(cox)")
R.eval("ggsurv1 <- function(s, CI = 'def', plot.cens = T, surv.col = 'gg.def',
                   cens.col = 'red', lty.est = 1, lty.ci = 2,
                   cens.shape = 3, back.white = F, xlab = 'Time',
                   ylab = 'Survival', main = ''){
 
  library(ggplot2)
  strata <- ifelse(is.null(s$strata) ==T, 1, length(s$strata))
  stopifnot(length(surv.col) == 1 | length(surv.col) == strata)
  stopifnot(length(lty.est) == 1 | length(lty.est) == strata)
 
  ggsurv.s <- function(s, CI = 'def', plot.cens = T, surv.col = 'gg.def',
                       cens.col = 'red', lty.est = 1, lty.ci = 2,
                       cens.shape = 3, back.white = F, xlab = 'Time',
                       ylab = 'Survival', main = ''){
 
    dat <- data.frame(time = c(0, s$time),
                      surv = c(1, s$surv),
                      up = c(1, s$upper),
                      low = c(1, s$lower),
                      cens = c(0, s$n.censor))
    dat.cens <- subset(dat, cens != 0)
 
    col <- ifelse(surv.col == 'gg.def', 'black', surv.col)
 
    pl <- ggplot(dat, aes(x = time, y = surv)) +
      xlab(xlab) + ylab(ylab) + ggtitle(main) +
      geom_step(col = col, lty = lty.est)
 
    pl <- if(CI == T | CI == 'def') {
      pl + geom_step(aes(y = up), color = col, lty = lty.ci) +
        geom_step(aes(y = low), color = col, lty = lty.ci)
    } else (pl)
 
    pl <- if(plot.cens == T & length(dat.cens) > 0){
      pl + geom_point(data = dat.cens, aes(y = surv), shape = cens.shape,
                       col = cens.col)
    } else if (plot.cens == T & length(dat.cens) == 0){
      stop ('There are no censored observations')
    } else(pl)
 
    pl <- if(back.white == T) {pl + theme_bw()
    } else (pl)
    pl
  }
 
  ggsurv.m <- function(s, CI = 'def', plot.cens = T, surv.col = 'gg.def',
                       cens.col = 'red', lty.est = 1, lty.ci = 2,
                       cens.shape = 3, back.white = F, xlab = 'Time',
                       ylab = 'Survival', main = '') {
    n <- s$strata
 
    groups <- factor(unlist(strsplit(names
                                     (s$strata), '='))[seq(2, 2*strata, by = 2)])
    gr.name <-  unlist(strsplit(names(s$strata), '='))[1]
    gr.df <- vector('list', strata)
    ind <- vector('list', strata)
    n.ind <- c(0,n); n.ind <- cumsum(n.ind)
    for(i in 1:strata) ind[[i]] <- (n.ind[i]+1):n.ind[i+1]
 
    for(i in 1:strata){
      gr.df[[i]] <- data.frame(
        time = c(0, s$time[ ind[[i]] ]),
        surv = c(1, s$surv[ ind[[i]] ]),
        up = c(1, s$upper[ ind[[i]] ]),
        low = c(1, s$lower[ ind[[i]] ]),
        cens = c(0, s$n.censor[ ind[[i]] ]),
        group = rep(groups[i], n[i] + 1))
    }
 
    dat <- do.call(rbind, gr.df)
    dat.cens <- subset(dat, cens != 0)
 
    pl <- ggplot(dat, aes(x = time, y = surv, group = group)) +
      xlab(xlab) + ylab(ylab) + ggtitle(main) +
      geom_step(aes(col = group, lty = group))
 
    col <- if(length(surv.col == 1)){
      scale_colour_manual(name = gr.name, values = rep(surv.col, strata))
    } else{
      scale_colour_manual(name = gr.name, values = surv.col)
    }
 
    pl <- if(surv.col[1] != 'gg.def'){
      pl + col
    } else {pl + scale_colour_discrete(name = gr.name)}
 
    line <- if(length(lty.est) == 1){
      scale_linetype_manual(name = gr.name, values = rep(lty.est, strata))
    } else {scale_linetype_manual(name = gr.name, values = lty.est)}
 
    pl <- pl + line
 
    pl <- if(CI == T) {
      if(length(surv.col) > 1 && length(lty.est) > 1){
        stop('Either surv.col or lty.est should be of length 1 in order
             to plot 95% CI with multiple strata')
      }else if((length(surv.col) > 1 | surv.col == 'gg.def')[1]){
        pl + geom_step(aes(y = up, color = group), lty = lty.ci) +
          geom_step(aes(y = low, color = group), lty = lty.ci)
      } else{pl +  geom_step(aes(y = up, lty = group), col = surv.col) +
               geom_step(aes(y = low,lty = group), col = surv.col)}
    } else {pl}
 
 
    pl <- if(plot.cens == T & length(dat.cens) > 0){
      pl + geom_point(data = dat.cens, aes(y = surv), shape = cens.shape,
                      col = cens.col)
    } else if (plot.cens == T & length(dat.cens) == 0){
      stop ('There are no censored observations')
    } else(pl)
 
    pl <- if(back.white == T) {pl + theme_bw()
    } else (pl)
    pl
  }
  pl <- if(strata == 1) {ggsurv.s(s, CI , plot.cens, surv.col ,
                                  cens.col, lty.est, lty.ci,
                                  cens.shape, back.white, xlab,
                                  ylab, main)
  } else {ggsurv.m(s, CI, plot.cens, surv.col ,
                   cens.col, lty.est, lty.ci,
                   cens.shape, back.white, xlab,
                   ylab, main)}
  pl
}")
R.eval("saveWidgetFix <- function (widget,file,...) {
  ## A wrapper to saveWidget which compensates for arguable BUG in
  ## saveWidget which requires `file` to be in current working
  ## directory.
  wd<-getwd()
  on.exit(setwd(wd))
  outDir<-dirname(file)
  file<-basename(file)
  setwd(outDir);
  saveWidget(widget,file=file,...)
}")
R.eval("names1 <- as.vector(dt$V3[1])")
R.eval("log_rank <-survival::survdiff(Surv(TUfin$V11, TUfin$V12) ~ TUfin$V2, data=TUfin)")
R.eval('z <-ggsurv1(cox_fit,  main = paste("Cox Hazards Regression for",names1)) +  theme_bw() + ggplot2::geom_text(aes(label = sprintf("log-rank test p-value: %0.2g",pchisq(log_rank$chisq, df = 1, lower.tail = F)),x = 2000, y = 0.9))')
R.eval("o <-plotly::ggplotly(z)")
R.eval('htmlwidgets::saveWidget(as_widget(o), "coxph.html")')
  redirect_to('/coxph.html')
  File.delete('app/assets/data.csv')
else
  redirect_to(:back, notice: " Sorry. You are too quick for me! Something went wrong. Please try your request again")
end
end

def runRkaplansingle
  if File.exist?('public/kaplanmeier.html')
File.delete('app/public/kaplanmeier.html')
end
if File.exist?('public/KM_data.csv')
File.delete('app/public/KM_data.csv')
end
if File.exist?('app/assets/data.csv')
R.eval("library(data.table)")
R.eval("library(survival)")
R.eval("library(ggplot2)")
R.eval("library(dplyr)")
R.eval("library(ggfortify)")
R.eval("library(plotly)")
R.eval("library(twitteR)")
R.eval("library(RColorBrewer)")
R.eval("library(Ckmeans.1d.dp)")
R.eval("data <- read.table('app/assets/data.csv', header = FALSE, sep=',')")
R.eval("dt <- as.data.table(data)")
R.eval("TU <- dt[!data$V1 %like% '-N$']")
#R.eval("TUin <- TU[!TU$V11 %like% '-1']")
R.eval("TUfin <- TU[!TU$V12 %like% '0$']")
R.eval("x <- c(TUfin$V2)")
R.eval("TPM <- as.numeric(unlist(x))")
R.eval("result <- Ckmeans.1d.dp(TPM)")
R.eval("k <- max(result$cluster)")
R.eval("dat = TUfin[,c(2)]")
R.eval("km1 = kmeans(dat, k)")
R.eval("TUfin$cluster <- km1$cluster")

R.eval("km <-survfit(Surv(TUfin$V11, TUfin$V12) ~ TUfin$cluster, data=TUfin)")
#R.eval('a <- plot_ly(TUfin,y=TUfin,x=TUfin$V2, mode = "marker",type= "scatter",
#        showlegend = FALSE,
 #       hoverinfo = "text+x",
  #      text = ~TUfin$V1,
   #     marker = list(opacity = 1,
    #                  color = TUfin$cluster,
     #                 size = 12,
#                      line = list(color = "#262626", width = 1)))')



R.eval("ggsurv1 <- function(s, CI = 'def', plot.cens = T, surv.col = 'gg.def',
                   cens.col = 'red', lty.est = 1, lty.ci = 2,
                   cens.shape = 3, back.white = F, xlab = 'Time',
                   ylab = 'Survival', main = ''){
 
  library(ggplot2)
  strata <- ifelse(is.null(s$strata) ==T, 1, length(s$strata))
  stopifnot(length(surv.col) == 1 | length(surv.col) == strata)
  stopifnot(length(lty.est) == 1 | length(lty.est) == strata)
 
  ggsurv.s <- function(s, CI = 'def', plot.cens = T, surv.col = 'gg.def',
                       cens.col = 'red', lty.est = 1, lty.ci = 2,
                       cens.shape = 3, back.white = F, xlab = 'Time',
                       ylab = 'Survival', main = ''){
 
    dat <- data.frame(time = c(0, s$time),
                      surv = c(1, s$surv),
                      up = c(1, s$upper),
                      low = c(1, s$lower),
                      cens = c(0, s$n.censor))
    dat.cens <- subset(dat, cens != 0)
 
    col <- ifelse(surv.col == 'gg.def', 'black', surv.col)
 
    pl <- ggplot(dat, aes(x = time, y = surv)) +
      xlab(xlab) + ylab(ylab) + ggtitle(main) +
      geom_step(col = col, lty = lty.est)
 
    pl <- if(CI == T | CI == 'def') {
      pl + geom_step(aes(y = up), color = col, lty = lty.ci) +
        geom_step(aes(y = low), color = col, lty = lty.ci)
    } else (pl)
 
    pl <- if(plot.cens == T & length(dat.cens) > 0){
      pl + geom_point(data = dat.cens, aes(y = surv), shape = cens.shape,
                       col = cens.col)
    } else if (plot.cens == T & length(dat.cens) == 0){
      stop ('There are no censored observations')
    } else(pl)
 
    pl <- if(back.white == T) {pl + theme_bw()
    } else (pl)
    pl
  }
 
  ggsurv.m <- function(s, CI = 'def', plot.cens = T, surv.col = 'gg.def',
                       cens.col = 'red', lty.est = 1, lty.ci = 2,
                       cens.shape = 3, back.white = F, xlab = 'Time',
                       ylab = 'Survival', main = '') {
    n <- s$strata
 
    groups <- factor(unlist(strsplit(names
                                     (s$strata), '='))[seq(2, 2*strata, by = 2)])
    gr.name <-  unlist(strsplit(names(s$strata), '='))[1]
    gr.df <- vector('list', strata)
    ind <- vector('list', strata)
    n.ind <- c(0,n); n.ind <- cumsum(n.ind)
    for(i in 1:strata) ind[[i]] <- (n.ind[i]+1):n.ind[i+1]
 
    for(i in 1:strata){
      gr.df[[i]] <- data.frame(
        time = c(0, s$time[ ind[[i]] ]),
        surv = c(1, s$surv[ ind[[i]] ]),
        up = c(1, s$upper[ ind[[i]] ]),
        low = c(1, s$lower[ ind[[i]] ]),
        cens = c(0, s$n.censor[ ind[[i]] ]),
        group = rep(groups[i], n[i] + 1))
    }
 
    dat <- do.call(rbind, gr.df)
    dat.cens <- subset(dat, cens != 0)
 
    pl <- ggplot(dat, aes(x = time, y = surv, group = group)) +
      xlab(xlab) + ylab(ylab) + ggtitle(main) +
      geom_step(aes(col = group, lty = group))
 
    col <- if(length(surv.col == 1)){
      scale_colour_manual(name = gr.name, values = rep(surv.col, strata))
    } else{
      scale_colour_manual(name = gr.name, values = surv.col)
    }
 
    pl <- if(surv.col[1] != 'gg.def'){
      pl + col
    } else {pl + scale_colour_discrete(name = gr.name)}
 
    line <- if(length(lty.est) == 1){
      scale_linetype_manual(name = gr.name, values = rep(lty.est, strata))
    } else {scale_linetype_manual(name = gr.name, values = lty.est)}
 
    pl <- pl + line
 
    pl <- if(CI == T) {
      if(length(surv.col) > 1 && length(lty.est) > 1){
        stop('Either surv.col or lty.est should be of length 1 in order
             to plot 95% CI with multiple strata')
      }else if((length(surv.col) > 1 | surv.col == 'gg.def')[1]){
        pl + geom_step(aes(y = up, color = group), lty = lty.ci) +
          geom_step(aes(y = low, color = group), lty = lty.ci)
      } else{pl +  geom_step(aes(y = up, lty = group), col = surv.col) +
               geom_step(aes(y = low,lty = group), col = surv.col)}
    } else {pl}
 
 
    pl <- if(plot.cens == T & length(dat.cens) > 0){
      pl + geom_point(data = dat.cens, aes(y = surv), shape = cens.shape,
                      col = cens.col)
    } else if (plot.cens == T & length(dat.cens) == 0){
      stop ('There are no censored observations')
    } else(pl)
 
    pl <- if(back.white == T) {pl + theme_bw()
    } else (pl)
    pl
  }
  pl <- if(strata == 1) {ggsurv.s(s, CI , plot.cens, surv.col ,
                                  cens.col, lty.est, lty.ci,
                                  cens.shape, back.white, xlab,
                                  ylab, main)
  } else {ggsurv.m(s, CI, plot.cens, surv.col ,
                   cens.col, lty.est, lty.ci,
                   cens.shape, back.white, xlab,
                   ylab, main)}
  pl
}")

R.eval("log_rank <- survival::survdiff(Surv(TUfin$V11, TUfin$V12) ~ TUfin$cluster, data=TUfin)")
R.eval("round_df <- function(x, digits) {
    # round all numeric variables
    # x: data frame 
    # digits: number of digits to round
    numeric_columns <- sapply(x, mode) == 'numeric'
    x[numeric_columns] <-  round(x[numeric_columns], digits)
    x}")

R.eval('p1 <-ggsurv1(km, main =  paste("Kmeans Clustering & Kaplan Meier Curve for ",TUfin$V3[1],".\n", k, " Optimal Cluster(s) with median(s)", 
          toString(round_df(result$centers,2)),"TPM")) + theme_bw() +  ggplot2::geom_text(aes(label = sprintf("log-rank test p-value: %0.2g", 
                                            pchisq(log_rank$chisq, df = 1, lower.tail = F)),
                          x = 2000, y = 0.9))')
R.eval('tr <-plotly::ggplotly(p1)%>%
   layout(hovermode = "closest",
          margin = list(r = 20, t = 70, b = 60, l = 60, pad = 1),titlefont = list(color = "rgb(2, 0, 1)", size = 22))')
                          
R.eval("setwd('/home/deploy/apps/diffexdb/current/public')")
R.eval('htmlwidgets::saveWidget(as_widget(tr), "kaplanmeier.html")')
R.eval('res <- summary(km)')
R.eval('save.df <- as.data.frame(res[c("strata", "time", "n.risk", "n.event", "surv", "std.err", "lower", "upper")])')
R.eval('write.csv(save.df, "public/KM_data.csv")')
#send_file("public/KM_data.csv", :disposition => 'attachment')
  redirect_to('/kaplanmeier.html',:target => "blank")
  File.delete('app/assets/data.csv')
else
  redirect_to(:back, notice: " Sorry. You are too quick for me! Something went wrong. Please try your request again")
end
end
def runRkaplansingle_file
  if File.exist?('public/kaplanmeier.html')
File.delete('app/public/kaplanmeier.html')
end
if File.exist?('public/KM_data.csv')
File.delete('app/public/KM_data.csv')
end
if File.exist?('app/assets/data.csv')
R.eval("library(data.table)")
R.eval("library(survival)")
R.eval("library(ggplot2)")
R.eval("library(dplyr)")
R.eval("library(ggfortify)")
R.eval("library(plotly)")
R.eval("library(twitteR)")
R.eval("library(RColorBrewer)")
R.eval("library(Ckmeans.1d.dp)")
R.eval("data <- read.table('app/assets/data.csv', header = FALSE, sep=',')")
R.eval("dt <- as.data.table(data)")
R.eval("TU <- dt[!data$V1 %like% '-N$']")
R.eval("TUfin <- TU[!TU$V11 %like% '-1$']")
#R.eval("TUfin <- TU[!TU$V12 %like% '0']")
R.eval("x <- c(TUfin$V2)")
R.eval("TPM <- as.numeric(unlist(x))")
R.eval("result <- Ckmeans.1d.dp(TPM)")
R.eval("k <- max(result$cluster)")
R.eval("dat = TUfin[,c(2)]")
R.eval("km1 = kmeans(dat, k)")
R.eval("TUfin$cluster <- km1$cluster")

R.eval("km <-survfit(Surv(TUfin$V12, TUfin$V11) ~ TUfin$cluster, data=TUfin)")
R.eval('a <- plot_ly(TUfin,x=TUfin$V2, mode = "marker",type= "scatter",
        showlegend = FALSE,
        hoverinfo = "text+x",
        text = ~TUfin$V1,
        marker = list(opacity = 1,
                      color = TUfin$cluster,
                      size = 12,
                      line = list(color = "#262626", width = 1)))%>%

  layout(hovermode = "closest",
         showlegend = F,
         margin = list(r = 20, t = 60, b = 60, l = 60, pad = 1),
         paper_bgcolor = "",
         title = paste("Kmeans Clustering for",TUfin$V3[1], "Univariate cluster algorithm found",k, "optimal clusters"),
         titlefont = list(color = "rgb(2, 0, 1)", size = 20),xaxis = list(
           gridcolor = "rgb(255, 255, 255)",
           tickfont = list(color = "rgb(255, 255, 255)"),
           title = "TPM",
           titlefont = list(color = "rgb(2, 0, 1)")),

         yaxis = list(
           gridcolor = "rgb(255, 255, 255)",
           tickfont = list(color = "rgb(255, 255, 255)"),
           title = "Sample Number",
           titlefont = list(color = "rgb(2, 0, 1)")))')



R.eval("ggsurv <- function(s, CI = 'def', plot.cens = T, surv.col = 'gg.def',
                   cens.col = 'red', lty.est = 1, lty.ci = 2,
                   cens.shape = 3, back.white = F, xlab = 'Time',
                   ylab = 'Survival', main = ''){
 
  library(ggplot2)
  strata <- ifelse(is.null(s$strata) ==T, 1, length(s$strata))
  stopifnot(length(surv.col) == 1 | length(surv.col) == strata)
  stopifnot(length(lty.est) == 1 | length(lty.est) == strata)
 
  ggsurv.s <- function(s, CI = 'def', plot.cens = T, surv.col = 'gg.def',
                       cens.col = 'red', lty.est = 1, lty.ci = 2,
                       cens.shape = 3, back.white = F, xlab = 'Time',
                       ylab = 'Survival', main = ''){
 
    dat <- data.frame(time = c(0, s$time),
                      surv = c(1, s$surv),
                      up = c(1, s$upper),
                      low = c(1, s$lower),
                      cens = c(0, s$n.censor))
    dat.cens <- subset(dat, cens != 0)
 
    col <- ifelse(surv.col == 'gg.def', 'black', surv.col)
 
    pl <- ggplot(dat, aes(x = time, y = surv)) +
      xlab(xlab) + ylab(ylab) + ggtitle(main) +
      geom_step(col = col, lty = lty.est)
 
    pl <- if(CI == T | CI == 'def') {
      pl + geom_step(aes(y = up), color = col, lty = lty.ci) +
        geom_step(aes(y = low), color = col, lty = lty.ci)
    } else (pl)
 
    pl <- if(plot.cens == T & length(dat.cens) > 0){
      pl + geom_point(data = dat.cens, aes(y = surv), shape = cens.shape,
                       col = cens.col)
    } else if (plot.cens == T & length(dat.cens) == 0){
      stop ('There are no censored observations')
    } else(pl)
 
    pl <- if(back.white == T) {pl + theme_bw()
    } else (pl)
    pl
  }
 
  ggsurv.m <- function(s, CI = 'def', plot.cens = T, surv.col = 'gg.def',
                       cens.col = 'red', lty.est = 1, lty.ci = 2,
                       cens.shape = 3, back.white = F, xlab = 'Time',
                       ylab = 'Survival', main = '') {
    n <- s$strata
 
    groups <- factor(unlist(strsplit(names
                                     (s$strata), '='))[seq(2, 2*strata, by = 2)])
    gr.name <-  unlist(strsplit(names(s$strata), '='))[1]
    gr.df <- vector('list', strata)
    ind <- vector('list', strata)
    n.ind <- c(0,n); n.ind <- cumsum(n.ind)
    for(i in 1:strata) ind[[i]] <- (n.ind[i]+1):n.ind[i+1]
 
    for(i in 1:strata){
      gr.df[[i]] <- data.frame(
        time = c(0, s$time[ ind[[i]] ]),
        surv = c(1, s$surv[ ind[[i]] ]),
        up = c(1, s$upper[ ind[[i]] ]),
        low = c(1, s$lower[ ind[[i]] ]),
        cens = c(0, s$n.censor[ ind[[i]] ]),
        group = rep(groups[i], n[i] + 1))
    }
 
    dat <- do.call(rbind, gr.df)
    dat.cens <- subset(dat, cens != 0)
 
    pl <- ggplot(dat, aes(x = time, y = surv, group = group)) +
      xlab(xlab) + ylab(ylab) + ggtitle(main) +
      geom_step(aes(col = group, lty = group))
 
    col <- if(length(surv.col == 1)){
      scale_colour_manual(name = gr.name, values = rep(surv.col, strata))
    } else{
      scale_colour_manual(name = gr.name, values = surv.col)
    }
 
    pl <- if(surv.col[1] != 'gg.def'){
      pl + col
    } else {pl + scale_colour_discrete(name = gr.name)}
 
    line <- if(length(lty.est) == 1){
      scale_linetype_manual(name = gr.name, values = rep(lty.est, strata))
    } else {scale_linetype_manual(name = gr.name, values = lty.est)}
 
    pl <- pl + line
 
    pl <- if(CI == T) {
      if(length(surv.col) > 1 && length(lty.est) > 1){
        stop('Either surv.col or lty.est should be of length 1 in order
             to plot 95% CI with multiple strata')
      }else if((length(surv.col) > 1 | surv.col == 'gg.def')[1]){
        pl + geom_step(aes(y = up, color = group), lty = lty.ci) +
          geom_step(aes(y = low, color = group), lty = lty.ci)
      } else{pl +  geom_step(aes(y = up, lty = group), col = surv.col) +
               geom_step(aes(y = low,lty = group), col = surv.col)}
    } else {pl}
 
 
    pl <- if(plot.cens == T & length(dat.cens) > 0){
      pl + geom_point(data = dat.cens, aes(y = surv), shape = cens.shape,
                      col = cens.col)
    } else if (plot.cens == T & length(dat.cens) == 0){
      stop ('There are no censored observations')
    } else(pl)
 
    pl <- if(back.white == T) {pl + theme_bw()
    } else (pl)
    pl
  }
  pl <- if(strata == 1) {ggsurv.s(s, CI , plot.cens, surv.col ,
                                  cens.col, lty.est, lty.ci,
                                  cens.shape, back.white, xlab,
                                  ylab, main)
  } else {ggsurv.m(s, CI, plot.cens, surv.col ,
                   cens.col, lty.est, lty.ci,
                   cens.shape, back.white, xlab,
                   ylab, main)}
  pl
}")

R.eval("log_rank <- survival::survdiff(Surv(TUfin$V7, TUfin$V6) ~ TUfin$cluster, data=TUfin)")
R.eval('p1 <-ggsurv(km, main = "Test") + theme_bw() +  ggplot2::geom_text(aes(label = sprintf("log-rank test p-value: %0.2g", 
                                            pchisq(log_rank$chisq, df = 1, lower.tail = F)),
                          x = 2000, y = 0.9))')
R.eval('tr <-plotly::ggplotly(p1)')
                          
R.eval('z <- subplot(a,tr)%>%
   layout(hovermode = "closest",
          margin = list(r = 20, t = 60, b = 60, l = 60, pad = 1),paper_bgcolor = "",title = paste("Kmeans Clustering & Kaplan Meier Curve for ",TUfin$V3[1],".\n", "Cluster medians", 
          format(round(min(result$centers), 2), nsmall = 2),"&",format(round(max(result$centers), 2), nsmall = 2),"TPM"),
          titlefont = list(color = "rgb(2, 0, 1)", size = 20),xaxis = list(
            gridcolor = "rgb(255, 255, 255)",
            tickfont = list(color = "rgb(2, 0, 1)"),
            title = "TPM",
            titlefont = list(color = "rgb(2, 0, 1)")),
          yaxis = list(
            gridcolor = "rgb(255, 255, 255)",
            tickfont = list(color = "rgb(2, 0, 1)"),
            title = "Sample Number",
            titlefont = list(color = "rgb(2, 0, 1)")),xaxis2 = list(
            gridcolor = "rgb(2, 0, 1)",
            tickfont = list(color = "rgb(2, 0, 1)"),
            title = "time",
            titlefont = list(color = "rgb(2, 0, 1)")),
          yaxis2 = list(
            gridcolor = "rgb(2, 0, 1)",
            tickfont = list(color = "rgb(2, 0, 1)"),
            title = "Survival",
            titlefont = list(color = "rgb(2, 0, 1)")),showlegend=FALSE)')
#R.eval('htmlwidgets::saveWidget(as_widget(z), "kaplanmeier.html")')
R.eval("setwd('/home/deploy/apps/diffexdb/current/public')")
R.eval('res <- summary(km)')
R.eval('save.df <- as.data.frame(res[c("strata", "time", "n.risk", "n.event", "surv", "std.err", "lower", "upper")])')
R.eval('write.csv(save.df, "public/KM_data.csv")')
send_file("public/KM_data.csv", :disposition => 'attachment')
  File.delete('app/assets/data.csv')
else
  redirect_to(:back, notice: " Sorry. You are too quick for me! Something went wrong. Please try your request again")
end
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_abundance
      @abundance = Abundance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def abundance_params
      params.require(:abundance).permit(:bcr_patient_barcode, :target_id, :length, :eff_length, :est_counts, :tpm,:notes, :flag)
    end
  end
