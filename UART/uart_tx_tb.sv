module uart_tx_tb;

logic clk = 0;
logic reset;
logic start;
logic [7:0] data;
logic tx;
logic busy;

uart_tx dut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .data(data),
    .tx(tx),
    .busy(busy)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("uart_tx.vcd");
    $dumpvars(0, uart_tx_tb);

    reset = 1;
    start = 0;
    data  = 0;

    #20;
    reset = 0;

    #10;
    data  = 8'h55;   // 01010101
    start = 1;

    #10;
    start = 0;

    #150;
    $finish;
end

endmodule
