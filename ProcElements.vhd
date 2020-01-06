----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Matthew Rutigliano & Will Lambrecht
-- 
-- Create Date:    07:55:46 02/27/2008 
-- Design Name: 
-- Module Name:    Control - Boss 
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

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Control is
    Port ( opcode : in  STD_LOGIC_VECTOR (5 downto 0);
           clk : in  STD_LOGIC;
           RegDst : out  STD_LOGIC;
           Branch : out  STD_LOGIC;
           MemRead : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC;
           ALUOp : out  STD_LOGIC_VECTOR(1 downto 0);
           MemWrite : out  STD_LOGIC;
           ALUSrc : out  STD_LOGIC;
		jump : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC);
end Control;

architecture Boss of Control is
	signal controlLine: std_logic_vector(9 downto 0);

begin
	jump <= controlLine(9);
	RegDst <= controlLine(8);
	ALUSrc <= controlLine(7);
	MemtoReg <= controlLine(6);
	--controlLine(5) and the clock control RegWrite
	MemRead <= controlLine(4);
	--controlLine(3) and the clock control MemWrite
	Branch <= controlLine(2);
	ALUOp <= controlLine(1 downto 0);

	with opcode select
		controlLine <= "0100100010" when "000000",	-- R-type
				"0011110000" when "100011",	-- lw
				"0010001000" when "101011",	-- sw
				"0000000101" when "000100",	-- beq
				"1000000000" when "000010",	-- jump
				"0010100000" when "001000",	-- addi
				"0000000000" when others;
		MemWrite <= controlLine(3) AND NOT clk;
		RegWrite <= controlLine(5) AND NOT clk;

end Boss;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Registers is
	Port (	ReadReg1, ReadReg2, WriteReg: in std_logic_vector(4 downto 0);
				WriteData: in std_logic_vector(31 downto 0);
				WriteCmd: in std_logic;
				ReadData1, ReadData2: out std_logic_vector(31 downto 0));
end entity Registers;

architecture remember of Registers is

component register32mod
	port(wordin: in std_logic_vector(31 downto 0);
		wordout: out std_logic_vector(31 downto 0);
		writeword, writelowhalfword, writelowbyte: in std_logic);
end component;


signal out0: std_logic_vector(31 downto 0);
signal out1: std_logic_vector(31 downto 0);
signal out2: std_logic_vector(31 downto 0);
signal out3: std_logic_vector(31 downto 0);
signal out4: std_logic_vector(31 downto 0);
signal out5: std_logic_vector(31 downto 0);
signal out6: std_logic_vector(31 downto 0);
signal out7: std_logic_vector(31 downto 0);
signal out8: std_logic_vector(31 downto 0);
signal out9: std_logic_vector(31 downto 0);
signal out10: std_logic_vector(31 downto 0);
signal out11: std_logic_vector(31 downto 0);
signal out12: std_logic_vector(31 downto 0);
signal out13: std_logic_vector(31 downto 0);
signal out14: std_logic_vector(31 downto 0);
signal out15: std_logic_vector(31 downto 0);

signal writeEnable: std_logic_vector(15 downto 0);
signal selector: std_logic_vector(15 downto 0);

begin

	with WriteReg select
		writeEnable <= "0000000000000001" when "00001",
							"0000000000000010" when "00010",
							"0000000000000100" when "00011",
							"0000000000001000" when "00100",
							"0000000000010000" when "00101",
							"0000000000100000" when "00110",
							"0000000001000000" when "00111",
							"0000000010000000" when "01000",
							"0000000100000000" when "01001",
							"0000001000000000" when "01010",
							"0000010000000000" when "01011",
							"0000100000000000" when "01100",
							"0001000000000000" when "01101",
							"0010000000000000" when "01110",
							"0100000000000000" when "01111",
							"1000000000000000" when "10000",
							"0000000000000000" when others;
	selection: for i in 0 to 15 generate
		selector(i) <= WriteCmd And writeEnable(i);
	end generate;
		
	reg0 : register32mod port map (WriteData, out0, selector(0), selector(0), selector(0));
	reg1 : register32mod port map (WriteData, out1, selector(1), selector(1), selector(1));
	reg2 : register32mod port map (WriteData, out2, selector(2), selector(2), selector(2));
	reg3 : register32mod port map (WriteData, out3, selector(3), selector(3), selector(3));
	reg4 : register32mod port map (WriteData, out4, selector(4), selector(4), selector(4));
	reg5 : register32mod port map (WriteData, out5, selector(5), selector(5), selector(5));
	reg6 : register32mod port map (WriteData, out6, selector(6), selector(6), selector(6));
	reg7 : register32mod port map (WriteData, out7, selector(7), selector(7), selector(7));
	reg8 : register32mod port map (WriteData, out8, selector(8), selector(8), selector(8));
	reg9 : register32mod port map (WriteData, out9, selector(9), selector(9), selector(9));
	reg10 : register32mod port map (WriteData, out10, selector(10), selector(10), selector(10));
	reg11 : register32mod port map (WriteData, out11, selector(11), selector(11), selector(11));
	reg12 : register32mod port map (WriteData, out12, selector(12), selector(12), selector(12));
	reg13 : register32mod port map (WriteData, out13, selector(13), selector(13), selector(13));
	reg14 : register32mod port map (WriteData, out14, selector(14), selector(14), selector(14));
	reg15 : register32mod port map (WriteData, out15, selector(15), selector(15), selector(15));
	
	with ReadReg1 select
	ReadData1 <= "00000000000000000000000000000000" when "00000",
					out0 when "00001",
					out1 when "00010",
					out2 when "00011",
					out3 when "00100",
					out4 when "00101",
					out5 when "00110",
					out6 when "00111",
					out7 when "01000",
					out8 when "01001",
					out9 when "01010",
					out10 when "01011",
					out11 when "01100",
					out12 when "01101",
					out13 when "01110",
					out14 when "01111",
					out15 when "10000",
			"ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when others;
					
	with ReadReg2 select
	ReadData2 <= "00000000000000000000000000000000" when "00000",
					out0 when "00001",
					out1 when "00010",
					out2 when "00011",
					out3 when "00100",
					out4 when "00101",
					out5 when "00110",
					out6 when "00111",
					out7 when "01000",
					out8 when "01001",
					out9 when "01010",
					out10 when "01011",
					out11 when "01100",
					out12 when "01101",
					out13 when "01110",
					out14 when "01111",
					out15 when "10000",
			"ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when others;

end remember;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
	Port(	DataIn1,DataIn2: in std_logic_vector(31 downto 0);
			Control: in std_logic_vector(4 downto 0);
			Zero: out std_logic;
			ALUResult: out std_logic_vector(31 downto 0) );
end entity ALU;

architecture cogs of ALU is

	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
				datain_b: in std_logic_vector(31 downto 0);
				add_sub: in std_logic;
				dataout: out std_logic_vector(31 downto 0);
				co: out std_logic);
	end component;
	
	component shift_register
		port(datain: in std_logic_vector(31 downto 0);
			dir: in std_logic;
			shamt:	in std_logic_vector(1 downto 0);
			dataout: out std_logic_vector(31 downto 0));
	end component;

	signal addSubResult: std_logic_vector(31 downto 0);
	signal shiftResult: std_logic_vector(31 downto 0);
	signal carry     : std_logic;
	signal selector : std_logic_vector(2 downto 0);
	signal andrea   : std_logic_vector(31 downto 0);
	signal orphelia : std_logic_vector(31 downto 0);
	signal zeroProbe: std_logic_vector(31 downto 0);
	
begin
	selector <= Control(2 downto 0);
	
	adderSubber : adder_subtracter port map (DataIn1, DataIn2, Control(2), addSubResult, carry);
	shifty : shift_register port map (DataIn2, Control(2), Control(4 downto 3), shiftResult);

	
	andrea <= DataIn1 AND DataIn2;
	orphelia <= DataIn1 OR DataIn2;
	

	zeroProbe <= andrea when selector = "000" else
			orphelia when selector = "001" else
			addSubResult when selector = "010" else
			shiftResult when selector = "011" else
			addSubResult when selector = "110" else
			shiftResult when selector = "111" else
			"ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";

	ALUResult <= zeroProbe;
					  
		

	Zero <= '1' when zeroProbe = "00000000000000000000000000000000" else
				'0';

end architecture cogs;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BusMux2to1 is
	Port(	selector: in std_logic;
			In0, In1: in std_logic_vector(31 downto 0);
			Result: out std_logic_vector(31 downto 0) );
end entity BusMux2to1;

architecture selection of BusMux2to1 is

begin
	with selector select
		Result <= In0 when '0',
			In1 when others;
end architecture selection;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALUControl is
	Port(	funct: in std_logic_vector(5 downto 0);
			shamt: in std_logic_vector(1 downto 0);
			op: in std_logic_vector(1 downto 0);
			aluctrl: out std_logic_vector(4 downto 0) );
end entity ALUControl;

architecture bossy of ALUControl is

begin
	-- outputs the stuff we need
	-- 0000: AND
	-- 0001: OR
	-- 0010: ADD
	-- 0110: SUB
	aluctrl <= "00000" when (funct = "100100" and op = "10") -- AND
			else "00001" when (funct = "100101" and op = "10") -- OR
			else "00010" when (funct = "100000" and op = "10") -- ADD
			else "00110" when (funct = "100010" and op = "10") -- SUB
			else "00110" when op = "01" -- beq
			else shamt & "011" when (funct = "000000" and op = "10") --shift left logical
			else shamt & "111" when (funct = "000010" and op = "10"); -- shift right logical
	
end architecture bossy;