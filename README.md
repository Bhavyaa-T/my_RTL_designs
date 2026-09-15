# my_RTL_designs

## Usage

Compile and run a module with its testbench:

```bash
iverilog -g2012 -o module.vvp module.sv module_tb.sv
vvp module.vvp
```

Include the following in your testbench to generate a viewable `.vcd` waveform file:

```systemverilog
$dumpfile("module.vcd");
$dumpvars(0, module_tb);
```
