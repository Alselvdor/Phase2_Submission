LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY MODU IS
  PORT (
    MODU_input_data       :IN  std_logic; 
    MODU_input_ready      :IN  std_logic;
	clk_100MHz            :IN  std_logic;                 
    clk_50MHz             :IN  std_logic;
    reset                 :IN  std_logic;
    MODU_output_valid     :OUT std_logic;
    MODU_output_Q         :OUT std_logic_vector(15 DOWNTO 0);
    MODU_output_I         :OUT std_logic_vector(15 DOWNTO 0)
  );
END ENTITY;

architecture MODU_rtl of MODU IS
    SIGNAL qpsk                    : std_logic_vector(1 DOWNTO 0);
    SIGNAL temp                    : std_logic;
	SIGNAL MODU_output_Q_t         : std_logic_vector(15 DOWNTO 0);
    SIGNAL MODU_output_I_t         : std_logic_vector(15 DOWNTO 0);
    SIGNAL MODU_output_valid_flag  : std_logic;
begIN

    Out_clk50 : process(clk_50MHz,reset,MODU_output_valid_flag,MODU_output_Q_t,MODU_output_I_t)
    begIN
        IF(reset = '1')THEN
            MODU_output_valid <= '0';
            MODU_output_Q <= (others =>'0');
            MODU_output_I <= (others =>'0');
        elsIF(rISINg_edge(clk_50MHz))THEN
            IF(MODU_output_valid_flag = '1')THEN
                MODU_output_valid <= MODU_output_valid_flag;
                MODU_output_Q <= MODU_output_Q_t;
                MODU_output_I <= MODU_output_I_t;
            else
                MODU_output_valid <= '0';
                MODU_output_Q <= (others =>'0');
                MODU_output_I <= (others =>'0');
            END IF;
        END IF;
    END process;
    
    shift_clk100 : process(clk_100MHz,reset,MODU_input_data,MODU_input_ready)
    begIN
        IF(reset = '1')THEN
            qpsk <= (others =>'0');
            temp <= '0';
            MODU_output_valid_flag <= '0';
        elsIF(rISINg_edge(clk_100MHz))THEN
            IF(MODU_input_ready = '1')THEN
                temp <= temp xor '1';
                qpsk(0) <= MODU_input_data;
                qpsk(1) <= qpsk(0);
            END IF;
            MODU_output_valid_flag <= temp and MODU_input_ready;
        END IF;
    END process;
    MODU_output_Q_t <= x"5a7f" when (qpsk(1) = '0') else x"a581";
    MODU_output_I_t <= x"5a7f" when (qpsk(0) = '0') else x"a581";

END MODU_rtl;