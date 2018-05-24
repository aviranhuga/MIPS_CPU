
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY hazard_detection IS
   PORT( 	
	ID_Instruction	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	EX_Instruction 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	EX_MemRead  	: IN 	STD_LOGIC;
	stall_enable 	: OUT 	STD_LOGIC;
	clock			: IN 	STD_LOGIC );

END hazard_detection;

ARCHITECTURE behavior OF hazard_detection IS

	SIGNAL ID_RegisterRt 		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL ID_RegisterRs		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL EX_RegisterRt		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL valid_instraction    : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL EX_rt_xor_ID_rs		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL EX_rt_xor_ID_rt		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );


BEGIN      

	EX_RegisterRt               <= EX_Instruction( 20 DOWNTO 16 );
	ID_RegisterRs			 	<= ID_Instruction( 25 DOWNTO 21 );
   	ID_RegisterRt			 	<= ID_Instruction( 20 DOWNTO 16 );
	
	valid_instraction           <=  ID_Instruction xor EX_Instruction;
	EX_rt_xor_ID_rs            	<= (EX_RegisterRt xor ID_RegisterRs) WHEN ((ID_RegisterRs /=0) AND (valid_instraction /=0)) ELSE "11111";
	EX_rt_xor_ID_rt             <= (EX_RegisterRt xor ID_RegisterRt) WHEN ((ID_RegisterRt /=0) AND (valid_instraction /=0)) ELSE "11111";
     
PROCESS (EX_rt_xor_ID_rt,EX_rt_xor_ID_rs,EX_MemRead )
	BEGIN
	-- A hazard check
		IF ((EX_MemRead ='1') AND ((EX_rt_xor_ID_rs = 0) OR (EX_rt_xor_ID_rt = 0))) THEN
			stall_enable <= '1';
		ELSE 
			stall_enable <= '0';
		END IF;
		
	END PROCESS;
END behavior;
