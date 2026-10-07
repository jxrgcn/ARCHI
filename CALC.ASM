.MODEL SMALL
.STACK 100H

.DATA
    msg1      DB 13, 10, 'Enter first number: $'
    msgOp     DB 13, 10, 'Enter operation (+, -, *, /): $'
    msg2      DB 13, 10, 'Enter second number: $'
    msgRes    DB 13, 10, 'Result: $'
    msgErr    DB 13, 10, 'Divide by zero error!$'
    msgAgain  DB 13, 10, 13, 10, 'Calculate again? (Y/N): $'
    
    num1      DW 0
    num2      DW 0
    op        DB 0

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

MAIN_LOOP:
    MOV AH, 09H
    LEA DX, msg1
    INT 21H
    CALL READ_NUM
    MOV num1, AX

    MOV AH, 09H
    LEA DX, msgOp
    INT 21H
    MOV AH, 01H
    INT 21H
    MOV op, AL

    MOV AH, 09H
    LEA DX, msg2
    INT 21H
    CALL READ_NUM
    MOV num2, AX

    MOV AH, 09H
    LEA DX, msgRes
    INT 21H

    MOV AX, num1
    MOV BX, num2
    
    CMP op, '+'
    JE DO_ADD
    CMP op, '-'
    JE DO_SUB
    CMP op, '*'
    JE DO_MUL
    CMP op, '/'
    JE DO_DIV
    JMP ASK_AGAIN

DO_ADD:
    ADD AX, BX
    CALL PRINT_NUM
    JMP ASK_AGAIN

DO_SUB:
    SUB AX, BX
    CALL PRINT_NUM
    JMP ASK_AGAIN

DO_MUL:
    IMUL BX
    CALL PRINT_NUM
    JMP ASK_AGAIN

DO_DIV:
    CMP BX, 0
    JE DIV_ZERO
    CWD
    IDIV BX
    CALL PRINT_NUM
    JMP ASK_AGAIN

DIV_ZERO:
    MOV AH, 09H
    LEA DX, msgErr
    INT 21H

ASK_AGAIN:
    MOV AH, 09H
    LEA DX, msgAgain
    INT 21H

    MOV AH, 01H
    INT 21H

    CMP AL, 'Y'
    JE RESTART_APP
    CMP AL, 'y'
    JE RESTART_APP
    JMP END_PROG

RESTART_APP:
    JMP MAIN_LOOP

END_PROG:
    MOV AH, 02H
    MOV DL, 13
    INT 21H
    MOV DL, 10
    INT 21H

    MOV AH, 4CH
    INT 21H
MAIN ENDP

READ_NUM PROC
    XOR BX, BX
    XOR DI, DI
READ_FIRST:
    MOV AH, 01H
    INT 21H
    CMP AL, '-'
    JNE READ_PROCESS
    MOV DI, 1
    JMP READ_LOOP
READ_LOOP:
    MOV AH, 01H
    INT 21H
READ_PROCESS:
    CMP AL, 13
    JE READ_DONE
    
    SUB AL, '0'
    XOR AH, AH
    MOV CX, AX
    
    MOV AX, BX
    MOV DX, 10
    MUL DX
    ADD AX, CX
    MOV BX, AX
    JMP READ_LOOP
READ_DONE:
    CMP DI, 1
    JNE READ_EXIT
    NEG BX
READ_EXIT:
    MOV AX, BX
    RET
READ_NUM ENDP

PRINT_NUM PROC
    CMP AX, 0       
    JGE IS_POSITIVE 
    
    PUSH AX         
    MOV AH, 02H     
    MOV DL, '-'     
    INT 21H         
    POP AX          
    NEG AX          

IS_POSITIVE:
    XOR CX, CX
    MOV BX, 10
PRINT_LOOP:
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE PRINT_LOOP

PRINT_DIGITS:
    POP DX
    ADD DL, '0'
    MOV AH, 02H
    INT 21H
    LOOP PRINT_DIGITS
    RET
PRINT_NUM ENDP

END MAIN