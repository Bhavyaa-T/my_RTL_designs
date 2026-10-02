module print_queue #(
  parameter DATA_WIDTH = 8,
  parameter ADDR_BITS  = 3
) (
  input  logic                  clk_i,
  input  logic                  rst_i,
  input  logic                  wr_i,
  input  logic [DATA_WIDTH-1:0] wdata_i,
  input  logic                  rd_i,
  output logic [DATA_WIDTH-1:0] rdata_o,
  output logic                  full_o,
  output logic                  empty_o
);

  // FIFO depth defined by no. addr bits
  // this will NOT be reset - so that it can be inferred as RAM
  logic [DATA_WIDTH-1:0] mem_r [0:(2**(ADDR_BITS)) - 1];

  // read/write pointers of width addr bits
  logic [ADDR_BITS-1:0] rd_ptr;
  logic [ADDR_BITS-1:0] wr_ptr;

  // counter to track full/empty - needs to be of size addr_bits since 
  // count == 2**ADDR_BITS is our check for full 
  logic [ADDR_BITS:0] counter;

  // internal signals to decide when pointer logic executes
  logic do_write, do_read;

  assign full_o = (counter == 2**ADDR_BITS);
  assign empty_o = (counter == 0);

  // this time we will do_write if write enabled AND 
  // NOT full OR Read enabled
  assign do_write = wr_i && (!full_o || rd_i);
  
  // note that we are not allowing the same criteria for 
  // empty. If there is nothing to read, we WILL refuse read
  assign do_read = rd_i && !empty_o;

  // combinational read - First Word Fall Through
  // oldest job always shows
  assign rdata_o = mem_r[rd_ptr];

  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      rd_ptr <= '0;
      wr_ptr <= '0;
      counter <= '0;
    end
    else begin
      if (do_read && do_write) begin
        mem_r[wr_ptr] <= wdata_i;
        wr_ptr <= wr_ptr + 1;
        rd_ptr <= rd_ptr + 1;
      end
      else if (do_write) begin
        mem_r[wr_ptr] <= wdata_i;
        wr_ptr <= wr_ptr + 1;
        counter <= counter + 1;
      end
      else if (do_read) begin
        rd_ptr <= rd_ptr + 1;
        counter <= counter - 1;
      end
    end
  end

endmodule
