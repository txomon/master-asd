----------------------------------------------------------------------------------
-- company:
-- engineer:
--
-- create date:    14:55:34 11/07/2013
-- design name:
-- module name:    crc - behavioral
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

-- uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
--use ieee.numeric_std.all;

-- uncomment the following library declaration if instantiating
-- any xilinx primitives in this code.
--library unisim;
--use unisim.vcomponents.all;

entity crc is
  port(
    signal rst, clk, stream :in std_logic;
    signal crc :out std_logic_vector(7 downto 0)
  );
end crc;

architecture behavioral of crc is
  signal crc_i : std_logic_vector(7 downto 0);
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        crc_i <= (others => '0');
      else
        crc_i <= crc_i(6 downto 2) & (crc_i(1) xor crc_i(7)) & (crc_i(0) xor crc_i(7)) & (stream xor crc_i(7));
      end if;
    end if;
  end process;

  crc <= crc_i;
end behavioral;
