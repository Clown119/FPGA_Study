`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/15 12:36:10
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
reg     [1:0]   key;
wire    [3:0]   dig;
wire    [7:0]   seg;
        
top #(
    .COUNT       (5        ),
    .TIME_MS     (1        ),
    .TIME_20MS   (5        ),
    .TIME_S      (5        ),
    .TIME_M      (5        ),
    .TIME_H      (5        )    
    ) top_tb(
    .clk         (clk      ),
    .rst_n       (rst_n    ),
    .key         (key      ),
    .dig         (dig      ),
    .seg         (seg      )
    );

initial begin
    clk     =   1'b0    ;
    rst_n   =   1'b0    ;
    #30
    rst_n   =   1'b1    ;
end
always  #10 clk =   ~clk    ;

initial begin
    key    =   2'b11   ;
    //#600
    //key    =   2'b10   ;
    //#130
    //key    =   2'b11   ;
    //#130
    //key    =   2'b01   ;
    //#130
    //key    =   2'b11   ;
    //#130
    //key    =   2'b10   ;
    //#130
    //key    =   2'b11   ;
    //#130
    //key    =   2'b10   ;
    //#130
    //key    =   2'b11   ;
    //#130
    //key    =   2'b10   ;
    //#130
    //key    =   2'b11   ;
    //#130
    //key    =   2'b10   ;
    //#130
    //key    =   2'b11   ;
end

endmodule