`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/14 18:38:53
// Design Name: 
// Module Name: tb
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


module tb();
reg    clk         ;
reg    rst_n       ;
reg    key         ;
wire   led        ;
        
top #(
        .TIME_20MS  (20'd10  )
    ) top_tb(
    .clk     (clk     ),
    .rst_n   (rst_n   ),
    .key     (key     ),
    .led     (led     )
    );

initial begin
    clk     =   1'b0    ;
    rst_n   =   1'b0    ;
    #30
    rst_n   =   1'b1    ;
end
always  #10 clk =   ~clk    ;

initial begin
    key =   1'b1    ;
    #50
    key =   1'b0    ;
    #300
    key =   1'b1    ;
    #50
    key =   1'b0    ;
    #240
    key =   1'b1    ;
end

endmodule
