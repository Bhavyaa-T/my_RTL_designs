module uart_tx (
    input  logic       clk,
    input  logic       reset,
    input  logic       start,
    input  logic [7:0] data,
    output logic       tx,
    output logic       busy
);

logic [3:0] bit_count;
logic [9:0] frame;

always_ff @(posedge clk) begin
    if (reset) begin
        tx        <= 1'b1;
        busy      <= 1'b0;
        bit_count <= 0;
    end
    else if (start && !busy) begin
        // {stop bit, data, start bit}
        frame     <= {1'b1, data, 1'b0};
        busy      <= 1'b1;
        bit_count <= 0;
    end
    else if (busy) begin
        tx <= frame[bit_count];

        if (bit_count == 9) begin
            busy <= 1'b0;
            tx   <= 1'b1;
        end
        else begin
            bit_count <= bit_count + 1;
        end
    end
end

endmodule
