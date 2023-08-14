`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/14 19:45:09
// Design Name: 
// Module Name: time_ctrl
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


module #(
    parameter   TIME_S  =   26'd50_000_000  ,
    parameter   M       =   6'd60           ,
    parameter   H       =   5'd24           
) time_ctrl(
    input           clk     ,
    input           rst_n   ,
    output  [11:00] time_out  
    );

    reg [25:00] cnt_s   ;
    reg [5:0]   cnt_m   ;
    reg [4:0]   cnt_h   ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_s
    end

endmodule
