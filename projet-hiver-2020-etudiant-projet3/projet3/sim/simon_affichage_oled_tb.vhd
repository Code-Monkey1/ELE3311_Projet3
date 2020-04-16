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

  -- EntrÃ©es et sorties du UUT et valeur initiale
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
  -- Definir la sequence d'entrÃ©es pour exercer la fonctionalitÃ© du systÃ¨me
  -- On simule un systeme synchrone actif sur le front montant de l'horloge.
  -- Les entrees sont modifiees au front descendant de l'horloge
  -- PLAN DE VERIFICATION:  Ajouter des commentaires sur les stimulus 
  --                        a generer dans le processus ci-dessous
  stimulus: process
  begin
    -- A completer
    
    -- ****Notre plan de vérification: ****
    -- On fixe A = 11.
    -- Attendre que le reset soit fini avec un "wait until"
    -- Vérifier que les signaux soient bien initialisé avec une boucle 
    -- On va alors essayer d'écrire (aux fronts montants) dans le frame buffer les symboles suivants:
    -- Le caractère associé au code 11 (qu'on met à l'adresse 17),
    -- le caractère associé au code 12 (qu'on met à l'adresse 49)
    -- le caractère espace (qu'on met à l'adresse 0).
    -- Les écritures ne sont pas simultané. Il y a une pause entre chaque écriture.
    -- Par la suite, nous allons faire dans le process "Verification" des lectures pour confirmer que les trois écritures ont été réussi.
    -- Pour faire ces lectures sur col_data_o(aux fronts descendants), nous allons faire des "wait on" sur ctl_addr_o pour s'assurer d'être synchronisé.
    -- Nous allons ensuite comparer les caractères qui ont été lu avec les caractères qui ont été écrits. Cela va être fait avec 
    -- la commande "assert". 
    
    
    
    wait until rst = '0'; -- Attendre que le reset soit fini

    -- Écriture de l'espace à l'adresse 0 au front descendant
	wait until falling_edge(clk_100mhz);
    fb_wr_en <= '1';
    fb_wr_addr <= (others => '0'); -- L'adresse dans le OLED
    fb_wr_data <= (others => '0'); -- Le code dans la charte des symboles
    
    wait for clk_period*1;
    fb_wr_en <= '0';
    
    wait for clk_period*10;
    
    -- Écriture du deuxième caractère à l'adresse 17 (au front descendant)
    wait until falling_edge(clk_100mhz);
    fb_wr_en <= '1'; -- Mode écriture pour une période
    fb_wr_addr <= "010001"; -- L'adresse dans le OLED. On veut mettre a la position 17 le symbole associé au code 11.
    fb_wr_data <= "01011"; -- Le code (A = 11) dans la charte des symboles
    
	wait until falling_edge(clk_100mhz);
	fb_wr_en <= '0';
    fb_wr_addr <= (others => '0');
    fb_wr_data <= (others => '0');

    -- Écriture du dernier caractère à l'adresse A+1 (au front descendant)
    wait until falling_edge(clk_100mhz);
    fb_wr_en <= '1';
    fb_wr_addr <= "110001";  -- L'adresse dans le OLED. On veut mettre a la position 49 le symbole associé au code 12.
    fb_wr_data <= "01100";  -- Le code (A+1 = 12) dans la charte des symboles

	wait until falling_edge(clk_100mhz);
	fb_wr_en <= '0';
    fb_wr_addr <= (others => '0');
    fb_wr_data <= (others => '0');
    
    wait for 30000*clk_period; -- 300 microsecondes

    -- ArrÃªter l'horloge pour terminer la simulation automatiquement
    enable_clk_src <= false;
    wait;
  end process;
  
  ------------------------------------------------------------------------------
  -- Verification des sorties
  -- On simule un systeme synchrone actif sur le front montant de l'horloge.
  -- Les sorties sont verifiees au front descendant de l'horloge
  -- PLAN DE VERIFICATION:  Ajouter des commentaires sur les items a verifier
  --                        dans le processus ci-dessous
  line_start  <= '1' when (to_integer(unsigned(ctl_addr)) mod 128 = 0) else '0'; -- Utiliser pour savoir quand vérifier la prochaine ligne
  frame_start <= '1' when (to_integer(unsigned(ctl_addr)) = 0) else '0'; -- Utiliser pour savoir lorsque la trame commence
  frame_count <= frame_count + 1 when rising_edge(frame_start); -- Utiliser pour savoir si nous sommes à la bonne trame

  verification: process
  begin
    -- A completer:

		wait until rst = '0'; -- Attendre que le reset soit fini
		
		-- Vérifier que les signaux soient bien initialisé avec une boucle
        while frame_start = '0' loop
          assert col_data = "00000000" report "col_data does not only contain zeros at the start" severity error; 
          wait for clk_period;
        end loop;
		
		wait until frame_start = '1'; -- Nouvelle frame
		
		wait for 4*clk_period;
		
		-- VÉRIFICATION DU SYMBOLE ASSOCIÉ AU CODE 11 À L'ADRESSE 17
		wait until line_start = '1'; -- L'adresse 17 est sur la deuxieme ligne donc on doit attendre pour que la premiere ligne finisse
		wait on  ctl_addr until ctl_addr = "010001000" for 10 * clk_period;
		wait until falling_edge(clk_100mhz); -- On regarde les fronts descendants pour la vérification
		assert ctl_addr(8 downto 3) = "010001" report "Error ctl_addr: should be 17" severity error; -- Doit être la bonne adresse
        while ctl_addr(8 downto 3) = "010001" loop
        
            if (ctl_addr(2 downto 0) = "000") then
                assert col_data(7 downto 0) = "11111111" report "Error data is incorrect: this data was expected: 11111111" severity error; -- Doit être les bonnes données
            elsif  (ctl_addr(2 downto 0) = "001") then
		      assert col_data(7 downto 0) = "00000000" report "Error data is incorrect: this data was expected: 00000000" severity error; -- Doit être les bonnes données
            elsif  (ctl_addr(2 downto 0) = "010") then
		      assert col_data(7 downto 0) = "11111111" report "Error data is incorrect: this data was expected: 11111111" severity error; -- Doit être les bonnes données
            elsif  (ctl_addr(2 downto 0) = "011") then
		      assert col_data(7 downto 0) = "00000000" report "Error data is incorrect: this data was expected: 00000000" severity error; -- Doit être les bonnes données
            elsif  (ctl_addr(2 downto 0) = "100") then
		      assert col_data(7 downto 0) = "11111111" report "Error data is incorrect: this data was expected: 11111111" severity error; -- Doit être les bonnes données
            elsif  (ctl_addr(2 downto 0) = "101") then
		      assert col_data(7 downto 0) = "00000000" report "Error data is incorrect: this data was expected: 00000000" severity error; -- Doit être les bonnes données
            elsif  (ctl_addr(2 downto 0) = "110") then
		      assert col_data(7 downto 0) = "11111111" report "Error data is incorrect: this data was expected: 11111111" severity error; -- Doit être les bonnes données
            else
		      assert col_data(7 downto 0) = "00000000" report "Error data is incorrect: this data was expected: 00000000" severity error; -- Doit être les bonnes données
		    end if;
		      
          wait until falling_edge(clk_100mhz);
        end loop;
		
        wait for 4*clk_period;
		
		-- VÉRIFICATION DU SYMBOLE ASSOCIÉ AU CODE 12 À L'ADRESSE 49
		-- Nous sommes encore à la deuxième ligne. Notre destination, soit l'adresse 49  se trouve à la quatrième ligne,
		-- donc on attend pour deux line_start
		wait until line_start = '1';
		wait until line_start = '1';
		
        wait on  ctl_addr until ctl_addr = "110001000" for 10 * clk_period;
		wait until falling_edge(clk_100mhz); -- On regarde les fronts descendants pour la vérification
		assert ctl_addr(8 downto 3) = "110001" report "Error ctl_addr: should be 49" severity error; -- Doit être la bonne adresse
        while ctl_addr(8 downto 3) = "110001" loop

            if (ctl_addr(2 downto 0) = "000") then
                assert col_data(7 downto 0) = "00000001" report "Error data is incorrect: this data was expected: 00000001" severity error; -- Doit être les bonnes données
            elsif  (ctl_addr(2 downto 0) = "001") then
		      assert col_data(7 downto 0) = "00000010" report "Error data is incorrect: this data was expected: 00000010" severity error; -- Doit être les bonnes données
            elsif  (ctl_addr(2 downto 0) = "010") then
		      assert col_data(7 downto 0) = "00000100" report "Error data is incorrect: this data was expected: 00000100" severity error; -- Doit être les bonnes données
            elsif  (ctl_addr(2 downto 0) = "011") then
		      assert col_data(7 downto 0) = "00001000" report "Error data is incorrect: this data was expected: 00001000" severity error; -- Doit être les bonnes données
            elsif  (ctl_addr(2 downto 0) = "100") then
		      assert col_data(7 downto 0) = "00010000" report "Error data is incorrect: this data was expected: 00010000" severity error; -- Doit être les bonnes données
            elsif  (ctl_addr(2 downto 0) = "101") then
		      assert col_data(7 downto 0) = "00100000" report "Error data is incorrect: this data was expected: 00100000" severity error; -- Doit être les bonnes données
            elsif  (ctl_addr(2 downto 0) = "110") then
		      assert col_data(7 downto 0) = "01000000" report "Error data is incorrect: this data was expected: 01000000" severity error; -- Doit être les bonnes données
            else
		      assert col_data(7 downto 0) = "10000000" report "Error data is incorrect: this data was expected: 10000000" severity error; -- Doit être les bonnes données
		    end if;
		      
          wait until falling_edge(clk_100mhz);

          wait until falling_edge(clk_100mhz);
        end loop;
	
		
    -- Attendre la fin de la simulation
    wait;
  end process;
  
end;