CS 254: Course Project

Team Members:
- Ankit Kumar Misra (190050020)
- Devansh Jain  (190100044)
- Harshit Varma (190100055)
- Richeek Das (190260036)

File Descriptions:

code/
    ALU.vhd                : Basic Arithmatic and Logical Unit
    FSM.vhd                : The Finite State Machine
    IITBProc.vhd           : Top Level Entity
    MUXes.vhd              : Package of different MUXes
    Memory.vhd             : Async Memory with Read/Write
    OneBitAdder.vhd        : Single bit Full Adder
    OneBitRegister.vhd     : Async Single Bit Register
    RegisterFile.vhd       : Async Register File
    SixteenBitAdder.vhd    : 16-bit Ripple Carry Adder
    SixteenBitNand.vhd     : 16-bit NAND Operation
    SixteenBitRegister.vhd : Async 16-bit Register
    Testbench.vhd          : Used for testing

utils/
    hex2instr.py : Converts a hexadecimal instruction to it's human-readable string form
    instr2hex.py : Converts the string form of an instruction to the corresponding hexadecimal form