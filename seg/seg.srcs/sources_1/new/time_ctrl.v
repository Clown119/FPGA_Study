`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/14 11:25:38
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


module time_ctrl #(
    parameter   TIME_S  =   26'd50_000_000      ,
    parameter   T       =   7'd100              
) (
    input                clk     ,
    input                rst_n   ,
    input                key     ,
    output  reg  [6:0]   time_ctrl
    );

    reg [25:00] cnt_s   ;
    reg [6:0]   cnt     ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_s   <=  26'd0   ;
        end
        else if (cnt_s == TIME_S - 26'd1)
            cnt_s   <=  26'd0   ;
        else
            cnt_s   <=  cnt_s   +   26'd1   ;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <=  7'd0    ;
        end
        else if (cnt_s == TIME_S - 26'd1) 
            if (cnt == T - 7'd1)
                cnt <=  7'd0    ;
            else
                cnt <=  cnt +   7'd1    ;
        else
            cnt <=  cnt ;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            time_ctrl   <=  7'd0    ;
        end
        else if (key) begin
            time_ctrl   <=  cnt ;
        end
        else if (!key)
            time_ctrl   <=  T  -   cnt ;
        else
            time_ctrl   <=  time_ctrl   ;
    end

endmodule
