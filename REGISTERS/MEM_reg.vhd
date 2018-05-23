-- ====================================================================
--
--	File Name:		MEM_Reg.vhd
--	Description:	Register for MEM stage
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

entity MEM_Reg is 
port (
	Instruction_out 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	Instruction_in		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
   	ALU_Result_out	 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	ALU_Result_in		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	read_data_out 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	read_data_in		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	MemtoReg_MEM_OUT 	: OUT 	STD_LOGIC;
	RegDst_MEM_OUT 		: OUT 	STD_LOGIC;
	RegWrite_MEM_OUT 	: OUT 	STD_LOGIC;
	RegWrite_MEM_IN 	: IN 	STD_LOGIC;
	RegDst_MEM_IN 		: IN 	STD_LOGIC;
	MemtoReg_MEM_IN 	: IN 	STD_LOGIC;
    clock 				: IN 	STD_LOGIC 
	);
end MEM_Reg;

architecture MEM_Reg_arch of MEM_Reg is

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
	
	read_data: for i in 0 to 31 generate
		read_data_i: DFF_for_reg port map(
		data => read_data_in(i),
		clk=>clock, 
		en=>one, 
		q=>read_data_out(i));
	end generate read_data;
	
-- control signals 
	RegDst:      DFF_for_reg port map(data => RegDst_MEM_IN,clk=>clock, en=>one, q=>RegDst_MEM_OUT);
	RegWrite: 	 DFF_for_reg port map(data => RegWrite_MEM_IN,clk=>clock, en=>one, q=>RegWrite_MEM_OUT);
	MemtoReg:    DFF_for_reg port map(data => MemtoReg_MEM_IN,clk=>clock, en=>one, q=>MemtoReg_MEM_OUT);	
		
end MEM_Reg_arch;