LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ctrl IS
  PORT (
    SIGNAL rst :IN STD_LOGIC;
    SIGNAL clk :IN STD_LOGIC;
    SIGNAL stb :IN STD_LOGIC;
    SIGNAL m :IN STD_LOGIC;
    SIGNAL tx :OUT STD_LOGIC;
    SIGNAL ld :OUT STD_LOGIC;
    SIGNAL en :OUT STD_LOGIC;
    SIGNAL ini :OUT STD_LOGIC
  );
END ctrl;

ARCHITECTURE behavioral OF ctrl IS
  TYPE STATUS_TYPE IS (SBY, STA, B0, B1, B2, B3, B4, B5, B6, B7, STO);
  SIGNAL status : STATUS_TYPE := SBY;
BEGIN

  -- Status progress
  PROCESS(clk)
    BEGIN
      IF RISING_EDGE(clk) THEN
        IF rst = '0' THEN
          CASE status IS
            WHEN SBY => IF stb = '1' THEN status <= STA; END IF;
            WHEN STA => status <= B0;
            WHEN B0 => status <= B1;
            WHEN B1 => status <= B2;
            WHEN B2 => status <= B3;
            WHEN B3 => status <= B4;
            WHEN B4 => status <= B5;
            WHEN B5 => status <= B6;
            WHEN B6 => status <= B7;
            WHEN B7 => status <= STO;
            WHEN STO => status <= SBY;
          END CASE;
        ELSE
          status <= SBY;
        END IF;
      END IF;
    END PROCESS;

  -- TX out pin
  WITH status SELECT
  tx <= '0' WHEN STA,
        '1' WHEN SBY | STO,
        m WHEN OTHERS;

  -- LD out pin
  WITH status SELECT
  ld <= '1' WHEN SBY,
        '0' WHEN OTHERS;

  -- EN out pin
  WITH status SELECT
  en <= '0' WHEN SBY | STA | B7 | STO,
        '1' WHEN OTHERS;

  -- INI out pin
  WITH status SELECT
  ini <= '1' WHEN SBY,
         '0' WHEN OTHERS;

END behavioral;
