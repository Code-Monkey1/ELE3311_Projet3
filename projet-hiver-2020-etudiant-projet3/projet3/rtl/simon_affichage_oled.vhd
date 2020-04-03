----------------------------------------------------------------------------------
-- POLYTECHNIQUE MONTREAL
-- ELE3311 - Systemes logiques programmables 
-- 
-- Module Name:    simon_affichage_oled 
-- Description: 
--
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity simon_affichage_oled is
generic (
  SHORT_SIM             : boolean := false
);
port (
  --RST & CLK
  rst_n_i               : in    std_logic;
  clk_100mhz_i          : in    std_logic;
      
  fb_wr_en_i            : in    std_logic;
  fb_wr_addr_i          : in    std_logic_vector(5 downto 0);
  fb_wr_data_i          : in    std_logic_vector(4 downto 0);

  ctl_addr_o            : out   std_logic_vector(8 downto 0);
  col_data_o            : out   std_logic_vector(7 downto 0)
);
end simon_affichage_oled;


architecture behavioral of simon_affichage_oled is
-- ###########################################################################
-- Entete de l'architecture
-- ###########################################################################

  signal rst                    : std_logic;
  signal clk                    : std_logic;
  signal ctl_addr               : std_logic_vector(8 downto 0);
  signal ctl_addr_p1            : std_logic_vector(8 downto 0);
  signal ctl_addr_p2            : std_logic_vector(8 downto 0);
  signal char_addr              : std_logic_vector(7 downto 0);
  signal symbol                 : std_logic_vector(4 downto 0);

  component rst_bridge	
  generic (
    GENERIC_IO_LOGIC : std_logic := '1'  -- 1=POSITIVE 0=NEGATIVE
  );
  port ( 
    rst_n_i    : in  std_logic;
    clk_i      : in  std_logic;
    rst_clk_o  : out std_logic
    );
  end component;

  component cnt
  generic (
    WIDTH                 : integer := 9
  );
  port (
    clk_i                 : in    std_logic;
    rst_i                 : in    std_logic;
    set_1_i               : in    std_logic;
    inc_i                 : in    std_logic;
    cnt_o                 : out   std_logic_vector(WIDTH-1 downto 0)
  );
  end component;

  component fb_mem
  port (
    clk_i                 : in    std_logic;
    rd_addr_i             : in    std_logic_vector(5 downto 0);
    rd_data_o             : out   std_logic_vector(4 downto 0);
    wr_en_i               : in    std_logic;
    wr_addr_i             : in    std_logic_vector(5 downto 0);
    wr_data_i             : in    std_logic_vector(4 downto 0)
  );
  end component;

  component symbol_map
  port (
    clk_i                 : in    std_logic;
    rd_addr_i             : in    std_logic_vector(7 downto 0);
    rd_data_o             : out   std_logic_vector(7 downto 0)
  );
  end component;


-- ###########################################################################
-- Debut de l'architecture
-- ###########################################################################
begin

  ----------------------------------------------------------------------------
  -- Horloge et remise a zero
  -- Instantiation d'un BUFG pour la distribution de l'horloge
  -- Generation du signal d'echantillonnage pour le dbnc
  -- Ajustement de la polarite du reset
  ----------------------------------------------------------------------------
  BUFG_inst : BUFG
  port map (
     O => clk,
     I => clk_100mhz_i
  );
  
  --clk <= clk_100mhz_i;

  RST_BRIDGE_INST : rst_bridge	
  port map( 
    rst_n_i                 => rst_n_i,
    clk_i                   => clk,
    rst_clk_o               => rst
  );

  addr_cnt_inst : cnt
  port map(
    clk_i                   => clk,
    rst_i                   => rst,
    set_1_i                 => '0',
    inc_i                   => '1',
    cnt_o                   => ctl_addr
  );

  fb_mem_inst : fb_mem
  port map(
    clk_i                   => clk,
    rd_addr_i               => ctl_addr(8 downto 3),
    rd_data_o               => symbol,
    wr_en_i                 => fb_wr_en_i,
    wr_addr_i               => fb_wr_addr_i,
    wr_data_i               => fb_wr_data_i
  );

  symbol_map_inst : symbol_map
  port map(
    clk_i                   => clk,
    rd_addr_i               => char_addr,
    rd_data_o               => col_data_o
  );

  ----------------------------------------------------------------------------
  -- concatenation du compteur d'adresse et de la sortie de fb_mem
  ----------------------------------------------------------------------------
  char_addr          <= symbol & ctl_addr_p1(2 downto 0);


  ----------------------------------------------------------------------------
  -- alignement de ctl_addr avec la sortie des memoires
  ----------------------------------------------------------------------------
  alignment : process(clk)
  begin
    if rising_edge(clk) then
      ctl_addr_p1         <= ctl_addr;
      ctl_addr_p2         <= ctl_addr_p1;
    end if;
  end process;

  ----------------------------------------------------------------------------
  -- Assign outputs
  ----------------------------------------------------------------------------
  ctl_addr_o          <= ctl_addr_p2;

end behavioral;