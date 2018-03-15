FROM rocker/shiny

MAINTAINER Tobias Verbeke "tobias.verbeke@openanalytics.eu"

# system libraries of general use
RUN apt-get update && apt-get install -y \
	nano \
	libssl-dev \
	libcurl4-openssl-dev \
        sudo \
        pandoc \
        pandoc-citeproc \
        libcairo2-dev \
        libxt-dev \
        libssl-dev \
        libssh2-1-dev \
	libpq-dev
	
        


# basic shiny functionality
RUN Rscript -e "install.packages(c('shinydashboard'), repos='https://cloud.r-project.org/')"

COPY app.R /shiny/app.R
CMD ["R", "-e shiny::runApp('/shiny/app.R',host='0.0.0.0',port=3838)"]
