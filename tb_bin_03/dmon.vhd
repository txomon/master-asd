LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY dmon IS
  PORT (
    SIGNAL clk :IN STD_LOGIC;
    SIGNAL rst :IN STD_LOGIC;
    SIGNAL stb :IN STD_LOGIC;
    SIGNAL dat :IN STD_LOGIC_VECTOR(7 downto 0)
  );
END dmon;

ARCHITECTURE dataflow OF dmon IS

BEGIN
  PROCESS(stb, rst)
    TYPE BinFile IS FILE OF CHARACTER;
    FILE fich : BinFile;
    VARIABLE char: CHARACTER; -- reading var
  BEGIN
    IF FALLING_EDGE(rst) THEN
      FILE_OPEN(fich, "fichescritura.txt", WRITE_MODE);
    ELSIF rst = '0' THEN
      FILE_OPEN(fich, "fichescritura.txt", APPEND_MODE);
    END IF;

    IF (rst = '0' and RISING_EDGE(stb)) THEN
      char := CHARACTER'VAL(conv_integer(dat));
      WRITE(fich, char);
      FILE_CLOSE(fich);
    END IF;
  END PROCESS;

END dataflow;
