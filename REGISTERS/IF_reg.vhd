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
	IF_Write            : IN    STD_LOGIC;
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

signal en_for_dff : std_logic;

begin    

 en_for_dff <= NOT IF_Write;
 
	Instruction: for i in 0 to 31 generate
		Instructioni: DFF_for_reg port map(
		data => Instruction_in(i),
		clk=>clock, 
		en=>en_for_dff, 
		q=>Instruction_out(i));
	end generate Instruction;
	
	PC_plus_4: for i in 0 to 9 generate
		PC_plus_4i: DFF_for_reg port map(
		data => PC_plus_4_out_in(i),
		clk=>clock, 
		en=>en_for_dff, 
		q=>PC_plus_4_out_out(i));
	end generate PC_plus_4;

end IF_Reg_arch;