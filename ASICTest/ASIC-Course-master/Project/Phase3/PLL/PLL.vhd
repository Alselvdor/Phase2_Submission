-- megafunction wizard: %PLL Intel FPGA IP v20.1%
-- GENERATION: XML
-- PLL.vhd

-- Generated using ACDS version 20.1 711

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PLL is
	port (
		refclk   : in  std_logic := '0'; --  refclk.clk
		rst      : in  std_logic := '0'; --   reset.reset
		outclk_0 : out std_logic;        -- outclk0.clk
		outclk_1 : out std_logic;        -- outclk1.clk
		locked   : out std_logic         --  locked.export
	);
end entity PLL;

architecture rtl of PLL is
	component PLL_0002 is
		port (
			refclk   : in  std_logic := 'X'; -- clk
			rst      : in  std_logic := 'X'; -- reset
			outclk_0 : out std_logic;        -- clk
			outclk_1 : out std_logic;        -- clk
			locked   : out std_logic         -- export
		);
	end component PLL_0002;

begin

	pll_inst : component PLL_0002
		port map (
			refclk   => refclk,   --  refclk.clk
			rst      => rst,      --   reset.reset
			outclk_0 => outclk_0, -- outclk0.clk
			outclk_1 => outclk_1, -- outclk1.clk
			locked   => locked    --  locked.export
		);

end architecture rtl; -- of PLL
