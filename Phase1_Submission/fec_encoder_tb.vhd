library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

entity FEC_tb is
end FEC_tb;

architecture FEC_tb_rtl of FEC_tb is
    component FEC
    port(
    clk_50mhz                 : in    std_logic; 
    clk_100mhz               : in    std_logic; 
    reset               	  : in    std_logic; 
    FEC_input_ready           : in    std_logic; 
    FEC_input_data            : in    std_logic; 
    FEC_output_valid          : out   std_logic; 
    FEC_output_data           : out   std_logic

        );
    end component;

    --constants 
    constant CLK_50MHz                        : Time := 20 ns; 
    constant CLK_50MHz_test                   : Time := CLK_50MHz / 2; 
    constant CLK_100MHz                       : Time := 10 ns; 
    constant CLK_100MHz_test                  : Time := CLK_100MHz / 2;
    --signals                 
    signal   clk_50                               : std_logic := '0'; 
    signal   clk_100                              : std_logic := '1'; 
    signal   reset                                : std_logic; 
    signal   en                                   : std_logic; 
    signal   test_in_vector                       : std_logic_vector(95 downto 0) := x"558AC4A53A1724E163AC2BF9";
    signal   test_out_vector                      : std_logic_vector(191 downto 0) := x"000000000000000000000000000000000000000000000000";
    signal   test_in_bit                          : std_logic;
    signal   test_out_bit                         : std_logic;
    signal   out_valid                            : std_logic;
    signal   flag                                 : std_logic := '0';
begin 

    --instant 
    uut: FEC port map (clk_50mhz => clk_50, clk_100mhz => clk_100, reset => reset, FEC_input_ready => en, FEC_input_data => test_in_bit, FEC_output_valid => out_valid, FEC_output_data => test_out_bit);

    --clk process 
    clk_50 <= not clk_50 after CLK_50MHz_test; 
    clk_100 <= not clk_100 after CLK_100MHz_test; 

    --serial input in 
    process begin 
        reset   <= '1'; 
        wait for CLK_50MHz + 10 ns; 
        reset   <= '0';
        en      <= '1';
        for i in 95 downto 0 loop 
            test_in_bit <= test_in_vector(i);
            wait for CLK_50MHz; 
        end loop;

        for i in 95 downto 0 loop 
            test_in_bit <= test_in_vector(i);
            wait for CLK_50MHz; 
        end loop;

        for i in 95 downto 0 loop 
            test_in_bit <= test_in_vector(i);
            wait for CLK_50MHz; 
        end loop;

        for i in 95 downto 0 loop 
            test_in_bit <= test_in_vector(i);
            wait for CLK_50MHz; 
        end loop;

        for i in 95 downto 0 loop 
            test_in_bit <= test_in_vector(i);
            wait for CLK_50MHz; 
        end loop;

        -- wait until flag = '1'; 
        en  <= '0';
        wait;
    end process; 

    --check output 
    process begin 
        wait until out_valid = '1';
        wait for 2 ns;
        for i in 191 downto 0 loop 
            test_out_vector(i) <= test_out_bit; 
            wait for CLK_100MHz; 
        end loop;

        for i in 191 downto 0 loop 
            test_out_vector(i) <= test_out_bit; 
            wait for CLK_100MHz; 
        end loop;

        for i in 191 downto 0 loop 
            test_out_vector(i) <= test_out_bit; 
            wait for CLK_100MHz; 
        end loop;

        for i in 191 downto 0 loop 
            test_out_vector(i) <= test_out_bit; 
            wait for CLK_100MHz; 
        end loop;

        for i in 191 downto 0 loop 
            test_out_vector(i) <= test_out_bit; 
            wait for CLK_100MHz; 
        end loop;


        flag    <= '1'; 
        wait;
    end process;
end FEC_tb_rtl;