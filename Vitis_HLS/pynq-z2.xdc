## This file is a general .xdc for the PYNQ-Z2 board 
## To use it in a project:
## - rename the used ports (after get_ports) to match your top-level port names
## - uncomment the lines you actually need

## Clock signal 125 MHz (unused here)
#set_property PACKAGE_PIN H16   IOSTANDARD LVCMOS33 [get_ports { sysclk }];
#create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { sysclk }];

##------------------------
## OV7670 Camera on PMOD A
##------------------------

## XCLK output from PL (Clocking Wizard)
set_property PACKAGE_PIN Y18 [get_ports OV7670_XCLK]
set_property IOSTANDARD   LVCMOS33      [get_ports OV7670_XCLK]

## Pixel clock in
set_property PACKAGE_PIN Y19 [get_ports pclk_0]
set_property IOSTANDARD   LVCMOS33      [get_ports pclk_0]

## VSYNC in
set_property PACKAGE_PIN Y16 [get_ports vsync_0]
set_property IOSTANDARD   LVCMOS33      [get_ports vsync_0]

## HREF in
set_property PACKAGE_PIN Y17 [get_ports href_0]
set_property IOSTANDARD   LVCMOS33      [get_ports href_0]

## Data bus [7:0]
set_property PACKAGE_PIN U18 [get_ports {data_in_0[7]}]
set_property IOSTANDARD   LVCMOS33      [get_ports {data_in_0[7]}]

set_property PACKAGE_PIN U19 [get_ports {data_in_0[6]}]
set_property IOSTANDARD   LVCMOS33      [get_ports {data_in_0[6]}]

set_property PACKAGE_PIN W18 [get_ports {data_in_0[5]}]
set_property IOSTANDARD   LVCMOS33      [get_ports {data_in_0[5]}]

set_property PACKAGE_PIN W19 [get_ports {data_in_0[4]}]
set_property IOSTANDARD   LVCMOS33      [get_ports {data_in_0[4]}]

set_property PACKAGE_PIN W14 [get_ports {data_in_0[3]}]
set_property IOSTANDARD   LVCMOS33      [get_ports {data_in_0[3]}]

set_property PACKAGE_PIN Y14 [get_ports {data_in_0[2]}]
set_property IOSTANDARD   LVCMOS33      [get_ports {data_in_0[2]}]

set_property PACKAGE_PIN T11 [get_ports {data_in_0[1]}]
set_property IOSTANDARD   LVCMOS33      [get_ports {data_in_0[1]}]

set_property PACKAGE_PIN T10 [get_ports {data_in_0[0]}]
set_property IOSTANDARD   LVCMOS33      [get_ports {data_in_0[0]}]

##------------------------
## PL AXI-IIC on PMOD B
##------------------------

set_property PACKAGE_PIN W16 [get_ports iic_rtl_0_scl_io]
set_property IOSTANDARD   LVCMOS33      [get_ports iic_rtl_0_scl_io]

set_property PACKAGE_PIN V16 [get_ports iic_rtl_0_sda_io]
set_property IOSTANDARD   LVCMOS33      [get_ports iic_rtl_0_sda_io]

##------------------------
## Camera RESET & PWDN (optional)
##------------------------

set_property PACKAGE_PIN V12 [get_ports OV7670_RESET]
set_property IOSTANDARD   LVCMOS33      [get_ports OV7670_RESET]

set_property PACKAGE_PIN W13 [get_ports OV7670_PWDN]
set_property IOSTANDARD   LVCMOS33      [get_ports OV7670_PWDN]


##------------------------
## Built-in PYNQ-Z2 HDMI Out
##------------------------
# TMDS Clock Lane
set_property PACKAGE_PIN L16 [get_ports TMDS_Clk_p_0]
set_property IOSTANDARD   TMDS_33      [get_ports TMDS_Clk_p_0]

set_property PACKAGE_PIN L17 [get_ports TMDS_Clk_n_0]
set_property IOSTANDARD   TMDS_33      [get_ports TMDS_Clk_n_0]

# TMDS Data Lane 0
set_property PACKAGE_PIN K17 [get_ports {TMDS_Data_p_0[0]}]
set_property IOSTANDARD   TMDS_33      [get_ports {TMDS_Data_p_0[0]}]

set_property PACKAGE_PIN K18 [get_ports {TMDS_Data_n_0[0]}]
set_property IOSTANDARD   TMDS_33      [get_ports {TMDS_Data_n_0[0]}]

# TMDS Data Lane 1
set_property PACKAGE_PIN K19 [get_ports {TMDS_Data_p_0[1]}]
set_property IOSTANDARD   TMDS_33      [get_ports {TMDS_Data_p_0[1]}]

set_property PACKAGE_PIN J19 [get_ports {TMDS_Data_n_0[1]}]
set_property IOSTANDARD   TMDS_33      [get_ports {TMDS_Data_n_0[1]}]

# TMDS Data Lane 2
set_property PACKAGE_PIN J18 [get_ports {TMDS_Data_p_0[2]}]
set_property IOSTANDARD   TMDS_33      [get_ports {TMDS_Data_p_0[2]}]

set_property PACKAGE_PIN H18 [get_ports {TMDS_Data_n_0[2]}]
set_property IOSTANDARD   TMDS_33      [get_ports {TMDS_Data_n_0[2]}]
