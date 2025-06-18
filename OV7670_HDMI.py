#!/usr/bin/env python3
from pynq import Overlay
from pynq.lib.iic import AxiIIC
import time

# ----------------------------------------------------------------------------
# 1) Load the bitstream / hardware description
# ----------------------------------------------------------------------------
bitfile = "OV7670HW.xsa"               # your exported XSA
ol      = Overlay(bitfile)
ol.download()
print(f"Overlay loaded: {ol.bitfile_name}")

# ----------------------------------------------------------------------------
# 2) Bring up the OV7670 SCCB (I²C) bus
# ----------------------------------------------------------------------------
iic       = AxiIIC(ol.iic_0)            # name matches your block-design instance
CAM_ADDR  = 0x21                        # OV7670 default 7-bit address (0x42>>1)

# Full SCCB init sequence for OV7670; replace with your own settings:
ov7670_regs = [
    (0x12, 0x80),  # COM7: reset
    # … add all your other (reg, value) pairs here …
    (0x11, 0x01),  # CLKRC: use external XCLK/2
    (0x0C, 0x04),  # COM3: enable scaling
    (0x3E, 0x19),  # COM14: pclk scaling
    # etc…
]

print("Configuring OV7670 registers over SCCB/I²C...")
for reg, val in ov7670_regs:
    # send(address, buffer, length)
    iic.send(CAM_ADDR, bytes([reg, val]), 2)
    time.sleep(0.005)                # small settle time
time.sleep(0.1)
print("OV7670 initialization complete.")

# ----------------------------------------------------------------------------
# 3) Grab the VDMA and its two channels
# ----------------------------------------------------------------------------
vdma       = ol.axi_vdma_0             # your VDMA IP instance
read_chan  = vdma.readchannel          # S2MM: PL → DDR
write_chan = vdma.writechannel         # MM2S: DDR → PL (to HDMI)

# Frame geometry (must match your HLS / camera pipeline)
WIDTH, HEIGHT, BYTES_PER_PIXEL = 640, 480, 2
FRAME_BYTES = WIDTH * HEIGHT * BYTES_PER_PIXEL

# ----------------------------------------------------------------------------
# 4) Start the VDMA channels
# ----------------------------------------------------------------------------
write_chan.start()                     # spin the HDMI output DMA
read_chan.start(FRAME_BYTES)           # tell camera→DDR DMA how big each frame is

print("Streaming…  Press Ctrl-C to stop.")

# ----------------------------------------------------------------------------
# 5) Main loop: read one full frame, write it back out
# ----------------------------------------------------------------------------
try:
    while True:
        buf = read_chan.readframe()   # block until a new 640×480×2 buffer arrives
        write_chan.writeframe(buf)    # push that buffer into the HDMI pipeline
except KeyboardInterrupt:
    print("\nStopping…")
finally:
    read_chan.stop()
    write_chan.stop()
    print("Cleaned up, exiting.")

