-- ====================================================================
--
--	File Name:		Absoult_value.vhd
--	Description:	Absoult value calc for FPU
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

entity Absoult_value is 
generic ( N: integer :=8);
port (
	Input : in std_logic_vector(N-1 downto 0);
	Output : out std_logic_vector(N-1 downto 0)
	);
end Absoult_value;

architecture Absoult_value_arch of Absoult_value is

signal one : std_logic_vector(N-1 downto 0);

begin                
	one(0) <= '1';
	one(N-1 downto 1) <= (others => '0');
	
 --Design Body
	process(Input,one)
		begin
		if (Input(N-1)='0') then -- positive input
			Output <= Input;
		else 
			Output <= UNSIGNED(not Input)+ UNSIGNED(one);
		end if;
	end process;
end Absoult_value_arch;

