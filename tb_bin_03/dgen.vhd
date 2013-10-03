LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY dgen IS
  GENERIC (
    CONSTANT tp :IN TIME := 10 ns;
    CONSTANT trst :IN TIME := 320 ns;
    CONSTANT tclk :IN TIME := 100 ns;
    CONSTANT npause :IN INT := 10;
  );
  
  PORT   (
    SIGNAL rst :OUT STD_LOGIC;
    SIGNAL clk :OUT STD_LOGIC;
    SIGNAL stb :OUT STD_LOGIC;
    SIGNAL dat :OUT STD_LOGIC_VECTOR(7 downto 0)
  );
  
END dgen;

ARCHITECTURE dataflow OF dgen IS
  SIGNAL stb_a :STD_LOGIC;
  SIGNAL stb_b :STD_LOGIC;
  SIGNAL cont :INTEGER RANGE 0 TO npause;
  SIGNAL dat :STD_LOGIC_VECTOR(7 downto 0)
BEGIN
  
  -- Reset signal
  PROCESS
  BEGIN
    rst <= '1';
    WAIT FOR trst;
    rst <= '0';
  END PROCESS;
  
  -- Clock signal
  PROCESS
  BEGIN
    --clk <= '1';
    WHILE TRUE LOOP
      clk <= '0';
      WAIT FOR (tclk / 2);
      clk <= '1';
      WAIT FOR (tclk / 2);
    END LOOP;
  END PROCESS;

  -- Counter
  PROCESS (clk)
  BEGIN
  	IF RISING_EDGE(clk) THEN
  		IF (rst = '1') THEN
  			cont <= 0;
 		ELSE
  		  IF (cont = npause) THEN
		    cont <= 0;
		  ELSE
    			 cont <= cont + 1;
  			END IF;
  		END IF;
  	END IF;
  END PROCESS;
  
  stb_a <= '1' WHEN cont = npause ELSE '0';

  -- File read
  PROCESS (stb_b, rst)
    TYPE BinFile IS FILE OF CHARACTER;
    FILE fich : BinFile OPEN READ_MODE IS "fichlectura.txt";
    VARIABLE char: CHARACTER; -- reading var
  BEGIN
 	  IF RISING_EDGE(rst) THEN
 	    FILE_CLOSE(fich);
 	    FILE_OPEN(fich, "fichlectura.txt");
	  ELSE
	    IF rst = '0' and RISING_EDGE(stb_b) THEN
	      READ(fich, char);
	      lect <= CONV_STD_LOGIC_VECTOR(CHARACTER'POS(char),8);
      END IF;
    END IF;
  END PROCESS;
  
  -- Read trigger
  stb_b <= stb_a AFTER tp IF rst = '0' ELSE '0';
  stb <= stb_b;
  dat <= lect IF stb_b = '1' ELSE 'ZZZZZZZZ';
  
END dataflow;