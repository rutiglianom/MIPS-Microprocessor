Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_arith.all;
Use ieee.std_logic_unsigned.all;

entity bitstorage is
	port(bitin, writein: in std_logic;
		 bitout: out std_logic);
end entity bitstorage;

architecture memlike of bitstorage is
	signal q: std_logic;
begin
	process(writein) is
	begin
		if (rising_edge(writein)) then
			q <= bitin;
		end if;
	end process;
	bitout <= q;
end architecture memlike;

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_arith.all;
Use ieee.std_logic_unsigned.all;

entity register8mod is
	port(WriteData: in std_logic_vector(7 downto 0);
		WriteCmd: in std_logic;
		ReadData: out std_logic_vector(7 downto 0));
end entity register8mod;

architecture mod8 of register8mod is
	component bitstorage
		port (bitin, writein: in std_logic;
			bitout: out std_logic);
	end component;
begin
	registers: for i in 0 to 7 generate
		modi: bitstorage port map (WriteData(i), WriteCmd, ReadData(i));
	end generate;
end mod8;

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_arith.all;
Use ieee.std_logic_unsigned.all;

entity register32mod is
	port(wordin: in std_logic_vector(31 downto 0);
		wordout: out std_logic_vector(31 downto 0);
		writeword, writelowhalfword, writelowbyte: in std_logic);
end entity register32mod;

architecture mod32 of register32mod is
	component register8mod
		port(WriteData: in std_logic_vector(7 downto 0);
		WriteCmd: in std_logic;
		ReadData: out std_logic_vector(7 downto 0));
	end component;

	signal write8: std_logic;
	signal write16: std_logic;
begin
	write8 <= writeword OR writelowhalfword OR writelowbyte;
	write16 <= writeword OR writelowhalfword;

	re0: register8mod port map (wordin(7 downto 0), write8, wordout(7 downto 0));
	re1: register8mod port map (wordin(15 downto 8), write16, wordout(15 downto 8));
	re2: register8mod port map (wordin(23 downto 16), writeword, wordout(23 downto 16));
	re3: register8mod port map (wordin(31 downto 24), writeword, wordout(31 downto 24));
end architecture mod32;

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_arith.all;
Use ieee.std_logic_unsigned.all;

entity shift_register is
	port(datain: in std_logic_vector(31 downto 0);
		dir: in std_logic;
		shamt:	in std_logic_vector(1 downto 0);
		dataout: out std_logic_vector(31 downto 0));
end entity shift_register;

architecture shifty of shift_register is
signal shamcount: std_logic_vector(2 downto 0);
begin
	shamcount <= dir & shamt;
	with shamcount select
		dataout <= datain(30 downto 0) & "0" when "001",
		 	datain(29 downto 0) & "00" when "010",
		 	datain(28 downto 0) & "000" when "011",
		 	"0" & datain(31 downto 1) when "101",
		 	"00" & datain(31 downto 2) when "110",
		 	"000" & datain(31 downto 3) when "111",
		 	datain when others;
end architecture shifty;

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_arith.all;
Use ieee.std_logic_unsigned.all;

entity bitadder is
	port(	a,b,ci: in std_logic;
		c,co: out std_logic);
end entity bitadder;

architecture fulladder of bitadder is
begin
	c <= (a xor b) xor ci;
	co <= (a and b) or (ci and (a xor b));
end architecture fulladder;

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_arith.all;
Use ieee.std_logic_unsigned.all;

entity adder_subtracter is
	port(datain_a: in std_logic_vector(31 downto 0);
		datain_b: in std_logic_vector(31 downto 0);
		add_sub: in std_logic;
		dataout: out std_logic_vector(31 downto 0);
		co: out std_logic);
end entity adder_subtracter;

architecture addsub32 of adder_subtracter is
	component bitadder is
		port(	a,b,ci: in std_logic;
			c,co: out std_logic);
	end component;
	signal carry: std_logic_vector(32 downto 0);
	signal complimentA: std_logic_vector(31 downto 0);
begin
	complimentA <= (not datain_a) when add_sub = '1' else  -- if the add/sub bit is 1, we subtract by turning A
		datain_a;					       -- to its two's compliment form
		carry(0) <= add_sub;
		co <= carry(32);
	adders32: for i in 0 to 31 generate
		bai: bitadder port map (complimentA(i), datain_b(i), carry(i), dataout(i), carry(i+1));
	end generate;
	
end architecture addsub32;