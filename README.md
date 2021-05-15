# Simple Air Temperature Control

This project is about a very simple temperature control setup involving DHT22 sensor, relay and user interface in form of OLED and rotary switch.

It is being used to control air temperature inside a cabinet by controlling a heating element.

It performs a simple on/off control following a set target temperature.

User can set target temperature right after startup, using rotary switch. Target temperature is visible on the OLED screen.

By pressing the switch the control starts.

Control loop happens every 1 sec. On the display it is shown current temperature and humidity, as well as target temp and observed up to now min and max temperatures.

If new temperature is to be set, one has to reset the power supply.

## Parts

- DHT22
- NodeMCU (any variant)
- Relay (any variant as long as it is Arduino compliant)
- Rotary switch (cheap chinese ones)
- OLED 128x64 0.96" SSD1306

## Wiring

NodeMCU pins:

- D5 : DHT22 (S)
- D1 : OLED (SDA)
- D2 : OLED (SCL)
- D3 : Rotary (SW)
- D6 : Rotary (B)
- D7 : Rotary (A)
- D8 : Relay (S)

## Firmware

Following modules are required:

- rotary
- dht
- u8g2
- tmr
- gpio
- i2c

Both, integer and float builds should be working fine with this code.

## License

GPLv3, see LICENSE file
