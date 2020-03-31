----------------------------------------------------------------------------------
-- POLYTECHNIQUE MONTREAL
-- ELE3311 - Systemes logiques programmables 
-- 
-- Module Name:    cnt 
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

entity cnt is
generic (
  WIDTH                 : integer := 8
);
port (
  clk_i                 : in    std_logic;
  rst_i                 : in    std_logic;  -- synchrone
  set_1_i               : in    std_logic;  -- set to one
  inc_i                 : in    std_logic;  -- increment
  cnt_o                 : out   std_logic_vector(WIDTH-1 downto 0)
);
end cnt;


architecture behavioral of cnt is

  signal clk                  : std_logic;
  signal rst                  : std_logic;

  signal cnt_p                : unsigned(WIDTH-1 downto 0) := (others => '0');

  signal cnt_f                : unsigned(WIDTH-1 downto 0);

begin
  clk <= clk_i;
  rst <= rst_i;


  REGISTERED: process(rst, clk)
  begin
    if rst = '1' then
      cnt_p <= to_unsigned(0, cnt_f'length);
    elsif rising_edge(clk) then
      cnt_p <= cnt_f;
    end if;
  end process;


  COMBINATORIAL: process(set_1_i, inc_i, cnt_p)
  begin
    if (set_1_i = '1') then
      cnt_f <= to_unsigned(1, cnt_f'length);
    elsif (inc_i = '1') then
      cnt_f <= cnt_p + 1;
    else
      cnt_f <= cnt_p;
    end if;
  end process;


  -- Assign outputs
  cnt_o <= std_logic_vector(cnt_p);

end behavioral;
