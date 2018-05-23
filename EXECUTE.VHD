--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY  Execute IS
	PORT(	Read_data_1 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Read_data_2 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			write_data_WB 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALU_result_MEM 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ForwardA 		: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			ForwardB 		: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			Sign_extend 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Function_opcode : IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			ALUOp 			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			ALUSrc 			: IN 	STD_LOGIC;
			Zero 			: OUT	STD_LOGIC;
			ALU_Result 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Add_Result 		: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			PC_plus_4 		: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			clock, reset	: IN 	STD_LOGIC );
END Execute;

ARCHITECTURE behavior OF Execute IS

component FPU_add_sub
	port (
	A : in std_logic_vector(31 downto 0);
	B : in std_logic_vector(31 downto 0);
	sub : in std_logic;
	result: out std_logic_vector(31 downto 0)
	);
end component;


SIGNAL Ainput, Binput 						: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL Ainput_Forward, Binput_Forward 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL ALU_output_mux						: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL Branch_Add 							: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
SIGNAL ALU_ctl								: STD_LOGIC_VECTOR( 2 DOWNTO 0 );
SIGNAL FPU_ADD_SUB_RESULT   				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );


BEGIN
		FPU_add_or_sub: FPU_add_sub
		port map(
		A => Ainput,
		B => Binput,
		sub => Function_opcode( 0 ),
		result => FPU_ADD_SUB_RESULT);
		
	with ForwardA select Ainput_Forward <= 
		ALU_result_MEM WHEN "10",
		write_data_WB  WHEN "01",
		Read_data_1    WHEN others;
		
	with ForwardB select Binput_Forward <= 
		ALU_result_MEM WHEN "10",
		write_data_WB  WHEN "01",
		Read_data_2    WHEN others;	
		
	Ainput <= Ainput_Forward;
						-- ALU input mux
	Binput <= Binput_Forward 
		WHEN ( ALUSrc = '0' ) 
  		ELSE  Sign_extend( 31 DOWNTO 0 );
						-- Generate ALU control bits
	ALU_ctl( 0 ) <= ( Function_opcode( 0 ) OR Function_opcode( 3 ) ) AND ALUOp(1 );
	ALU_ctl( 1 ) <= ( NOT Function_opcode( 2 ) ) OR (NOT ALUOp( 1 ) );
	ALU_ctl( 2 ) <= ( Function_opcode( 1 ) AND ALUOp( 1 )) OR ALUOp( 0 );
						-- Generate Zero Flag
	Zero <= '1' 
		WHEN ( ALU_output_mux( 31 DOWNTO 0 ) = X"00000000"  )
		ELSE '0';    
						-- Select ALU output        
	ALU_result <= X"0000000" & B"000"  & ALU_output_mux( 31 ) 
		WHEN  ALU_ctl = "111" 
		ELSE  	ALU_output_mux( 31 DOWNTO 0 );
						-- Adder to compute Branch Address
	Branch_Add	<= PC_plus_4( 9 DOWNTO 2 ) +  Sign_extend( 7 DOWNTO 0 ) ;
		Add_result 	<= Branch_Add( 7 DOWNTO 0 );

PROCESS ( ALU_ctl, Ainput, Binput,FPU_ADD_SUB_RESULT )
	BEGIN
					-- Select ALU operation
 	CASE ALU_ctl IS
						-- ALU performs ALUresult = A_input AND B_input
		WHEN "000" 	=>	ALU_output_mux 	<= Ainput AND Binput; 
						-- ALU performs ALUresult = A_input OR B_input
     	WHEN "001" 	=>	ALU_output_mux 	<= Ainput OR Binput;
						-- ALU performs ALUresult = A_input + B_input
	 	WHEN "010" 	=>	ALU_output_mux 	<= Ainput + Binput;
						-- ALU performs ?
 	 	WHEN "011" 	=>	ALU_output_mux <= X"00000000";
						-- ALU performs xor
 	 	WHEN "100" 	=>	ALU_output_mux 	<= FPU_ADD_SUB_RESULT;
						-- ALU performs nor
 	 	WHEN "101" 	=>	ALU_output_mux 	<= FPU_ADD_SUB_RESULT;
						-- ALU performs ALUresult = A_input -B_input
 	 	WHEN "110" 	=>	ALU_output_mux 	<= Ainput - Binput;
						-- ALU performs SLT
  	 	WHEN "111" 	=>	ALU_output_mux 	<= Ainput - Binput ;
 	 	WHEN OTHERS	=>	ALU_output_mux 	<= X"00000000" ;
  	END CASE;
  END PROCESS;
END behavior;

