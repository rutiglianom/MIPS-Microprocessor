-- Processor assembly
-- Matthew Rutigliano & Will Lambrecht
-- Lab 4

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProcessorAssembly is
	port( clock: in std_logic;
		-- Probes to test
		dataMemProbe: out std_logic_vector(31 downto 0));
end entity;

architecture assembly of ProcessorAssembly is

	component Processor is
		port( instruction : in  STD_LOGIC_VECTOR (31 downto 0);
           	DataMemdatain : in  STD_LOGIC_VECTOR (31 downto 0); -- Input for processor, output for DataMem
           	DataMemdataout : out  STD_LOGIC_VECTOR (31 downto 0); -- Output for processor, input for DataMem
           	InstMemAddr : out  STD_LOGIC_VECTOR (31 downto 0);
           	DataMemAddr : out  STD_LOGIC_VECTOR (31 downto 0);
			  DataMemRead, DataMemWrite: out std_logic;
           	clock : in  std_logic);
	end component;
	
	component DataMem is
		port ( DataIn, Address: in std_logic_vector(31 downto 0);
		WriteEn: in std_logic;
		ReadEn: in std_logic;
		DataOut: out std_logic_vector(31 downto 0));
	end component;

	component Code_Mem is
		port ( address: in std_logic_vector(31 downto 0);
		 instruction: out std_logic_vector(31 downto 0) );
	end component;

	signal instruct: std_logic_vector(31 downto 0);
	signal DataMemdatain: std_logic_vector(31 downto 0);
	signal DataMemdataout: std_logic_vector(31 downto 0);
	signal InstMemAddr: std_logic_vector(31 downto 0);
	signal DataMemAddr: std_logic_vector(31 downto 0);
	signal DataMemRead: std_logic;
	signal DataMemWrite: std_logic;
	
begin
	CentralProcessing: Processor port map(instruct, DataMemdatain, DataMemdataout, InstMemAddr, DataMemAddr, DataMemRead, DataMemWrite, clock);
	DataMemory: DataMem port map(DataMemdataout, DataMemAddr, DataMemWrite, DataMemRead, DataMemdatain);
	CodeMemory: Code_Mem port map(InstMemAddr, instruct);

	dataMemProbe <= DataMemDatain;
end architecture assembly;
	