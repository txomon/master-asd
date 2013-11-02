LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY wbm_dmon1 IS
  GENERIC (
    CONSTANT tp :IN TIME := 10 ns
  );
  PORT (
    SIGNAL clk_i, rst_i, ack_i, rdy_i :IN STD_LOGIC;
    SIGNAL we_o, stb_o :OUT STD_LOGIC;
    SIGNAL dat_i :IN STD_LOGIC_VECTOR(7 downto 0)
  );
END wbm_dmon1;

ARCHITECTURE dataflow OF wbm_dmon1 IS
  TYPE BinFile IS FILE OF CHARACTER;
  FILE fich : BinFile;
  SIGNAL in_we_o : STD_LOGIC;
BEGIN

  PROCESS(clk_i)
    VARIABLE char: CHARACTER; -- reading var
  BEGIN
    IF RISING_EDGE(clk_i) THEN
      IF rst_i = '0' THEN
        IF ack_i='1' THEN
          char := CHARACTER'VAL(conv_integer(dat_i));
          WRITE(fich, char);
        END IF;
      END IF;
    END IF;
  END PROCESS;

  PROCESS(rst_i)
  BEGIN
    IF FALLING_EDGE(rst_i) THEN
      FILE_OPEN(fich, "fichescritura.txt", WRITE_MODE);
    ELSIF RISING_EDGE(rst_i) THEN
      FILE_CLOSE(fich);
    END IF;
  END PROCESS;

  in_we_o <= rdy_i AFTER tp;

  stb_o <= NOT in_we_o;
  we_o <= in_we_o;
END dataflow;
