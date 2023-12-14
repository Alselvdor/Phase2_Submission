library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

entity TopWiMax is 
    port(
        clk_50mhz                            	  : in    std_logic; 
        reset                 	                  : in    std_logic; 
        en                 	                      : in    std_logic; 
        load               	                      : in    std_logic; 
        data_in                               	  : in    std_logic; 
        TopWiMax_out_valid                        : out   std_logic;
        data_out1                              	  : out   std_logic_vector(15 downto 0);   -- TWO OUTPUTS?
        data_out2                              	  : out   std_logic_vector(15 downto 0) 
    );
end TopWiMax;

architecture TopWiMax_arch of TopWiMax is

    --components 
    component PLL is 
        port (
            refclk                                : in  std_logic := 'X'; --  refclk.clk
            rst                                   : in  std_logic := 'X'; --   reset.reset
            outclk_0                              : out std_logic;        -- outclk0.clk
            outclk_1                              : out std_logic;        -- outclk1.clk
            locked                                : out std_logic         --  locked.export
        );
    end component;

    component RANDIi
       port(
            clk_50mhz, reset, RANDI_in_ready       : in  std_logic; 
            load                                  : in  std_logic;
            RANDI_in                               : in  std_logic;
            RANDI_out                              : out std_logic;
            RANDI_out_valid                        : out std_logic
       );
    end component;

    component FEC
        port(
            clk_50mhz, clk_100mhz                 : in    std_logic; 
            reset, RANDI_out_valid                 : in    std_logic; 
            data_in                               : in    std_logic; 
            FEC_encoder_out_valid_out             : out   std_logic; 
            data_out                              : out   std_logic
        );
    end component;

    component INTER
        port(
            clk_100mhz                            : in    std_logic; 
            reset, FEC_encoder_out_valid          : in    std_logic; 
            data_in                               : in    std_logic; 
            INTER_out_valid                 : out   std_logic; 
            data_out                              : out   std_logic
        );
    end component;

    component MODU
        port(
            clk_100mhz                            : in  std_logic; 
            reset                                 : in  std_logic; 
            INTER_out_valid                 : in  std_logic; 
            data_in                               : in  std_logic; 
            MODU_out_valid                  : out std_logic; 
            output1, output2                      : out std_logic_vector(15 downto 0) 

        );
    end component;

    --signals 

    --PLL
    signal  clk_50mhz_sig                         : std_logic;
    signal  clk_100mhz_sig                        : std_logic;
    signal  locked                                : std_logic;
    signal  locked2                               : std_logic;
 
    --RANDI          
    signal  RANDI_out                              : std_logic;
    signal  RANDI_out_valid                        : std_logic;
 
    --FEC         
    signal  FEC_encoder_out_valid_out             : std_logic;
    signal  fec_out                               : std_logic;
 
    --INTER         
    signal  INTER_out_valid                 : std_logic;
    signal  INTER_out                       : std_logic;


begin
    --reset for other blocks (blocks' reset is active high)
    locked2 <= not locked; 
    
    --Instantiations
    pll1: PLL port map 
    (
        refclk                      => clk_50mhz,
        rst                         => reset,
        outclk_0                    => clk_100mhz_sig,
        outclk_1                    => clk_50mhz_sig,
        locked                      => locked
    );

    RANDI1: RANDI port map 
    (
        clk_50mhz                   => clk_50mhz_sig,
        reset                       => locked2,
        RANDI_in_ready               => en,
        load                        => load,             
        RANDI_in                     => data_in,               
        RANDI_out                    => RANDI_out,             
        RANDI_out_valid              => RANDI_out_valid             
    );

    fec1: FEC port map
    (
        clk_50mhz                   => clk_50mhz_sig,
        clk_100mhz                  => clk_100mhz_sig,
        reset                       => locked2, 
        RANDI_out_valid              => RANDI_out_valid,
        data_in                     => RANDI_out,
        FEC_encoder_out_valid_out   => FEC_encoder_out_valid_out, 
        data_out                    => fec_out       
    );

    int1: INTER port map 
    (
        clk_100mhz                  => clk_100mhz_sig,           
        reset                       => locked2,
        FEC_encoder_out_valid       => FEC_encoder_out_valid_out,
        data_in                     => fec_out,      
        INTER_out_valid       => INTER_out_valid,
        data_out                    => INTER_out 
    );

    mod1: MODU port map 
    (
        clk_100mhz                  => clk_100mhz_sig,   
        reset                       => locked2,
        INTER_out_valid             => INTER_out_valid,
        data_in                     => INTER_out,
        MODU_out_valid              => TopWiMax_out_valid,
        output1                     => data_out1,
        output2                     => data_out2     
    );

end TopWiMax_arch;