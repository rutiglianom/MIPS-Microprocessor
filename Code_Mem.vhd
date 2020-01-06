-- Matthew Rutigliano & Will Lambrecht
-- Lab 4

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_arith.all;
Use ieee.std_logic_unsigned.all;

entity code_mem is
	port(address: in std_logic_vector(31 downto 0);
		 instruction: out std_logic_vector(31 downto 0) );
end entity code_mem;

architecture memlike of code_mem is
	signal in1: std_logic_vector(31 downto 0);
	signal in2: std_logic_vector(31 downto 0);
	signal in3: std_logic_vector(31 downto 0);
	signal in4: std_logic_vector(31 downto 0);
	signal in5: std_logic_vector(31 downto 0);
	signal in6: std_logic_vector(31 downto 0);
	signal in7: std_logic_vector(31 downto 0);
	signal in8: std_logic_vector(31 downto 0);
	signal in9: std_logic_vector(31 downto 0);
	signal in10: std_logic_vector(31 downto 0);
	signal in11: std_logic_vector(31 downto 0);
	signal in12: std_logic_vector(31 downto 0);
	signal in13: std_logic_vector(31 downto 0);
	signal in14: std_logic_vector(31 downto 0);
	signal in15: std_logic_vector(31 downto 0);
	signal in16: std_logic_vector(31 downto 0);
begin
	-- provide 16 instructions in response to 16 sequential addresses
	-- at the input. Choose instructions we will implement.


	-- Hardcoded instruction bay
	in1 <= "00000000000000000100100000100000";	-- Add $t1, $zero, $zero
	in2 <= "00100001001010001001000000001000";	-- Addi $t0, $t1, 0x9008
	in3 <= "00000000000010000101000011000000";	-- Sll $t2, $t0, 3
	in4 <= "00000000000010100101100011000000";	-- Sll $t3, $t2, 3
	in5 <= "00000000000010110110000011000000";	-- Sll $t4, $t3, 3
	in6 <= "00000000000011000110100011000000";	-- Sll $t5, $t4, 3
	in7 <= "00000000000011010111000011000000";	-- Sll $t6, $t5, 3
	in8 <= "00000000000011100111100001000000";	-- Sll $t7, $t6, 1
	in9 <= "00100001000010010000000000000010";	-- Addi $t1, $t0, 2
	in10 <= "10101101111010010000000000000000";	-- Sw $t1, 0($t7)
	in11 <= "10001101111010100000000000000000";	-- Lw $t2, 0($t7)
	in12 <= "00010001001010100000000000000001";	-- Beq $t1, $t2, Branch
	in13 <= "00000000000000000100000000100010";	-- Sub $t0, $zero, $zero
	in14 <= "00001000000000000000000000001111";	-- Branch: j jump
	in15 <= "00000001010010010101000000100100";	-- And $t3, $t2, $t1
	in16 <= "00000001010010110110000000100000";	-- jump: Add $t4, $t2, $t3

	with address select
		instruction <= 	in1 when "00000000000000000000000000000000",
				in2 when "00000000000000000000000000000100",
				in3 when "00000000000000000000000000001000",
				in4 when "00000000000000000000000000001100",
				in5 when "00000000000000000000000000010000",
				in6 when "00000000000000000000000000010100",
				in7 when "00000000000000000000000000011000",
				in8 when "00000000000000000000000000011100",
				in9 when "00000000000000000000000000100000",
				in10 when "00000000000000000000000000100100",
				in11 when "00000000000000000000000000101000",
				in12 when "00000000000000000000000000101100",
				in13 when "00000000000000000000000000110000",
				in14 when "00000000000000000000000000110100",
				in15 when "00000000000000000000000000111000",
				in16 when "00000000000000000000000000111100",
				"ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when others;
end architecture memlike;
