`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2024 10:42:03 AM
// Design Name: 
// Module Name: clock_divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clock_divider(
  input clk,            // 100MHz clock input
  input switch_x10,     // 10Hz switch
  input switch_x100,    // 100Hz switch
  input switch_x1000,   // 1000Hz switch
  output reg clk_hz    // clock output
      );

    reg clk1hz;     // 1Hz clock output
    reg clk10hz;    // 10Hz clock output
    reg clk100hz;   // 100Hz clock output
    reg clk1000hz;  // 1000Hz clock output
   
    reg [26:0] counter; // clock counter
    reg [2:0] switches;   // switch array
    
always @(*) begin
    switches = {switch_x1000, switch_x100, switch_x10};
end            
           
always @(posedge clk) begin              
    casex (switches[2:0])
        3'd0: // for 1Hz output
            begin
                counter <= counter + 1;
                if (counter >= 50000000) begin
                    clk1hz <= ~clk1hz;
                    counter <= 0;
                end
                clk_hz <= clk1hz; 
            end

        3'b1??: // for 1000Hz output
            begin
                counter <= counter + 1;
                if (counter >= 50000) begin
                    clk1000hz <= ~clk1000hz;
                    counter <= 0;
                end
                clk_hz <= clk1000hz;
            end

        3'b01?: // for 100Hz output
            begin
                counter <= counter + 1;
                if (counter >= 500000) begin
                    clk100hz <= ~clk100hz;
                    counter <= 0;
                end
                clk_hz <= clk100hz;
            end

        3'b001: // for 10Hz output
            begin
                counter <= counter + 1;
                if (counter >= 5000000) begin
                    clk10hz <= ~clk10hz;
                    counter <= 0;
                end
                clk_hz <= clk10hz;
            end

        default: begin
            counter <= 0;
        end
    endcase
end

endmodule

