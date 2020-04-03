----------------------------------------------------------------------------------
-- POLYTECHNIQUE MONTREAL
-- ELE3311 - Systemes logiques programmables 
-- 
-- Module Name:    simon_affichage_oled_tb 
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


entity simon_affichage_oled_tb is
end simon_affichage_oled_tb;


architecture bench of simon_affichage_oled_tb is

  component simon_affichage_oled
  generic (
    SHORT_SIM             : boolean := false
  );
  port (
   rst_n_i               : in    std_logic;
   clk_100mhz_i          : in    std_logic;
   fb_wr_en_i            : in    std_logic;
   fb_wr_addr_i          : in    std_logic_vector(5 downto 0);
   fb_wr_data_i          : in    std_logic_vector(4 downto 0);
   ctl_addr_o            : out   std_logic_vector(8 downto 0);
   col_data_o            : out   std_logic_vector(7 downto 0)
  );
  end component;

  -- Entrées et sorties du UUT et valeur initiale
  signal rst                  : std_logic                     := '1';
  signal rst_n                : std_logic;
  signal clk_100mhz           : std_logic;
  signal fb_wr_en             : std_logic                     := '0';
  signal fb_wr_addr           : std_logic_vector (5 downto 0) := (others => '0');
  signal fb_wr_data           : std_logic_vector (4 downto 0) := (others => '0');
  signal ctl_addr             : std_logic_vector (8 downto 0);
  signal col_data             : std_logic_vector (7 downto 0);

  constant clk_period         : time := 10ns;
  signal enable_clk_src       : boolean := true;
  
  -- signaux pour aider la verification
  signal line_start           : std_logic := '0';
  signal frame_start          : std_logic := '0';
  signal frame_count          : integer := 0;
begin

  uut: simon_affichage_oled
  generic  map (
    SHORT_SIM               => true
  )
  port map (
    clk_100mhz_i            => clk_100mhz,
    rst_n_i                 => rst_n,
    fb_wr_en_i              => fb_wr_en,
    fb_wr_addr_i            => fb_wr_addr,
    fb_wr_data_i            => fb_wr_data,
    ctl_addr_o              => ctl_addr,
    col_data_o              => col_data
);


  -- Reset
  rst_n       <= not rst;
  rst         <= '1', '0' after 52 ns;

  -- Clock
  clocking: process
  begin
    while enable_clk_src loop
      clk_100mhz <= '0', '1' after clk_period / 2;
      wait for clk_period;
    end loop;
    wait;
  end process;

  ------------------------------------------------------------------------------
  -- Definir la sequence d'entrées pour exercer la fonctionalité du système
  -- On simule un systeme synchrone actif sur le front montant de l'horloge.
  -- Les entrees sont modifiees au front descendant de l'horloge
  -- PLAN DE VERIFICATION:  Ajouter des commentaires sur les stimulus 
  --                        a generer dans le processus ci-dessous
  stimulus: process
  begin
    -- A completer
    wait for 10000 ns; -- temporaire

    -- Arrêter l'horloge pour terminer la simulation automatiquement
    enable_clk_src <= false;
    wait;
  end process;
  
  ------------------------------------------------------------------------------
  -- Verification des sorties
  -- On simule un systeme synchrone actif sur le front montant de l'horloge.
  -- Les sorties sont verifiees au front descendant de l'horloge
  -- PLAN DE VERIFICATION:  Ajouter des commentaires sur les items a verifier
  --                        dans le processus ci-dessous
  line_start  <= '1' when (to_integer(unsigned(ctl_addr)) mod 128 = 0) else '0';
  frame_start <= '1' when (to_integer(unsigned(ctl_addr)) = 0) else '0';
  frame_count <= frame_count + 1 when rising_edge(frame_start);

  verification: process
  begin
    -- A completer

    -- Attendre la fin de la simulation
    wait;
  end process;
  
end;