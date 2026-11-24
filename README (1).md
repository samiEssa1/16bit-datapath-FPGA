# 16-bit Accumulator Processor on FPGA

This is my project for the EE 3562 Microprocessor course at the Islamic University of Madinah. I designed a simple 16-bit processor in Verilog and ran it on a Nexys 3 FPGA board (Xilinx Spartan-6).

## What it does

- It has three 16-bit registers: A (the accumulator), B and C.
- It can run 16 instructions (add, subtract, shift, logic, move and more).
- You enter numbers with 8 switches, one byte at a time.
- The result is shown in hexadecimal on the 4-digit display.
- The design is saved in the board's flash memory, so it starts by itself when you turn it on.

## Instructions

| Op | Instruction | What it does | Op | Instruction | What it does |
|:--:|-------------|--------------|:--:|-------------|--------------|
| 0 | LOAD A | A = input | 8 | NOT A | A = NOT A |
| 1 | LOAD B | B = input | 9 | NOT B | B = NOT B |
| 2 | CLEAR A | A = 0 | A | ADD | A = A + B |
| 3 | CLEAR B | B = 0 | B | SUB | A = A − B |
| 4 | LSL A | shift A left (× 2) | C | INC A | A = A + 1 |
| 5 | LSR A | shift A right (÷ 2) | D | DEC A | A = A − 1 |
| 6 | MOV A→B | B = A | E | AND | A = A AND B |
| 7 | MOV B→A | A = B | F | OR | A = A OR B |

## How to use it

| Control | What it does |
|---------|--------------|
| 8 switches | Set one byte in binary. The LEDs show the switches. |
| LOAD HI | Save the switches as the high byte. The display shows HI. |
| LOAD LO | Save the switches as the low byte. The display shows LO. |
| OP+ / OP− | Choose the instruction. The display shows OP and the number. |
| EXEC | Run the instruction. The display shows the new value of A or B. |
| OP+ and OP− together | Reset everything. |

### Example: 1234 + 0005

1. Switches 0001 0010 → LOAD HI, then switches 0011 0100 → LOAD LO
2. Choose OP 0 (LOAD A) → EXEC → display shows 1234
3. Switches 0000 0000 → LOAD HI, then 0000 0101 → LOAD LO
4. Choose OP 1 (LOAD B) → EXEC → display shows 0005
5. Choose OP A (ADD) → EXEC → display shows 1239

> Always load both bytes. Each byte keeps its old value until you load it again.

## How it works

The design is made of small modules, and `top.v` connects them together:

- **button_conditioner** – cleans the button signal (debounce) and gives one short pulse for each press
- **opcode counter** – keeps the selected instruction (0 to F)
- **decoder** – turns the 4-bit opcode into 16 lines, one line for each instruction
- **staging register** – two 8-bit registers that hold the high and low byte of the input
- **register16** – registers A, B and C
- **mux** – chooses what goes into each register
- **ALU** – does the math and logic
- **controller** – makes the load and clear signals, only when EXEC is pressed
- **display_mux** – decides what to show (OP, HI, LO, A or B)
- **seg7 driver** – shows the 4 digits one after another very fast (1 ms each), so they look on all the time

## Results

- All 16 instructions were tested in simulation (51 checks, all passed) and on the board.
- It runs at 100 MHz with no timing errors.

## Files

| Folder | What is inside |
|--------|----------------|
| `src/` | Verilog source files |
| `sim/` | Testbenches |
| `constraints/` | `top.ucf` for the board, `top_box.ucf` for the box |
| `bitstream/` | `top.bit`, ready to load on the board |
| `docs/` | Report, presentation and photos |

## Tools

Verilog · Xilinx ISE 14.7 · ISim · Digilent Adept · Nexys 3 (Spartan-6 XC6SLX16)

## Future ideas

- Add program memory and a program counter, so it runs a full program by itself
- Add jump instructions and flags (Zero, Carry) for loops
- Show register C and the carry flag on the display
- Connect it to a PC with UART

## Author

Sami – Electrical Engineering student, Islamic University of Madinah
