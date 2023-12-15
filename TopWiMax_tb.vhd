library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;
use work.Test_Pack.all;

entity TopWiMax_tb is 
end TopWiMax_tb;

architecture TopWiMax_tb_rtl of TopWiMax_tb is
    component TopWiMax  
    port(
        CLK_50Mhz                            	  : in    std_logic; 
        reset                 	                  : in    std_logic; 

        TopWiMax_in_valid                 	      : in    std_logic; 
        load               	                      : in    std_logic; 
        WiInput                               	  : in    std_logic; 
        
        TopWiMax_out_valid                        : out   std_logic;
        WiOutput1                              	  : out   std_logic_vector(15 downto 0); 
        WiOutput2                              	  : out   std_logic_vector(15 downto 0) 
    );
    end component;

    
    signal   clk_50                               : std_logic := '0'; 
    signal   reset                                : std_logic; 
    signal   TopWiMax_in_valid                                   : std_logic; 
    signal   load                                 : std_logic; 
    signal   test_in_vector                       : std_logic_vector(95 downto 0) := RANDI_VECTOR_INPUT;
    -- signal   demodulation_vector                  : std_logic_vector(191 downto 0) := (others => '0');
    signal   test_in_bit                          : std_logic;
    signal   test_out1_bit                        : std_logic_vector(15 downto 0) ;
    signal   test_out2_bit                        : std_logic_vector(15 downto 0) ;
    signal   out_valid                            : std_logic;
    
    --alias signals 
    signal  rand_out_alias_signal                 : std_logic;
    signal  rand_valid_alias_signal               : std_logic;
    signal  fec_out_alias_signal                  : std_logic;
    signal  fec_valid_alias_signal                : std_logic;
    signal  int_out_alias_signal                  : std_logic;
    signal  int_valid_alias_signal                : std_logic;
    
    -- Randi Self Checker Signals
    signal RANDI_Output_Expected                        : std_logic_vector(95 downto 0) := RANDI_VECTOR_OUTPUT;
    signal RANDI_Output_Vector                      : std_logic_vector(95 downto 0) := (others => '0');
    signal test_pass_RANDI                          : boolean;

    -- FEC Self Checker Signals
    signal   test_pass_fec_encoder                : boolean := true;
    signal   FEC_Expected_Output                  : std_logic_vector(191 downto 0) := FEC_VECTOR_OUTPUT;
    signal   FEC_Output_Vector                      : std_logic_vector(191 downto 0) := x"000000000000000000000000000000000000000000000000";

    -- INTER Self Checker Signals
    signal test_pass_INTER_encoder                : boolean := true;
    signal INTER_Output_Vector                        : std_logic_vector(191 downto 0) := x"000000000000000000000000000000000000000000000000";
    signal INTER_Expected_Output                  : std_logic_vector(191 downto 0) := INTER_VECTOR_OUTPUT;

    -- MODU Self Checker Signals
    signal test_out_vector_Q         : std_logic_vector(1535 downto 0) := (others => '0');
    signal test_out_vector_I         : std_logic_vector(1535 downto 0) := (others => '0');
    signal test_out_vector_Q1        : std_logic_vector(1535 downto 0) := (others => '0');
    signal test_out_vector_I1        : std_logic_vector(1535 downto 0) := (others => '0');
    signal MODU_Expected_Output_Q    : std_logic_vector(1535 downto 0) := MODU_VECTOR_OUTPUT_Q;
    signal MODU_Expected_Output_I    : std_logic_vector(1535 downto 0) := MODU_VECTOR_OUTPUT_I;
    signal test_pass_MODU_encoder_I                : boolean := true;
    signal test_pass_MODU_encoder_Q                : boolean := true;


    -- Auto Streaming Test
    -- constant streamingnumber : integer := 1;


    begin 

    --instantiations 
    twimax : TopWiMax port map 
    (
        CLK_50Mhz             => clk_50,
        reset                 => reset,            
        TopWiMax_in_valid     => TopWiMax_in_valid,    
        load                  => load,    	   
        WiInput               => test_in_bit,        
        TopWiMax_out_valid    => out_valid,       
        WiOutput1             => test_out1_bit,           
        WiOutput2             => test_out2_bit         
    );

    --clk process 
    clk_50 <= not clk_50 after CLK_50MHz_Period_HALF; 

    --assigning input bits from the vector 
    process begin 
        reset <= '1'; --initialize values 
        TopWiMax_in_valid    <= '0';
        wait for 3*CLK_50MHz_Period_HALF;     --make sure a pos edge came before changing the reset 
        reset <= '0'; 
        wait for 2*CLK_50MHz_Period_HALF;
        load <= '1';    --take seed into module 
        wait for 1.5*CLK_50MHz_Period; --bec of 75 ns edge the next pos edge so make sure a pos edge came 
        load <= '0'; 
        TopWiMax_in_valid <= '1'; 
        --Inputting steams 
        report procedure_Break_Notice;
        report procedure_start_SIMULATION_Notice severity note;
        report procedure_Break_Notice;

        report procedure_Break_Notice;
        report "------------------------------ Inputting {2} Input Streams --------------------------------" severity note;
        report procedure_Break_Notice;
        report "---------------------------- ### Starting Inputting the First stream: " severity note;
        report procedure_Break_Notice;
        procedure_96_inputs(0, 95, test_in_vector, test_in_bit);
        report "----------------------------- ### Done Inputting the First stream: " severity note;
        report procedure_Break_Notice;
        report "----------------------------- ## Starting Inputting the Second stream: " severity note;
        report procedure_Break_Notice;
        procedure_96_inputs(0, 95, test_in_vector, test_in_bit);
        report "----------------------------- ## Done Inputting the Second stream: " severity note;
        report procedure_Break_Notice;
        report "------------------------------ Finishehd Inputting {2} Input Streams --------------------------" severity note;
        report procedure_Break_Notice;
      --  procedure_96_inputs(0, 95, test_in_vector, test_in_bit);
       -- procedure_96_inputs(0, 95, test_in_vector, test_in_bit);
      --  procedure_96_inputs(0, 95, test_in_vector, test_in_bit);     
        test_in_bit <= '0';   
        TopWiMax_in_valid  <= '0';
        wait; --makes process executes once 
    end process;


    process 
    variable i : integer := 191;
    --demodulation for testing 
    -- procedure demodulation_procedure is 
    --     begin   
    --         i := 191;
    --         demodulation_vector <= (others => '0');
    --         while (i > 0) loop 
    --             if (test_out1_bit = ZeroTS and test_out2_bit = ZeroTS) then 
    --                 demodulation_vector(i)      <= '0';
    --                 demodulation_vector(i-1)    <= '0';
    --             elsif(test_out1_bit = NZeroTS and test_out2_bit = NZeroTS) then 
    --                 demodulation_vector(i)      <= '1';
    --                 demodulation_vector(i-1)    <= '1';
    --             elsif(test_out1_bit = NZeroTS and test_out2_bit = ZeroTS) then 
    --                 demodulation_vector(i)      <= '1';
    --                 demodulation_vector(i-1)    <= '0';
    --             elsif(test_out1_bit = ZeroTS and test_out2_bit = NZeroTS) then
    --                 demodulation_vector(i)      <= '0';
    --                 demodulation_vector(i-1)    <= '1';
    --             end if;
    --             i := i - 2; 
    --             wait for 2 * CLK_100MHz_Period;
    --         end loop;
    --     end demodulation_procedure;
    begin         
        wait until out_valid = '1'; 
        wait for 2 ns; 

        report "========================================================================================================";
        report "------------------------------------- STARTED OUTPUT SELF CHECKER --------------------------------------";
        report "========================================================================================================";  
        test_pass_MODU_encoder_Q <= true;  -- Reset the test flag for MODU Q outputs
        test_pass_MODU_encoder_I <= true;  -- Reset the test flag for MODU I outputs
        report "----------------------------- Checking (Demodulating) (2) output streams ---------------" severity note;
        report procedure_Break_Notice;
        report "------------------------ ### Started Checking First MODU Output stream: " severity note;
        procedure_192_outputs_MODU_x2(0, 1535, test_out_vector_Q, test_out1_bit, MODU_Expected_Output_Q, test_pass_MODU_encoder_Q, test_out_vector_I, test_out2_bit, MODU_Expected_Output_I, test_pass_MODU_encoder_I);
        assert test_pass_MODU_encoder_Q = false 
            report "------------------------ ### First MODU Output Stream: 1536 Q Values Successed" severity note;
        assert test_pass_MODU_encoder_Q = true 
            report "------------------------ ### First MODU Output Stream: 1536 Q Values Failed" severity note;
            report procedure_Break_Notice;
        assert test_pass_MODU_encoder_I = false 
            report "------------------------ ### First MODU Output Stream: 1536 I Values Successed" severity note;
        assert test_pass_MODU_encoder_I = true 
            report "------------------------ ### First MODU Output Stream: 1536 I Values failed" severity note;
        report procedure_Break_Notice;
        report "--------------------------- ### Ended Checking MODU First Output stream " severity note;
        report procedure_Break_Notice;

        report "-------------------------- ### Started Checking MODU Second Output stream: " severity note;
        procedure_192_outputs_MODU_x2(0, 1535, test_out_vector_Q1, test_out1_bit, MODU_Expected_Output_Q, test_pass_MODU_encoder_Q, test_out_vector_I1, test_out2_bit, MODU_Expected_Output_I, test_pass_MODU_encoder_I);
        assert test_pass_MODU_encoder_Q = false 
            report "------------------------ ### Second MODU Output Stream: 1536 Q Values Successed" severity note;
        assert test_pass_MODU_encoder_Q = true 
            report "------------------------ ### Second MODU Output Stream: 1536 Q Values Failed" severity note;
        

            report procedure_Break_Notice;
        assert test_pass_MODU_encoder_I = false 
            report "------------------------ ### Second MODU Output Stream: 1536 I Values Successed" severity note;
        assert test_pass_MODU_encoder_I = true 
            report "------------------------ ### Second MODU Output Stream: 1536 I Values Failed" severity note;
        report procedure_Break_Notice;
        report "--------------------------- ### Ended Checking MODU Second Output stream " severity note;
        report procedure_Break_Notice;
        report "----------------------------- Ended Checking (Demodulating) (2) output streams ---------------" severity note;
        report procedure_Break_Notice;
        -- demodulation_procedure;
        -- report "Demodulation finished. " severity note;
        -- assert demodulation_vector /= MODU_VECTOR_INPUT
        --     report "Demodulated vector is equal to the input one, test succeeded on stream 2" severity note; 
        --     assert demodulation_vector = MODU_VECTOR_INPUT
        --         report "Demodulated vector is not equal to input 2 stream vector, test failed" severity error;      
                
        -- report "Starting Demodulation of modulated output 3 stream: " severity note;
        -- demodulation_procedure;
        -- report "Demodulation finished. " severity note;
        -- assert demodulation_vector /= MODU_VECTOR_INPUT
        --     report "Demodulated vector is equal to the input one, test succeeded on stream 3" severity note; 
        --     assert demodulation_vector = MODU_VECTOR_INPUT
        --         report "Demodulated vector is not equal to input 3 stream vector, test failed" severity error;   

        -- report "Starting Demodulation of modulated output 4 stream: " severity note;
        -- demodulation_procedure;
        -- report "Demodulation finished. " severity note;
        -- assert demodulation_vector /= MODU_VECTOR_INPUT
        --     report "Demodulated vector is equal to the input one, test succeeded on stream 4" severity note; 
        --     assert demodulation_vector = MODU_VECTOR_INPUT
        --         report "Demodulated vector is not equal to input 4 stream vector, test failed" severity error;   

        -- report "Starting Demodulation of modulated output 5 stream: " severity note;
        -- demodulation_procedure;
        -- report "Demodulation finished. " severity note;
        -- assert demodulation_vector /= MODU_VECTOR_INPUT
        --     report "Demodulated vector is equal to the input one, test succeeded on stream 5" severity note; 
        --     assert demodulation_vector = MODU_VECTOR_INPUT
        --         report "Demodulated vector is not equal to input 5 stream vector, test failed" severity error;   

        -- report END_SIMULATION_Notice;

        report procedure_Break_Notice;
        report END_SIMULATION_Notice severity note;
        report procedure_Break_Notice;

        wait;
    end process;

    -------------------------------------------------------------- Blocks Self-Check Verification-------------------------------------------------------------- 

    -- Randi
    process 
    begin 
        wait for 1 ns;
        wait until rand_valid_alias_signal = '1'; 
        wait for 5 ns;
        report "========================================================================================================";
        report "------------------------------------- STARTED Blocks SELF CHECKER --------------------------------------";
        report "========================================================================================================";               
        report "---------------------------- Started self checker for: Randomizer Block --------------------------------";
        report "========================================================================================================";        
        report "---------------------------------- ### The First Randimoizer Input Stream  " severity note;
            procedure_96_outputs_RANDI(0, 95, RANDI_Output_Vector, rand_out_alias_signal, RANDI_Output_Expected, test_pass_RANDI);
            report procedure_Break_Notice;
            assert test_pass_RANDI = false 
                report "------------------------- ### Randomizer First Input Stream test passed successfully" severity note ;
            assert test_pass_RANDI = true 
                report "------------------------- ### Randomizer First Input Stream test Failed" severity note ;
            
            report procedure_Break_Notice;
            report "---------------------------------- ## The Second Randimoizer Input Stream  " severity note;
            procedure_96_outputs_RANDI(0, 95, RANDI_Output_Vector, rand_out_alias_signal, RANDI_Output_Expected, test_pass_RANDI);
            report procedure_Break_Notice;
            assert test_pass_RANDI = false 
                report "------------------------- ## Randomizer Second Input Stream test passed successfully" severity note ;
            assert test_pass_RANDI = true 
                report "------------------------- ## Randomizer Second Input Stream test Failed" severity note ;
            
            
                report "========================================================================================================";
                report "-------------------Finished self checker for: RANDI Block--------------------------";
                report "========================================================================================================";
                

    --     checker_randomizer;
    --     if (test_pass_randomizer = true) then 
    --         report "Randomizer stream 1 test passed successfully" ;
    --     end if;
    --     report "Randomizer stream 2: ";
    --     checker_randomizer;
    --     if (test_pass_randomizer = true) then 
    --         report "Randomizer stream 2 test passed successfully" ;
    --     end if;
    --     report "Randomizer stream 3: ";
    --     checker_randomizer;
    --     if (test_pass_randomizer = true) then 
    --         report "Randomizer stream 3 test passed successfully" ;
    --     end if;
    --     report "Randomizer stream 4: ";
    --     checker_randomizer;
    --     if (test_pass_randomizer = true) then 
    --         report "Randomizer stream 4 test passed successfully" ;
    --     end if;
    --     report "Randomizer stream 5: ";
    --     checker_randomizer;
    --     if (test_pass_randomizer = true) then 
    --         report "Randomizer stream 5 test passed successfully" ;
    --     end if;


        wait;
    end process;

    -- FEC 
    process 
        begin 
         wait for 1 ns;
         wait until fec_valid_alias_signal = '1'; 
         wait for 5 ns;

         report "========================================================================================================";               
         report "---------------------------- Started self checker for: FEC Block --------------------------------";
         report "========================================================================================================";        
         report "---------------------------------- ### The First FEC Input Stream  " severity note;
            procedure_192_outputs_FEC(0, 191, FEC_Output_Vector, fec_out_alias_signal, FEC_Expected_Output, test_pass_fec_encoder);
             report procedure_Break_Notice;
             assert test_pass_fec_encoder = false 
                 report "------------------------- ### FEC First Input Stream test passed Successfully" severity note ;
             assert test_pass_fec_encoder = true 
                 report "------------------------- ### FEC First Input Stream test Failed" severity note ;
             
             report procedure_Break_Notice;
             report "---------------------------------- ## The Second FEC Input Stream  " severity note;
             procedure_192_outputs_FEC(0, 191, FEC_Output_Vector, fec_out_alias_signal, FEC_Expected_Output, test_pass_fec_encoder);
             report procedure_Break_Notice;
             assert test_pass_fec_encoder = false 
                 report "------------------------- ## FEC Second Input Stream test passed Successfully" severity note ;
             assert test_pass_fec_encoder = true 
                 report "------------------------- ## FEC Second Input Stream test Failed" severity note ;
             
                 report "========================================================================================================";
                 report "-------------------Finished self checker for: FEC Block--------------------------";
                 report "========================================================================================================";
                 



    --     report "-------------------Started handshake self checker for: FEC Encoder Block--------------------------";
    --     report "FEC stream 1: ";
    --     fec_checker;
    --     if (test_pass_fec_encoder = true) then 
    --         report "FEC Encoder stream 1 test passed successfully" ;
    --     end if;
    --     report "FEC stream 2: ";
    --     fec_checker;
    --     if (test_pass_fec_encoder = true) then 
    --         report "FEC Encoder stream 2 test passed successfully" ;
    --     end if;
    --     report "FEC stream 3: ";
    --     fec_checker;
    --     if (test_pass_fec_encoder = true) then 
    --         report "FEC Encoder stream 3 test passed successfully" ;
    --     end if;
    --     report "FEC stream 4: ";
    --     fec_checker;
    --     if (test_pass_fec_encoder = true) then 
    --         report "FEC Encoder stream 4 test passed successfully" ;
    --     end if;
    --     report "FEC stream 5: ";
    --     fec_checker;
    --     if (test_pass_fec_encoder = true) then 
    --         report "FEC Encoder stream 5 test passed successfully" ;
    --     end if;
    --     report "-------------------Finished handshake self checker for: FEC Encoder Block--------------------------";
        wait;
    end process;

    -- INTER
    process 

    begin 
        wait for 1 ns;
        wait until int_valid_alias_signal = '1'; 
        wait for 5 ns;

        report "========================================================================================================";               
        report "---------------------------- Started self checker for: INTER Block --------------------------------";
        report "========================================================================================================";        
        report "---------------------------------- ### The First INTER Input Stream  " severity note;
            procedure_192_outputs_INTER(0, 191, INTER_Output_Vector, int_out_alias_signal, INTER_Expected_Output, test_pass_INTER_encoder);
            report procedure_Break_Notice;
            assert test_pass_INTER_encoder = false 
                report "------------------------- ### INTER First Input Stream test passed Successfully" severity note ;
            assert test_pass_INTER_encoder = true 
                report "------------------------- ### INTER First Input Stream test Failed" severity note ;
            
            report procedure_Break_Notice;
            report "---------------------------------- ## The Second INTER Input Stream  " severity note;
            procedure_192_outputs_INTER(0, 191, INTER_Output_Vector, int_out_alias_signal, INTER_Expected_Output, test_pass_INTER_encoder);
            report procedure_Break_Notice;
            assert test_pass_INTER_encoder = false 
                report "------------------------- ## INTER Second Input Stream test passed Successfully" severity note ;
            assert test_pass_INTER_encoder = true 
                report "------------------------- ## INTER Second Input Stream test Failed" severity note ;
            


    --     report "-------------------Started handshake self checker for: Interleaver Block--------------------------";
    --     report "Interleaver stream 1: ";
    --     interleaver_checker;
    --     if (test_pass_interleaver = true) then 
    --         report "Interleaver stream 1 test passed successfully" ;
    --     end if;
    --     report "Interleaver stream 2: ";
    --     interleaver_checker;
    --     if (test_pass_interleaver = true) then 
    --         report "Interleaver stream 2 test passed successfully" ;
    --     end if;
    --     report "Interleaver stream 3: ";
    --     interleaver_checker;
    --     if (test_pass_interleaver = true) then 
    --         report "Interleaver stream 3 test passed successfully" ;
    --     end if;
    --     report "Interleaver stream 4: ";
    --     interleaver_checker;
    --     if (test_pass_interleaver = true) then 
    --         report "Interleaver stream 4 test passed successfully" ;
    --     end if;
    --     report "Interleaver stream 5: ";
    --     interleaver_checker;
    --     if (test_pass_interleaver = true) then 
    --         report "Interleaver stream 5 test passed successfully" ;
    --     end if;
     report "========================================================================================================";
     report "-------------------Finished self checker for: INTER Block--------------------------";
     report "========================================================================================================";
     report "------------------------------------FINISHED SELF CHECKER--------------------------";
     report "========================================================================================================";
    wait;
    end process;

        -- Alias assignments 
        -- alias rand_out_alias_signal   is TopWiMax_tb.twimax.RANDI.RANDI_out;
        -- alias rand_valid_alias_signal is TopWiMax_tb.twimax.RANDI.RANDI_out_valid;
        -- alias fec_out_alias_signal    is TopWiMax_tb.twimax.fec_out;
        -- alias fec_valid_alias_signal  is TopWiMax_tb.twimax.FEC_encoder_out_valid_out;
        -- alias int_out_alias_signal    is TopWiMax_tb.twimax.INTER_out;
        -- alias int_valid_alias_signal  is TopWiMax_tb.twimax.INTER_out_valid;   
        rand_out_alias_signal   <=  <<signal .topwimax_tb.twimax.RANDI1.RANDI_output_data    : std_logic >>; 
        rand_valid_alias_signal <=  <<signal .topwimax_tb.twimax.RANDI1.RANDI_output_valid   : std_logic >>; 
        fec_out_alias_signal    <=  <<signal .topwimax_tb.twimax.fec1.fec_output_data        : std_logic >>;  
        fec_valid_alias_signal  <=  <<signal .topwimax_tb.twimax.fec1.fec_output_valid       : std_logic >>;
        int_out_alias_signal    <=  <<signal .topwimax_tb.twimax.int1.INTER_Output_data      : std_logic >>; 
        int_valid_alias_signal  <=  <<signal .topwimax_tb.twimax.int1.INTER_Output_valid     : std_logic >>;

end TopWiMax_tb_rtl;