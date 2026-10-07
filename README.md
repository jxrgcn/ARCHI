# 8086 Assembly Calculator Project

## 1. Project Introduction
This project is an original 8086 Assembly calculator designed to run inside a DOSBox environment using TASM/TLINK. The program follows the professor's assignment requirements and demonstrates the same basic Assembly concepts used in the reference screenshot: input reading, ASCII conversion, arithmetic, decimal output, stack handling, and DOS INT 21H I/O.

## 2. Problem / Purpose
The goal is to create a simple command-line calculator that accepts:
- First number
- Operation: +, -, *, /
- Second number

Then it performs the arithmetic operation and shows the result. The program must handle multiple-digit numbers, negative results, zero results, and division by zero safely.

## 3. Features
- Accepts single-digit and multi-digit numbers
- Supports +, -, *, and /
- Performs arithmetic in 8086 Assembly instructions
- Displays negative results correctly
- Handles division by zero without crashing
- Repeats the calculator loop until the user exits
- Uses DOS interrupt 21H for console I/O
- Uses procedures similar to classroom examples

## 4. How the Calculator Works
The program starts by displaying the title and then prompts for the first number. It reads each number digit by digit using a custom READ_NUM procedure. After the user enters the operator, the program reads the second number and executes the required arithmetic instruction.

The result is then printed using PRINT_NUM, which converts the binary result into ASCII digits and displays it on the screen.

## 5. User Input
The calculator expects the following flow:
1. First number
2. Operation
3. Second number
4. Result
5. Repeat or exit

Examples:
- 25 + 17 = 42
- 10 - 25 = -15
- 12 * 5 = 60
- 20 / 4 = 5

## 6. READ_NUM Explanation
The READ_NUM procedure reads keyboard input one character at a time.

Conceptually:
- Read a character from keyboard
- Check if Enter was pressed
- Make sure it is a digit
- Convert ASCII to numeric value by subtracting '0'
- Multiply the current total by 10
- Add the new digit

This is the same idea as the professor's sample code:

current_number = current_number * 10 + digit

This is implemented using Assembly instructions such as:
- MOV
- MUL
- ADD
- CMP
- JMP

## 7. Operation Selection
The user enters one of these symbols:
- +
- -
- *
- /

The program compares the entered character using CMP and directs execution to the correct operation branch.

Example:
- CMP AL, '+'
- JE ADDITION
- CMP AL, '-'
- JE SUBTRACTION

Any invalid operation displays:
- Invalid operation!

## 8. Addition Logic
Addition is performed with the 8086 ADD instruction.

Example:
- AX = FIRST
- ADD AX, SECOND

This stores the sum in AX and then PRINT_NUM converts it to a printable decimal value.

## 9. Subtraction Logic
Subtraction uses the SUB instruction.

Example:
- AX = FIRST
- SUB AX, SECOND

If the result is negative, the program prints a '-' sign and uses NEG AX before printing the magnitude.

## 10. Multiplication Logic
Multiplication uses the 8086 MUL instruction.

Example:
- AX = FIRST
- BX = SECOND
- MUL BX

This multiplies AX by BX, producing a 16-bit product in DX:AX.

## 11. Division Logic
Division uses DIV.

Example:
- AX = FIRST
- BX = SECOND
- XOR DX, DX
- DIV BX

The quotient ends up in AX, and if needed the remainder remains in DX.

The program checks for division by zero before executing the division instruction.

## 12. PRINT_NUM Explanation
The PRINT_NUM procedure prints a signed decimal number using a classic stack-based technique.

It works like this:
1. Check if AX is negative
2. Print a '-' sign when needed
3. Use NEG AX to make it positive
4. Divide by 10 repeatedly
5. Push each remainder onto the stack
6. Pop values in reverse order
7. Convert digits to ASCII
8. Display each digit using DOS INT 21H

This technique is very similar to the screenshot's output logic and is a standard 8086 approach.

## 13. ASCII Conversion
The calculator converts digits between ASCII and numeric values using simple arithmetic.

Examples:
- ASCII '5' -> numeric 5 by subtracting '0'
- Numeric 5 -> ASCII '5' by adding '0'

This is essential for both input reading and output printing.

## 14. Decimal Conversion
Decimal conversion is handled by repeated division by 10.

Example for 123:
- 123 / 10 = 12 remainder 3
- 12 / 10 = 1 remainder 2
- 1 / 10 = 0 remainder 1

The remainders are stored in the stack and then printed in reverse order, producing 123.

## 15. Stack Usage
The stack is used to reverse the digit order during output.

The program pushes remainders onto the stack while dividing by 10, then pops them in reverse order to print the number correctly.

This is a key concept in the professor's reference program.

## 16. DOS INT 21H
The program uses DOS interrupt 21H for all console I/O.

Examples:
- AH = 09H for printing strings
- AH = 02H for printing a single character
- AH = 01H for reading keyboard input

INT 21H is the classic DOS interface used in 8086 Assembly programs.

## 17. Error Handling
The program includes error handling for:
- Invalid operation
- Division by zero

Example:
- Enter operation (+, -, *, /): %
- Invalid operation!

Example:
- 20 / 0
- Error: Cannot divide by zero.

## 18. Demonstration Test Cases
The program was designed to handle the following examples:

1. Addition
   - 10 + 20 = 30

2. Subtraction
   - 25 - 10 = 15

3. Negative subtraction
   - 10 - 25 = -15

4. Multiplication
   - 12 * 5 = 60

5. Division
   - 20 / 4 = 5

6. Multi-digit addition
   - 125 + 375 = 500

7. Division with remainder
   - 20 / 3 = 6

8. Division by zero
   - 20 / 0 = error

9. Zero result
   - 50 - 50 = 0

## 19. Limitations
This project is intentionally designed to be simple and educational. It is suitable for a student assignment and follows the professor's expected 8086 level.

Limitations include:
- Only integer arithmetic is supported
- No floating-point calculations
- No GUI interface
- No advanced memory management

## 20. Conclusion
This calculator is a classic 8086 Assembly console program that demonstrates the core topics taught in the classroom: input reading, arithmetic, data conversion, stack usage, and DOS-level I/O. It is intentionally kept at a manageable student level while still meeting the assignment requirements.

The final result is a complete DOS-based calculator application that should be suitable for a professor's evaluation and for a related presentation video.

## How to Assemble and Run in DOSBox
1. Start DOSBox.
2. Mount the folder containing the source code.
3. Compile:

   TASM CALC.ASM
   TLINK CALC.OBJ

4. Run:

   CALC

Example:

   mount c C:\project
   c:
   tasm calc.asm
   tlink calc.obj
   calc

## Presentation Guide
Use the project explanation above as the basis for a 10-15 minute presentation.

Suggested structure:
1. Introduction to the project
2. Why Assembly was used
3. Program flow and user interface
4. Input reading with READ_NUM
5. Operation selection logic
6. Arithmetic instructions used
7. Output printing with PRINT_NUM
8. Stack and ASCII conversion
9. Error handling
10. Demonstration of sample test cases
11. Conclusion

## Possible Q&A
### Q: Why did you use Assembly Language?
A: Because the assignment requires 8086 Assembly and it demonstrates the low-level execution model, register operations, and direct hardware-level programming.

### Q: How does READ_NUM convert ASCII characters into a number?
A: It reads each character, verifies it is a digit, subtracts '0', multiplies the current number by 10, and adds the new digit.

### Q: Why do you multiply by 10 when reading multiple-digit numbers?
A: To shift the existing digits left by one decimal place before adding the next digit.

### Q: How does PRINT_NUM display a number?
A: It repeatedly divides by 10, pushes digits onto the stack, then pops them in reverse order to print the digits correctly.

### Q: Why do you use PUSH/POP when printing digits?
A: To reverse the sequence of remainders so the digits appear in the correct order.

### Q: Why do you divide by 10?
A: Because decimal digits are extracted one at a time through repeated division by 10.

### Q: How does the program detect a negative number?
A: It checks whether AX is less than zero. If so, it prints a '-' sign and then negates AX before printing the magnitude.

### Q: What happens when the user divides by zero?
A: The program checks the divisor first and prints an error message instead of executing DIV.

### Q: What is INT 21H?
A: It is the DOS interrupt used for keyboard input and screen output in 8086 DOS programs.

### Q: What registers are used?
A: AX, BX, CX, DX, and AL/BL/DL are used extensively for arithmetic, digits, and I/O.

### Q: Why is AX used for arithmetic?
A: AX is the main accumulator register and is used by many 8086 arithmetic instructions, including MUL and DIV.

### Q: What is the purpose of DS?
A: DS points to the data segment so the program can access variables and messages stored in memory.

### Q: What is the difference between MUL and IMUL?
A: MUL multiplies unsigned values, while IMUL multiplies signed values. This project uses unsigned arithmetic for the calculator because the inputs are treated as integer values for the assignment.

## Final Notes
This project is intentionally designed to match the expected style of a student-level 8086 Assembly assignment. It is simple, readable, educational, and runs in a classic DOSBox environment.
