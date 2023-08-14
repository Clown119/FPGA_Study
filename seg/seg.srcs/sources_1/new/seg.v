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


module seg #(
    parameter   TIME_S  =   26'd50_000_000  ,
    parameter   TIME_MS =   16'd50_000      ,
    parameter   T       =   7'd100          
) (
    input               clk     ,
    input               rst_n   ,
    input       [1:0]   key     ,
    output  reg [3:0]   dig     ,
    output  reg [7:0]   seg     
    );

    localparam      IDLE    =   2'b00   ;
    localparam      DIG1    =   2'b01   ;
    localparam      DIG2    =   2'b11   ;
    reg     [1:0]   cur_state           ;
    reg     [1:0]   next_state          ;
    reg     [15:00] cnt_ms              ;
    reg     [3:0]   num                 ;
    reg     [6:0]   time_ctrl           ;
    wire    [3:0]   dig1                ;
    wire    [3:0]   dig2                ;
    wire            key_flag            ;
    wire            key0                ;
    wire            key1                ;

    assign  dig1    =   time_ctrl   %   10  ;
    assign  dig2    =   time_ctrl   /   10  ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cur_state   <=  IDLE        ;
        end
            cur_state   <=  next_state  ;
    end

    always @(*) begin
        case (cur_state)
            IDLE    :   begin
                if (cnt_ms == TIME_MS - 16'd1) begin
                    next_state  =   DIG1        ;
                end
                else
                    next_state  =   cur_state   ;
            end
            DIG1    :   begin
                if (cnt_ms == TIME_MS - 16'd1)
                    next_state  =   DIG2        ;
                else
                    next_state  =   cur_state   ;
            end
            DIG2    :   begin
                if (cnt_ms == TIME_MS - 16'd1)
                    next_state  =   DIG1        ;
                else
                    next_state  =   cur_state   ;
            end
            default : next_state    =   IDLE    ;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_ms      <=  16'd0   ;
            num         <=  4'd0    ;
            dig         <=  4'hf    ;
        end
        else begin
            case (cur_state)
                IDLE    :   begin
                    if (!key[0] || !key[1]) begin
                        if (cnt_ms == TIME_MS - 16'd1) begin
                            cnt_ms  <=  16'd0       ;
                        end
                        else
                            cnt_ms  <=  cnt_ms  +   16'd1   ;
                    end
                    else begin
                        cnt_ms  <=  cnt_ms  ;
                    end
                    num         <=  4'd0    ;
                    dig         <=  4'd0    ;
                end
                DIG1    :   begin
                    if (cnt_ms == TIME_MS - 16'd1) begin
                        cnt_ms  <=  16'd0       ;
                    end
                    else
                        cnt_ms  <=  cnt_ms  +   16'd1   ;
                    num     <=  dig1    ;
                    dig     <=  4'b1110 ;
                end
                DIG2    :   begin
                    if (cnt_ms == TIME_MS - 16'd1) begin
                        cnt_ms  <=  16'd0       ;
                    end
                    else
                        cnt_ms  <=  cnt_ms  +   16'd1   ;
                    num     <=  dig2    ;
                    dig     <=  4'b1101 ;
                end
                default :   begin
                    cnt_ms      <=  16'd0   ;
                    num         <=  4'd0    ;
                    dig         <=  4'd0    ;
                end
            endcase
        end
    end

    time_ctrl #(
        .TIME_S (26'd50_000_000 ),
        .T      (7'd100         )
    ) time_ctrl_inst(
        .clk        (clk        ),
        .rst_n      (rst_n      ),
        .key        (key0       ),
        .time_ctrl  (time_ctrl  )
    );

    decode decode_inst(
        .num        (num        ),
        .seg        (seg        )
    );

    key key0_inst(
        .clk        (clk        ),
        .rst_n      (rst_n      ),
        .key        (key[0]     ),
        .key_flag   (key0       )
    );

    key key1_inst(
        .clk        (clk        ),
        .rst_n      (rst_n      ),
        .key        (key[1]     ),
        .key_flag   (key1       )
    );

endmodule
