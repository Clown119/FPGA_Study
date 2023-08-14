`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/14 16:43:15
// Design Name: 
// Module Name: top
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


module top #(
    parameter   TIME_20MS   =   20'd1_000_000
) (
    input       clk     ,
    input       rst_n   ,
    input       key     ,
    output  reg led     
    );

    wire    key_out ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            led <=  1'b0    ;
        else if (key_out)
            led <=  ~led    ;
        else
            led <=  led     ;
    end

    key #(
        .TIME_20MS  (TIME_20MS  )
    ) key1_inst(
        .clk        (clk        ),
        .rst_n      (rst_n      ),
        .key        (key        ),
        .key_out    (key_out    )
    );

endmodule
