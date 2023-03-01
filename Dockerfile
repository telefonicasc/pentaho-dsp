# Copyright 2020 Telefónica Soluciones de Informática y Comunicaciones de España, S.A.U.
#
# This file is part of Pentaho DSP.
#
# Pentaho DSP is free software: you can redistribute it and/or
# modify it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Pentaho DSP is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero
# General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Orion Context Broker. If not, see http://www.gnu.org/licenses/.
#
# For those usages not covered by this license please contact with
# sc_support at telefonica dot com

FROM openjdk:11-jdk-slim

MAINTAINER telefonica

# Install dependencies.
#
# - postgresql-client to install schema in postgres servers
# - git and xsltproc to support building tools
# - wget, build-essential et al to build apr, tomcat-native, etc
#
# Add pentaho user and group
#
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      postgresql-client git xsltproc \
      wget build-essential openssl unzip libssl-dev \
      libfreetype6 fontconfig && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    groupadd -g 1000 pentaho && \
    useradd  -g pentaho -u 1000 -m pentaho && \
    mkdir /opt/scratch && \
    chown pentaho:pentaho /opt/scratch

# Get this version from https://apr.apache.org/download.cgi
ENV APR_VERSION 1.7.2
RUN cd /tmp && \
    DEBIAN_FRONTEND=noninteractive wget "https://dlcdn.apache.org/apr/apr-${APR_VERSION}.tar.bz2" && \
    tar -xjvf "apr-${APR_VERSION}.tar.bz2" && \
    cd "apr-${APR_VERSION}" && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    rm -rf /tmp/*

# Get this version from https://tomcat.apache.org/download-native.cgi
ENV TCN_VERSION 1.2.36
RUN cd /tmp && \
    DEBIAN_FRONTEND=noninteractive wget "https://dlcdn.apache.org/tomcat/tomcat-connectors/native/${TCN_VERSION}/source/tomcat-native-${TCN_VERSION}-src.tar.gz" && \
    tar -xzvf "tomcat-native-${TCN_VERSION}-src.tar.gz" && \
    cd "tomcat-native-${TCN_VERSION}-src/native" && \
    ./configure --prefix=/usr --with-apr=/usr \
        --with-java-home=$JAVA_HOME && \
    make && \
    make install && \
    rm -rf /tmp/*

# C3P0 connection pool from  https://sourceforge.net/projects/c3p0/
ENV C3P0_VERSION 0.9.5.5
RUN cd /tmp && \
    DEBIAN_FRONTEND=noninteractive wget "https://sourceforge.net/projects/c3p0/files/c3p0-bin/c3p0-${C3P0_VERSION}/c3p0-${C3P0_VERSION}.bin.tgz/download" && \
    mv download "c3p0-${C3P0_VERSION}.tgz" && \
    tar -xzvf "c3p0-${C3P0_VERSION}.tgz" && \
    mv c3p0-${C3P0_VERSION}/lib/* /usr/local/lib && \
    rm -rf /tmp/*

# Get this version from https://logging.apache.org/log4j/
ENV LOG4J_EXTRAS_VERSION 1.2.17
RUN cd /tmp && \
    DEBIAN_FRONTEND=noninteractive wget "http://dlcdn.apache.org/logging/log4j/extras/${LOG4J_EXTRAS_VERSION}/apache-log4j-extras-${LOG4J_EXTRAS_VERSION}-bin.tar.gz" && \
    tar -xzvf "apache-log4j-extras-${LOG4J_EXTRAS_VERSION}-bin.tar.gz" && \
    mv "apache-log4j-extras-${LOG4J_EXTRAS_VERSION}/apache-log4j-extras-${LOG4J_EXTRAS_VERSION}.jar" /usr/local/lib && \
    rm -rf /tmp/*

# Get this version from https://dev.mysql.com/downloads/connector/j/
# Pentaho 8 is compatible with mysql connector 5 only
# ENV MYSQL_CONN_VERSION 8.0.31
ENV MYSQL_CONN_VERSION 5.1.49
RUN cd /tmp && \
    DEBIAN_FRONTEND=noninteractive wget "https://downloads.mysql.com/archives/get/p/3/file/mysql-connector-java-${MYSQL_CONN_VERSION}.tar.gz" && \
    tar -xzvf "mysql-connector-java-${MYSQL_CONN_VERSION}.tar.gz" && \
    mv "mysql-connector-java-${MYSQL_CONN_VERSION}/mysql-connector-java-${MYSQL_CONN_VERSION}.jar" /usr/local/lib && \
    rm -rf /tmp/*

# Get this version from https://jdbc.postgresql.org/download/
ENV PGSQL_CONN_VERSION 42.5.2
RUN cd /tmp && \
    DEBIAN_FRONTEND=noninteractive wget "https://jdbc.postgresql.org/download/postgresql-${PGSQL_CONN_VERSION}.jar" && \
    mv "postgresql-${PGSQL_CONN_VERSION}.jar" /usr/local/lib

# Set environment variables for Pentaho
ENV JAVA_VERSION 11
ENV PENTAHO_JAVA_HOME "/usr/local/openjdk-11"
ENV PENTAHO_JAVA "/usr/local/openjdk-11/bin/java"

# Add tini
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# Pentaho must be downloaded, uncompressed and mounted as a volume in the path /opt/biserver-ce.
#
# Pentaho can be downloaded from:
# http://downloads.sourceforge.net/project/pentaho/Business Intelligence Server/${PENTAHO_MAJOR}/biserver-ce-${PENTAHO_MINOR}.zip

VOLUME  /opt/pentaho-server
WORKDIR /opt/pentaho-server
ENV PENTAHO_HOME "/opt/pentaho-server"
ENV PGPASSFILE   "/tmp/.pgpass"

# If this instance is to be run behind a proxy, the proxy port and
# scheme must be given as environment variables, e.g.
ENV PENTAHO_PORT 8080
ENV PROXY_PORT 8080
ENV PROXY_SCHEME http

# Configuration files from Pentaho 9.4
ADD files /opt/
RUN find /opt -type f -iname "*.sh" -exec chmod a+x {} \;

# Add config hooks to /opt
ADD hooks /opt/hooks/
RUN chmod a+r /opt/hooks/* && chmod a+rx /opt/hooks/*.sh && chmod a+rx /opt/*.sh

USER pentaho
# Add source code to /home/pentaho
ADD src /home/pentaho/src

EXPOSE 8080
CMD "/opt/start.sh"
