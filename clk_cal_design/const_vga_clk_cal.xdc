# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk_100MHz]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk_100MHz]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk_100MHz]
 
# Switches
## sw0
set_property PACKAGE_PIN V17 	 [get_ports {switch_0}]					
set_property IOSTANDARD LVCMOS33 [get_ports {switch_0}]
## sw1
set_property PACKAGE_PIN V16 	 [get_ports {switch_1}]					
set_property IOSTANDARD LVCMOS33 [get_ports {switch_1}]
## sw2
set_property PACKAGE_PIN W16 	 [get_ports {switch_2}]					
set_property IOSTANDARD LVCMOS33 [get_ports {switch_2}]
## sw3
set_property PACKAGE_PIN W17 	 [get_ports {switch_3}]					
set_property IOSTANDARD LVCMOS33 [get_ports {switch_3}]
## sw4
set_property PACKAGE_PIN W15 	 [get_ports {switch_4}]					
set_property IOSTANDARD LVCMOS33 [get_ports {switch_4}]
## sw5
set_property PACKAGE_PIN V15 	 [get_ports {switch_5}]					
set_property IOSTANDARD LVCMOS33 [get_ports {switch_5}]
## sw12
set_property PACKAGE_PIN W2 	 [get_ports {reset}]					
set_property IOSTANDARD LVCMOS33 [get_ports {reset}]
## sw13
set_property PACKAGE_PIN U1 	 [get_ports {switch_13}]					
set_property IOSTANDARD LVCMOS33 [get_ports {switch_13}]
## sw14
set_property PACKAGE_PIN T1 	 [get_ports {switch_14}]					
set_property IOSTANDARD LVCMOS33 [get_ports {switch_14}]
## sw15
set_property PACKAGE_PIN R2 	 [get_ports {switch_15}]					
set_property IOSTANDARD LVCMOS33 [get_ports {switch_15}]



# LEDs
## LED 0
set_property PACKAGE_PIN U16 	 [get_ports {leds[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {leds[0]}]
## LED 1
set_property PACKAGE_PIN E19 	 [get_ports {leds[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {leds[1]}]
## LED 2
set_property PACKAGE_PIN U19 	 [get_ports {leds[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {leds[2]}]
## LED 3
set_property PACKAGE_PIN V19 	 [get_ports {leds[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {leds[3]}]
## LED 4
set_property PACKAGE_PIN W18 	 [get_ports {leds[4]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {leds[4]}]
## LED 5
set_property PACKAGE_PIN U15 	 [get_ports {leds[5]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {leds[5]}]


##Buttons
## btnC
set_property PACKAGE_PIN U18 	 [get_ports pause]						
set_property IOSTANDARD LVCMOS33 [get_ports pause]
## btnU
set_property PACKAGE_PIN T18 	 [get_ports inc_hr]						
set_property IOSTANDARD LVCMOS33 [get_ports inc_hr]
## btnL
set_property PACKAGE_PIN W19 	 [get_ports dec_min]						
set_property IOSTANDARD LVCMOS33 [get_ports dec_min]
## btnR
set_property PACKAGE_PIN T17 	 [get_ports inc_min]						
set_property IOSTANDARD LVCMOS33 [get_ports inc_min]
## btnD
set_property PACKAGE_PIN U17 	 [get_ports dec_hr]						
set_property IOSTANDARD LVCMOS33 [get_ports dec_hr]

##7 segment display
set_property PACKAGE_PIN W7 	 [get_ports {seg[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property PACKAGE_PIN W6 	 [get_ports {seg[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN U8 	 [get_ports {seg[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V8 	 [get_ports {seg[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 	 [get_ports {seg[4]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN V5 	 [get_ports {seg[5]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN U7 	 [get_ports {seg[6]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]
set_property PACKAGE_PIN U2 	 [get_ports {an[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 	 [get_ports {an[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 	 [get_ports {an[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 	 [get_ports {an[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]

##VGA Connector
set_property PACKAGE_PIN N19     [get_ports {rgb[11]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[11]}]
set_property PACKAGE_PIN J19     [get_ports {rgb[10]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[10]}]
set_property PACKAGE_PIN H19     [get_ports {rgb[9]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[9]}]
set_property PACKAGE_PIN G19     [get_ports {rgb[8]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[8]}]
set_property PACKAGE_PIN D17     [get_ports {rgb[7]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[7]}]
set_property PACKAGE_PIN G17     [get_ports {rgb[6]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[6]}]
set_property PACKAGE_PIN H17     [get_ports {rgb[5]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[5]}]
set_property PACKAGE_PIN J17     [get_ports {rgb[4]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[4]}]
set_property PACKAGE_PIN J18     [get_ports {rgb[3]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[3]}]
set_property PACKAGE_PIN K18     [get_ports {rgb[2]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[2]}]
set_property PACKAGE_PIN L18     [get_ports {rgb[1]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[1]}]
set_property PACKAGE_PIN N18     [get_ports {rgb[0]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[0]}]
set_property PACKAGE_PIN P19     [get_ports hsync]						
set_property IOSTANDARD LVCMOS33 [get_ports hsync]
set_property PACKAGE_PIN R19     [get_ports vsync]						
set_property IOSTANDARD LVCMOS33 [get_ports vsync]
