/**
* IF 模块
* PC程序计数器
*/

`include "defines.v"

module pc_reg (
    input wire clk,  // 时钟信号
    input wire rst,  // 复位信号
    input wire[5:0] stall,  // 来自控制模块CTRL

    output reg[`InstAddrBus] pc,  // pc
    output reg ce,  // 指令存储器使能信号

    input wire branch_flag_i,  // 是否发生转移
    input wire[`RegBus] branch_target_address_i  // 转移到的目标地址
);
    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            ce <= `ChipEnable; 
        end else begin
            ce <= `ChipDisable;  
        end
    end

    always @(posedge clk) begin
        if (ce == `ChipDisable) begin
            pc <= 32'h00000000;
        // 当stall[0]为NoStop时，pc加4，否则，pc保持不变
        end else if (stall[0] == `NoStop) begin
            if (branch_flag_i == `Branch) begin
                pc <= branch_target_address_i;
            end else begin
                pc <= pc + 4'h4;
            end
        end
    end
endmodule