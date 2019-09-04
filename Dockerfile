FROM php:7.2-apache

#install oci
ENV LD_LIBRARY_PATH /usr/local/instantclient
ENV ORACLE_HOME /usr/local/instantclient

ADD instantclient-sdk-linux.x64-11.2.0.4.0.tar.gz /usr/local
ADD instantclient-sqlplus-linux.x64-11.2.0.4.0.tar.gz /usr/local
ADD instantclient-basic-linux.x64-11.2.0.4.0.tar.gz /usr/local

RUN apt-get update -y
RUN apt-get install libaio1 -y
RUN ln -s /usr/local/instantclient_11_2 ${ORACLE_HOME}
RUN ln -s ${ORACLE_HOME}/libclntsh.so.* ${ORACLE_HOME}/libclntsh.so
RUN ln -s ${ORACLE_HOME}/libocci.so.* ${ORACLE_HOME}/libocci.so
RUN ln -s ${ORACLE_HOME}/lib* /usr/lib
RUN ln -s ${ORACLE_HOME}/sqlplus /usr/bin/sqlplus
RUN ln -s /usr/lib/libnsl.so.2.0.0  /usr/lib/libnsl.so.1
RUN docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,${ORACLE_HOME}
RUN docker-php-ext-configure oci8 --with-oci8=instantclient,${ORACLE_HOME}
RUN echo 'instantclient,${ORACLE_HOME}' | pecl install oci8 
RUN docker-php-ext-install pdo_oci
RUN docker-php-ext-enable oci8
RUN rm -rf /tmp/*.zip /var/cache/apt/* /tmp/pear

# ADD oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm /usr/local
# ADD oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm /usr/local
# ADD oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm /usr/local

# RUN apt-get update -y
# RUN apt-get install alien -y
# RUN alien -i /usr/local/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
# RUN alien -i /usr/local/oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm
# RUN alien -i /usr/local/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm
# RUN apt-get install libaio1 -y
# RUN > /etc/ld.so.conf.d/oracle.conf && echo '/usr/lib/oracle/11.2/client64/lib' >> /etc/ld.so.conf.d/oracle.conf
# RUN ldconfig
# RUN export ORACLE_HOME=/usr/lib/oracle/11.2/client64/
# #RUN pear clear-cache
# RUN pear update-channels
# RUN pear upgrade
# RUN pecl download OCI8


# #install xdebug
# RUN pecl install xdebug && docker-php-ext-enable xdebug

# #Install the soap extension
# RUN rm /etc/apt/preferences.d/no-debian-php

# RUN apt-get update -y && \
#     apt-get install -y libxml2-dev php-pear php-soap && \
#     docker-php-ext-install soap && docker-php-ext-enable soap

# #install ldap
# RUN apt-get update && \
#     apt-get install libldap2-dev -y && \
#     rm -rf /var/lib/apt/lists/* && \
#     docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
#     docker-php-ext-install ldap && docker-php-ext-enable ldap

# #install pdo_mysql
# RUN docker-php-ext-install pdo_mysql && docker-php-ext-enable pdo_mysql

# #install mysqli
# RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

# #install pgsql
# RUN apt-get update && apt-get install -y libpq-dev && \
#     docker-php-ext-install pdo pdo_pgsql && docker-php-ext-enable pdo pdo_pgsql