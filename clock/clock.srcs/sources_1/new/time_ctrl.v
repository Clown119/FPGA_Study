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


module time_ctrl #(
    parameter   COUNT   =   26'd50_000_000  ,
    parameter   TIME_S  =   6'd60           ,
    parameter   TIME_M  =   6'd60           ,
    parameter   TIME_H  =   5'd24           
    ) (
    input           clk     ,
    input           rst_n   ,
    input           en      ,
    input           refresh ,
    input   [10:00] time_in ,
    output  [10:00] time_out  
    );

    reg [25:00] cnt     ;
    reg [5:0]   cnt_s   ;
    reg [5:0]   cnt_m   ;
    reg [4:0]   cnt_h   ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt   <=  26'd0   ;
        else if (en) begin
            if (cnt == COUNT - 26'd1)
                cnt   <=  26'd0   ;
            else
                cnt   <=  cnt   +   26'd1   ;
        end
        else
            cnt   <=  26'd0   ;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_s   <=  6'd0    ;
        else if (cnt == COUNT - 26'd1) begin
            if (cnt_s == TIME_S - 6'd1)
                cnt_s   <=  6'd0    ;
            else
                cnt_s   <=  cnt_s   +   6'd1   ;
        end
        else
            cnt_s   <=  cnt_s   ;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_m   <=  6'd0    ;
        else if (refresh)
            cnt_m   <=  time_in[5:0]    ;
        else if (cnt_s == TIME_S - 6'd1 && cnt == COUNT - 26'd1) begin
            if (cnt_m == TIME_M - 6'd1)
                cnt_m   <=  6'd0    ;
            else
                cnt_m   <=  cnt_m   +   6'd1   ;
        end
        else
            cnt_m   <=  cnt_m   ;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_h   <=  5'd0    ;
        else if (refresh)
            cnt_h   <=  time_in[10:06]  ;
        else if (cnt_m == TIME_M - 6'd1 && cnt_s == TIME_S - 6'd1 && cnt == COUNT - 26'd1) begin
            if (cnt_h == TIME_H - 5'd1)
                cnt_h   <=  5'd0    ;
            else
                cnt_h   <=  cnt_h   +   5'd1   ;
        end
        else
            cnt_h   <=  cnt_h   ;
    end

    assign  time_out    =   {cnt_h, cnt_m}      ;

endmodule
