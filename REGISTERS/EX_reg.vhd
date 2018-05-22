-- ====================================================================
--
--	File Name:		EX_Reg.vhd
--	Description:	Register for EX stage
--					
--
--	Date:			7/07/2018
--	Designer:		Aviran Huga
--
-- ====================================================================


-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity EX_Reg is 
port (
	Instruction_out 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	Instruction_in		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
   	ALU_Result_out	 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	ALU_Result_in		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	read_data_2_out 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	read_data_2_in		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	Add_Result_out 		: OUT 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	Add_Result_in 		: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	Branch_EX_OUT		: OUT 	STD_LOGIC;
	MemtoReg_EX_OUT 	: OUT 	STD_LOGIC;
	MemRead_EX_OUT 		: OUT 	STD_LOGIC;
	RegDst_EX_OUT 		: OUT 	STD_LOGIC;
	MemWrite_EX_OUT 	: OUT 	STD_LOGIC;
	zero_OUT            : OUT   STD_LOGIC;
	zero_IN             : IN    STD_LOGIC;
	MemtoReg_EX_IN 		: IN 	STD_LOGIC;
	MemRead_EX_IN 		: IN 	STD_LOGIC;
	MemWrite_EX_IN 		: IN 	STD_LOGIC;
	RegDst_EX_IN 		: IN 	STD_LOGIC;
	Branch_EX_IN		: IN 	STD_LOGIC;
    clock 				: IN 	STD_LOGIC 
	);
end EX_Reg;

architecture EX_Reg_arch of EX_Reg is

component DFF_for_reg 
	port (
	data : in std_logic := '0';	
	clk : in std_logic;	
	en : in std_logic := '0';	
	q : out std_logic := '0'
	);
end component;

signal one : std_logic;

begin    
 one <= '1';
 
	Instruction: for i in 0 to 31 generate
		Instructioni: DFF_for_reg port map(
		data => Instruction_in(i),
		clk=>clock, 
		en=>one, 
		q=>Instruction_out(i));
	end generate Instruction;
	
	ALU_Result: for i in 0 to 31 generate
		ALU_Resulti: DFF_for_reg port map(
		data => ALU_Result_in(i),
		clk=>clock, 
		en=>one, 
		q=>ALU_Result_out(i));
	end generate ALU_Result;
	
	Add_Result: for i in 0 to 7 generate
		ALU_Resulti: DFF_for_reg port map(
		data => Add_Result_in(i),
		clk=>clock, 
		en=>one, 
		q=>Add_Result_out(i));
	end generate Add_Result;
	
	read_data_2: for i in 0 to 31 generate
		read_data_2i: DFF_for_reg port map(
		data => read_data_2_in(i),
		clk=>clock, 
		en=>one, 
		q=>read_data_2_out(i));
	end generate read_data_2;
	
-- control signals 
	RegDst:      DFF_for_reg port map(data => RegDst_EX_IN,clk=>clock, en=>one, q=>RegDst_EX_OUT);
	MemtoReg:    DFF_for_reg port map(data => MemtoReg_EX_IN,clk=>clock, en=>one, q=>MemtoReg_EX_OUT);	
	MemRead: 	 DFF_for_reg port map(data => MemRead_EX_IN,clk=>clock, en=>one, q=>MemRead_EX_OUT);
	MemWrite:    DFF_for_reg port map(data => MemWrite_EX_IN,clk=>clock, en=>one, q=>MemWrite_EX_OUT);
	Branch:		 DFF_for_reg port map(data => Branch_EX_IN,clk=>clock, en=>one, q=>Branch_EX_OUT);
	zero:      	 DFF_for_reg port map(data => zero_IN ,clk=>clock, en=>one, q=>zero_OUT);
		
end EX_Reg_arch;