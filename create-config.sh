#!/bin/sh

# Function to check if a variable is set and not empty
check_var() {
  var_value=$(eval echo \$$1)
  if [ -z "$var_value" ]; then
    echo "Error: Environment variable $1 is not set or empty."
    exit 1
  fi
}

# Validate required environment variables
check_var "NIGHTSCOUT_URL"
check_var "NIGHTSCOUT_TOKEN"
check_var "LIBRE_USERNAME"
check_var "LIBRE_PASSWORD"
check_var "LIBRE_DEVICE"
check_var "HARDWARE_DESCRIPTOR"
check_var "OS_VERSION"
check_var "HARDWARE_NAME"
check_var "LIBRE_RESET_DEVICE"
check_var "FROM_YEAR"
check_var "FROM_MONTH"
check_var "FROM_DAY"
check_var "DELTA_DAY"

# Optionally, add specific validation rules (e.g., numerical values, valid URLs)
if ! echo "$NIGHTSCOUT_URL" | grep -qE '^https?://'; then
  echo "Error: NIGHTSCOUT_URL must be a valid URL."
  exit 1
fi

if ! echo "$FROM_YEAR" | grep -qE '^[0-9]{4}$'; then
  echo "Error: FROM_YEAR must be a valid 4-digit year."
  exit 1
fi

if ! echo "$FROM_MONTH" | grep -qE '^(0?[1-9]|1[012])$'; then
  echo "Error: FROM_MONTH must be a valid month (01-12)."
  exit 1
fi

if ! echo "$FROM_DAY" | grep -qE '^(0?[1-9]|[12][0-9]|3[01])$'; then
  echo "Error: FROM_DAY must be a valid day (01-31)."
  exit 1
fi

if ! echo "$DELTA_DAY" | grep -qE '^[0-9]+$'; then
  echo "Error: DELTA_DAY must be a valid positive integer."
  exit 1
fi

# All checks passed, create config.json
cat <<EOF > /app/config.json
{
  "nightscoutUrl": "$NIGHTSCOUT_URL",
  "nightscoutToken": "$NIGHTSCOUT_TOKEN",
  "libreUsername": "$LIBRE_USERNAME",
  "librePassword": "$LIBRE_PASSWORD",
  "libreDevice": "$LIBRE_DEVICE",
  "hardwareDescriptor": "$HARDWARE_DESCRIPTOR",
  "osVersion": "$OS_VERSION",
  "hardwareName": "$HARDWARE_NAME",
  "libreResetDevice": "$LIBRE_RESET_DEVICE",
  "fromYear": "$FROM_YEAR",
  "fromMonth": "$FROM_MONTH",
  "fromDay": "$FROM_DAY",
  "deltaDay": "$DELTA_DAY"
}
EOF

echo "config.json successfully generated."
