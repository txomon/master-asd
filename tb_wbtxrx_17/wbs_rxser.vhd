LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY wbs_rxser IS
  GENERIC (
    CONSTANT nvt :IN INTEGER := 10
  );
  PORT (
    SIGNAL rst_i, clk_i :IN STD_LOGIC;
    SIGNAL stb_i, we_i :IN STD_LOGIC;
    SIGNAL rx :IN STD_LOGIC;
    SIGNAL rdy_o, ack_o :OUT STD_LOGIC;
    SIGNAL dat_o :OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END wbs_rxser;

ARCHITECTURE behavioral OF wbs_rxser IS
  TYPE STATUS_TYPE IS (
    SBY,
    STR,
    STRM,
    B0,
    B0M,
    B1,
    B1M,
    B2,
    B2M,
    B3,
    B3M,
    B4,
    B4M,
    B5,
    B5M,
    B6,
    B6M,
    B7,
    B7M,
    STO,
    STOM
  );
  SIGNAL sta, stn : STATUS_TYPE;
  SIGNAL ini, tc, en : STD_LOGIC;
  SIGNAL cnt : INTEGER RANGE 0 TO nvt/2;
  SIGNAL in_dat : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
  -- sta progress
  PROCESS(sta, tc, rx)
    BEGIN
      CASE sta IS
        WHEN SBY =>
          IF rx = '0' THEN
            stn <= STR;
          END IF;
        WHEN STR =>
          IF tc = '1' THEN
            stn <= STRM;
          END IF;
        WHEN STRM =>
          IF tc = '1' THEN
            stn <= B0;
          END IF;
        WHEN B0 =>
          IF tc = '1' THEN
            stn <= B0M;
          END IF;
        WHEN B0M =>
          IF tc = '1' THEN
            stn <= B1;
          END IF;
        WHEN B1 =>
          IF tc = '1' THEN
            stn <= B1M;
          END IF;
        WHEN B1M =>
          IF tc = '1' THEN
            stn <= B2;
          END IF;
        WHEN B2 =>
          IF tc = '1' THEN
            stn <= B2M;
          END IF;
        WHEN B2M =>
          IF tc = '1' THEN
            stn <= B3;
          END IF;
        WHEN B3 =>
          IF tc = '1' THEN
            stn <= B3M;
          END IF;
        WHEN B3M =>
          IF tc = '1' THEN
            stn <= B4;
          END IF;
        WHEN B4 =>
          IF tc = '1' THEN
            stn <= B4M;
          END IF;
        WHEN B4M =>
          IF tc = '1' THEN
            stn <= B5;
          END IF;
        WHEN B5 =>
          IF tc = '1' THEN
            stn <= B5M;
          END IF;
        WHEN B5M =>
          IF tc = '1' THEN
            stn <= B6;
          END IF;
        WHEN B6 =>
          IF tc = '1' THEN
            stn <= B6M;
          END IF;
        WHEN B6M =>
          IF tc = '1' THEN
            stn <= B7;
          END IF;
        WHEN B7 =>
          IF tc = '1' THEN
            stn <= B7M;
          END IF;
        WHEN B7M =>
          IF tc = '1' THEN
            stn <= STO;
          END IF;
        WHEN STO =>
          IF tc = '1' THEN
            stn <= STOM;
          END IF;
        WHEN STOM =>
          IF tc = '1' THEN
            stn <= SBY;
          END IF;
      END CASE;
    END PROCESS;

  PROCESS(clk_i, rst_i)
    BEGIN
      IF RISING_EDGE(clk_i) THEN
        IF rst_i = '1' THEN
          sta <= SBY;
        ELSE
          sta <= stn;
        END IF;
      END IF;
    END PROCESS;


  -- RDY out pin
  WITH sta SELECT
  rdy_o <= tc WHEN STO,
           '0' WHEN OTHERS;

  -- ACK out pin
  ack_o <= we_i and stb_i;

  -- EN out pin
  WITH sta SELECT
  en <= tc WHEN B0 | B1 | B2 | B3 | B4 | B5 | B6 | B7,
        '0' WHEN OTHERS;

  -- INI out pin
  WITH sta SELECT
  ini <= '1' WHEN SBY,
         '0' WHEN OTHERS;

  -- Retarded
  PROCESS(clk_i) BEGIN
    IF RISING_EDGE(clk_i) THEN
      IF ini='1' THEN
        cnt <= 0;
        tc <= '0';
      ELSE
        IF cnt = (nvt/2)-1 THEN
          cnt <= 0;
          tc <= '1';
        ELSE
          cnt <= cnt + 1;
          tc <= '0';
        END IF;
      END IF;
    END IF;
  END PROCESS;

  PROCESS(clk_i)
  BEGIN
    IF RISING_EDGE(clk_i) THEN
      IF en = '1' THEN
        in_dat <= rx & in_dat(7 DOWNTO 1);
      END IF;
    END IF;
  END PROCESS;
  dat_o <= in_dat;

END behavioral;
