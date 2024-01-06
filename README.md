# esp32-zig-starter

A simple starter project for integrating Zig code into the [Espressif IoT
Development Framework (ESP-IDF)](https://github.com/espressif/esp-idf) build
system.

The example in this project is essentially a port of the [`blink`
example][blink] from the ESP-IDF. The project targets an ESP32C3. The goal of
this project is not to support multiple targets or be a "framework": it is
simply a starting point for you to copy from for building your own Zig
components in ESP-IDF.

[blink]: https://github.com/espressif/esp-idf/tree/master/examples/get-started/blink

## Quickstart

Follow the Espressif documentation for [installing ESP-IDF][install]. Set
`$IDF_PATH` to the location of your `esp-idf` installation.

Clone this repository and navigate to the project root:

    git clone https://github.com/gpanders/esp32-zig-starter
    cd esp32-zig-starter

Build the project and flash it to the device:

    idf.py set-target esp32c3
    idf.py build
    idf.py -p PORT flash

(Optional) Open a serial console to view log messages:

    idf.py -p PORT monitor

[install]: https://docs.espressif.com/projects/esp-idf/en/stable/esp32c3/get-started/index.html#installation
