library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity INTER IS
port(
        INTER_Input_data   : IN  std_logic;
        INTER_Input_ready  : IN  std_logic;
        clk                : IN  std_logic;
        reset              : IN  std_logic;
        INTER_Output_data  : OUT std_logic;
        INTER_Output_valid : OUT std_logic
        );
end INTER;

architecture INTER_rtl of INTER is
    component subPISO is
        port (
            subPISO_Input_data   : in  std_logic_vector (191 downto 0);
            subPISO_Input_ready  : in  std_logic;
            DoneShifting         : in  std_logic;         
            clk                  : in  std_logic;                     
            reset                : in  std_logic;
            subPISO_Output_data  : out std_logic;
            subPISO_Output_valid : out std_logic
        );
    end component;

    component subSIPO is
        port (
            subSIPO_Input_data     : in  std_logic;
            subSIPO_Input_ready    : in  std_logic;
            clk                    : in  std_logic;    
            reset                  : in  std_logic;      
            DoneShifting           : out std_logic;
            subSIPO_Output_data    : out std_logic_vector (191 downto 0);
            subSIPO_Output_valid   : out std_logic
        );
    end component;

    SIGNAL INTER_Input_Temp        : std_logic_vector(191 downto 0);
    SIGNAL INTER_Output_Temp       : std_logic_vector(191 downto 0);
    SIGNAL DoneShifting            : std_logic;
    SIGNAL Comm_Ready               : std_logic;

BEGIN

    PISO: subPISO
        port map (
            subPISO_Input_data      => INTER_Output_Temp,
            subPISO_Input_ready     => Comm_Ready,
            DoneShifting            => DoneShifting,
            clk                     => clk,
            reset                   => reset,
            subPISO_Output_data     => INTER_Output_Data,
            subPISO_Output_valid    => INTER_Output_Valid
        );
    
    SIPO: subSIPO
        port map (
            subSIPO_Input_data      => INTER_Input_Data,
            subSIPO_Input_ready     => INTER_Input_Ready,
            clk                     => clk,
            reset                   => reset,
            DoneShifting            => DoneShifting,
            subSIPO_Output_data     => INTER_Input_Temp,
            subSIPO_Output_valid    => Comm_Ready
        );

        INTER : process(DoneShifting,INTER_Input_temp)
    variable mk : INteger := 0;
begIN
    if (DoneShifting = '1') then
        for i IN 0 to 191 loop
            mk := 12 * (i mod 16) + to_INteger(shift_right(to_unsigned(i,32),4));
            INTER_Output_temp(mk) <= INTER_Input_temp(i);
        end loop;
	else INTER_Output_temp <= INTER_Input_temp;

    end if;

end process;

END INTER_rtl;
