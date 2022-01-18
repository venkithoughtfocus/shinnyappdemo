# Example shiny app docker file

# get shiny serveR and a version of R from the rocker project
FROM rocker/shiny:4.0.5

# system libraries
# Try to only install system libraries you actually need
# Package Manager is a good resource to help discover system deps
RUN apt-get update && apt-get install -y \
    libcurl4-gnutls-dev \
    libssl-dev
  

# install R packages required 
# Change the packages list to suit your needs
RUN R -e 'install.packages(c(\
              "shiny", \
              "shinydashboard", \
              "ggplot2" \
            ), \
            repos="https://packagemanager.rstudio.com/cran/__linux__/focal/2021-04-23"\
          )' && \
     cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
     chown shiny:shiny /var/lib/shiny-server

EXPOSE 80

COPY shiny-server.sh /usr/bin/shiny-server.sh

COPY shiny-customized.config /etc/shiny-server/shiny-server.conf

RUN chmod a+x /usr/bin/shiny-server.sh
chown -R shiny:shiny /srv/shiny-server/

# copy the app directory into the image
COPY ./shiny-app/* /srv/shiny-server/

# run app
CMD ["/usr/bin/shiny-server"]
