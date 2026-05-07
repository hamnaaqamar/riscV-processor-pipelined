`timescale 1ns/1ps

module tb_processor();
    reg clk;
    reg reset;

    processor dut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("simulation.vcd");
        $dumpvars(0, tb_processor);
        
        // Initialize registers with test data
        // x9=20, x10=10, x11=5
        dut.RF.registers[9]  = 32'd20;
        dut.RF.registers[10] = 32'd10;
        dut.RF.registers[11] = 32'd5;
        dut.RF.registers[0]  = 32'd0; // Hardwired zero

        clk = 0;
        reset = 1;
        #20 reset = 0;

        #250; // Allow time for pipeline to finish

        $display("--- SIMULATION RESULTS ---");
        $display("x5 (20+10) = %d [Expected 30]", dut.RF.registers[5]);
        $display("x6 (30-5)  = %d [Expected 25]", dut.RF.registers[6]);
        $display("x7 (Load)  = %d [Expected 25]", dut.RF.registers[7]);
        $display("x8 (25+30) = %d [Expected 55]", dut.RF.registers[8]);

        if (dut.RF.registers[6] === 32'd25 && dut.RF.registers[8] === 32'd55)
            $display("SUCCESS: Forwarding and Stalling are working!");
        else
            $display("FAILURE: Hazard logic incorrect.");

        $finish;
    end
endmodule