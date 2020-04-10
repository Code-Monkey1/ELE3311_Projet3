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
  signal rst_n                : std_logic                     := '0';
  signal clk_100mhz           : std_logic                     := '0';
  signal fb_wr_en             : std_logic                     := '0';
  signal fb_wr_addr           : std_logic_vector (5 downto 0) := (others => '0');
  signal fb_wr_data           : std_logic_vector (4 downto 0) := (others => '0');
  signal ctl_addr             : std_logic_vector (8 downto 0) := (others => '0');
  signal col_data             : std_logic_vector (7 downto 0) := (others => '0');

  constant clk_period         : time                          := 10ns;
  constant A                  : integer                       := 11; -- Notre choix
  signal enable_clk_src       : boolean                       := true;
  
  -- signaux pour aider la verification
  signal line_start           : std_logic                     := '0';
  signal frame_start          : std_logic                     := '0';
  signal frame_count          : integer                       :=  0;
      
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
    
    -- ****Notre plan de v�rification: ****
    -- On fixe A = 11.
    -- Attendre que le reset soit fini avec un "wait until"
    -- V�rifier que les signaux soient bien initialis� avec une boucle 
    -- On va alors essayer d'�crire (aux fronts montants) dans le frame buffer les symboles suivants:
    -- Le caract�re associ� au code 11 (qu'on met � l'adresse 17),
    -- le caract�re associ� au code 12 (qu'on met � l'adresse 49)
    -- le caract�re espace (qu'on met � l'adresse 0).
    -- Les �critures ne sont pas simultan�. Il y a une pause entre chaque �criture.
    -- Par la suite, nous allons faire dans le process "Verification" des lectures pour confirmer que les trois �critures ont �t� r�ussi.
    -- Pour faire ces lectures sur col_data_o(aux fronts descendants), nous allons faire des "wait on" sur ctl_addr_o pour s'assurer d'�tre synchronis�.
    -- Nous allons ensuite comparer les caract�res qui ont �t� lu avec les caract�res qui ont �t� �crits. Cela va �tre fait avec 
    -- la commande "assert". 
    
    
    
    wait until rst = '0'; -- Attendre que le reset soit fini

    -- �criture de l'espace � l'adresse 0 au front descendant
	wait until falling_edge(clk)
    fb_wr_en <= '1';
    fb_wr_addr <= (others => '0'); -- L'adresse dans le OLED
    fb_wr_data <= (others => '0'); -- Le code dans la charte des symboles
    
    wait for clk_period*1;
    fb_wr_en <= '0';
    
    wait for clk_period*10;
    
    -- �criture de du deuxi�me caract�re � l'adresse A.
    fb_wr_en <= '1';
    fb_wr_addr <= "01011"; -- L'adresse dans le OLED
    fb_wr_data <= "11111"; -- Le code dans la charte des symboles
    
    -- (pas completement fini)...


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
  line_start  <= '1' when (to_integer(unsigned(ctl_addr)) mod 128 = 0) else '0'; -- Utiliser pour savoir quand v�rifier la prochaine ligne
  frame_start <= '1' when (to_integer(unsigned(ctl_addr)) = 0) else '0'; -- Utiliser pour savoir lorsque la trame commence
  frame_count <= frame_count + 1 when rising_edge(frame_start); -- Utiliser pour savoir si nous sommes � la bonne trame

  verification: process
  begin
    -- A completer:

		wait until rst = '0'; -- Attendre que le reset soit fini
		
		-- V�rifier que les signaux soient bien initialis� avec une boucle
		for I in 0 to 514 loop -- 514 because there is two flip flops and 512 adresses
			assert col_data = "00000000" report "col_data does not only contain zeros at the start" severity error; 
		end loop;
		
		wait until frame_start = '1';
		
		
		
    -- Attendre la fin de la simulation
    wait;
  end process;
  
end;