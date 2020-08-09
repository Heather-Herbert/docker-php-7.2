FROM centos:7

LABEL maintainer="heather.herbert.1975@gmail.com"

ENV REFRESHED_AT 2020-08-08
ENV PUBLIC_ROOT html
ENV SERVER_NAME localhost
ENV HOST_PORT_XDEBUG 9000

RUN yum update -y
RUN yum install httpd mod_ssl wget epel-release zip unzip nano yum-utils -y

RUN yum-config-manager --enable remi-php72 -y

RUN yum update -y
RUN yum install php -y

RUN yum install php-fpm \
		 php-gd \
		 php-json \
		 php-mbstring \
		 php-mysqlnd \
		 php-xml \
		 php-xmlrpc \
		 php-opcache -y

RUN mkdir -p /var/run/php-fpm 

# Create HTTPS certs
RUN openssl genrsa -out ca.key 2048
RUN openssl req -new -nodes -subj "/C=UK/ST=Aberdeenshire/L=Aberdeen/O=Test/CN=cryptonot.es" -key ca.key -out ca.csr
RUN openssl x509 -req -days 365 -in ca.csr -signkey ca.key -out ca.crt
RUN cp ca.crt /etc/pki/tls/certs
RUN cp ca.key /etc/pki/tls/private/ca.key
RUN cp ca.csr /etc/pki/tls/private/ca.csr
RUN sed -i 's/SSLCertificateFile \/etc\/pki\/tls\/certs\/localhost.crt/SSLCertificateFile \/etc\/pki\/tls\/certs\/ca.crt/g' /etc/httpd/conf.d/ssl.conf
RUN sed -i 's/SSLCertificateKeyFile \/etc\/pki\/tls\/private\/localhost.key/SSLCertificateKeyFile \/etc\/pki\/tls\/private\/ca.key/g' /etc/httpd/conf.d/ssl.conf

COPY ./.bashrc /root/
# Apache and PHP configs
COPY ./php/php.ini /etc/
COPY ./httpd/conf/httpd.conf /etc/httpd/conf/

EXPOSE 80
EXPOSE 443
EXPOSE 1521

# Install Supervisor for managing processes
RUN yum install -y python-setuptools
RUN easy_install supervisor==3.4.0
COPY ./supervisord/supervisord.conf /usr/etc/supervisord.conf

CMD ["/usr/bin/supervisord"]


EXPOSE 80
EXPOSE 443
EXPOSE 1521

