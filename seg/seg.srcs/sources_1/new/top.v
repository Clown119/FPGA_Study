`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/14 15:09:10
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


module top(
    input               clk     ,
    input               rst_n   ,
    input       [2:0]   key     ,
    output      [3:0]   dig     ,
    output      [7:0]   seg     
    );

    parameter   TIME_S  =   26'd50_000_000  ;
    parameter   T       =   14'd9999        ;
    localparam  IDLE    =   3'b000          ,
                D1      =   3'b001          ,
                D2      =   3'b011          ,
                D3      =   3'b111          ,
                D4      =   3'b110          ,
                D5      =   3'b100          ,
                D6      =   3'b101          ;
    reg [25:00] cnt_s                       ;
    reg [2:0]   cur_state                   ;
    reg [2:0]   next_state                  ;
    wire        key1                        ;
    wire        key2                        ;
    wire        key3                        ;
    reg [13:00] din                         ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_s   <=  26'd0   ;
        else if (cnt_s == TIME_S - 26'd1)
            cnt_s   <=  26'd0   ;
        else
            cnt_s   <=  cnt_s   +   26'd1   ;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cur_state   <=  IDLE        ;
        else
            cur_state   <=  next_state  ;
    end

    always @(*) begin
        case (cur_state)
            IDLE    :   next_state  =   D1      ;
            D1      :   begin
                if (key1)
                    next_state  =   D2          ;
                else if (key2)
                    next_state  =   D3          ;
                else if (key3)
                    next_state  =   IDLE        ;
                else
                    next_state  =   cur_state   ;
            end
            D2      :   begin
                if (key1)
                    next_state  =   D1          ;
                else if (key2)
                    next_state  =   D4          ;
                else if (key3)
                    next_state  =   IDLE        ;
                else
                    next_state  =   cur_state   ;
            end
            D3      :   begin
                if (key1)
                    next_state  =   D2          ;
                else if (key2)
                    next_state  =   D5          ;
                else if (key3)
                    next_state  =   IDLE        ;
                else
                    next_state  =   cur_state   ;
            end
            D4      :   begin
                if (key1)
                    next_state  =   D1          ;
                else if (key2)
                    next_state  =   D6          ;
                else if (key3)
                    next_state  =   IDLE        ;
                else
                    next_state  =   cur_state   ;
            end
            D5      :   begin
                if (key1)
                    next_state  =   D2          ;
                else if (key2)
                    next_state  =   D3          ;
                else if (key3)
                    next_state  =   IDLE        ;
                else
                    next_state  =   cur_state   ;
            end
            D6      :   begin
                if (key1)
                    next_state  =   D1          ;
                else if (key2)
                    next_state  =   D4          ;
                else if (key3)
                    next_state  =   IDLE        ;
                else
                    next_state  =   cur_state   ;
            end
            default : next_state    =   IDLE    ;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            din <=  14'd0   ;
        else begin
            case (cur_state)
                IDLE    :   din <=  14'd0           ;
                D1      :   din <=  14'd0           ;
                D2      :   din <=  T               ;
                D3      :   begin
                    if (cnt_s == TIME_S - 26'd1) begin
                        if (din == T - 14'd1)
                            din <=  14'd0           ;
                        else
                            din <=  din +   14'd1   ;
                    end
                    else
                        din <=  din                 ;
                end
                D4      :   begin
                    if (cnt_s == TIME_S - 26'd1) begin
                        if (din == 14'd0)
                            din <=  T               ;
                        else
                            din <=  din -   14'd1   ;
                    end
                    else
                        din <=  din                 ;
                end
                D5      :   din <=  din             ;
                D6      :   din <=  din             ;
                default :   din <=  14'd0           ;
            endcase
        end
    end

    key key1_inst(
        .clk        (clk        ),
        .rst_n      (rst_n      ),
        .key        (key[0]     ),
        .key_out    (key1      )
    );

    key key2_inst(
        .clk        (clk        ),
        .rst_n      (rst_n      ),
        .key        (key[1]     ),
        .key_out    (key2      )
    );

    key key3_inst(
        .clk        (clk        ),
        .rst_n      (rst_n      ),
        .key        (key[2]     ),
        .key_out    (key3      )
    );

    seg(
        .clk        (clk        ),
        .rst_n      (rst_n      ),
        .din        (din        ),
        .dig        (dig        ),
        .seg        (seg        )
    );

endmodule
