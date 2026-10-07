.MODEL SMALL
.STACK 100H

.DATA
    prompt1   DB 13, 10, 'Enter first number: $'
    promptOp  DB 13, 10, 'Enter operation (+, -, *, /): $'
    prompt2   DB 13, 10, 'Enter second number: $'
    resultMsg DB 13, 10, 'Result: $'
    zeroMsg   DB 13, 10, 'Divide by zero error!$'
    retryMsg  DB 13, 10, 13, 10, 'Calculate again? (Y/N): $'

    firstNum  DW 0
    secondNum DW 0
    operator  DB 0

.CODE

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

CALCULATE:
    ; Get first number
    MOV AH, 09H
    LEA DX, prompt1
    INT 21H

    CALL READ_NUM
    MOV firstNum, AX

    ; Get operation
    MOV AH, 09H
    LEA DX, promptOp
    INT 21H

    MOV AH, 01H
    INT 21H
    MOV operator, AL

    ; Get second number
    MOV AH, 09H
    LEA DX, prompt2
    INT 21H

    CALL READ_NUM
    MOV secondNum, AX

    ; Display result
    MOV AH, 09H
    LEA DX, resultMsg
    INT 21H

    MOV AX, firstNum
    MOV BX, secondNum

    CMP operator, '+'
    JE ADDITION

    CMP operator, '-'
    JE SUBTRACTION

    CMP operator, '*'
    JE MULTIPLICATION

    CMP operator, '/'
    JE DIVISION

    JMP ASK_RETRY


ADDITION:
    ADD AX, BX
    CALL PRINT_NUM
    JMP ASK_RETRY


SUBTRACTION:
    SUB AX, BX
    CALL PRINT_NUM
    JMP ASK_RETRY


MULTIPLICATION:
    IMUL BX
    CALL PRINT_NUM
    JMP ASK_RETRY


DIVISION:
    CMP BX, 0
    JE ZERO_ERROR

    CWD
    IDIV BX
    CALL PRINT_NUM
    JMP ASK_RETRY


ZERO_ERROR:
    MOV AH, 09H
    LEA DX, zeroMsg
    INT 21H


ASK_RETRY:
    MOV AH, 09H
    LEA DX, retryMsg
    INT 21H

    MOV AH, 01H
    INT 21H

    CMP AL, 'Y'
    JE START_OVER

    CMP AL, 'y'
    JE START_OVER

    JMP EXIT_PROGRAM


START_OVER:
    JMP CALCULATE


EXIT_PROGRAM:
    MOV AH, 02H
    MOV DL, 13
    INT 21H

    MOV DL, 10
    INT 21H

    MOV AH, 4CH
    INT 21H

MAIN ENDP


; Read number
READ_NUM PROC
    XOR BX, BX
    XOR DI, DI

GET_CHARACTER:
    MOV AH, 01H
    INT 21H

    CMP AL, '-'
    JNE CHECK_INPUT

    MOV DI, 1
    JMP GET_CHARACTER


CHECK_INPUT:
    CMP AL, 13
    JE FINISH_INPUT

    SUB AL, '0'
    XOR AH, AH

    MOV CX, AX

    MOV AX, BX
    MOV DX, 10
    MUL DX

    ADD AX, CX
    MOV BX, AX

    JMP GET_CHARACTER


FINISH_INPUT:
    CMP DI, 1
    JNE RETURN_NUMBER

    NEG BX


RETURN_NUMBER:
    MOV AX, BX
    RET

READ_NUM ENDP


; Print number
PRINT_NUM PROC
    CMP AX, 0
    JGE PRINT_POSITIVE

    PUSH AX

    MOV AH, 02H
    MOV DL, '-'
    INT 21H

    POP AX
    NEG AX


PRINT_POSITIVE:
    XOR CX, CX
    MOV BX, 10


CONVERT_DIGITS:
    XOR DX, DX
    DIV BX

    PUSH DX
    INC CX

    CMP AX, 0
    JNE CONVERT_DIGITS


OUTPUT_DIGITS:
    POP DX
    ADD DL, '0'

    MOV AH, 02H
    INT 21H

    LOOP OUTPUT_DIGITS

    RET

PRINT_NUM ENDP

END MAIN