#!/usr/bin/with-contenv bashio
set -e

# Paths to configuration files
INVERTER_CONFIG="/etc/inverter/inverter.conf"
MQTT_CONFIG="/etc/inverter/mqtt.json"

# Update the inverter.conf file
DEVICE=$(bashio::config 'device_type')
case "${DEVICE}" in
serial)
    DEVICE_PATH="/dev/ttyS0"
    ;;
usb-serial)
    DEVICE_PATH="/dev/ttyUSB1"
    ;;
usb)
    DEVICE_PATH="/dev/hidraw0"
    ;;
*)
    bashio::log.error "Invalid device type: ${DEVICE}"
    exit 1
    ;;
esac

# Update the mqtt.json file
BROKER_HOST=$(bashio::config 'mqtt_broker_host')
USERNAME=$(bashio::config 'mqtt_username')
PASSWORD=$(bashio::config 'mqtt_password')

# Debug: Print updated file contents
echo "[DEBUG] Updated content of inverter.conf:"
# cat "$INVERTER_CONFIG"

echo "[DEBUG] Updated content of mqtt.json:"
# cat "$MQTT_CONFIG"

bashio::log.info "Configuration completed successfully."

/bin/bash
