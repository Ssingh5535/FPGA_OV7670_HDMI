# OV7670 Camera on PYNQ-Z2 → HDMI Demo

![Project Flow](docs/flow_overview.png)

## Table of Contents

1. [Project Overview](#project-overview)  
2. [Repository Structure](#repository-structure)  
3. [Hardware Requirements](#hardware-requirements)  
4. [Vivado Block Diagram](#vivado-block-diagram)  
5. [Clocking & Reset](#clocking--reset)  
6. [HLS IP: dvp2axis](#hls-ip-dvp2axis)  
7. [PS-EMIO I²C (SCCB) Setup](#ps-emio-i²c-sccb-setup)  
8. [AXI-Stream → Video Out Pipeline](#axi-stream--video-out-pipeline)  
9. [AXI-VDMA Configuration](#axi-vdma-configuration)  
10. [Top-Level Wrapper & XDC Constraints](#top-level-wrapper--xdc-constraints)  
11. [PYNQ Python Software](#pynq-python-software)   
12. [Known Issues & Tips](#known-issues--tips)  


---

## Project Overview

This project demonstrates a complete FPGA-and-software flow for:

1. **Capturing** live video from an OV7670 camera module via PMOD on a PYNQ-Z2 board  
2. **Programming** the camera’s SCCB registers over PS-EMIO I²C in Python  
3. **Packing** raw DVP data into AXI-Stream with a custom HLS IP (`dvp2axis`)  
4. **Buffering** frames in DDR using AXI-VDMA  
5. **Outputting** video over HDMI with Xilinx Video-Out IP  
6. **Controlling** and **viewing** all stages from a Python Jupyter notebook  

---

## Repository Structure

---

## Hardware Requirements

- **Digilent PYNQ-Z2** development board (XC7Z020-1CLG400C)  
- **OV7670** camera module with SCCB interface  
- **2× 1×6 PMOD connector cables** (Camera → PYNQ PMOD B)  
- **HDMI cable & monitor** for video out  
- **Micro-SD card** with PYNQ 3.x image  

---

## Vivado Block Diagram



![Block Diagram](docs/block_diagram.png)

**Major IP Blocks**  
- **Clocking Wizard**: Generates 24 MHz (camera XCLK) and 25 MHz (HDMI pixel clock)  
- **Processing System (PS-7)**:  
  - 7-series Zynq PS, with **I2C0 EMIO** enabled for SCCB  
  - DDR and fixed-IO connections for PS subsystems  
- **Utility Buffer (×2)**:  
  - Configured as IOBUF for `SCL_O/I/T` and `SDA_O/I/T` to PMOD pins  
- **Vivado HLS IP (`dvp2axis_0`)**: C→AXI-Stream converter for camera DVP  
- **AXI Data-Width & Clock Converters**: Match pixel width (2 bytes) & domain (25 MHz)  
- **Video Timing Controller (`v_tc_0`)**: Generates HSYNC/VSYNC/DE for 640×480@60 Hz  
- **AXI4-Stream to Video Out (`v_axi4s_vid_out_0`)**: Packs AXIS into TMDS signals  
- **AXI-VDMA (`axi_vdma_0`)**: S2MM for snapshot, MM2S for live loop (optional)  

---

## Clocking & Reset

| Clock Source         | Used For               | Frequency  |
|----------------------|------------------------|-----------:|
| `sys_clk_pin` (MIO)  | PS DDR, PS Peripherals | 125 MHz    |
| `clk_wiz_0_clk_out0` | OV7670 XCLK            | 24 MHz     |
| `clk_wiz_0_clk_out1` | N/A                    | (unused)   |
| `clk_wiz_0_clk_out2` | Video Timing/HDMI Out  | 25 MHz     |

- **Reset**: `proc_sys_reset_0/peripheral_aresetn` synchronized to 25 MHz  

---

## HLS IP: `dvp2axis`

- **Source**: `hls/dvp2axis.cpp`, `dvp2axis.h`  
- **Function**:  
  1. On each rising PCLK, sample `data_in[7:0]`, `href`, `vsync`.  
  2. When `href` is high, pack pixel into 16-bit RGB565.  
  3. Assert `tuser` at start of frame, `tlast` at end of line.  
- **Interface**:  
  - AXI4-Stream Master: `m_axis_tdata[15:0]`, `tvalid`, `tready`, `tuser`, `tlast`  
  - Clock: PCLK domain for input → output clock converter  
- **Co-Simulation**: `tb_dvp2axis.cpp` provides dummy DVP input to verify functionality.  

---

## PS-EMIO I²C (SCCB) Setup

1. In the Zynq PS block, **enable EMIO** for **I2C0**.  
2. Add two **Utility Buffer** IPs, set **C Buf Type = IOBUF**.  
3. Wire PS EMIO pins:



