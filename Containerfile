FROM docker.io/rocker/r2u:22.04

ENV S6_VERSION=v2.1.0.2
ENV RSTUDIO_VERSION=2023.12.0+369
ENV DEFAULT_USER=rstudio
ENV PANDOC_VERSION=default

COPY container-scripts/rocker_scripts /rocker_scripts
COPY container-scripts/custom_scripts /custom_scripts

RUN /rocker_scripts/install_rstudio.sh
RUN /rocker_scripts/install_pandoc.sh
RUN install2.r "targets" "tarchetypes" "visNetwork"

RUN /custom_scripts/install_stan.sh

RUN install2.r --error --skipinstalled posterior loo bayesplot tidybayes
RUN install2.r --error --skipinstalled brms
RUN install2.r --error --skipinstalled lavaan
RUN install2.r --error --skipinstalled flextable
#RUN installGithub.r --deps FALSE --update FALSE \
#   hugomell/osf-heloise-young-fragile-family

RUN install2.r --error --skipinstalled devtools

WORKDIR /home/root/project

RUN echo 'session-default-working-dir=/home/root/project' >> \
    /etc/rstudio/rsession.conf && \
    echo 'session-default-new-project-dir=/home/root/project' >> \
    /etc/rstudio/rsession.conf

EXPOSE 8787

CMD ["/init"]
