# my_RTL_designs

** Usage: ** 

''' bash
iverilog -g2012 -o module.vvp module.sv module_tb.sv
vvp module.vvp
''' bash

include the following in your tb so that a viewable .vcd file is generated as well
 
    $dumpfile("module.vcd");
    $dumpvars(0, module_tb);
