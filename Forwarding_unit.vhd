
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
	SIGNAL EX_RegisterRs		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL EX_RegisterRt		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL MEM_rd_xor_EX_rs		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL MEM_rd_xor_EX_rt		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL WB_rd_xor_EX_rs		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL WB_rd_xor_EX_rt		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );

BEGIN      

	MEM_RegisterRd              <= MEM_Instruction( 15 DOWNTO 11 );
	WB_RegisterRd               <= WB_Instruction( 15 DOWNTO 11 );
	EX_RegisterRs			 	<= EX_Instruction( 25 DOWNTO 21 );
   	EX_RegisterRt			 	<= EX_Instruction( 20 DOWNTO 16 );

	MEM_rd_xor_EX_rs            <= MEM_RegisterRd xor EX_RegisterRs;
	MEM_rd_xor_EX_rt            <= MEM_RegisterRd xor EX_RegisterRt;
	WB_rd_xor_EX_rs             <= WB_RegisterRd xor EX_RegisterRs;
	WB_rd_xor_EX_rt             <= WB_RegisterRd xor EX_RegisterRt;
     
PROCESS ( MEM_RegisterRd, WB_RegisterRd, EX_RegisterRs,EX_RegisterRt,MEM_RegWrite,WB_RegWrite,MEM_rd_xor_EX_rs,WB_rd_xor_EX_rs,MEM_rd_xor_EX_rt,WB_rd_xor_EX_rt )
	BEGIN
	-- A hazard check
		IF ((MEM_RegWrite ='1') AND (MEM_RegisterRd /= 0) AND (MEM_rd_xor_EX_rs = 0)) THEN
			ForwardA <= "10";
		ELSIF (((WB_RegWrite ='1') AND (WB_RegisterRd /= 0)) AND (WB_rd_xor_EX_rs = 0)) THEN
			ForwardA <= "01";
		ELSE ForwardA <= "00";
		END IF;
		
	-- B hazard check
		IF ((MEM_RegWrite ='1') AND (MEM_RegisterRd /= 0) AND (MEM_rd_xor_EX_rt = 0)) THEN
			ForwardB <= "10";
		ELSIF (((WB_RegWrite ='1') AND (WB_RegisterRd /= 0)) AND (WB_rd_xor_EX_rt = 0)) THEN
			ForwardB <= "01";
		ELSE ForwardB <= "00";
		END IF;
	END PROCESS;
END behavior;

