LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY waitd IS
  GENERIC (
    CONSTANT ntb :IN INTEGER := 10
  );

  PORT (
    SIGNAL clk :IN STD_LOGIC;
    SIGNAL ini :IN STD_LOGIC;
    SIGNAL tc :OUT STD_LOGIC
  );
END waitd;

ARCHITECTURE behavioral OF waitd IS
  SIGNAL cnt : INTEGER := 0;
BEGIN
  PROCESS(clk)
    BEGIN
      IF RISING_EDGE(clk) THEN
        IF ini = '1' THEN
          cnt <= 0;
        ELSE
          IF cnt = ntb THEN
            cnt <= 0;
            tc <= '1';
          ELSE
            cnt <= cnt + 1;
            tc <= '0';
          END IF;
        END IF;
      END IF;
    END PROCESS;
END behavioral;