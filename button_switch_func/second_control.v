module second_control(
    input clk,            // System clock
    input [5:0] sw,       // Switch inputs for setting seconds
    output reg [5:0] sec, // Current seconds count
    output [5:0] led      // LED outputs for displaying seconds
);

    // Register to store previous switch value
    reg [5:0] prev_sw;

    // Assign the current seconds count to LEDs
    assign led = sec;

    // Main control logic
    always @(posedge clk) begin
        // Check if switch inputs have changed
        if (sw != prev_sw) begin
            sec <= sw; // Update seconds count with switch value
            prev_sw <= sw; // Store current switch value
        end
    end
endmodule

