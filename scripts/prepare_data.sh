#!/bin/sh
set -eu

DATA_DIR="/data"
READY_FILE="${DATA_DIR}/__READY__"
URL="https://modelseed.org/annotation/projects/kbase/2025-11-03.tar.gz"
ARCHIVE="/tmp/2025-11-03.tar.gz"

echo "Preparing data directory..."

# Create /data if it doesn't exist
mkdir -p "${DATA_DIR}/profiles"

# Download archive if not already present
if [ ! -f "${ARCHIVE}" ]; then
    echo "Downloading dataset..."
    curl -sSL -C - --retry 10 --retry-all-errors --retry-delay 5 \
        --connect-timeout 30 --max-time 0 "${URL}" -o "${ARCHIVE}"
else
    echo "Archive already downloaded, skipping download."
fi

# Extract into /data
echo "Extracting dataset to ${DATA_DIR}..."
tar -xvf "${ARCHIVE}" -C "${DATA_DIR}/profiles"

touch "${READY_FILE}"
echo "Reference data successfully prepared. READY file created."
