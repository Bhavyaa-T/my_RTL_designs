module sample_tag_buffer (
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

  // Note that this design does NOT have a combinational bypass - the scenario when 
  // valid_o = 0, valid_i = 1, ready_i = 1 
  // should result in accepting the inputs ONLY and setting valid_o = 1
  // it will NOT bypass the inputs to the outputs
  
  // combinational ready_o signal 
  // this signal should be high if either our output register is empty (contains junk)
  // or if the downstream is ready
  assign ready_o = ~valid_o || ready_i;
  
  // valid_o is registered and is our flag for whether the output register is empty or not
  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      valid_o <= 0;
      data_o <= '0;
      tag_o <= '0;
    end
    // if output reg is full, upstream valid, and downstream ready we will keep valid_o high
    // and simply refill output reg with new inputs
    else if (valid_o && ready_i && valid_i) begin
      data_o <= data_i;
      tag_o <= tag_i;
    end
    // if output reg is full and downstream is ready, we will drop valid_o
    else if (valid_o && ready_i) begin
      valid_o <= 0;
    end
    // if output reg is empty and upstream is valid, we will store inputs and set valid_o high
    else if (~valid_o && valid_i) begin
      data_o <= data_i;
      tag_o <= tag_i;
      valid_o <= 1;
    end
  end


      
endmodule
