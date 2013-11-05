LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY monproc IS
  PORT (
    SIGNAL clk :IN STD_LOGIC;
    SIGNAL rst :IN STD_LOGIC;
    SIGNAL sta :IN STD_LOGIC;
    SIGNAL dat :IN STD_LOGIC_VECTOR(7 downto 0)
  );
END monproc;

ARCHITECTURE dataflow OF monproc IS
  TYPE BinFile IS FILE OF CHARACTER;
  FILE fich : BinFile OPEN WRITE_MODE IS "fichescritura.txt";
  SIGNAL sta_in : STD_LOGIC;
BEGIN

  PROCESS(clk)
    VARIABLE char : CHARACTER; -- writting var
    VARIABLE val : UNSIGNED (3 DOWNTO 0);
  BEGIN
    IF (rst = '0' AND RISING_EDGE(clk)) THEN
      IF sta = '1' AND sta_in = '0' THEN
        WRITE(fich, LF);
      END IF;

      FOR I IN 0 TO 1 LOOP
        val := UNSIGNED(dat((7-I*4) DOWNTO ((4-I*4))));
        IF val < 10 THEN
          char := CHARACTER'VAL(CONV_INTEGER(val) + 48);
        ELSIF val > 9 THEN
          char := CHARACTER'VAL(CONV_INTEGER(val) + 55);
        END IF;
        WRITE(fich, char);
      END LOOP;
      sta_in <= '0';
    ELSIF (rst = '1' AND RISING_EDGE(clk)) THEN
      sta_in <= '1';
    END IF;
  END PROCESS;
END dataflow;
