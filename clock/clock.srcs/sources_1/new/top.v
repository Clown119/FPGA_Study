`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/15 09:36:31
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
    parameter   COUNT       =   26'd50_000_000  ,
    parameter   TIME_MS     =   16'd50_000      ,
    parameter   TIME_20MS   =   20'd1_000_000   ,
    parameter   TIME_S      =   26'd50_000_000  ,
    parameter   TIME_M      =   6'd60           ,
    parameter   TIME_H      =   5'd24           
    ) (
    input               clk     ,
    input               rst_n   ,
    input       [1:0]   key     ,
    output      [3:0]   dig     ,
    output      [7:0]   seg     
    );

    localparam  IDLE    =   3'b000  ;
    localparam  D0      =   3'b001  ;
    localparam  D1      =   3'b011  ;
    localparam  D2      =   3'b111  ;
    localparam  D3      =   3'b110  ;
    localparam  D4      =   3'b100  ;
    reg     [2:0]   cur_state   ;
    reg     [2:0]   next_state  ;
    wire    [10:00] time_ctrl   ;
    reg     [10:00] seg_in      ;
    wire            key1        ;
    wire            key2        ;
    reg             en_time     ;
    reg             refresh     ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cur_state   <=  IDLE        ;
        else
            cur_state   <=  next_state  ;
    end

    always @(*) begin
        case(cur_state)
            IDLE    :   next_state  =   D0      ;
            D0      :   begin
                if (key1)
                    next_state  =   D1          ;
                else
                    next_state  =   cur_state   ;
            end
            D1      :   begin
                if (key1)
                    next_state  =   D2          ;
                else
                    next_state  =   cur_state   ;
            end
            D2      :   begin
                if (key1)
                    next_state  =   D3          ;
                else
                    next_state  =   cur_state   ;
            end
            D3      :   begin
                if (key1)
                    next_state  =   D4          ;
                else
                    next_state  =   cur_state   ;
            end
            D4      :   begin
                if (key1)
                    next_state  =   D0          ;
                else
                    next_state  =   cur_state   ;
            end
            default :   next_state  =   IDLE    ;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_time <=  1'b0    ;
            refresh <=  1'b0    ;
            seg_in  <=  11'd0   ;
        end
        else begin
            case(cur_state)
                IDLE    :   begin
                    en_time <=  1'b0        ;
                    refresh <=  1'b0        ;
                    seg_in  <=  11'd0       ;
                end
                D0      :   begin
                    en_time <=  1'b1        ;
                    refresh <=  1'b0        ;
                    seg_in  <=  time_ctrl   ;
                end
                D1      :   begin
                    en_time <=  1'b0        ;
                    if (key2) begin
                        refresh <=  1'b1    ;
                        if (time_ctrl[5:0] == TIME_M - 6'd1) begin
                            seg_in[5:0] <=  6'd0    ;
                            if (time_ctrl[10:6] == TIME_H - 5'd1)
                                seg_in[10:6] <=  5'd0    ;
                            else
                                seg_in[10:6] <=  time_ctrl[10:6] +   5'd1    ;
                        end
                        else
                            seg_in[5:0]  <=  time_ctrl[5:0]  +   6'd1    ;
                    end
                    else begin
                        refresh <=  1'b0        ;
                        seg_in  <=  time_ctrl   ;
                    end
                end
                D2      :   begin
                    en_time <=  1'b0        ;
                    if (key2) begin
                        refresh <=  1'b1    ;
                        if (time_ctrl[5:0] == 6'd0) begin
                            seg_in[5:0] <=  TIME_M - 6'd1   ;
                            if (time_ctrl[10:6] == 5'd0)
                                seg_in[10:6] <=  5'd0    ;
                            else
                                seg_in[10:6] <=  time_ctrl[10:6]    -   5'd1    ;
                        end
                        else
                            seg_in[5:0]  <=  time_ctrl[5:0]  -   6'd1    ;
                    end
                    else begin
                        refresh <=  1'b0        ;
                        seg_in  <=  time_ctrl   ;
                    end
                end
                D3      :   begin
                    en_time <=  1'b0        ;
                    if (key2) begin
                        refresh <=  1'b1    ;
                        if (time_ctrl[10:6] == TIME_H - 5'd1) begin
                            seg_in[10:6] <=  5'd0    ;
                        end
                        else
                            seg_in[10:6]  <=  time_ctrl[10:6]  +   5'd1    ;
                        seg_in[5:0]  <=  time_ctrl[5:0] ;
                    end
                    else begin
                        refresh <=  1'b0        ;
                        seg_in  <=  time_ctrl   ;
                    end
                end
                D4      :   begin
                    en_time <=  1'b0        ;
                    if (key2) begin
                        refresh <=  1'b1    ;
                        if (time_ctrl[10:6] == 5'd0) begin
                            seg_in[10:6] <=  TIME_H - 5'd1  ;
                        end
                        else
                            seg_in[10:6]  <=  time_ctrl[10:6]  -   5'd1    ;
                        seg_in[5:0]  <=  time_ctrl[5:0] ;
                    end
                    else begin
                        refresh <=  1'b0        ;
                        seg_in  <=  time_ctrl   ;
                    end
                end
                default :   begin
                    en_time <=  1'b0    ;
                    refresh <=  1'b0    ;
                    seg_in  <=  11'd0   ;
                end
            endcase
        end
    end

    time_ctrl #(
        .COUNT      (COUNT      ),
        .TIME_S     (TIME_S     ),
        .TIME_M     (TIME_M     ),
        .TIME_H     (TIME_H     )
    ) time_ctrl_inst(
        .clk        (clk        ),
        .rst_n      (rst_n      ),
        .en         (en_time    ),
        .refresh    (refresh    ),
        .time_in    (seg_in     ),
        .time_out   (time_ctrl  )  
    );

    seg #(
        .TIME_MS    (TIME_MS    )  
    ) seg_inst(
        .clk        (clk        ),
        .rst_n      (rst_n      ),
        .seg_in     (seg_in     ),
        .dig        (dig        ),
        .seg        (seg        )
    );

    key #(
        .TIME_20MS  (TIME_20MS  )
    ) key1_inst(
        .clk        (clk        ),
        .rst_n      (rst_n      ),
        .key        (key[0]     ),
        .key_out    (key1       )
    );

    key #(
        .TIME_20MS  (TIME_20MS  )
    ) key2_inst(
        .clk        (clk        ),
        .rst_n      (rst_n      ),
        .key        (key[1]     ),
        .key_out    (key2       )
    );

endmodule
