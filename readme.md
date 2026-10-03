<picture>
  <source media="(prefers-color-scheme: dark)" srcset="/docs/images/TOTEM_logo_dark.svg">
  <source media="(prefers-color-scheme: light)" srcset="/docs/images/TOTEM_logo_bright.svg">
  <img alt="TOTEM logo font" src="/docs/images/TOTEM_logo_bright.svg">
</picture>

# ZMK CONFIG FOR THE TOTEM SPLIT KEYBOARD

[Here](https://github.com/GEIGEIGEIST/totem) you can find the hardware files and build guide.\
[Here](https://github.com/GEIGEIGEIST/qmk-config-totem) you can find the QMK config for the TOTEM.

TOTEM is a 38 key column-staggered split keyboard running [ZMK](https://zmk.dev/) or [QMK](https://docs.qmk.fm/). It's meant to be used with a SEEED XIAO BLE or RP2040.


![TOTEM layout](/docs/images/TOTEM_layout.svg)



## HOW TO USE

- fork this repo
- `git clone` your repo, to create a local copy on your PC (you can use the [command line](https://www.atlassian.com/git/tutorials) or [github desktop](https://desktop.github.com/))
- adjust the totem.keymap file (find all the keycodes on [the zmk docs pages](https://zmk.dev/docs/codes/))
- `git push` your repo to your fork
- on the GitHub page of your fork navigate to "Actions"
- scroll down and unzip the `firmware.zip` archive that contains the latest firmware
- connect the left half of the TOTEM to your PC, press reset twice
- the keyboard should now appear as a mass storage device
- drag'n'drop the `totem_left-seeeduino_xiao_ble-zmk.uf2` file from the archive onto the storage device
- repeat this process with the right half and the `totem_right-seeeduino_xiao_ble-zmk.uf2` file.

## LOCAL BUILD

To build the firmware locally instead of using GitHub Actions:

- install [Docker Desktop](https://www.docker.com/products/docker-desktop/) and make sure it is running
- run the build script from the repo root:

  ```sh
  ./build.sh
  ```

The script builds the same targets as CI using the `zmkfirmware/zmk-build-arm:3.5`
image (matching the ZMK `v0.2` / Zephyr 3.5 revision pinned in `config/west.yml`)
and writes the firmware to the `build/` directory:

- `build/totem_left-seeeduino_xiao_ble-zmk.uf2`
- `build/totem_right-seeeduino_xiao_ble-zmk.uf2`
- `build/settings_reset-seeeduino_xiao_ble-zmk.uf2` (use to clear the stored settings)

The west workspace (downloaded ZMK/Zephyr modules) is kept outside the repo in
`../zmk-workspace`. Override it with `ZMK_WORKSPACE=/path/to/workspace ./build.sh`.