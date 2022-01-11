FROM centos:7
MAINTAINER Diep LM  <dieplm@vnpay.vn>

# Downloading Mod Gearman packages from Nagios 

ADD *.sh /
RUN yum install -y wget ; \
/download.sh

# Cleaning YUM - Without this gearman worker installation fails
RUN yum clean all 
#; rm -f /var/lib/rpm/__db* ; rpm --rebuilddb

# Installing Mod Gearman Worker
RUN rpm -Uvh https://repo.nagios.com/nagios/7/nagios-repo-7-4.el7.noarch.rpm; \
yum repolist; \
chmod +x /tmp/ModGearmanInstall.sh ; \
/tmp/ModGearmanInstall.sh --type=worker

ADD nrpe/*.rpm /
#Install NRPE
RUN yum install -y /nagios-common-4.4.5-7.el7.centos.x86_64.rpm ; \
yum install -y /nrpe-4.0.3-2.el7.centos.x86_64.rpm ; \
yum install -y /nagios-plugins-2.3.3-2.el7.centos.x86_64.rpm  ; \
yum install -y /nagios-plugins-nrpe-4.0.3-2.el7.centos.x86_64.rpm ; \
yum install -y /nagios-plugins-http-2.3.3-2.el7.centos.x86_64.rpm ; \
yum install -y /nagios-plugins-icmp-2.3.3-2.el7.centos.x86_64.rpm ; \
yum install -y /nagios-plugins-tcp-2.3.3-2.el7.centos.x86_64.rpm ; \
yum install -y /nagios-plugins-uptime-2.3.3-2.el7.centos.x86_64.rpm ; \
yum install -y /nagios-plugins-users-2.3.3-2.el7.centos.x86_64.rpm ; \
yum install -y /nagios-plugins-by_ssh-2.3.3-2.el7.centos.x86_64.rpm

ADD nrpe/utils.pm /usr/local/nagios/libexec/
RUN chmod +x /usr/local/nagios/libexec/utils.pm

RUN yum install -y gcc glibc glibc-common openssl openssl-devel perl wget perl-Time-Piece
#Config
ADD ReadBackwards.pm /usr/share/perl5/File/
RUN chmod +x /usr/share/perl5/File/ReadBackwards.pm
#ADD nrpe.cfg /usr/local/nagios/etc/nrpe.cfg

RUN mkdir -p /usr/local/nagios/etc/nrpe/ ; \
mkdir -p /usr/local/nagios/libexec/lib/
ADD vnpay.cfg /usr/local/nagios/etc/nrpe/
ADD vnpay_linux.cfg /usr/local/nagios/etc/nrpe/
RUN chmod -R 755 /usr/local/nagios/etc/nrpe/

ADD lib/* /usr/local/nagios/libexec/lib/
RUN chmod -R 755 /usr/local/nagios/libexec/lib/

ADD nrpe/*.pl /usr/local/nagios/libexec/
RUN chmod -R 755 /usr/local/nagios/libexec/*.pl

#Supervisord + Nagios Scripts
#RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm ; \
#yum --enablerepo=epel install -y supervisor ; \
#mv -f /etc/supervisord.conf /etc/supervisord.conf.org

#ADD supervisord.conf /etc/

#Configuring Gearman
ADD worker.conf /etc/mod_gearman/worker.conf



ENTRYPOINT ["/entrypoint.sh"]
