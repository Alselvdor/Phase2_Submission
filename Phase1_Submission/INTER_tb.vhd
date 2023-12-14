library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity INTER_tb is end entity;

architecture INTER_tb_rtl of INTER_tb is
    component INTER is
        port(
            INTER_input_data   : in  std_logic;
            INTER_input_ready  : in  std_logic;
            clk                : in  std_logic;
            reset              : in  std_logic;
            INTER_output_data  : out std_logic;
            INTER_output_valid : out std_logic
            );
    end component;
    signal clk, reset, INTER_input_ready, INTER_input_data: std_logic := '0';

    signal temp_data_out: std_logic;
    signal temp_valid_out: std_logic;
    signal ROM_input: std_logic_vector(0 to 191) := X"2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA";
    signal ROM_output: std_logic_vector(0 to 191) := X"4B047DFA42F2A5D5F61C021A5851E9A309A24FD58086BD1E";
    constant PERIOD : time := 10 ns; 
    begin
    clk <= not clk after PERIOD/2;
    interdut: INTER
    port map (INTER_input_data => INTER_input_data, INTER_input_ready =>INTER_input_ready, clk =>clk, reset =>reset, INTER_output_data => temp_data_out, INTER_output_valid => temp_valid_out);
        process
              variable tb_test: boolean;
        begin
            reset <= '1'; wait for (2* PERIOD);
    
            reset <= '0';
            wait for PERIOD;
            
            for i in 0 to 191 loop
                INTER_input_ready <= '1';
                INTER_input_data <= ROM_input(i);
                wait until falling_edge(clk);
            end loop;
            INTER_input_ready <= '0';
            wait until temp_valid_out = '1';
            for i in 0 to 191 loop
            wait until falling_edge(clk);
            if ((temp_data_out = ROM_output(i)) and (temp_valid_out = '1'))then
                tb_test := true;
                else
                     tb_test := false;
            end if;
                assert tb_test
                    report "test failed."
                    severity note;
            end loop;
    
    
            for i in 0 to 191 loop
                INTER_input_ready <= '1';
                INTER_input_data <= ROM_input(i);
                wait until falling_edge(clk);
            end loop;
            INTER_input_ready <= '0';
            wait until temp_valid_out = '1';
            for i in 0 to 191 loop
            wait until falling_edge(clk);
            if ((temp_data_out = ROM_output(i)) and (temp_valid_out = '1'))then
                tb_test := true;
                else
                     tb_test := false;
            end if;
                assert tb_test
                    report "test failed."
                    severity note;
            end loop;
    
            wait;
        end process ;
    
end INTER_tb_rtl;