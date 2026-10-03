#!/usr/bin/env bash
#
# Build TOTEM ZMK firmware locally using the same Docker image as CI.
#
# Usage: ./build.sh
#
# Output: build/{totem_left,totem_right,settings_reset}-seeeduino_xiao_ble-zmk.uf2
#
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$REPO_DIR/build"
WS_DIR="${ZMK_WORKSPACE:-$(dirname "$REPO_DIR")/zmk-workspace}"
IMAGE="${ZMK_IMAGE:-zmkfirmware/zmk-build-arm:3.5}"
BOARD="seeeduino_xiao_ble"

if ! docker info >/dev/null 2>&1; then
  echo "Docker daemon is not running. Start Docker Desktop and retry." >&2
  exit 1
fi

mkdir -p "$BUILD_DIR" "$WS_DIR"
rsync -a --delete "$REPO_DIR/config/" "$WS_DIR/config/"

docker run --rm -v "$WS_DIR:/workspaces" -w /workspaces "$IMAGE" bash -lc "
  set -euo pipefail
  if [ ! -d /workspaces/.west ]; then
    west init -l /workspaces/config
    west update
  fi
  west zephyr-export
  for shield in totem_left totem_right settings_reset; do
    west build -p auto -s zmk/app -d /workspaces/build/\$shield -b $BOARD \
      -- -DZMK_CONFIG=/workspaces/config -DSHIELD=\$shield
  done
"

mkdir -p "$BUILD_DIR"
for shield in totem_left totem_right settings_reset; do
  cp "$WS_DIR/build/$shield/zephyr/zmk.uf2" "$BUILD_DIR/$shield-$BOARD-zmk.uf2"
done
echo "Firmware written to $BUILD_DIR"
