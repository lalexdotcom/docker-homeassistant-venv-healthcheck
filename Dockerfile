FROM homeassistant/home-assistant:stable

RUN pip install shyaml

RUN mkdir /healthcheck
COPY healthcheck.sh /healthcheck
RUN chmod +x /healthcheck/healthcheck.sh

# 10 mins shoud be enough to start...
HEALTHCHECK --start-period=30s --interval=10s --retries=57 --timeout=10s \
  CMD /healthcheck/healthcheck.sh

COPY run /etc/services.d/home-assistant/run
