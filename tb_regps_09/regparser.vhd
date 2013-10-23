LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY regparser IS
  GENERIC (
    CONSTANT n_b :IN INTEGER := 8
  );
  PORT (
    SIGNAL clk :IN STD_LOGIC;
    SIGNAL dat :IN STD_LOGIC_VECTOR(n_b-1 DOWNTO 0);
    SIGNAL en :IN STD_LOGIC;
    SIGNAL ld :IN STD_LOGIC;
    SIGNAL m :OUT STD_LOGIC
  );
END regparser;

ARCHITECTURE behavioral OF regparser IS
  SIGNAL in_dat : STD_LOGIC_VECTOR(n_b-1 DOWNTO 0) := (OTHERS => '0');
BEGIN

  PROCESS (clk)
    BEGIN
      IF RISING_EDGE(clk) THEN
        IF ld = '1' THEN
          in_dat <= dat;
        ELSIF en = '1' THEN
          in_dat <= '0' & in_dat(n_b-1 DOWNTO 1);
        END IF;
      END IF;
    END PROCESS;
  m <= in_dat(0);
END behavioral;