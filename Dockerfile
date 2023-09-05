FROM anujdatar/cups

COPY run.sh /

# Install dependencies
RUN apt-get update -qq  && apt-get upgrade -qqy \
    && apt-get install -qqy \
    curl \
    expect \
    dos2unix \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl https://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/hplip-3.22.10-plugin.run -O \
    && dos2unix /run.sh \
    && apt-get purge -qqy curl dos2unix

COPY install-printer.exp /

CMD ["/run.sh"]
