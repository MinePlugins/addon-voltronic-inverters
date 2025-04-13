ARG BUILD_FROM
FROM ${BUILD_FROM}
# FROM ghcr.io/hassio-addons/debian-base/amd64:stable
# Install dependencies
RUN apt-get update && apt-get install -y \
    nano \
    jq \
    python3 \
    python3-pip \
    mosquitto-clients

# Set the working directory
WORKDIR /opt

RUN pip install mppsolar --break-system-packages

# Create the destination directory and copy necessary file

COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Configure healthcheck
HEALTHCHECK \
    --interval=30s \
    --timeout=10s \
    --start-period=1m \
    --retries=3 \
    CMD /opt/healthcheck

# Set the startup command
CMD [ "/run.sh" ]
