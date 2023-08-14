`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/14 10:07:08
// Design Name: 
// Module Name: seg
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


module seg(
    input               clk     ,
    input               rst_n   ,
    input       [13:00] din     ,
    output  reg [3:0]   dig     ,
    output      [7:0]   seg     
    );

    parameter   TIME_MS =   16'd50_000  ;
    reg     [15:00] cnt_ms  ;
    reg     [3:0]   num     ;
    wire    [3:0]   dig1    ;
    wire    [3:0]   dig2    ;
    wire    [3:0]   dig3    ;
    wire    [3:0]   dig4    ;

    assign  dig1    =   din    %   10              ;
    assign  dig2    =   din    /   10      %   10  ;
    assign  dig3    =   din    /   100     %   10  ;
    assign  dig4    =   din    /   1000    %   10  ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_ms  <=  16'd0   ;
        end
        else if(cnt_ms == TIME_MS - 16'd1)
            cnt_ms  <=  16'd0   ;
        else
            cnt_ms <=   cnt_ms  +   16'd1   ;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dig <=  4'b1110 ;
        end
        else if (cnt_ms == TIME_MS - 16'd1)
            dig <=  {dig[2:0], dig[3]}  ;
        else
            dig <=  dig     ;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            num <=  4'd0    ;
        end
        else begin
            case (dig)
                4'b1110    :   num <=  dig1    ;
                4'b1101    :   num <=  dig2    ;
                4'b1011    :   num <=  dig3    ;
                4'b0111    :   num <=  dig4    ;
                default :   num <=  4'd0    ;
            endcase
        end
    end

    decode decode_inst(
        .num        (num        ),
        .seg        (seg        )
    );

endmodule
