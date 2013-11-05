LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY alup IS
  GENERIC (
    CONSTANT nb :IN INTEGER := 4
  );
  PORT (
    SIGNAL fun :IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL a :IN STD_LOGIC_VECTOR((nb-1) DOWNTO 0);
    SIGNAL b :IN STD_LOGIC_VECTOR((nb-1) DOWNTO 0);
    SIGNAL dat :OUT STD_LOGIC_VECTOR((nb-1) DOWNTO 0);
    SIGNAL c :OUT STD_LOGIC;
    SIGNAL z :OUT STD_LOGIC;
    SIGNAL e :OUT STD_LOGIC
  );
END alup;

ARCHITECTURE behavioral OF alup IS
  SIGNAL cdat : STD_LOGIC_VECTOR(nb DOWNTO 0);
  SIGNAL in_a : SIGNED((nb) DOWNTO 0);
  SIGNAL in_b : SIGNED((nb) DOWNTO 0);
BEGIN

  in_a <= SIGNED(a(nb-1) & a);
  in_b <= SIGNED(b(nb-1) & b);

  WITH fun SELECT
    cdat <= '0' & a WHEN "0000",
            '0' & NOT a WHEN "0001",
            '0' & (a OR b) WHEN "0010",
            '0' & (a AND b) WHEN "0011",
            '0' & (a XOR b) WHEN "0100",
            in_a + in_b WHEN "0101",
            in_a - in_b WHEN "0110",
            in_a - in_b WHEN "0111",
            in_a + 1 WHEN "1000",
            in_a - 1 WHEN "1001",
            a(nb-1) & a(nb-2 DOWNTO 0) & a(nb-1) WHEN "1010",
            a(0) & a(0) & a(nb-1 DOWNTO 1) WHEN "1011",
            (OTHERS => '1') WHEN OTHERS;

  c <= cdat(nb);
  e <= '0' WHEN fun = "0111" ELSE '1';
  z <= '1' WHEN cdat = "00000" ELSE '0';
  dat <= cdat(nb-1 DOWNTO 0);
END behavioral;