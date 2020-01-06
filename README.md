# mips-microprocessor
MIPS Microprocessor created in VHDL, Spring 2019

Processor is capable of shifting three bits in both directions, adding, adding immediate,
subtracting, and-ing, or-ing, branching if equal, jumping, saving, and loading. Sixteen 32 bit registers
hold the instructions, while eight 32 bit registers make up the data memory. Outside of these register banks,
the main components are the ALU and the Controller (Both in ProcElements.vhd). ProcessorAssembly.vhd assembles
all the components.

This project was coded in ModelSim and Intel Quartus Prime.
