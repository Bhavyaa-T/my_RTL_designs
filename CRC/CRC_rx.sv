// End-of-train command checker: CRC-8 over the whole frame, polynomial 0x1D,
// start value 0xFF, MSB first; frame_ok = the frame divided clean
module train_tail_crc (
  input  logic clk_i,
  input  logic rst_i,
  input  logic en_i,
  input  logic d_i,
  input  logic last_i,
  output logic frame_ok_o
);

  localparam POLY = 8'h1D;

  logic [7:0] crc_r, crc_r_next;
  logic fb;
  logic verdict_flag;

  assign fb = crc_r[7] ^ d_i;

  assign crc_r_next = {crc_r[6:0], 1'b0} ^ (fb ? POLY: 8'h00);
  
  // YOUR CODE HERE
  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      crc_r <= 8'hFF;
      verdict_flag <= 0;
      frame_ok_o <= 0;
    end
    else if (en_i & ~verdict_flag) begin
      if (last_i) begin
        frame_ok_o <= &(~crc_r_next);
        verdict_flag <= 1;
      end
      else begin 
        crc_r <= crc_r_next;
      end
    end
  end

endmodule
