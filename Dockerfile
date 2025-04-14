FROM odoo:18.0

LABEL MAINTAINER Alitux <alitux@disroot.org> y Titux <hectorquiroz@trixocom.com>
USER root
#Requerimientos Python
# COPY requirements.txt /tmp/


## Instalar dependencias necesarias
RUN apt-get update \
 && apt-get install -y git gcc swig python3-m2crypto unzip curl python3-venv \
 && curl -sS https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
 && python3 get-pip.py --break-system-packages --ignore-installed\
 && rm get-pip.py


RUN pip install setuptools==69.0.3 wheel --break-system-packages 
RUN pip3 install git+https://gitlab.com/alitux/odoogci --break-system-packages
RUN mkdir /tmp/download/

## Descarga localización Adhoc
RUN cd /tmp/download/ &&\
    odoogci -u "https://github.com/ingadhoc/odoo-argentina" -b "18.0" &&\
    odoogci -u "https://github.com/ingadhoc/account-invoicing" -b "18.0" &&\
    odoogci -u "https://github.com/ingadhoc/account-financial-tools" -b "18.0" &&\
    odoogci -u "https://github.com/ingadhoc/account-payment" -b "18.0" &&\
    odoogci -u "https://github.com/ingadhoc/odoo-argentina-ce" -b "18.0" &&\
    mv /tmp/download/* /usr/lib/python3/dist-packages/odoo/addons/

## Instalar pyfafipws versión 2025 
RUN pip install git+https://github.com/reingart/pyafipws.git@2025 --break-system-packages

## Parche para SSL
RUN mkdir -p /usr/local/lib/python3.12/dist-packages/pyafipws/cache
RUN chown -R odoo:odoo /usr/local/lib/python3.12/dist-packages/pyafipws/cache
RUN sed  -i "s/CipherString = DEFAULT@SECLEVEL=2/#CipherString = DEFAULT@SECLEVEL=2/" /etc/ssl/openssl.cnf

USER odoo