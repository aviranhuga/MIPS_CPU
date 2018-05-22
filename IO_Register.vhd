-- ====================================================================
--
--	File Name:		IO_Register.vhd
--	Description:	Register for IO data
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

entity IO_Register is 
port (
	clock 		: IN 	STD_LOGIC;
	Memwrite 	: IN 	STD_LOGIC;
	address 		: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	sevseg_sel  : IN    STD_LOGIC;
	write_data 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	seven_seg0 	: out std_logic_vector(6 downto 0);
	seven_seg1 	: out std_logic_vector(6 downto 0);
	seven_seg2 	: out std_logic_vector(6 downto 0);
	seven_seg3 	: out std_logic_vector(6 downto 0)
	);
end IO_Register;

architecture IO_Register_arch of IO_Register is


component DFF_for_reg 
	port (
	data : in std_logic := '0';	
	clk : in std_logic;	
	en : in std_logic := '0';	
	q : out std_logic := '0'
	);
end component;

component seven_seg_disp 
port (
	data : in std_logic_vector(3 downto 0);
	clock : in std_logic;	
	data_out : out std_logic_vector(6 downto 0)
	);
end component;

signal en_for_dff : std_logic;
signal write_clock : std_logic;
signal dff_out : std_logic_vector(15 downto 0);
signal input_data : std_logic_vector(15 downto 0);

begin    
	
	seven_seg_disp_0: seven_seg_disp
	port map(
	data => dff_out(3 downto 0),
	clock => clock,
	data_out => seven_seg0);
	
	seven_seg_disp_1: seven_seg_disp
	port map(
	data => dff_out(7 downto 4),
	clock => clock,
	data_out => seven_seg1);
	
	seven_seg_disp_2: seven_seg_disp
	port map(
	data => dff_out(11 downto 8),
	clock => clock,
	data_out => seven_seg2);
	
	seven_seg_disp_3: seven_seg_disp
	port map(
	data => dff_out(15 downto 12),
	clock => clock,
	data_out => seven_seg3);
	

	--register for HI
	Array_Of_DFF: for i in 0 to 15 generate
		dffi: DFF_for_reg port map(data => input_data(i),clk=>write_clock, en=>en_for_dff, q=>dff_out(i));
	end generate Array_Of_DFF;

	en_for_dff <= Memwrite WHEN address="00000001" ELSE '0';
	input_data <= write_data(15 downto 0) WHEN  sevseg_sel='0' ELSE write_data(31 downto 16);
	write_clock <= NOT clock;
end IO_Register_arch;