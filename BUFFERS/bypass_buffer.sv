module bypass_buffer (
  input logic clk_i,
  input logic rst_i,
  input logic valid_i,
  input logic ready_i,
  input logic [7:0] data_i,
  input logic [3:0] tag_i,
  output logic ready_o,
  output logic valid_o,
  output logic [7:0] data_o,
  output logic [3:0] tag_o
);
  // TODO: implement the cycle contract.
  logic [7:0] data_buff;
  logic [3:0] tag_buff;
  logic full_flag;
  logic in_hs;
  logic out_hs;

  // this always_comb block will deal with 
  // combinationally setting what all 4 outputs show
  always_comb begin
    // depending on full_flag, data/tag_o either points at the buffer or at the input
    // valid_o will decide the criteria for when the consumer can look at these values
    data_o = (rst_i) ? '0 : ((full_flag) ? data_buff : data_i);
    tag_o = (rst_i) ? '0 : ((full_flag) ? tag_buff : tag_i);
    
    valid_o = ~rst_i && (full_flag || valid_i);

    ready_o = rst_i || ~full_flag || ready_i;

  // Our handshake criteria for in and out
  // in the clocked block, we will consider the 4 different examples of this 
    in_hs = valid_i && ready_o;
    out_hs = ready_i && valid_o;
  end

  // the clocked block will deal with manipulating full_flag
  // and transfers into the buffer
  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      data_buff <= '0;
      tag_buff <= '0;
      full_flag <= 0;
    end
    else begin
      // if full flag low no change required,
      // if full flag high fill the buffer 
      if (in_hs && out_hs) begin
        if (full_flag) begin
          data_buff <= data_i;
          tag_buff <= tag_i;
        end
      end
      // if full flag low fill buffer and set full flag high
      // else do nothing
      else if (in_hs) begin
        if (~full_flag) begin
          data_buff <= data_i;
          tag_buff <= tag_i;
          full_flag <= 1;
        end
      end
      // if full flag high, set full flag low (in theory could clear buffer but this wont do anything)
      // else do nothing
      else if (out_hs) begin
        if (full_flag) begin
          full_flag <= 0;
        end
      end
      // if neither handshake then don't change anything
      else begin
      end
    end
  end
              
      
endmodule
