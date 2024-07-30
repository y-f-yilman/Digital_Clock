module digital_clock(clk_1hz, time_in, time_out, time_ow);
  input clk_1hz, time_ow; // 1 Hz clock (clock), Time overwrite (asynchronous reset)
  // Time signal format: h[4:0]:m[5:0]:s[5:0] (hhhhh:mmmmmm:ssssss)
  input [16:0] time_in;
  output [16:0] time_out;

  // Separated time signals
  wire [5:0] sec_in, min_in;
  wire [4:0] hour_in;
  reg [5:0] sec_reg, min_reg;
  reg [4:0] hour_reg;

  // Separation and combination of time signals
  assign {hour_in, min_in, sec_in} = time_in;
  assign time_out = {hour_reg, min_reg, sec_reg};

  // Handle seconds
  always @(posedge clk_1hz or posedge time_ow)
    begin
      if (time_ow)
        begin
          sec_reg <= sec_in;
        end
      else
        begin
          sec_reg <= (sec_reg == 6'd59) ? 6'd0 : (sec_reg + 6'd1);
        end
    end

  // Handle minutes
  always @(posedge clk_1hz or posedge time_ow)
    begin
      if (time_ow)
        begin
          min_reg <= min_in;
        end
      else
        begin
          if (sec_reg == 6'd59)
            begin
              min_reg <= (min_reg == 6'd59) ? 6'd0 : (min_reg + 6'd1);
            end
        end
    end

  // Handle hours
  always @(posedge clk_1hz or posedge time_ow)
    begin
      if (time_ow)
        begin
          hour_reg <= hour_in;
        end
      else
        begin
          if ((sec_reg == 6'd59) && (min_reg == 6'd59))
            begin
              hour_reg <= (hour_reg == 5'd23) ? 5'd0 : (hour_reg + 5'd1);
            end
        end
    end
endmodule
