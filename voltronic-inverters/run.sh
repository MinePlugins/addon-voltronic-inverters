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

# # Start the mppsolar process to communicate with the inverter
# bashio::log.info "Starting mppsolar process..."

# # Create necessary configuration files
# cat >"$INVERTER_CONFIG" <<EOF
# {
#     "device": "${DEVICE_PATH}",
#     "protocol": "${DEVICE}"
# }
# EOF

# cat >"$MQTT_CONFIG" <<EOF
# {
#     "host": "${BROKER_HOST}",
#     "username": "${USERNAME}",
#     "password": "${PASSWORD}",
#     "topic": "homeassistant/sensor/voltronic"
# }
# EOF

# # Start mppsolar daemon in the background
# bashio::log.info "Starting mppsolar daemon..."
# mppsolar -C "$INVERTER_CONFIG" -q "$MQTT_CONFIG" --daemon

# Keep the container running indefinitely
bashio::log.info "Starting infinite loop to keep container running..."
while true; do
    sleep 30
    # Check if mppsolar process is still running
    if ! pgrep -f mppsolar >/dev/null; then
        bashio::log.warning "mppsolar process died, restarting..."
        mppsolar -C "$INVERTER_CONFIG" -q "$MQTT_CONFIG" --daemon
    fi
done
