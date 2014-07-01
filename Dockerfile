###############################################################################
#
#
###############################################################################

FROM centos:centos6

MAINTAINER Jiri Matysek <jirimaty@gmail.com>

RUN yum -y update
RUN yum -y install binutils
RUN yum -y install compat-libstdc++-33.i686
RUN yum -y install compat-libstdc++-33.x86_64
RUN yum -y install elfutils-libelf
RUN yum -y install elfutils-libelf-devel
RUN yum -y install expat
RUN yum -y install gcc
RUN yum -y install gcc-c++
RUN yum -y install glibc.i686
RUN yum -y install glibc.x86_64
RUN yum -y install glibc-common
RUN yum -y install glibc-devel
RUN yum -y install glibc-headers
RUN yum -y install libaio.i686
RUN yum -y install libaio.x86_64
RUN yum -y install libaio-devel.i686
RUN yum -y install libaio-devel.x86_64
RUN yum -y install libgcc.i686
RUN yum -y install libgcc.x86_64
RUN yum -y install libstdc++.i686
RUN yum -y install libstdc++.x86_64
RUN yum -y install libstdc++-devel
RUN yum -y install make
RUN yum -y install numactl
#RUN yum -y install pdksh
RUN yum -y install mksh
RUN yum -y install sysstat

# ORACLE
RUN /usr/sbin/groupadd oinstall
RUN /usr/sbin/groupadd -g 502 dba
RUN /usr/sbin/groupadd -g 506 asmdba
RUN /usr/sbin/useradd -u 502 -g oinstall -G dba,asmdba oracle

###############################################################################
# Install java
###############################################################################
RUN cd root && curl -O http://10.101.10.155:8000/jdk-6u45-linux-x64.bin
RUN chmod 755 /root/jdk-6u45-linux-x64.bin
RUN cd /opt && sh /root/jdk-6u45-linux-x64.bin
ENV JAVA_HOME /opt/jdk1.6.0_45
ENV PATH $JAVA_HOME/bin:$PATH

###############################################################################
# Copy and unzip oracle instalation images
###############################################################################
RUN yum -y install unzip
RUN mkdir /u01
RUN chown oracle:oinstall /u01
USER oracle
RUN mkdir /home/oracle/install
RUN cd /home/oracle && curl -O http://10.101.10.155:8000/linux.x64_11gR2_database_1of2.zip
RUN cd /home/oracle && curl -O http://10.101.10.155:8000/linux.x64_11gR2_database_2of2.zip
RUN unzip /home/oracle/linux.x64_11gR2_database_1of2.zip -d /home/oracle/install
RUN unzip /home/oracle/linux.x64_11gR2_database_2of2.zip -d /home/oracle/install
ADD db_install.rsp /home/oracle/db_install.rsp
RUN mkdir -p /u01/app/oracle/product/11.2.0/dbhome_1
ENV ORACLE_BASE /u01/app/oracle
ENV ORACLE_HOME /u01/app/oracle/product/11.2.0/dbhome_1
RUN cd /home/oracle/install/database && ./runInstaller -silent -ignoreSysPrereqs -waitforcompletion -responseFile /home/oracle/db_install.rsp
