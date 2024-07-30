# Clock signal
set_property PACKAGE_PIN W5 [get_ports main_clock]       
 set_property IOSTANDARD LVCMOS33 [get_ports main_clock]
set_property PACKAGE_PIN R2 [get_ports reset]     
 set_property IOSTANDARD LVCMOS33 [get_ports reset]
 
# LED signals
set_property PACKAGE_PIN U16 [get_ports {button_led_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {button_led_out[0]}]

set_property PACKAGE_PIN E19 [get_ports {button_led_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {button_led_out[1]}]

set_property PACKAGE_PIN U19 [get_ports {button_led_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {button_led_out[2]}]

set_property PACKAGE_PIN V19 [get_ports {button_led_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {button_led_out[3]}]

set_property PACKAGE_PIN W18 [get_ports {button_led_out[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {button_led_out[4]}]

set_property PACKAGE_PIN U15 [get_ports {button_led_out[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {button_led_out[5]}]