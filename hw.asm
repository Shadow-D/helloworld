;输出彩色hello world!

;原理
;向B8000H~BFFFFH写入数据将出现在显示器上,分八页,每页25行,每行80列
;每个字符两个字节,偶地址为字符,奇地址为配色
;7(闪烁)654(背景)3(闪烁)210(颜色)

ASSUME CS:CODE,DS:DATA,SS:STACK;绑定段寄存器

DATA SEGMENT
    DB 'HELLO-WORLD!';显示字符
    ;六种配色
    DB 11111000B
    DB 11101001B
    DB 11001011B
    DB 10111100B
    DB 10011110B
    DB 10101101B
DATA ENDS

STACK SEGMENT STACK

STACK ENDS

CODE SEGMENT
    START:
        MOV AX,DATA;数据段寄存器存储数据首地址
        MOV DS,AX
        MOV AX,0B87CH;拓展段寄存器存储显示的起始位置
        MOV ES,AX
        MOV BX,12;配色偏移量
        MOV CX,12;循环次数
        MOV DI,0;配色后字符偏移量
        MOV SI,0;原始字符偏移量
        PRINT:
            MOV AL,DS:[SI];偶地址存字符
            MOV ES:[DI],AL
            MOV AH,DS:[BX];奇地址存配色
            MOV ES:[DI+1],AH
            ADD DI,2;每次循环后指向下一个字符位置
            INC BX
            INC SI
            CMP BX,18;因为配色只有六种,故每六次进行复位
            JE UP;六次后跳到up
            JMP CON;否则执行下一次循环
            UP:
                MOV BX,12
            CON:
        LOOP PRINT
        MOV AH,4CH;安全退出程序
        INT 21H
CODE ENDS
END START
            
