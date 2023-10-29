FROM anujdatar/cups:23.10.01

COPY startup.sh /

# Install dependencies
RUN apt-get update -qq  && apt-get upgrade -qqy \
    && apt-get install -qqy \
    curl \
    expect \
    dos2unix \
    gnupg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl https://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/hplip-3.22.10-plugin.run -O \
    && curl https://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/hplip-3.22.10-plugin.run.asc -O \
    && dos2unix /startup.sh \
    && chmod +x /startup.sh \
    && apt-get purge -qqy curl dos2unix

COPY install-printer.exp /

CMD ["/startup.sh"]
