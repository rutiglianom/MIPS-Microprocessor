----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Matthew Rutigliano & Will Lambrecht
-- 
-- Create Date:    11:11:17 02/27/2008 
-- Design Name: 
-- Module Name:    Processor - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SmallBusMux2to1 is
		Port(	selector: in std_logic;
				In0, In1: in std_logic_vector(4 downto 0);
				Result: out std_logic_vector(4 downto 0) );
end entity SmallBusMux2to1;

architecture switching of SmallBusMux2to1 is
begin
	with selector select
		Result <=	In0 when '0',
						In1 when '1',
						In1 when others;
end architecture switching;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Processor is

    Port ( instruction : in  STD_LOGIC_VECTOR (31 downto 0);
           DataMemdatain : in  STD_LOGIC_VECTOR (31 downto 0); -- Input for processor, output for DataMem
           DataMemdataout : out  STD_LOGIC_VECTOR (31 downto 0); -- Output for processor, input for DataMem
           InstMemAddr : out  STD_LOGIC_VECTOR (31 downto 0);
           DataMemAddr : out  STD_LOGIC_VECTOR (31 downto 0);
			  DataMemRead, DataMemWrite: out std_logic;
           clock : in  std_logic);
end Processor;

architecture holistic of Processor is
	component Control
		Port(opcode : in  STD_LOGIC_VECTOR (5 downto 0);
           clk : in  STD_LOGIC;
           RegDst : out  STD_LOGIC;
           Branch : out  STD_LOGIC;
           MemRead : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC;
           ALUOp : out  STD_LOGIC_VECTOR(1 downto 0);
           MemWrite : out  STD_LOGIC;
           ALUSrc : out  STD_LOGIC;
		jump: out std_logic;
           RegWrite : out  STD_LOGIC);
	end component;

	component Registers
		Port (	ReadReg1, ReadReg2, WriteReg: in std_logic_vector(4 downto 0);
					WriteData: in std_logic_vector(31 downto 0);
					WriteCmd: in std_logic;
					ReadData1, ReadData2: out std_logic_vector(31 downto 0));
	end component;
	
	component ALU
		Port(	DataIn1,DataIn2: in std_logic_vector(31 downto 0);
				Control: in std_logic_vector(4 downto 0);
				Zero: out std_logic;
				ALUResult: out std_logic_vector(31 downto 0) );
	end component;
	
	component BusMux2to1
		Port(	selector: in std_logic;
				In0, In1: in std_logic_vector(31 downto 0);
				Result: out std_logic_vector(31 downto 0) );
	end component;
	
	component SmallBusMux2to1
		Port(	selector: in std_logic;
				In0, In1: in std_logic_vector(4 downto 0);
				Result: out std_logic_vector(4 downto 0) );
	end component;
	
	component ALUControl
		Port(	funct: in std_logic_vector(5 downto 0);
				shamt: in std_logic_vector(1 downto 0);
				op: in std_logic_vector(1 downto 0);
				aluctrl: out std_logic_vector(4 downto 0) );
	end component;
	
	component register32mod
		port(	wordin: in std_logic_vector(31 downto 0);
				wordout: out std_logic_vector(31 downto 0);
				writeword, writelowhalfword, writelowbyte: in std_logic);
	end component;
	
	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
				datain_b: in std_logic_vector(31 downto 0);
				add_sub: in std_logic;
				dataout: out std_logic_vector(31 downto 0);
				co: out std_logic);
	end component;
	
	signal readData1: std_logic_vector(31 downto 0);
	signal readData2: std_logic_vector(31 downto 0);
	signal readDataMuxOut: std_logic_vector(31 downto 0);
	signal zeroOut: std_logic;
	signal aluResult: std_logic_vector(31 downto 0);
	signal aluControlOut: std_logic_vector(4 downto 0);
	signal writeRegMuxOut: std_logic_vector(4 downto 0);
	signal dataMemMuxOut: std_logic_vector(31 downto 0);
	signal aluSignExtend: std_logic_vector(31 downto 0);
	
	-- Control signals
	signal RegDst : STD_LOGIC;
        signal Branch : STD_LOGIC;
        signal MemRead : STD_LOGIC;
        signal MemtoReg : STD_LOGIC;
        signal ALUOp : STD_LOGIC_VECTOR(1 downto 0);
        signal MemWrite : STD_LOGIC;
        signal ALUSrc : STD_LOGIC;
        signal RegWrite : STD_LOGIC;
	signal jump: std_logic;

	-- PC incrementer signal
	signal constant4: std_logic_vector(31 downto 0);
	signal incrementAdderOut: std_logic_vector(31 downto 0);
	signal incrementAdderCarryOut: std_logic;
	signal shiftedInstruction: std_logic_vector(27 downto 0);
	signal jumpAddress: std_logic_vector(31 downto 0);
	signal adderLock: std_logic;
	signal PCOut: std_logic_vector(31 downto 0);
	signal PCIn: std_logic_vector(31 downto 0);
	
	-- Beq/j adder signals
	signal beqAdderOut: std_logic_vector(31 downto 0);
	signal beqAdderMux1Out: std_logic_vector(31 downto 0);
	signal beqAdderMux1Select: std_logic;
	signal beqAdderMux2Out: std_logic_vector(31 downto 0);
	signal shiftedDataInB: std_logic_vector(31 downto 0);
	signal carryOut: std_logic;

begin
	-- Register Bank
	writeRegMux: SmallBusMux2to1 port map(RegDst, instruction(20 downto 16), instruction(15 downto 11), writeRegMuxOut);
	registerBank: Registers port map(instruction(25 downto 21), instruction(20 downto 16), writeRegMuxOut, dataMemMuxOut, RegWrite, readData1, readData2);
	DataMemdataout <= readData2;

	-- ALU
	aluSignExtend <= "0000000000000000" & instruction(15 downto 0);
	readDataMux: BusMux2to1 port map(ALUSrc, readData2, aluSignExtend, readDataMuxOut);
	mainALU: ALU port map(readData1, readDataMuxOut, aluControlOut, zeroOut, aluResult);
	DataMemAddr <= aluResult;

	-- ALU Control
	ALUCont: ALUControl port map(instruction(5 downto 0), instruction(7 downto 6), ALUOp, aluControlOut);

	-- DataMem Mux
	dataMemMux: BusMux2to1 port map(MemtoReg, aluResult, DataMemdatain, dataMemMuxOut);

	-- PC Incrementer
	adderLock <= '0';
	constant4 <= "00000000000000000000000000000100";
	incrementAdder: adder_subtracter port map(PCOut, constant4, adderLock, incrementAdderOut, incrementAdderCarryOut);
	shiftedInstruction <= instruction(25 downto 0) & "00";
	jumpAddress <= incrementAdderOut(31 downto 28) & shiftedInstruction;
	

	-- Beq/j adder
	shiftedDataInB <= aluSignExtend(29 downto 0) & "00";
	beqAdder: adder_subtracter port map(incrementAdderOut, shiftedDataInB, adderLock, beqAdderOut, carryOut);
	beqAdderMux1Select <= Branch and zeroOut;
	beqAdderMux1: BusMux2to1 port map(beqAdderMux1Select, incrementAdderOut, beqAdderOut, beqAdderMux1Out);
	beqAdderMux2: BusMux2to1 port map(jump, beqAdderMux1Out, jumpAddress, beqAdderMux2Out);

	-- Control
	controller: Control port map(instruction(31 downto 26), clock, RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, jump, RegWrite);
	DataMemWrite <= MemWrite;
	DataMemRead <= MemRead;

	-- PC
	PCIn <= "00000000000000000000000000000000" when beqAdderMux2Out = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
		else beqAdderMux2Out;
	PC: register32mod port map(PCIn, PCOut, clock, clock, clock);
	InstMemAddr <= PCOut;
	

end architecture holistic;

