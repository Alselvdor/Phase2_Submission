library ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

entity subSIPO is
  port (
    subSIPO_input_data     : in  std_logic;
    subSIPO_input_ready    : in  std_logic;
    clk                    : in  std_logic;    
    reset                  : in  std_logic;      
    DoneShifting           : out std_logic;
	 subSIPO_output_data    : out std_logic_vector (191 downto 0);
	 subSIPO_output_valid   : out std_logic
    );
end entity;

architecture subSIPO_rtl of subSIPO is

	signal temp    : std_logic_vector (191 downto 0);
	signal temp1   : std_logic_vector (191 downto 0);
	signal counter : integer:= 0;
begin
    process (clk, reset,subSIPO_input_ready) begin
        if (reset = '1') then
		  
            temp <= (others=>'0');
            temp1 <= (others=>'0');
				counter <= 0;
				
        elsif (rising_edge(clk)) then
            if (subSIPO_input_ready = '1') then
                counter <= counter + 1;
					 if (counter = 192) then
                    counter <= 1;
                end if;
                temp(0) <= subSIPO_input_data;
                temp(191 downto 1) <= temp(190 downto 0);
            else
                counter <= 0;
            end if;
            temp1(0) <= subSIPO_input_ready; 
				temp1(191 downto 1) <= temp1(190 downto 0);
        end if;
    end process;
		subSIPO_output_valid <= temp1(191);
		subSIPO_output_data <= temp;
		DoneShifting <= '1' when (counter = 192) else '0';
end subSIPO_rtl;