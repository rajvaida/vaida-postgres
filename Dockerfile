#
# CentOS 7 Dockerfile
#

# Build:
# docker build -t zokeber/centos:latest .

# Create:
# docker create -it --name centos -h centos zokeber/centos

# Start:
# docker start centos

# Connect with bash
# docker exec -it centos bash

# Pull base image
FROM centos:latest

# Maintener
MAINTAINER Raj Vaida <raja.vaida@gmail.com>

# Update CentOS 7
RUN yum update -y && yum upgrade -y

# Install packages
RUN yum install -y unzip wget curl git

# Install EPEL Repository
RUN yum install -y epel-release

# Clean CentOS 7
RUN yum clean all

# Set the environment variables
ENV HOME /root

# Working directory
WORKDIR /root

# Default command
CMD ["bash"]

COPY data/CIS_Hardening.sh /usr/local/bin/CIS_Hardening.sh
RUN chmod +x /usr/local/bin/CIS_Hardening.sh
CMD ["/bin/bash", "/usr/local/bin/CIS_Hardening.sh"]


# Postgresql version
ENV PG_VERSION 9.4
ENV PGVERSION 94

# Set the environment variables
ENV HOME /var/lib/pgsql
ENV PGDATA /var/lib/pgsql/9.4/data

# Install postgresql and run InitDB
RUN rpm -vih https://download.postgresql.org/pub/repos/yum/$PG_VERSION/redhat/rhel-7-x86_64/pgdg-centos$PGVERSION-$PG_VERSION-2.noarch.rpm && \
    yum update -y && \
    yum install -y sudo \
    pwgen \
    postgresql$PGVERSION \
    postgresql$PGVERSION-server \
    postgresql$PGVERSION-contrib && \
    yum clean all

# Copy
COPY data/postgresql-setup /usr/pgsql-$PG_VERSION/bin/postgresql$PGVERSION-setup

# Working directory
WORKDIR /var/lib/pgsql

# Run initdb
RUN /usr/pgsql-$PG_VERSION/bin/postgresql$PGVERSION-setup initdb

# Copy config file
COPY data/postgresql.conf /var/lib/pgsql/$PG_VERSION/data/postgresql.conf
COPY data/pg_hba.conf /var/lib/pgsql/$PG_VERSION/data/pg_hba.conf
COPY data/postgresql.sh /usr/local/bin/postgresql.sh
COPY data/baseTable.sql /usr/local/bin/baseTable.sql

# Change own user
RUN chown -R postgres:postgres /var/lib/pgsql/$PG_VERSION/data/* && \
    usermod -G wheel postgres && \
    sed -i 's/.*requiretty$/#Defaults requiretty/' /etc/sudoers && \
    chmod +x /usr/local/bin/postgresql.sh

# Set volume
VOLUME ["/var/lib/pgsql"]

# Set username
USER postgres

# Run PostgreSQL Server
CMD ["/bin/bash", "/usr/local/bin/postgresql.sh"]

# Expose ports.
EXPOSE 5432
