#!/bin/sh
# Install the 7F ML-DSA-65 FFI library (diy-seedsigner firmware/mldsa7f) into
# the app at opt/src/seedsigner/resources/lib/libmldsa7f.so -- the first path
# the app's models/sevenf/mldsa.py loads it from. Without it every 7F
# operation (enroll, sign, certify) fails on the device.
#
# MLDSA7F_LIB must name an armv7 build:
#   cargo build --release --target armv7-unknown-linux-gnueabihf   (no test-tooling feature)
# The build fails rather than ship an image without it (found 2026-10-08: the
# 2026-10-06 images had no library at all).
set -eu
TARGET_DIR="$1"

if [ -z "${MLDSA7F_LIB:-}" ] || [ ! -f "${MLDSA7F_LIB}" ]; then
	echo "ERROR: MLDSA7F_LIB must point to an armv7 libmldsa7f.so (got '${MLDSA7F_LIB:-}')" >&2
	exit 1
fi
if ! file -b "${MLDSA7F_LIB}" | grep -q "ELF 32-bit LSB shared object, ARM"; then
	echo "ERROR: ${MLDSA7F_LIB} is not a 32-bit ARM shared object: $(file -b "${MLDSA7F_LIB}")" >&2
	exit 1
fi

DEST="${TARGET_DIR}/opt/src/seedsigner/resources/lib/libmldsa7f.so"
install -D -m 0755 "${MLDSA7F_LIB}" "${DEST}"
echo "Installed libmldsa7f.so: $(sha256sum "${DEST}" | cut -d' ' -f1)"
