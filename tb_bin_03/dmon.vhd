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
  TYPE BinFile IS FILE OF CHARACTER;
  FILE fich : BinFile;    
BEGIN

  PROCESS(stb)
    VARIABLE char: CHARACTER; -- reading var
  BEGIN
    IF (rst = '0' and RISING_EDGE(stb)) THEN
      char := CHARACTER'VAL(conv_integer(dat));
      WRITE(fich, char);
    END IF;
  END PROCESS;

  PROCESS(rst,stb)
  BEGIN
    IF FALLING_EDGE(rst) THEN
      FILE_OPEN(fich, "fichescritura.txt", WRITE_MODE);
    ELSIF RISING_EDGE(rst) THEN
      FILE_CLOSE(fich);
    END IF;
  END PROCESS;
END dataflow;
