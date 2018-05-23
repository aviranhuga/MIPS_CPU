-- ====================================================================
--
--	File Name:		ID_Reg.vhd
--	Description:	Register for ID stage
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

entity ID_Reg is 
port (
	Instruction_out 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	Instruction_in		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
   	read_data_1_out 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	read_data_1_in		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	read_data_2_out 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	read_data_2_in		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	PC_plus_4_out_in 	: IN  	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	PC_plus_4_out_out 	: OUT  	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	Sign_extend_out		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	Sign_extend_in  	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	ALUSrc_ID_OUT 		: OUT 	STD_LOGIC;
	Branch_ID_OUT		: OUT 	STD_LOGIC;
	MemtoReg_ID_OUT 	: OUT 	STD_LOGIC;
	MemRead_ID_OUT 		: OUT 	STD_LOGIC;
	RegDst_ID_OUT 		: OUT 	STD_LOGIC;
	MemWrite_ID_OUT 	: OUT 	STD_LOGIC;
	ALUop_ID_OUT 		: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	RegWrite_ID_OUT 	: OUT 	STD_LOGIC;
	RegWrite_ID_IN 		: IN 	STD_LOGIC;
	ALUSrc_ID_IN 		: IN 	STD_LOGIC;
	MemtoReg_ID_IN 		: IN 	STD_LOGIC;
	MemRead_ID_IN 		: IN 	STD_LOGIC;
	RegDst_ID_IN 		: IN 	STD_LOGIC;
	MemWrite_ID_IN 		: IN 	STD_LOGIC;
	Branch_ID_IN		: IN 	STD_LOGIC;
	ALUop_ID_IN			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
    clock 				: IN 	STD_LOGIC 
	);
end ID_Reg;

architecture ID_Reg_arch of ID_Reg is

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
	
	read_data_1: for i in 0 to 31 generate
		read_data_1i: DFF_for_reg port map(
		data => read_data_1_in(i),
		clk=>clock, 
		en=>one, 
		q=>read_data_1_out(i));
	end generate read_data_1;
	
	read_data_2: for i in 0 to 31 generate
		read_data_2i: DFF_for_reg port map(
		data => read_data_2_in(i),
		clk=>clock, 
		en=>one, 
		q=>read_data_2_out(i));
	end generate read_data_2;
	
	Sign_extend: for i in 0 to 31 generate
		Sign_extendi: DFF_for_reg port map(
		data => Sign_extend_in(i),
		clk=>clock, 
		en=>one, 
		q=>Sign_extend_out(i));
	end generate Sign_extend;
	
	PC_plus_4: for i in 0 to 9 generate
		PC_plus_4i: DFF_for_reg port map(
		data => PC_plus_4_out_in(i),
		clk=>clock, 
		en=>one, 
		q=>PC_plus_4_out_out(i));
	end generate PC_plus_4;

-- control signals 
	RegDst:      DFF_for_reg port map(data => RegDst_ID_IN,clk=>clock, en=>one, q=>RegDst_ID_OUT);
	ALUSrc: 	 DFF_for_reg port map(data => ALUSrc_ID_IN,clk=>clock, en=>one, q=>ALUSrc_ID_OUT);	
	MemtoReg:    DFF_for_reg port map(data => MemtoReg_ID_IN,clk=>clock, en=>one, q=>MemtoReg_ID_OUT);
	RegWrite: 	 DFF_for_reg port map(data => RegWrite_ID_IN,clk=>clock, en=>one, q=>RegWrite_ID_OUT);	
	MemRead: 	 DFF_for_reg port map(data => MemRead_ID_IN,clk=>clock, en=>one, q=>MemRead_ID_OUT);
	MemWrite:    DFF_for_reg port map(data => MemWrite_ID_IN,clk=>clock, en=>one, q=>MemWrite_ID_OUT);
	Branch:		 DFF_for_reg port map(data => Branch_ID_IN,clk=>clock, en=>one, q=>Branch_ID_OUT);
	ALUop_0:	 DFF_for_reg port map(data => ALUop_ID_IN(0),clk=>clock, en=>one, q=>ALUop_ID_OUT(0));
	ALUop_1:	 DFF_for_reg port map(data => ALUop_ID_IN(1),clk=>clock, en=>one, q=>ALUop_ID_OUT(1));
		
end ID_Reg_arch;