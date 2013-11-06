----------------------------------------------------------------------------------
-- company:
-- engineer:
--
-- create date:    16:15:11 11/06/2013
-- design name:
-- module name:    stack - behavioral
-- project name:
-- target devices:
-- tool versions:
-- description:
--
-- dependencies:
--
-- revision:
-- revision 0.01 - file created
-- additional comments:
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

-- uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
--use ieee.numeric_std.all;

-- uncomment the following library declaration if instantiating
-- any xilinx primitives in this code.
--library unisim;
--use unisim.vcomponents.all;

entity stack is
    port ( clk : in  std_logic;
           dat_i : in  std_logic_vector (7 downto 0);
           we : in  std_logic;
           stb : in  std_logic;
           dat_o : out  std_logic_vector (7 downto 0));
end stack;

architecture behavioral of stack is
  type bram_8_8 is array (7 downto 0) of std_logic_vector(7 downto 0);
  signal ram : bram_8_8;
  signal cnt : integer := 0;
begin
  process(clk)
  begin
    if (rising_edge(clk)) then
      if(stb = '1') then
        if(we = '1') then
          ram(conv_integer(cnt)) <= dat_i;
        end if;
        dat_o <= ram(conv_integer(cnt));
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if we = '1' then
        if cnt = 7 then
          cnt <= 0;
        else
          cnt <= cnt + 1;
        end if;
      else
        if cnt = 0 then
          cnt <= 7;
        else
          cnt <= cnt - 1;
        end if;
      end if;
    end if;
  end process;
end behavioral;
