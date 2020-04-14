----------------------------------------------------------------------------------
-- POLYTECHNIQUE MONTREAL
-- ELE3311 - Systemes logiques programmables 
-- 
-- Module Name:    rst_bridge 
-- Description:    Ce module est base sur le module meta_harden
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

entity rst_bridge is	
generic (
  GENERIC_IO_LOGIC : std_logic := '1' -- 1=POSITIVE 0=NEGATIVE
);
port ( 
  rst_n_i    : in  std_logic;
  clk_i      : in  std_logic;
  rst_clk_o  : out std_logic
);
end rst_bridge;

architecture arch_rst_bridge of rst_bridge is

  signal sig_meta : std_logic := '0';
  signal sig_dst  : std_logic := '0';
  attribute ASYNC_REG : string;
  attribute ASYNC_REG of sig_meta : signal is "TRUE";
  attribute ASYNC_REG of sig_dst  : signal is "TRUE";
     
begin

  rst_clk_o <= sig_dst;

  -- processus synchrone
  RESET_BRIDGE: process (clk_i, rst_n_i)
  begin
    if (rst_n_i = '0') then 
        sig_dst <= '1'; -- Remise à zéro asynchrone de la sortie (active haute)
        sig_meta <= '1';
    elsif (clk_i'event and clk_i = '1') then
        sig_meta <= '0'; -- À tout les coups d'horloge, le signal meta est mis à zéro
        sig_dst <= sig_meta; -- La sortie est désactivée de manière synchrone
    end if;
  end process;
end arch_rst_bridge;







