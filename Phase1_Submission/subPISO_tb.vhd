library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


ENTITY subPISO_tb IS END subPISO_tb;

architecture subPISO_tb_rtl of subPISO_tb is
	COMPONENT subPiso IS
		  port (
				 subPISO_input_data   : in  std_logic_vector (191 downto 0);
				 subPISO_input_ready  : in std_logic;
				 DoneShifting         : in  std_logic;         
				 clk                  : in  std_logic;                     
				 reset                : in  std_logic;
				 subPISO_output_data  : out std_logic;
				 subPISO_output_valid : out std_logic
			  );
				
	END COMPONENT;

signal clk: std_logic := '0';
signal reset: std_logic := '0';
signal subPISO_input_ready: std_logic := '0';
signal DoneShifting: std_logic := '0';
signal subPISO_output_data: std_logic;
signal subPISO_input_data : std_logic_vector(0 to 191);
signal subPISO_output_valid: std_logic;
signal ROM_input: std_logic_vector(0 to 191) := X"2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA";
signal ROM_output: std_logic_vector(0 to 191) := X"2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA";
constant PERIOD : time := 10 ns; 

begin
    clk <= not clk after PERIOD/2;
    tbpiso: subPiso
		port map (    subPISO_input_data => subPISO_input_data,
					 subPISO_input_ready    => subPISO_input_ready,
					 DoneShifting           => DoneShifting, 
					 clk                    => clk, 
					 reset                  => reset, 
					 subPISO_output_data    => subPISO_output_data, 
					 subPISO_output_valid   => subPISO_output_valid);
process
          variable tb_test: boolean;
    begin
        reset <= '1'; 
        subPISO_input_data <= (others=>'0');
        wait for (PERIOD);
        reset <= '0';
        DoneShifting <= '1';
        subPISO_input_data <= ROM_input;
        wait for (PERIOD);
        DoneShifting <= '0';
            subPISO_input_ready <= '1';
            for i in 0 to 191 loop
                wait until falling_edge(clk);
                if (subPISO_output_data = ROM_output(i))then
                         tb_test := true;
                    else
                         tb_test := false;
                end if;
                end loop;
        
                wait;

    end process ;

end subPISO_tb_rtl;