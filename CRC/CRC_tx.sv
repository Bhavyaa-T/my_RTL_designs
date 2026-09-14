// Serial CRC-8 (polynomial x^8 + x^2 + x + 1): the shift chain doing long division
module crc8_serial (
  input  logic       clk_i,
  input  logic       rst_i,
  input  logic       en_i,
  input  logic       d_i,
  output logic [7:0] crc_o
);

  // generator x^8 + x^2 + x + 1: the x^8 term is the feedback itself,
  // the low eight coefficients are 0x07
  localparam logic [7:0] POLY = 8'h07;

  logic [7:0] crc_r;
  logic [7:0] crc_next;
  logic       fb;

  // the division decision: leading remainder bit XOR the incoming message bit
  assign fb = crc_r[7] ^ d_i;

  // shift left; where the polynomial has a 1, fb flips the bit on its way past
  assign crc_next = {crc_r[6:0], 1'b0} ^ (fb ? POLY : 8'h00);

  always_ff @(posedge clk_i) begin
    if (rst_i)
      crc_r <= 8'h00;
    else if (en_i)
      crc_r <= crc_next;
  end

  assign crc_o = crc_r;

endmodule
