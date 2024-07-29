module buttonCheck(
    input wire clk,            // Clock input
    input wire rst,            // Reset input
    input wire btnU,           // Button Up
    input wire btnD,           // Button Down
    input wire sw1,            // Switch 1 (units)
    input wire sw2,    
    input dp,        // Switch 2 (tens)
    output reg [6:0] cikis,    // 7-segment segments
    output reg [3:0] anode     // 7-segment anodes
);

    reg [15:0] number;         // 16-bit number to display (0-9999)
    reg [3:0] digit;           // Current digit to display

    // Debouncing parameters
    parameter DEBOUNCE_TIME = 50000; // Adjust as needed for debouncing (e.g., 50ms)

    reg [15:0] btnU_counter;
    reg [15:0] btnD_counter;
    reg btnU_state, btnD_state;
    reg btnU_pressed, btnD_pressed;

    reg [19:0] refresh_counter; // Refresh counter for 7-segment multiplexing
    wire [1:0] refresh_digit;   // Current digit to refresh

    assign refresh_digit = refresh_counter[19:18];

    // Combined debouncing and state machine for btnU and btnD
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            btnU_counter <= 0;
            btnD_counter <= 0;
            btnU_state <= 0;
            btnD_state <= 0;
            btnU_pressed <= 0;
            btnD_pressed <= 0;
            number <= 16'b0;
            refresh_counter <= 0;
        end else begin
            // Debouncing logic for btnU
            if (btnU && !btnU_state) begin
                if (btnU_counter < DEBOUNCE_TIME)
                    btnU_counter <= btnU_counter + 1;
                else begin
                    btnU_state <= 1;
                    btnU_pressed <= 1;
                    btnU_counter <= 0; // reset counter
                end
            end else if (!btnU) begin
                btnU_state <= 0;
                btnU_counter <= 0;
            end
            
            // Debouncing logic for btnD
            if (btnD && !btnD_state) begin
                if (btnD_counter < DEBOUNCE_TIME)
                    btnD_counter <= btnD_counter + 1;
                else begin
                    btnD_state <= 1;
                    btnD_pressed <= 1;
                    btnD_counter <= 0; // reset counter
                end
            end else if (!btnD) begin
                btnD_state <= 0;
                btnD_counter <= 0;
            end

            // Increment or decrement the number based on button press
            if (btnU_pressed) begin
                if (sw1) begin
                    // Change units and handle carry
                    if (number % 10 == 9) begin
                        number <= number + 1;
                    end else begin
                        number <= number + 1;
                    end
                end else if (sw2) begin
                    // Change tens and handle carry
                    if ((number / 10) % 10 == 9) begin
                        number <= number + 10;
                        
                    end else begin
                        number <= number + 10;
                    end
                end
                btnU_pressed <= 0; // reset the flag after increment
            end else if (btnD_pressed) begin
                if (sw1) begin
                    // Change units and handle borrow
                    if (number % 10 == 0) begin
                        number <= number - 1;
                    end else begin
                        number <= number - 1;
                    end
                end else if (sw2) begin
                    // Change tens and handle borrow
                    if ((number / 10) % 10 == 0) begin
                        number <= number - 10;
                    end else begin
                        number <= number - 10;
                    end
                end
                btnD_pressed <= 0; // reset the flag after decrement
            end

            // Refresh counter for multiplexing 7-segment displays
            refresh_counter <= refresh_counter + 1;
        end
    end

    // Extract digits from the number
    wire [3:0] thousands = (number / 1000) % 10;
    wire [3:0] hundreds  = (number / 100) % 10;
    wire [3:0] tens      = (number / 10) % 10;
    wire [3:0] units     = number % 10;

    // Select the digit to display based on refresh_digit
    always @(*) begin
        case (refresh_digit)
            2'b00: digit = units;
            2'b01: digit = tens;
            2'b10: digit = hundreds;
            2'b11: digit = thousands;
            default: digit = 4'b0000;
        endcase
    end

    // 7-segment display decoding
    always @(*) begin
        case (digit)
            4'b0000: cikis = 7'b1000000;
            4'b0001: cikis = 7'b1111001;
            4'b0010: cikis = 7'b0100100;
            4'b0011: cikis = 7'b0110000;
            4'b0100: cikis = 7'b0011001;
            4'b0101: cikis = 7'b0010010;
            4'b0110: cikis = 7'b0000010;
            4'b0111: cikis = 7'b1111000;
            4'b1000: cikis = 7'b0000000;
            4'b1001: cikis = 7'b0010000;
            default: cikis = 7'b1111111; // Display nothing
        endcase
    end

    // Enable the corresponding anode for the current digit
    always @(*) begin
        case (refresh_digit)
            2'b00: anode = 4'b1110; // Enable units
            2'b01: anode = 4'b1101; // Enable tens
            2'b10: anode = 4'b1011; // Enable hundreds
            2'b11: anode = 4'b0111; // Enable thousands
            default: anode = 4'b1111; // Disable all
        endcase
    end
endmodule
