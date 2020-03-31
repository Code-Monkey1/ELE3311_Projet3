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

  signal clk                   : std_logic;

  signal rd_data               : std_logic_vector(7 downto 0);

begin
  clk <= clk_i;

  -- A completer
  -- processus synchrone pour l'assignation de la sortie
  rd_data <= X"AA"; -- Temporaire, a remplacer

  ----------------------------------------------------------------------------
  -- Assign outputs
  ----------------------------------------------------------------------------
  rd_data_o             <= rd_data;

end behavioral;
