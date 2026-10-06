# AAT-SWR-PWR Meter

<p align="center">
  <img width="1200" alt="AAT-SWR-PWR meter" src="https://github.com/user-attachments/assets/9f0b663d-04a0-4a60-bdcb-180295d30a11" />
</p>

Automatic antenna tuner with integrated SWR and RF power measurement.

AAT-SWR-PWR Meter is a compact embedded RF instrument designed to tune an antenna automatically while measuring forward power, reflected power, SWR, and RF level. The project is built around an AVR microcontroller and a relay-based LC matching network, making it suitable for practical radio use and antenna matching experiments.

This project was designed as a practical tuner / analyzer for amateur radio use, combining antenna matching with measurement functions in a single instrument.

---

## Overview

The unit measures:

- forward power
- reflected power
- SWR
- RF power level in watts
- relative directional signal levels

It also includes:

- automatic tuning mode
- manual tuning mode
- band selection
- relay-based L/C switching
- user calibration routines
- EEPROM-backed parameter storage

The device is specifically designed around the idea of tuning an antenna to a low SWR condition while also providing a simple instrument for monitoring power and reflected energy.

---

## Key Features

- Automatic antenna tuning using relay-switched L/C network
- Manual tuning mode for direct antenna matching
- SWR display with numerical and graphical indication
- Forward / reflected bargraph display
- RF power measurement using AD8307 logarithmic detector
- Band selection for multiple operating bands
- EEPROM calibration and stored tuning values
- Built-in calibration routines for reference voltage and power calibration
- LCD-based user interface with dedicated operating menus
- Relay control delay adjustment
- Standby and tuner-off measurement modes

---

## Hardware Platform

The project is implemented on a compact AVR-based board using a relay-controlled LC matching network.

| Component | Description |
|---|---|
| Microcontroller | ATmega8A |
| Clock | Internal 8 MHz oscillator |
| Display | Alphanumeric LCD module |
| Matching Network | Relay-switched L/C network |
| RF Detector | AD8307 logarithmic amplifier |
| ADC Inputs | Forward, reflected, and power channels |
| Relays | L/C switching and tuning control |
| Memory | EEPROM for tuned values and calibration |

### Main operating principle

The device samples forward and reflected voltages, computes the SWR, and then adjusts the L/C network to minimize mismatch. A separate power channel is also sampled and processed to estimate RF power.

---

## Measurement Concept

### Forward / reflected measurement

The firmware reads three ADC channels:

- forward voltage
- reflected voltage
- RF power signal

These values are used to compute:

- forward power
- reflected power
- SWR
- RF power in watts

The project uses an AD8307-based logarithmic amplifier for power conversion and a direct ADC-sampled comparison for the forward / reflected path.

### SWR calculation

The calculation is based on the relationship between forward and reflected voltage:

```text
SWR = (Vfwd + Vrew) / (Vfwd - Vrew)
```

When the reflected signal is low, the SWR approaches a near-ideal value. The tuning logic seeks to minimize this value by selecting appropriate L and C values.

---

## Automatic Tuning

The automatic mode performs a search over the available relay states:

- L values from a coarse table
- C values from a coarse table
- optional relay polarity / sweep state

The firmware iterates through the possible combinations and keeps the setting that gives the lowest SWR for the selected band.

This process is performed in a loop with the following stages:

1. select a pair of L/C values
2. read forward and reflected voltages
3. compute SWR
4. compare with the current minimum
5. keep the best match
6. continue until the search is complete

The result is stored in EEPROM for the selected band.

---

## Manual Tuning

Manual tuning allows the user to adjust the relay-controlled LC network directly.

The available manual controls include:

- L-up / L-down
- C-up / C-down
- band selection
- relay state switching
- direct SWR viewing

This mode is useful when the user wants to fine-tune the antenna system while observing the real-time SWR and power readings.

---

## Menu Structure

The firmware includes several operating menus:

- **Main menu / antenna tuner**
- **Manual tune**
- **SWR / power meter**
- **Forward / reflected analog display**
- **Tuner OFF**
- **Delay Time Relay**
- **Calibration menu**

### Main features of the menu system

- band display in MHz
- displayed L and C values
- FWD / REW bargraph
- numeric SWR output
- power calculation and display
- relay delay adjustment

---

## Calibration

The project includes built-in calibration routines necessary for reliable measurement.

Calibration procedures include:

- ADC reference calibration
- power-level calibration at 1 W
- power-level calibration at 10 W
- SWR offset correction
- stored calibration values in EEPROM

This is important because the meter is intended for practical measurements and must remain aligned to real RF power and antenna conditions.

---

## Firmware and Development

The repository contains both generated source and build artifacts, including:

- `AAT_SWR_PWR_meter.c`
- `AAT_SWR_PWR_meter.asm`
- `.hex`, `.map`, `.eep`, `.rom`
- AVR project files

The firmware is built in C with AVR-specific assembly support and is intended for the ATmega8A microcontroller.

The project uses a CodeVision AVR / AVR Studio style development flow, as indicated by the generated project files and the EEPROM-driven configuration approach.

---

## Project Structure

```text
AAT-SWR-PWR-meter/
├── AAT_SWR_PWR_meter.c
├── AAT_SWR_PWR_meter.asm
├── AAT_SWR_PWR_meter.hex
├── AAT_SWR_PWR_meter.map
├── AAT_SWR_PWR_meter.eep
├── AAT_SWR_PWR_meter.rom
├── setari.h
├── Calcul_putere_AD8307.h
├── README.md
├── LICENSE
├── cuplor.JPG
└── control_block.gif
```

---

## Typical Use Cases

- antenna tuning on the bench
- portable HF/VHF antenna matching
- SWR and power checks before transmission
- educational RF projects
- experimental matching network optimization
- field radio deployment and tuning

---

## Project Status

This project is a functional RF tuner and analyzer. It is suitable for practical use with an antenna matching network and can be used to automatically minimize SWR while monitoring power.

Current project focus:

- tuning reliability
- SWR optimization
- power measurement accuracy
- calibration stability
- firmware robustness

---

## References

- Project page: https://www.qsl.net/yo6pir/aat.html
- Original concept: automatic antenna tuner with RF power measurement
- Inspired by practical amateur radio instrumentation design

---

## License

This project is distributed under the repository license included in the project.

Please review the LICENSE file for the applicable terms.

---

## Credits

Developed by Ovidiu — YO6PIR.

This project is a practical RF measurement and antenna tuning tool designed for amateur radio use, combining automatic matching with visible power and SWR monitoring in a compact embedded platform.
