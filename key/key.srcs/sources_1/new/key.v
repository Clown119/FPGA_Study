`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/14 16:44:35
// Design Name: 
// Module Name: key
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module key #(
    parameter   TIME_20MS   =   20'd1_000_000
) (
    input       clk     ,
    input       rst_n   ,
    input       key     ,
    output  reg key_out 
    );

    reg [19:00] cnt_20ms    ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_20ms    <=  20'd0   ;
        else if (!key) begin
            if (cnt_20ms == TIME_20MS - 20'd1)
                cnt_20ms    <=  cnt_20ms    ;
            else
                cnt_20ms    <=  cnt_20ms    +   20'd1   ;
        end
        else
            cnt_20ms    <=  20'd0   ;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            key_out <=  1'b0    ;
        else if (cnt_20ms == TIME_20MS - 20'd2)
            key_out <=  1'b1    ;
        else
            key_out <=  1'b0    ;
    end

endmodule
