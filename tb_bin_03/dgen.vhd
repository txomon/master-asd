LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY dgen IS
  GENERIC (
    CONSTANT tp :IN TIME := 10 ns;
    CONSTANT trst :IN TIME := 320 ns;
    CONSTANT tclk :IN TIME := 100 ns;
    CONSTANT npause :IN INTEGER := 10
  );

  PORT (
    SIGNAL rst :OUT STD_LOGIC;
    SIGNAL clk :OUT STD_LOGIC;
    SIGNAL stb :OUT STD_LOGIC;
    SIGNAL dat :OUT STD_LOGIC_VECTOR(7 downto 0)
  );

END dgen;

ARCHITECTURE dataflow OF dgen IS

  COMPONENT clktyp
    GENERIC (
      tclk : IN TIME
    );
    PORT (
      clk : OUT STD_LOGIC
    );
  END COMPONENT;

  SIGNAL in_clk, in_rst :STD_LOGIC;
  SIGNAL stb_a, stb_b :STD_LOGIC;
  SIGNAL cont :INTEGER RANGE 0 TO npause;
  SIGNAL lect :STD_LOGIC_VECTOR(7 downto 0);

BEGIN
  -- Reset signal
  PROCESS
  BEGIN
    in_rst <= '1';
    WAIT FOR trst;
    in_rst <= '0';
    WAIT;
  END PROCESS;

  rst <= in_rst;

  -- Clock signal
  CLOCK : clktyp
    GENERIC MAP (
      tclk => tclk
    )
    PORT MAP (
      in_clk
    );

  clk <= in_clk;

  -- Counter
  PROCESS (in_clk)
  BEGIN
  	IF RISING_EDGE(in_clk) THEN
  		IF (in_rst = '1') THEN
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
  PROCESS (stb_a, in_rst)
    TYPE BinFile IS FILE OF CHARACTER;
    FILE fich : BinFile OPEN READ_MODE IS "fichlectura.txt";
    VARIABLE char: CHARACTER; -- reading var
  BEGIN
 	  IF RISING_EDGE(in_rst) THEN
 	    FILE_CLOSE(fich);
 	    FILE_OPEN(fich, "fichlectura.txt", READ_MODE);
	  ELSE
	    IF (in_rst = '0' and RISING_EDGE(stb_a)) THEN
	      READ(fich, char);
	      lect <= CONV_STD_LOGIC_VECTOR(CHARACTER'POS(char),8);
      END IF;
    END IF;
  END PROCESS;

  -- Read trigger
  stb_b <= stb_a AFTER tp WHEN in_rst = '0' ELSE '0';
  stb <= stb_b;
  dat <= lect WHEN stb_b = '1' ELSE (OTHERS => 'Z');

END dataflow;
