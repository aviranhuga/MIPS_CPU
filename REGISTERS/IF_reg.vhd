-- ====================================================================
--
--	File Name:		IF_Reg.vhd
--	Description:	Register for IF stage
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

entity IF_Reg is 
port (
   	Instruction_out 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	Instruction_in		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
    PC_plus_4_out_in 	: IN  	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	PC_plus_4_out_out 	: OUT  	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	RegDst_IF_OUT 		: OUT 	STD_LOGIC;
	ALUSrc_IF_OUT 		: OUT 	STD_LOGIC;
	MemtoReg_IF_OUT 	: OUT 	STD_LOGIC;
	RegWrite_IF_OUT 	: OUT 	STD_LOGIC;
	MemRead_IF_OUT 		: OUT 	STD_LOGIC;
	MemWrite_IF_OUT 	: OUT 	STD_LOGIC;
	Branch_IF_OUT 		: OUT 	STD_LOGIC;
	ALUop_IF_OUT 		: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	RegDst_IF_IN 		: IN 	STD_LOGIC;
	ALUSrc_IF_IN 		: IN 	STD_LOGIC;
	MemtoReg_IF_IN 		: IN 	STD_LOGIC;
	RegWrite_IF_IN 		: IN 	STD_LOGIC;
	MemRead_IF_IN 		: IN 	STD_LOGIC;
	MemWrite_IF_IN 		: IN 	STD_LOGIC;
	Branch_IF_IN		: IN 	STD_LOGIC;
	ALUop_IF_IN			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
    clock 				: IN 	STD_LOGIC 
	);
end IF_Reg;

architecture IF_Reg_arch of IF_Reg is

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
	
	PC_plus_4: for i in 0 to 9 generate
		PC_plus_4i: DFF_for_reg port map(
		data => PC_plus_4_out_in(i),
		clk=>clock, 
		en=>one, 
		q=>PC_plus_4_out_out(i));
	end generate PC_plus_4;

-- control signals 
	RegDst:      DFF_for_reg port map(data => RegDst_IF_IN,clk=>clock, en=>one, q=>RegDst_IF_OUT);
	ALUSrc: 	 DFF_for_reg port map(data => ALUSrc_IF_IN,clk=>clock, en=>one, q=>ALUSrc_IF_OUT);	
	MemtoReg:    DFF_for_reg port map(data => MemtoReg_IF_IN,clk=>clock, en=>one, q=>MemtoReg_IF_OUT);	
	RegWrite: 	 DFF_for_reg port map(data => RegWrite_IF_IN,clk=>clock, en=>one, q=>RegWrite_IF_OUT);
	MemRead: 	 DFF_for_reg port map(data => MemRead_IF_IN,clk=>clock, en=>one, q=>MemRead_IF_OUT);
	MemWrite:    DFF_for_reg port map(data => MemWrite_IF_IN,clk=>clock, en=>one, q=>MemWrite_IF_OUT);
	Branch:		 DFF_for_reg port map(data => Branch_IF_IN,clk=>clock, en=>one, q=>Branch_IF_OUT);
	ALUop_0:	 DFF_for_reg port map(data => ALUop_IF_IN(0),clk=>clock, en=>one, q=>ALUop_IF_OUT(0));
	ALUop_1:	 DFF_for_reg port map(data => ALUop_IF_IN(1),clk=>clock, en=>one, q=>ALUop_IF_OUT(1));
		
end IF_Reg_arch;