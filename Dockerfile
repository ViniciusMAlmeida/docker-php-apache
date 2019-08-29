FROM php:7.2-apache

#install oci
ENV LD_LIBRARY_PATH /usr/local/instantclient
ENV ORACLE_HOME /usr/local/instantclient

ADD instantclient-sdk-linux.x64-11.2.0.4.0.tar.gz /usr/local
ADD instantclient-sqlplus-linux.x64-11.2.0.4.0.tar.gz /usr/local
ADD instantclient-basic-linux.x64-11.2.0.4.0.tar.gz /usr/local

RUN apt-get update -y
#RUN apt-get install make php7-pear php7-dev gcc musl-dev libnsl libaio
RUN ln -s /usr/local/instantclient_11_2 ${ORACLE_HOME}
RUN ln -s ${ORACLE_HOME}/libclntsh.so.* ${ORACLE_HOME}/libclntsh.so
RUN ln -s ${ORACLE_HOME}/libocci.so.* ${ORACLE_HOME}/libocci.so
RUN ln -s ${ORACLE_HOME}/lib* /usr/lib
RUN ln -s ${ORACLE_HOME}/sqlplus /usr/bin/sqlplus
RUN ln -s /usr/lib/libnsl.so.2.0.0  /usr/lib/libnsl.so.1
RUN docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,${ORACLE_HOME} 
RUN echo 'instantclient,${ORACLE_HOME}' | pecl install oci8 
RUN docker-php-ext-install pdo_oci
RUN docker-php-ext-enable oci8
#RUN apt del php7-pear php7-dev gcc musl-dev 
RUN rm -rf /tmp/*.zip /var/cache/apt/* /tmp/pear

#install soap
# RUN apt-get update -y \
#     && apt-get install -y \
#     libxml2-dev \
#     && apt-get clean -y \
#     docker-php-ext-install soap

#install xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

#Install the soap extension
RUN rm /etc/apt/preferences.d/no-debian-php

RUN apt-get update -y && \
    apt-get install -y libxml2-dev php-pear php-soap && \
    #apt-get clean -y && \
    docker-php-ext-install soap && docker-php-ext-enable soap