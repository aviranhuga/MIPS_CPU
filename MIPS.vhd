				-- Top Level Structural Model for MIPS Processor Core
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY MIPS IS

	PORT( reset, clock, sevseg_sel				: IN 	STD_LOGIC; 
		-- Output important signals to pins for easy display in Simulator
		PC								: OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		ALU_result_out, read_data_1_out, read_data_2_out, write_data_out,	
     	Instruction_out					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		seven_seg0,seven_seg1,seven_seg2,
		seven_seg3                      : OUT  STD_LOGIC_VECTOR( 6 downto 0);
		Branch_out, Zero_out, Memwrite_out, 
		Regwrite_out					: OUT 	STD_LOGIC );
END 	MIPS;

ARCHITECTURE structure OF MIPS IS

	COMPONENT IO_Register
   	     PORT(
			clock 		: IN 	STD_LOGIC;
			Memwrite 	: IN 	STD_LOGIC;
			sevseg_sel  : IN    STD_LOGIC;
			write_data 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			address 		: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			seven_seg0 	: out std_logic_vector(6 downto 0);
			seven_seg1 	: out std_logic_vector(6 downto 0);
			seven_seg2 	: out std_logic_vector(6 downto 0);
			seven_seg3 	: out std_logic_vector(6 downto 0));
	END COMPONENT;
	
	COMPONENT Ifetch
   	     PORT(	Instruction			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		PC_plus_4_out 		: OUT  	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        		Add_result 			: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
        		Branch 				: IN 	STD_LOGIC;
        		Zero 				: IN 	STD_LOGIC;
        		PC_out 				: OUT 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        		clock,reset 		: IN 	STD_LOGIC );
	END COMPONENT; 
	
	COMPONENT IF_Reg
		PORT (
				Instruction_out 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				Instruction_in		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				PC_plus_4_out_in 	: IN  	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
				PC_plus_4_out_out : OUT  	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
				RegDst_IF_OUT 		: OUT 	STD_LOGIC;
				ALUSrc_IF_OUT 		: OUT 	STD_LOGIC;
				MemtoReg_IF_OUT 	: OUT 	STD_LOGIC;
				RegWrite_IF_OUT 	: OUT 	STD_LOGIC;
				MemRead_IF_OUT 	: OUT 	STD_LOGIC;
				MemWrite_IF_OUT 	: OUT 	STD_LOGIC;
				Branch_IF_OUT 		: OUT 	STD_LOGIC;
				ALUop_IF_OUT 		: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
				RegDst_IF_IN 		: IN 	STD_LOGIC;
				ALUSrc_IF_IN 		: IN 	STD_LOGIC;
				MemtoReg_IF_IN 	: IN 	STD_LOGIC;
				RegWrite_IF_IN 	: IN 	STD_LOGIC;
				MemRead_IF_IN 		: IN 	STD_LOGIC;
				MemWrite_IF_IN 	: IN 	STD_LOGIC;
				Branch_IF_IN		: IN 	STD_LOGIC;
				ALUop_IF_IN			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
				clock 				: IN 	STD_LOGIC );
	END COMPONENT;

	COMPONENT Idecode
 	     PORT(	read_data_1 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		read_data_2 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		Instruction_read 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				Instruction_write 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		RegWrite		 	: IN 	STD_LOGIC;
        		RegDst 				: IN 	STD_LOGIC;
        		Sign_extend 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		clock, reset		: IN 	STD_LOGIC );
	END COMPONENT;

	
	COMPONENT ID_Reg
		PORT (
				RegDst_ID_OUT 		: OUT 	STD_LOGIC;
				RegDst_ID_IN 		: IN 	STD_LOGIC;
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
				MemtoReg_ID_OUT 	: OUT 	STD_LOGIC;
				Branch_ID_OUT		: OUT 	STD_LOGIC;
				MemRead_ID_OUT 		: OUT 	STD_LOGIC;
				MemWrite_ID_OUT 	: OUT 	STD_LOGIC;
				ALUop_ID_OUT 		: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
				ALUSrc_ID_IN 		: IN 	STD_LOGIC;
				MemtoReg_ID_IN 		: IN 	STD_LOGIC;
				MemRead_ID_IN 		: IN 	STD_LOGIC;
				Branch_ID_IN		: IN 	STD_LOGIC;
				MemWrite_ID_IN 		: IN 	STD_LOGIC;
				ALUop_ID_IN			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
				clock 				: IN 	STD_LOGIC );
	END COMPONENT;
	
	COMPONENT control
	     PORT( 	Opcode 				: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
             	RegDst 				: OUT 	STD_LOGIC;
             	ALUSrc 				: OUT 	STD_LOGIC;
             	MemtoReg 			: OUT 	STD_LOGIC;
             	RegWrite 			: OUT 	STD_LOGIC;
             	MemRead 			: OUT 	STD_LOGIC;
             	MemWrite 			: OUT 	STD_LOGIC;
             	Branch 				: OUT 	STD_LOGIC;
             	ALUop 				: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
             	clock, reset		: IN 	STD_LOGIC );
	END COMPONENT;

	COMPONENT  Execute
   	     PORT(	Read_data_1 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
                Read_data_2 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	Sign_Extend 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	Function_opcode		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
               	ALUOp 				: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
               	ALUSrc 				: IN 	STD_LOGIC;
               	Zero 				: OUT	STD_LOGIC;
               	ALU_Result 			: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	Add_Result 			: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
               	PC_plus_4 			: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
               	clock, reset		: IN 	STD_LOGIC );
	END COMPONENT;
	
	COMPONENT EX_Reg
		PORT (
				RegDst_EX_OUT 		: OUT 	STD_LOGIC;
				RegDst_EX_IN 		: IN 	STD_LOGIC;
				Instruction_out 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				Instruction_in		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				ALU_Result_out	 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				ALU_Result_in		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				read_data_2_out 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				read_data_2_in		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				Add_Result_out 		: OUT 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
				Add_Result_in 		: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
				Branch_EX_OUT		: OUT 	STD_LOGIC;
				MemtoReg_EX_OUT 	: OUT 	STD_LOGIC;
				MemRead_EX_OUT 		: OUT 	STD_LOGIC;
				MemWrite_EX_OUT 	: OUT 	STD_LOGIC;
				zero_OUT            : OUT   STD_LOGIC;
				zero_IN             : IN    STD_LOGIC;
				MemtoReg_EX_IN 		: IN 	STD_LOGIC;
				MemRead_EX_IN 		: IN 	STD_LOGIC;
				MemWrite_EX_IN 		: IN 	STD_LOGIC;
				Branch_EX_IN		: IN 	STD_LOGIC;
				clock 				: IN 	STD_LOGIC );
	END COMPONENT;


	COMPONENT dmemory
	     PORT(	read_data 			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		address 			: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
        		write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		MemRead, Memwrite 	: IN 	STD_LOGIC;
        		Clock,reset			: IN 	STD_LOGIC );
	END COMPONENT;
	
	COMPONENT MEM_Reg
		PORT (
				RegDst_MEM_OUT 		: OUT 	STD_LOGIC;
				RegDst_MEM_IN 		: IN 	STD_LOGIC;
				Instruction_out 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				Instruction_in		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				ALU_Result_out	 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				ALU_Result_in		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				read_data_out 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				read_data_in		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				MemtoReg_MEM_OUT 	: OUT 	STD_LOGIC;
				MemtoReg_MEM_IN 	: IN 	STD_LOGIC;
				clock 				: IN 	STD_LOGIC );
	END COMPONENT;
	
	COMPONENT WRITEBACK
		 PORT(	read_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				ALU_result			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				MemtoReg            : IN    STD_LOGIC;
				write_data 			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 ));
	END COMPONENT;

					-- declare signals used to connect VHDL components
	SIGNAL PC_plus_4 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL read_data_1 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_Extend 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Add_result 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL ALU_result 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALUSrc 			: STD_LOGIC;
	SIGNAL Branch 			: STD_LOGIC;
	SIGNAL RegDst 			: STD_LOGIC;
	SIGNAL Regwrite 		: STD_LOGIC;
	SIGNAL Zero 			: STD_LOGIC;
	SIGNAL MemWrite 		: STD_LOGIC;
	SIGNAL MemtoReg 		: STD_LOGIC;
	SIGNAL MemRead 			: STD_LOGIC;
	SIGNAL ALUop 			: STD_LOGIC_VECTOR(  1 DOWNTO 0 );
	SIGNAL Instruction		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL write_data_WB	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	--registers signals
	--IF STAGE
	SIGNAL Instruction_IFR	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
    SIGNAL PC_plus_4_IFR  	: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL RegDst_IFR  		: STD_LOGIC;
	SIGNAL ALUSrc_IFR 		: STD_LOGIC;
	SIGNAL MemtoReg_IFR 	: STD_LOGIC;
	SIGNAL RegWrite_IFR 	: STD_LOGIC;
	SIGNAL MemRead_IFR 		: STD_LOGIC;
	SIGNAL MemWrite_IFR 	: STD_LOGIC;
	SIGNAL Branch_IFR  		: STD_LOGIC;
	SIGNAL ALUop_IFR  		: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	--ID STAGE
	SIGNAL RegDst_IDR  		: STD_LOGIC;
	SIGNAL Instruction_IDR	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_1_IDR	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2_IDR	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL PC_plus_4_IDR  	: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL Sign_extend_IDR	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALUSrc_IDR 		: STD_LOGIC;
	SIGNAL MemtoReg_IDR 	: STD_LOGIC;
	SIGNAL MemRead_IDR 		: STD_LOGIC;
	SIGNAL MemWrite_IDR 	: STD_LOGIC;
	SIGNAL Branch_IDR  		: STD_LOGIC;
	SIGNAL ALUop_IDR  		: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	--EX STAGE
	SIGNAL RegDst_EXR  		: STD_LOGIC;
	SIGNAL Instruction_EXR	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALU_Result_EXR	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2_EXR	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Add_Result_EXR	: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL Zero_EXR 		: STD_LOGIC;
	SIGNAL MemtoReg_EXR 	: STD_LOGIC;
	SIGNAL MemRead_EXR		: STD_LOGIC;
	SIGNAL MemWrite_EXR 	: STD_LOGIC;
	SIGNAL Branch_EXR  		: STD_LOGIC;
	--MEM STAGE
	SIGNAL RegDst_MEM  		: STD_LOGIC;
	SIGNAL Instruction_MEM	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALU_Result_MEM	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_MEM	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL MemtoReg_MEM 	: STD_LOGIC;
	
BEGIN
					-- copy important signals to output pins for easy 
					-- display in Simulator
   Instruction_out 	<= Instruction;
   ALU_result_out 	<= ALU_result;
   read_data_1_out 	<= read_data_1;
   read_data_2_out 	<= read_data_2;
   write_data_out  	<= read_data WHEN MemtoReg = '1' ELSE ALU_result;
   Branch_out 		<= Branch;
   Zero_out 		<= Zero;
   RegWrite_out 	<= RegWrite;
   MemWrite_out 	<= MemWrite;	
					-- connect the 5 MIPS components   
  IFE : Ifetch
	PORT MAP (	Instruction 	=> Instruction,
    	    	PC_plus_4_out 	=> PC_plus_4,
				Add_result 		=> Add_Result_EXR,
				Branch 			=> Branch_EXR,
				Zero 			=> Zero_EXR,
				PC_out 			=> PC,        		
				clock 			=> clock,  
				reset 			=> reset );
				
   IFR : IF_Reg
   PORT MAP (	Instruction_out 	=> Instruction_IFR,
				Instruction_in		=> Instruction,
				PC_plus_4_out_in 	=> PC_plus_4,
				PC_plus_4_out_out 	=> PC_plus_4_IFR,
				RegDst_IF_OUT 		=> RegDst_IFR,
				ALUSrc_IF_OUT 		=> ALUSrc_IFR,
				MemtoReg_IF_OUT 	=> MemtoReg_IFR,
				RegWrite_IF_OUT 	=> RegWrite_IFR,
				MemRead_IF_OUT 		=> MemRead_IFR,
				MemWrite_IF_OUT 	=> MemWrite_IFR,
				Branch_IF_OUT 		=> Branch_IFR,
				ALUop_IF_OUT 		=> ALUop_IFR,
				RegDst_IF_IN 		=> RegDst,
				ALUSrc_IF_IN 		=> ALUSrc,
				MemtoReg_IF_IN 		=> MemtoReg,
				RegWrite_IF_IN 		=> RegWrite,
				MemRead_IF_IN 		=> MemRead,
				MemWrite_IF_IN 		=> MemWrite,
				Branch_IF_IN		=> Branch,
				ALUop_IF_IN			=> ALUop,
				clock 				=> clock);

   ID : Idecode
   	PORT MAP (	read_data_1 		=> read_data_1,
        		read_data_2 		=> read_data_2,
        		Instruction_read 	=> Instruction_IFR,
				Instruction_write 	=> Instruction_MEM,
        		write_data 			=> write_data_WB,
				RegWrite 			=> RegWrite_IFR,
				RegDst 				=> RegDst_MEM,
				Sign_extend 		=> Sign_extend,
        		clock 				=> clock,  
				reset 				=> reset );

   IDR : ID_Reg
   PORT MAP (   Instruction_out 	=> Instruction_IDR,
				Instruction_in		=> Instruction_IFR,
				read_data_1_out		=> read_data_1_IDR,
				read_data_1_in		=> read_data_1,
				read_data_2_out 	=> read_data_2_IDR,
				read_data_2_in		=> read_data_2,
				PC_plus_4_out_in    => PC_plus_4_IFR,
				PC_plus_4_out_out   => PC_plus_4_IDR,
				Sign_extend_out		=> Sign_extend_IDR,
				Sign_extend_in  	=> Sign_extend,
				ALUSrc_ID_OUT 		=> ALUSrc_IDR,
				RegDst_ID_OUT 		=> RegDst_IDR,
				MemtoReg_ID_OUT 	=> MemtoReg_IDR,
				MemRead_ID_OUT 		=> MemRead_IDR,
				Branch_ID_OUT		=> Branch_IDR,
				MemWrite_ID_OUT 	=> MemWrite_IDR,
				ALUop_ID_OUT 		=> ALUop_IDR,
				ALUSrc_ID_IN 		=> ALUSrc_IFR,
				MemtoReg_ID_IN 		=> MemtoReg_IFR,
				RegDst_ID_IN 		=> RegDst_IFR,
				Branch_ID_IN		=> Branch_IFR,
				MemRead_ID_IN 		=> MemRead_IFR,
				MemWrite_ID_IN 		=> MemWrite_IFR,
				ALUop_ID_IN			=> ALUop_IFR,
				clock 				=> clock);			
				
   CTL:   control
	PORT MAP ( 	Opcode 			=> Instruction( 31 DOWNTO 26 ),
				RegDst 			=> RegDst,
				ALUSrc 			=> ALUSrc,
				MemtoReg 		=> MemtoReg,
				RegWrite 		=> RegWrite,
				MemRead 		=> MemRead,
				MemWrite 		=> MemWrite,
				Branch 			=> Branch,
				ALUop 			=> ALUop,
                clock 			=> clock,
				reset 			=> reset );

   EXE:  Execute
   	PORT MAP (	Read_data_1 	=> read_data_1_IDR,
             	Read_data_2 	=> read_data_2_IDR,
				Sign_extend 	=> Sign_extend_IDR,
                Function_opcode	=> Instruction_IDR( 5 DOWNTO 0 ),
				ALUOp 			=> ALUop_IDR,
				ALUSrc 			=> ALUSrc_IDR,
				Zero 			=> Zero,
                ALU_Result		=> ALU_Result,
				Add_Result 		=> Add_Result,
				PC_plus_4		=> PC_plus_4_IDR,
                Clock			=> clock,
				Reset			=> reset );
				
   EXR : EX_Reg
   PORT MAP (  	Instruction_out 	=> Instruction_EXR,
				Instruction_in		=> Instruction_IDR,
		        ALU_Result_out	 	=> ALU_Result_EXR,
				ALU_Result_in		=> ALU_Result,
				read_data_2_out 	=> read_data_2_EXR,
				read_data_2_in		=> read_data_2_IDR,
				Add_Result_out      => Add_Result_EXR,
				Add_Result_in       => Add_Result,
				Branch_EX_OUT		=> Branch_EXR,
				RegDst_EX_OUT 		=> RegDst_EXR,
				MemtoReg_EX_OUT 	=> MemtoReg_EXR,
				MemRead_EX_OUT 		=> MemRead_EXR,
				MemWrite_EX_OUT 	=> MemWrite_EXR,
				zero_OUT			=> Zero_EXR,
				zero_IN				=> Zero,
				MemtoReg_EX_IN 		=> MemtoReg_IDR,
				RegDst_EX_IN 		=> RegDst_IDR,
				MemRead_EX_IN 		=> MemRead_IDR,
				MemWrite_EX_IN 		=> MemWrite_IDR,
				Branch_EX_IN		=> Branch_IDR,
				clock 				=> clock ); 			
				

   MEM:  dmemory
	PORT MAP (	read_data 		=> read_data,
				address 		=> ALU_Result_EXR (9 DOWNTO 2),--jump memory address by 4
				write_data 		=> read_data_2_EXR,
				MemRead 		=> MemRead_EXR, 
				Memwrite 		=> MemWrite_EXR, 
                clock 			=> clock,  
				reset 			=> reset );
				
   MEMR : MEM_Reg
    PORT MAP ( 	Instruction_out 	=> Instruction_MEM,
				Instruction_in		=> Instruction_EXR,
				ALU_Result_out	 	=> ALU_Result_MEM,
				ALU_Result_in		=> ALU_Result_EXR,
				read_data_out 		=> read_data_MEM,
				RegDst_MEM_OUT 		=> RegDst_MEM,
				RegDst_MEM_IN 		=> RegDst_EXR,
				read_data_in		=> read_data,
				MemtoReg_MEM_OUT 	=> MemtoReg_MEM,
				MemtoReg_MEM_IN 	=> MemtoReg_EXR,
				clock 				=> clock ); 				
				
   WB: WRITEBACK
	PORT MAP ( read_data 		=> read_data_MEM,
			   ALU_Result       => ALU_Result_MEM,
			   MemtoReg         => MemtoReg_MEM,
			   write_data       => write_data_WB );
				
	IO_REG: IO_Register
	PORT MAP ( 	clock           => clock,
				MemWrite 		=> MemWrite_EXR,
				sevseg_sel      => sevseg_sel,
				write_data 		=> Instruction_EXR,
				address 	    => ALU_Result_EXR (9 DOWNTO 2),--jump memory address by 4
				seven_seg0      => seven_seg0,
				seven_seg1		=> seven_seg1,
				seven_seg2		=> seven_seg2,
				seven_seg3		=> seven_seg3 );
END structure;

