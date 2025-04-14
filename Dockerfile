FROM odoo:15.0

LABEL MAINTAINER Alitux <alitux@disroot.org>
USER root
#Requerimientos Python
COPY requirements.txt /tmp/

## Instalar dependencias necesarias
RUN apt-get update && apt-get install -y git gcc swig python3-m2crypto unzip && pip3 install --upgrade pip
RUN pip3 install -r /tmp/requirements.txt && rm /tmp/requirements.txt
## Descarga localización Adhoc
RUN cd /usr/lib/python3/dist-packages/odoo/addons/ &&\
    #Dependencias de qr para facturas vía Moldeo
    # curl -LJO https://github.com/ctmil/odoo-argentina/archive/refs/heads/13.0.zip &&\
    # unzip odoo-argentina-13.0.zip "odoo-argentina-13.0/l10n_ar_report_fe/*" -d . &&\
    # cp -r odoo-argentina-13.0/l10n_ar_report_fe ./l10n_ar_report_fe &&\
    # rm -r odoo-argentina-13.0.zip &&\
    curl -LJO https://github.com/ingadhoc/odoo-argentina/archive/refs/heads/15.0.zip &&\
    curl -LJO https://github.com/ingadhoc/account-invoicing/archive/refs/heads/15.0.zip &&\
    curl -LJO https://github.com/ingadhoc/account-financial-tools/archive/refs/heads/15.0.zip &&\
    curl -LJO https://github.com/ingadhoc/account-payment/archive/refs/heads/15.0.zip &&\
    curl -LJO https://github.com/ingadhoc/odoo-argentina-ce/archive/refs/heads/15.0.zip &&\
    # curl -LJO https://github.com/ctmil/l10n_ar_fe_qr/archive/refs/heads/13.0.zip &&\
    unzip '*.zip' &&\
    mv account-financial-tools-15.0/* .;rm -r account-financial-tools-15.0 &&\
    mv account-invoicing-15.0/* .; rm -r account-invoicing-15.0 &&\
    mv account-payment-15.0/* .; rm -r account-payment-15.0 &&\
    mv odoo-argentina-15.0/* .; rm -r odoo-argentina-15.0 &&\
    mv odoo-argentina-ce-15.0/* .;rm -r odoo-argentina-ce-15.0 &&\
    # mv l10n_ar_fe_qr-13.0/ l10n_ar_fe_qr &&\
    rm *.zip &&\
    rm *.md &&\
    rm LICENSE

## Parche para SSL
RUN mkdir -p /usr/local/lib/python3.9/dist-packages/pyafipws/cache
RUN chown -R odoo:odoo /usr/local/lib/python3.9/dist-packages/pyafipws/cache
RUN sed  -i "s/CipherString = DEFAULT@SECLEVEL=2/#CipherString = DEFAULT@SECLEVEL=2/" /etc/ssl/openssl.cnf

USER odoo
