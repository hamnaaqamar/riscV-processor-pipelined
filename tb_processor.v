`timescale 1ns/1ps

module tb_processor();
    reg clk;
    reg reset;

    // Instantiate the processor
    processor dut (
        .clk(clk),
        .reset(reset)
    );

    // Clock Generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("simulation.vcd");
        $dumpvars(0, tb_processor);
        
        clk = 0;
        reset = 1;
        #20;
        reset = 0;

        #1000;
        $display("Simulation Finished");
        #10; // Wait a bit for the final WB
if (dut.RF.registers[5] === 32'h00000000) // Replace with expected hex result
    $display("TEST PASSED: x5 has the correct value.");
else
    $display("TEST FAILED: x5 is %h", dut.RF.registers[5]);
        $finish;
    end
endmodule