FROM centos:latest

# Update CentOS 7
RUN yum update -y && yum upgrade -y

# Install packages
RUN yum install -y unzip wget

# Install EPEL Repository
RUN yum install -y epel-release

# Clean CentOS 7
RUN yum clean all

# Set the environment variables
ENV HOME /root

# Working directory
WORKDIR /root

#Hardening
COPY data/CIS_Hardening.sh /usr/local/bin/CIS_Hardening.sh
RUN chmod +x /usr/local/bin/CIS_Hardening.sh
CMD ["/bin/bash", "/usr/local/bin/CIS_Hardening.sh"]



# Default command
CMD ["bash"]



# Set the environment variables
ENV HOME /var/lib/pgsql
ENV PGDATA /var/lib/pgsql/9.6/data

# Install postgresql and run InitDB
RUN rpm -vih https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm && \
    yum update -y && \
    yum install -y sudo \
    pwgen \
    postgresql96 \
    postgresql96-server \
    postgresql96-contrib && \
    yum clean all

# Copy
COPY data/postgresql-setup /usr/pgsql-9.6/bin/postgresql96-setup

# Working directory
WORKDIR /var/lib/pgsql

# Run initdb
RUN chmod +x /usr/pgsql-9.6/bin/postgresql96-setup
CMD ["/bin/bash", "/usr/pgsql-9.6/bin/postgresql96-setup initdb"]

# Copy config file
COPY data/postgresql.conf /var/lib/pgsql/9.6/data/postgresql.conf
COPY data/pg_hba.conf /var/lib/pgsql/9.6/data/pg_hba.conf
COPY data/postgresql.sh /usr/local/bin/postgresql.sh
COPY data/baseTable.sql /usr/local/bin/baseTable.sql

# Change own user
RUN chown -R postgres:postgres /var/lib/pgsql/9.6/data/* && \
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