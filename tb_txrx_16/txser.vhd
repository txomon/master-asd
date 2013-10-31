LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY txser IS
  GENERIC (
    CONSTANT nvt :IN INTEGER := 10
  );
  PORT (
    SIGNAL rst, clk, stb :IN STD_LOGIC;
    SIGNAL dat :IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL tx :OUT STD_LOGIC
  );
END txser;

ARCHITECTURE behavioral OF txser IS
  TYPE STATUS_TYPE IS (
    SBY,
    STR,
    B0,
    B1,
    B2,
    B3,
    B4,
    B5,
    B6,
    B7,
    STO
  );
  SIGNAL sta : STATUS_TYPE := SBY;
  SIGNAL stn : STATUS_TYPE;
  SIGNAL cnt : INTEGER := 0;
  SIGNAL tc, m, ld, en, ini : STD_LOGIC := '0';
  SIGNAL in_dat : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
  -- Status progress
  PROCESS(stb, sta, tc)
    BEGIN
      CASE sta IS
        WHEN SBY =>
          IF stb = '1' THEN
            stn <= STR;
          END IF;
        WHEN STR =>
          IF tc = '1' THEN
            stn <= B0;
          END IF;
        WHEN B0 =>
          IF tc = '1' THEN
            stn <= B1;
          END IF;
        WHEN B1 =>
          IF tc = '1' THEN
            stn <= B2;
          END IF;
        WHEN B2 =>
          IF tc = '1' THEN
            stn <= B3;
          END IF;
        WHEN B3 =>
          IF tc = '1' THEN
            stn <= B4;
          END IF;
        WHEN B4 =>
          IF tc = '1' THEN
            stn <= B5;
          END IF;
        WHEN B5 =>
          IF tc = '1' THEN
            stn <= B6;
          END IF;
        WHEN B6 =>
          IF tc = '1' THEN
            stn <= B7;
          END IF;
        WHEN B7 =>
          IF tc = '1' THEN
            stn <= STO;
          END IF;
        WHEN STO =>
          IF tc = '1' THEN
            stn <= SBY;
          END IF;
      END CASE;
    END PROCESS;

  -- Change status
  PROCESS(clk)
    BEGIN
      IF RISING_EDGE(clk) THEN
        sta <= stn;
      END IF;
    END PROCESS;

  -- TX out pin
  WITH sta SELECT
  tx <= '0' WHEN STR,
        '1' WHEN SBY | STO,
        m WHEN OTHERS;

  -- LD out pin
  WITH sta SELECT
  ld <= '1' WHEN SBY,
        '0' WHEN OTHERS;

  -- EN out pin
  WITH sta SELECT
  en <= '0' WHEN SBY | STR | STO,
        '1' WHEN OTHERS;

  -- INI out pin
  WITH sta SELECT
  ini <= '1' WHEN SBY,
         '0' WHEN OTHERS;

  -- Retarded
  PROCESS(clk) BEGIN
    IF RISING_EDGE(clk) THEN
      IF ini='1' THEN
        cnt <= 0;
      ELSE
        IF cnt = nvt-1 THEN
          cnt <= 0;
          tc <= '1';
        ELSE
          cnt <= cnt + 1;
          tc <= '0';
        END IF;
      END IF;
    END IF;
  END PROCESS;

  PROCESS (clk) BEGIN
      IF RISING_EDGE(clk) THEN
        IF ld = '1' THEN
          in_dat <= dat;
        ELSIF en = '1' THEN
          IF tc = '1' THEN
            in_dat <= '0' & in_dat(7 DOWNTO 1);
          END IF;
        END IF;
      END IF;
    END PROCESS;
  m <= in_dat(0);
END behavioral;
