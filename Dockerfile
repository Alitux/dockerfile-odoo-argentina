FROM odoo:17.0

LABEL MAINTAINER Alitux <alitux@disroot.org>
USER root
#Requerimientos Python
# COPY requirements.txt /tmp/

## Instalar dependencias necesarias
RUN apt-get update && apt-get install -y git gcc swig python3-m2crypto unzip && pip3 install --upgrade pip 
RUN pip install setuptools==65.5.1 wheel
RUN pip3 install git+https://gitlab.com/alitux/odoogci
RUN mkdir /tmp/download/

## Descarga localización Adhoc
RUN cd /tmp/download/ &&\
    odoogci -u "https://github.com/ingadhoc/odoo-argentina" -b "17.0" &&\
    odoogci -u "https://github.com/ingadhoc/account-invoicing" -b "17.0" &&\
    odoogci -u "https://github.com/ingadhoc/account-financial-tools" -b "17.0" &&\
    odoogci -u "https://github.com/ingadhoc/account-payment" -b "17.0" &&\
    odoogci -u "https://github.com/ingadhoc/odoo-argentina-ce" -b "17.0" &&\
    mv /tmp/download/* /usr/lib/python3/dist-packages/odoo/addons/

## Instalar pyfafipws versión 2025 
RUN pip install git+https://github.com/reingart/pyafipws.git@2025

## Parche para SSL
RUN mkdir -p /usr/local/lib/python3.10/dist-packages/pyafipws/cache
RUN chown -R odoo:odoo /usr/local/lib/python3.10/dist-packages/pyafipws/cache
RUN sed  -i "s/CipherString = DEFAULT@SECLEVEL=2/#CipherString = DEFAULT@SECLEVEL=2/" /etc/ssl/openssl.cnf

USER odoo