library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;
USE work.Test_Pack.ALL;


entity FEC_tb is
end FEC_tb;

architecture FEC_tb_rtl of FEC_tb is
    component FEC
    port(
        clk_50mhz                 : in    std_logic; 
        clk_100mhz                : in    std_logic; 

        reset               	  : in    std_logic; 

        FEC_input_data            : in    std_logic; 
        FEC_input_valid           : in    std_logic; 
        FEC_output_data           : out   std_logic;
        FEC_output_valid          : out   std_logic 
    );
    end component;

    -- Constants 
    -- constant CLK_50MHz_Period                     : Time := 20 ns; 
    -- constant CLK_50MHz_test                       : Time := CLK_50MHz_Period / 2; 
    -- constant CLK_100MHz_Period                    : Time := 10 ns; 
    -- constant CLK_100MHz_test                      : Time := CLK_100MHz_Period / 2;
    -- Signals                 
    signal   CLK_50MHz                            : std_logic := '0'; 
    signal   CLK_100MHz                           : std_logic := '1'; 
    signal   reset                                : std_logic; 
    signal   FEC_input_valid                      : std_logic; 
    signal   test_in_vector                       : std_logic_vector(95 downto 0) := FEC_VECTOR_INPUT;
    signal   test_out_vector                      : std_logic_vector(191 downto 0) := x"000000000000000000000000000000000000000000000000";
    signal   FEC_Expected_Output                  : std_logic_vector(191 downto 0) := FEC_VECTOR_OUTPUT;
    signal   FEC_input_data                       : std_logic;
    signal   test_pass_fec_encoder                : boolean := true;
    signal   FEC_output_data                      : std_logic;
    signal   FEC_output_valid                     : std_logic;
    signal   flag                                 : std_logic := '0';
begin 

    --instant 
    uut: FEC port map (CLK_50MHz => CLK_50MHz, CLK_100MHz => CLK_100MHz, reset => reset, FEC_input_data => FEC_input_data, FEC_input_valid => FEC_input_valid, FEC_output_data => FEC_output_data, FEC_output_valid => FEC_output_valid);

    --clk process 
    CLK_50MHz <= not CLK_50MHz after CLK_50MHz_test; 
    CLK_100MHz <= not CLK_100MHz after CLK_100MHz_test; 

    --serial input in 
    process begin 
        reset   <= '1'; 
        wait for CLK_50MHz_Period + 10 ns; 
        reset   <= '0';
        FEC_input_valid      <= '1';

        report procedure_Break_Notice;
        report procedure_start_SIMULATION_Notice severity note;
        report procedure_Break_Notice;
        report "Starting FEC" severity note; 
        report procedure_Break_Notice;
        --test_in_vector FEC_input_data
        report "First Input Streaming" severity note; 
        report procedure_Break_Notice;
        procedure_96_inputs_FEC(0, 95, test_in_vector, FEC_input_data);
        report procedure_Break_Notice;
        report "Second Input Streaming" severity note; 
        report procedure_Break_Notice;
        procedure_96_inputs_FEC(0, 95, test_in_vector, FEC_input_data);
        report procedure_Break_Notice;
        report "Third Input Streaming" severity note; 
        report procedure_Break_Notice;
        procedure_96_inputs_FEC(0, 95, test_in_vector, FEC_input_data);
        report procedure_Break_Notice;
        report "Fourth Input Streaming" severity note; 
        report procedure_Break_Notice;
        procedure_96_inputs_FEC(0, 95, test_in_vector, FEC_input_data);
        report procedure_Break_Notice;
        report "Fifth Input Streaming" severity note; 
        report procedure_Break_Notice;
        procedure_96_inputs_FEC(0, 95, test_in_vector, FEC_input_data);
        report procedure_Break_Notice;
        report "Done with Inputs Streaming" severity note; 
        report procedure_Break_Notice;


        -- for i in 95 downto 0 loop 
        --     FEC_input_data <= test_in_vector(i);
        --     wait for CLK_50MHz_Period; 
        -- end loop;
        -- for i in 95 downto 0 loop 
        --     FEC_input_data <= test_in_vector(i);
        --     wait for CLK_50MHz_Period; 
        -- end loop;

        -- for i in 95 downto 0 loop 
        --     FEC_input_data <= test_in_vector(i);
        --     wait for CLK_50MHz_Period; 
        -- end loop;

        -- for i in 95 downto 0 loop 
        --     FEC_input_data <= test_in_vector(i);
        --     wait for CLK_50MHz_Period; 
        -- end loop;

        -- for i in 95 downto 0 loop 
        --     FEC_input_data <= test_in_vector(i);
        --     wait for CLK_50MHz_Period; 
        -- end loop;
        FEC_input_valid      <= '0';
        --wait until flag = '1'; 
        --FEC_input_data <= '0';
        wait;
    end process; 

    --check output 
    process begin 
        wait until FEC_output_valid = '1';
        wait for 2 ns;
     --  test_out_vector FEC_output_data:
    report "Starting with Output Streaming" severity note; 
    report procedure_Break_Notice;
    report "First Output Streaming" severity note; 
    procedure_192_outputs_FEC(0, 191, test_out_vector, FEC_output_data, FEC_Expected_Output, test_pass_fec_encoder);
    report "Second Output Streaming" severity note; 
    procedure_192_outputs_FEC(0, 191, test_out_vector, FEC_output_data, FEC_Expected_Output, test_pass_fec_encoder);
    report "Third Output Streaming" severity note; 
    procedure_192_outputs_FEC(0, 191, test_out_vector, FEC_output_data, FEC_Expected_Output, test_pass_fec_encoder);
    report "Fourth Output Streaming" severity note; 
    procedure_192_outputs_FEC(0, 191, test_out_vector, FEC_output_data, FEC_Expected_Output, test_pass_fec_encoder);
    report "Fifth Output Streaming" severity note; 
    procedure_192_outputs_FEC(0, 191, test_out_vector, FEC_output_data, FEC_Expected_Output, test_pass_fec_encoder);
    report "Done with Output Streaming" severity note; 
    report procedure_Break_Notice;



        assert test_pass_fec_encoder = false 
            report procedure_Break_Notice;
            report "Test on 192 inputs passed successfully!" severity note; 
            report procedure_Break_Notice;
        report END_SIMULATION_Notice severity note;
        report procedure_Break_Notice;


        -- for i in 191 downto 0 loop 
        --     test_out_vector(i) <= FEC_output_data; 
        --     wait for CLK_100MHz_Period; 
        -- end loop;
        -- for i in 191 downto 0 loop 
        --     test_out_vector(i) <= FEC_output_data; 
        --     wait for CLK_100MHz_Period; 
        -- end loop;
        -- for i in 191 downto 0 loop 
        --     test_out_vector(i) <= FEC_output_data; 
        --     wait for CLK_100MHz_Period; 
        -- end loop;
        -- for i in 191 downto 0 loop 
        --     test_out_vector(i) <= FEC_output_data; 
        --     wait for CLK_100MHz_Period; 
        -- end loop;
        -- for i in 191 downto 0 loop 
        --     test_out_vector(i) <= FEC_output_data; 
        --     wait for CLK_100MHz_Period; 
        -- end loop;

        --			 -- Procedure for filling FEC input
		--	 procedure_96_inputs_FEC(0, 95, test_in_vector, FEC_input_data);

		--	 -- Procedure for checking FEC output
		--	 procedure_192_outputs(0, 191, FEC_output_data, flag);
        flag    <= '1'; 
        wait;
    end process;
end FEC_tb_rtl;
