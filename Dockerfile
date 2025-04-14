FROM odoo:16.0

LABEL MAINTAINER Alitux <alitux@disroot.org>
USER root
#Requerimientos Python
# COPY requirements.txt /tmp/

## Instalar dependencias necesarias
RUN apt update && apt install -y git gcc swig python3-m2crypto unzip && pip3 install --upgrade pip
RUN pip3 install git+https://gitlab.com/alitux/odoogci
## Descarga localización Adhoc
RUN cd /usr/lib/python3/dist-packages/odoo/addons/ &&\
    odoogci -u "https://github.com/ingadhoc/odoo-argentina" -b "16.0" &&\
    odoogci -u "https://github.com/ingadhoc/account-invoicing" -b "16.0" &&\
    odoogci -u "https://github.com/ingadhoc/account-financial-tools" -b "16.0" &&\
    odoogci -u "https://github.com/ingadhoc/account-payment" -b "16.0" &&\
    odoogci -u "https://github.com/ingadhoc/odoo-argentina-ce" -b "16.0"
## Parche para SSL
RUN mkdir -p /usr/local/lib/python3.9/dist-packages/pyafipws/cache
RUN chown -R odoo:odoo /usr/local/lib/python3.9/dist-packages/pyafipws/cache
RUN sed  -i "s/CipherString = DEFAULT@SECLEVEL=2/#CipherString = DEFAULT@SECLEVEL=2/" /etc/ssl/openssl.cnf

USER odoo
