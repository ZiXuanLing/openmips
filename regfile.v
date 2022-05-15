/**
* Reg 通用寄存器组
*/

`include "defines.v"

module regfile (
    input wire clk,  
    input wire rst,  

    // write
    input wire we,
    input wire[`RegAddrBus] wadddr,
    input wire[`RegBus] wdata,

    // read 1
    input wire re1,
    input wire[`RegAddrBus] raddr1,
    output wire[`RegBus] rdata1,

    // read2
    input wire re2,
    input wire[`RegAddrBus] raddr2,
    output wire[`RegBus] rdata2,
);
    reg[`RegBus] regs[0: `RegNum - 1];

    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            // `RegNumLog2'h0为00000000000000000000000000000000,表示第一个寄存器$,不可写
            if ((we == `WriteEnable) && (wadddr != `RegNumLog2'h0)) begin
                regs[wadddr] = wdata;
            end
        end
    end

    always @(*) begin
        if (rst == `RstEnable) begin
            rdata1 <= `ZeroWord;
        end else if (raddr1 == `RegNumLog2'h0) begin
            rdata1 <= `ZeroWord;
        // 当存在数据相关,但是两条指令之间间隔大于等于2时,写寄存器和读寄存器可以相同，此时直接读该写数据，消除了该数据冲突
        end else if ((raddr1 == wadddr) && (we == `WriteEnable) && (re1 == `ReadEnable)) begin
            rdata1 <= wdata;
        end else if (re1 == `ReadEnable) begin
            rdata1 <= regs[wadddr];
        end else begin
            rdata1 <= `ZeroWord;
        end
    end

    always @(*) begin
        if (rst == `RstEnable) begin
            rdata2 <= `ZeroWord;
        end else if (raddr2 == `RegNumLog2'h0) begin
            rdata2 <= `ZeroWord;
        // 当存在数据相关,但是两条指令之间间隔大于等于2时,写寄存器和读寄存器可以相同，此时直接读该写数据，消除了该数据冲突
        end else if ((raddr2 == wadddr) && (we == `WriteEnable) && (re2 == `ReadEnable)) begin
            rdata2 <= wdata;
        end else if (re2 == `ReadEnable) begin
            rdata2 <= regs[wadddr];
        end else begin
            rdata2 <= `ZeroWord;
        end
    end

endmodule