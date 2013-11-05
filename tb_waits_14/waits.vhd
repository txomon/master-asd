LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY waits IS
  GENERIC (
    CONSTANT ntb :IN INTEGER := 10
  );

  PORT (
    SIGNAL clk :IN STD_LOGIC;
    SIGNAL ini :IN STD_LOGIC;
    SIGNAL stp :IN STD_LOGIC;
    SIGNAL tc :OUT STD_LOGIC
  );
END waits;

ARCHITECTURE behavioral OF waits IS
  SIGNAL cnt : INTEGER := 0;
BEGIN
  PROCESS(clk)
    BEGIN
      IF RISING_EDGE(clk) THEN
        IF ini = '1' THEN
          cnt <= 0;
        ELSE
          IF cnt = ntb THEN
            tc <= '1';
            IF stp = '0' THEN
              cnt <= 0;
            END IF;
          ELSE
            tc <= '0';
            cnt <= cnt + 1;
          END IF;
        END IF;
      END IF;
    END PROCESS;
END behavioral;