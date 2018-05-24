
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY forwarding_unit IS
   PORT( 	
	EX_Instruction	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	MEM_Instruction : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	WB_Instruction 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	MEM_RegWrite	: IN 	STD_LOGIC;
	WB_RegWrite		: IN 	STD_LOGIC;
	
	ForwardA 		: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	ForwardB 		: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	clock			: IN 	STD_LOGIC );

END forwarding_unit;

ARCHITECTURE behavior OF forwarding_unit IS

	SIGNAL MEM_RegisterRd 		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL WB_RegisterRd		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL WB_RegisterRt		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL EX_RegisterRs		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL EX_RegisterRt		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL lw_opcode            : STD_LOGIC;

BEGIN      
	lw_opcode                   <= '1'  WHEN (WB_Instruction( 31 DOWNTO 26 ) = "100011")  ELSE '0';
	MEM_RegisterRd              <= MEM_Instruction( 15 DOWNTO 11 );
	WB_RegisterRd               <= WB_Instruction( 15 DOWNTO 11 );
	WB_RegisterRt               <= WB_Instruction( 20 DOWNTO 16 );
	EX_RegisterRs			 	<= EX_Instruction( 25 DOWNTO 21 );
   	EX_RegisterRt			 	<= EX_Instruction( 20 DOWNTO 16 );	

     
PROCESS (MEM_RegWrite,MEM_RegisterRd,EX_RegisterRs,WB_RegisterRd,WB_RegisterRt,EX_RegisterRt,WB_RegWrite,lw_opcode )
	BEGIN
	-- A hazard check
		IF ((MEM_RegWrite ='1') AND (MEM_RegisterRd /= 0) AND (MEM_RegisterRd = EX_RegisterRs)) THEN
			ForwardA <= "10";
		ELSIF ((WB_RegWrite ='1') AND 
		(((WB_RegisterRd /= 0) AND (WB_RegisterRd = EX_RegisterRs)) OR ((lw_opcode='1') AND (WB_RegisterRt = EX_RegisterRs) ))) THEN
			ForwardA <= "01";
		ELSE ForwardA <= "00";
		END IF;
		
	-- B hazard check
		IF ((MEM_RegWrite ='1') AND (MEM_RegisterRd /= 0) AND (MEM_RegisterRd = EX_RegisterRt)) THEN
			ForwardB <= "10";
		ELSIF ((WB_RegWrite ='1') AND 
		(((WB_RegisterRd /= 0) AND (WB_RegisterRd = EX_RegisterRt)) OR ((lw_opcode='1') AND (WB_RegisterRt = EX_RegisterRt) ))) THEN
			ForwardB <= "01";
		ELSE ForwardB <= "00";
		END IF;
	END PROCESS;
END behavior;

