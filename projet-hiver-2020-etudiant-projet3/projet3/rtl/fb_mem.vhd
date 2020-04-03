----------------------------------------------------------------------------------
-- POLYTECHNIQUE MONTREAL
-- ELE3311 - Systemes logiques programmables 
-- 
-- Module Name:    fb_mem 
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity fb_mem is
port (
  clk_i                 : in    std_logic;
  rd_addr_i             : in    std_logic_vector(5 downto 0);
  rd_data_o             : out   std_logic_vector(4 downto 0);
  wr_en_i               : in    std_logic;
  wr_addr_i             : in    std_logic_vector(5 downto 0);
  wr_data_i             : in    std_logic_vector(4 downto 0)
);
end fb_mem;


architecture behavioral of fb_mem is
  -- A completer
  -- type ...
  -- signal mem ...
  type fb_mem_T is array (0 to 63) of std_logic_vector (7 downto 0);
  signal fb_mem : fb_mem_T;
  
  

  signal clk                   : std_logic;
  -- Registered internal signals for outputs
  signal rd_data               : std_logic_vector(4 downto 0);
  
  

begin
  clk <= clk_i;


  -- A completer
  -- process synchrone pour l'ecriture et la lecture de la memoire
  p_sync: process(clk_i)
    begin
    if clk_i'event and clk_i='1' then
        if wr_en_i ='1' then
            RAM_2p (to_integer(unsigned(wr_addr_i)))<= wr_data_i;
        end if;
    rd_data <= RAM_2p (to_integer(unsigned(add_p2_i)));
    end if;
   end process;
  
  
  rd_data <= "10001"; -- Temporaire, a remplacer

  ----------------------------------------------------------------------------
  -- Assign outputs
  ----------------------------------------------------------------------------
  rd_data_o             <= rd_data;


end behavioral;
