FROM php:7.2-apache

#install oci
# ENV LD_LIBRARY_PATH /usr/local/instantclient
# ENV ORACLE_HOME /usr/local/instantclient

ADD oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm /usr/local
ADD oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm /usr/local
ADD oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm /usr/local

RUN apt-get update -y
RUN apt-get install alien -y
RUN alien -i /usr/local/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
RUN alien -i /usr/local/oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm
RUN alien -i /usr/local/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm
RUN apt-get install libaio1 wget ca-certificates -y
RUN > /etc/ld.so.conf.d/oracle.conf && echo '/usr/lib/oracle/11.2/client64/lib' >> /etc/ld.so.conf.d/oracle.conf
RUN ldconfig
RUN export ORACLE_HOME=/usr/lib/oracle/11.2/client64/
ENV ORACLE_HOME /usr/lib/oracle/11.2/client64/
RUN wget https://pecl.php.net/get/oci8-2.2.0.tgz --no-check-certificate
RUN tar zxvf oci8-2.2.0.tgz
RUN cd oci8-2.2.0/ && \
    phpize && \
    ./configure --with-oci8=instantclient,/usr/lib/oracle/11.2/client64/lib && \
    make install

#Install the soap extension
RUN rm /etc/apt/preferences.d/no-debian-php

RUN apt-get update -y && \
    apt-get install -y libxml2-dev php-pear php-soap && \
    docker-php-ext-install soap

#install ldap
RUN apt-get update && \
    apt-get install libldap2-dev -y && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap

#install pdo_mysql
RUN docker-php-ext-install pdo_mysql

#install mysqli
RUN docker-php-ext-install mysqli

#install pgsql
RUN apt-get update && apt-get install -y libpq-dev && \
    docker-php-ext-install pdo pdo_pgsql

#install xdebug
RUN wget https://pecl.php.net/get/xdebug-2.7.2.tgz --no-check-certificate
RUN pecl install xdebug-2.7.2.tgz && docker-php-ext-enable xdebug