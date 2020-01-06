-- Matthew Rutigliano
-- ECEGR 2220
-- May 29th, 2019
-- Data Memory bank

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_arith.all;
Use ieee.std_logic_unsigned.all;

Entity DataMem is
Port( DataIn, Address: in std_logic_vector(31 downto 0);
	WriteEn: in std_logic;
	ReadEn: in std_logic;
	DataOut: out std_logic_vector(31 downto 0));
End entity;
Architecture Memory of DataMem is
	Component register32mod 
		Port (wordin: in std_logic_vector(31 downto 0);
			wordout: out std_logic_vector(31 downto 0);
			writeword, writelowhalfword, writelowbyte: in std_logic);
	End component;
	--Signal Prep: std_logic_vector(31 downto 0);
	Signal selector: std_logic_vector(2 downto 0);
	Signal write0: std_logic_vector (31 downto 0);
	Signal write1: std_logic_vector (31 downto 0);
	Signal write2: std_logic_vector (31 downto 0);
	Signal write3: std_logic_vector (31 downto 0);
	Signal write4: std_logic_vector (31 downto 0);
	Signal write5: std_logic_vector (31 downto 0);
	Signal write6: std_logic_vector (31 downto 0);
	Signal write7: std_logic_vector (31 downto 0);
	Signal read0: std_logic_vector (31 downto 0);
	Signal read1: std_logic_vector (31 downto 0);
	Signal read2: std_logic_vector (31 downto 0);
	Signal read3: std_logic_vector (31 downto 0);
	Signal read4: std_logic_vector (31 downto 0);
	Signal read5: std_logic_vector (31 downto 0);
	Signal read6: std_logic_vector (31 downto 0);
	Signal read7: std_logic_vector (31 downto 0);


Begin
	Selector <= Address(4 downto 2);
	re0: register32mod port map (write0, read0, WriteEn, WriteEn, WriteEn);
	re1: register32mod port map (write1, read1, WriteEn, WriteEn, WriteEn);
	re2: register32mod port map (write2, read2, WriteEn, WriteEn, WriteEn);
	re3: register32mod port map (write3, read3, WriteEn, WriteEn, WriteEn);
	re4: register32mod port map (write4, read4, WriteEn, WriteEn, WriteEn);
	re5: register32mod port map (write5, read5, WriteEn, WriteEn, WriteEn);
	re6: register32mod port map (write6, read6, WriteEn, WriteEn, WriteEn);
	re7: register32mod port map (write7, read7, WriteEn, WriteEn, WriteEn);
	dataOut <= read0 when selector = 0 and ReadEn = '1'
		else read1 when selector = 1 and ReadEn = '1'
		else read2 when selector = 2 and ReadEn = '1'
		else read3 when selector = 3 and ReadEn = '1'
		else read4 when selector = 4 and ReadEn = '1'
		else read5 when selector = 5 and ReadEn = '1'
		else read6 when selector = 6 and ReadEn = '1'
		else read7 when selector = 7 and ReadEn = '1';
	write0 <= DataIn when selector = 0
		else read0;
	write1 <= DataIn when selector = 1
		else read1;
	write2 <= DataIn when selector = 2
		else read2;
	write3 <= DataIn when selector = 3
		else read3;
	write4 <= DataIn when selector = 4
		else read4;
	write5 <= DataIn when selector = 5
		else read5;
	write6 <= DataIn when selector = 6
		else read6;
	write7 <= DataIn when selector = 7
		else read7;
End architecture Memory;

