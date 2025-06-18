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
12. [Test Patterns & Debug](#test-patterns--debug)  
13. [Known Issues & Tips](#known-issues--tips)  
14. [License](#license)  

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

