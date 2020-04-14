----------------------------------------------------------------------------------
-- POLYTECHNIQUE MONTREAL
-- ELE3311 - Systemes logiques programmables 
-- 
-- Module Name:    symbol_map 
-- Description:    ROM
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity symbol_map is
port (
  clk_i                 : in    std_logic;
  rd_addr_i             : in    std_logic_vector(7 downto 0);
  rd_data_o             : out   std_logic_vector(7 downto 0)
);
end symbol_map;

architecture behavioral of symbol_map is

  signal clk                   : std_logic := '0';
  signal rd_data               : std_logic_vector(7 downto 0) := (others => '0');

begin
  clk <= clk_i;

  -- processus synchrone pour l'assignation de la sortie
    SYMBOL_MAP_PROCESS: process(clk, rd_addr_i)
  begin
		if rising_edge(clk) then
			if (rd_addr_i(7 downto 3) = "01011") then -- Pour n'importe quelle rangée du caractère associé au code 11
				rd_data <= "11111111"; -- On allume tout les pixels pour ce caractère
			elsif (rd_addr_i(7 downto 3) = "01100") then -- Pour n'importe quelle rangée du caractère associé au code 12
				rd_data <= "10101010"; -- On allume la moitié les pixels pour ce caractère
			else
				rd_data <= "00000000"; -- Pour n'importe quelle autre adresse, nous mettons un espace (aucun pixel d'allumé)
			end if;
		end if;
  end process;
  
  ----------------------------------------------------------------------------
  -- Assign outputs
  ----------------------------------------------------------------------------
  rd_data_o             <= rd_data;

end behavioral;
