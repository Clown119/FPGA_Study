`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/14 12:55:32
// Design Name: 
// Module Name: decode
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


module decode(
    input       [3:0]   num ,
    output  reg [7:0]   seg 
    );

    always @(*) begin
        case (num)
            4'd0    :   seg =   8'h3F   ;
            4'd1    :   seg =   8'h06   ;
            4'd2    :   seg =   8'h5B   ;
            4'd3    :   seg =   8'h4F   ;
            4'd4    :   seg =   8'h66   ;
            4'd5    :   seg =   8'h6D   ;
            4'd6    :   seg =   8'h7D   ;
            4'd7    :   seg =   8'h07   ;
            4'd8    :   seg =   8'h7F   ;
            4'd9    :   seg =   8'h6F   ;
            default :   seg =   8'hFF   ; 
        endcase
    end

endmodule
