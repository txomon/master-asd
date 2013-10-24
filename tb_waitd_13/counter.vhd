LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY counter IS
  GENERIC (
    CONSTANT ncnt :IN INTEGER := 12
  );
  PORT (
    SIGNAL rst :IN STD_LOGIC;
    SIGNAL clk :IN STD_LOGIC;
    SIGNAL dat :OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END counter;

ARCHITECTURE behavioral OF counter IS
  SIGNAL in_dat : UNSIGNED(7 DOWNTO 0);
BEGIN
  PROCESS(clk)
    BEGIN
      IF RISING_EDGE(clk) THEN
        IF rst = '1' THEN
          in_dat <= (OTHERS => '0');
        ELSIF rst = '0' THEN
          IF in_dat = UNSIGNED(CONV_STD_LOGIC_VECTOR(ncnt,8)) THEN
            in_dat <= (OTHERS => '0');
          ELSE
            in_dat <= in_dat + 1;
          END IF;
        END IF;
      END IF;
    END PROCESS;
  dat <= STD_LOGIC_VECTOR(in_dat);
END behavioral;