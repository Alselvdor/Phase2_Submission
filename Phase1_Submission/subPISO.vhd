library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity subPISO is
  port (
    subPISO_input_data   : in  std_logic_vector (191 downto 0);
	 subPISO_input_ready  : in std_logic;
    DoneShifting         : in  std_logic;         
    clk                  : in  std_logic;                     
    reset                : in  std_logic;
	 subPISO_output_data  : out std_logic;
    subPISO_output_valid : out std_logic
  );
end entity;

architecture subPISO_rtl of subPISO is
    signal temp :std_logic_vector (191 downto 0);
    signal subPISO_input_ready_r   : std_logic;
    signal subPISO_input_ready_r_r : std_logic;

	 begin
    testpiso: process(clk,reset,subPISO_input_ready)
    begin
        if(reset = '1')then
            subPISO_input_ready_r <= '0';
        elsif(rising_edge(clk))then
            subPISO_input_ready_r <= subPISO_input_ready;
            subPISO_input_ready_r_r <= subPISO_input_ready_r;
        end if;
    end process;
    process (clk, reset,subPISO_input_data,DoneShifting,subPISO_input_ready_r,temp) begin
        if (reset = '1') then
            temp <= (others=>'0');
        elsif (rising_edge(clk)) then
            if (DoneShifting = '1') then
                temp <= subPISO_input_data;
            elsif(subPISO_input_ready_r = '1')then
					subPISO_output_data <= temp(191);
					temp <= temp(190 downto 0) & '0';
				end if;
        end if;
    end process;
    subPISO_output_valid <= subPISO_input_ready_r_r;
end subPISO_rtl;