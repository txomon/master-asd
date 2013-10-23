LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY ram16x8 IS
  PORT (
    SIGNAL clk :IN STD_LOGIC;
    SIGNAL adr :IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL dat_i :IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL we :IN STD_LOGIC;
    SIGNAL stb :IN STD_LOGIC;
    SIGNAL dat_o :OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END ram16x8;

ARCHITECTURE behavioral OF ram16x8 IS
  TYPE ram_type IS ARRAY(0 TO 15) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL ram : ram_type;
  SIGNAL in_dat_o : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
  PROCESS(clk)
    BEGIN
      IF RISING_EDGE(clk) THEN
        IF stb = '1' THEN
          IF we = '1' THEN
            ram(CONV_INTEGER(UNSIGNED(adr))) <= dat_i;
          END IF;
          in_dat_o <= ram(CONV_INTEGER(UNSIGNED(adr)));
        END IF;
      END IF;
    END PROCESS;
  dat_o <= in_dat_o;
END behavioral;
