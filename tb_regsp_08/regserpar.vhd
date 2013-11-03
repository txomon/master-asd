LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY regserpar IS
  GENERIC (
    CONSTANT n_b :IN INTEGER := 8
  );

  PORT (
    SIGNAL clk :IN STD_LOGIC;
    SIGNAL d :IN STD_LOGIC;
    SIGNAL en :IN STD_LOGIC;
    SIGNAL dat :OUT STD_LOGIC_VECTOR(n_b-1 DOWNTO 0)
  );
END regserpar;

ARCHITECTURE behavioral OF regserpar IS
  SIGNAL in_dat : STD_LOGIC_VECTOR(n_b-1 DOWNTO 0) := (OTHERS => '0');
BEGIN
  PROCESS(clk)
  BEGIN
    IF RISING_EDGE(clk) AND en='1' THEN
      in_dat <= d & in_dat(n_b-1 DOWNTO 1);
    END IF;
  END PROCESS;
  dat <= in_dat;
END behavioral;
