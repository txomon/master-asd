LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY rstclk IS
  GENERIC (
    CONSTANT trst :IN TIME := 320 ns;
    CONSTANT tpck :IN TIME := 30 ns;
    CONSTANT tclk :IN TIME := 100 ns;
    CONSTANT ti1 :IN TIME := 5035 ns;
    CONSTANT tf1 :IN TIME := 5815 ns;
    CONSTANT ti2 :IN TIME := 3015 ns;
    CONSTANT tf2 :IN TIME := 3415 ns
  );
  
  PORT   (
    SIGNAL rst :OUT STD_LOGIC;
    SIGNAL clk :OUT STD_LOGIC;
    SIGNAL out1 :OUT STD_LOGIC;
    SIGNAL out2 :OUT STD_LOGIC
  );
  
END rstclk;

ARCHITECTURE dataflow OF rstclk IS
BEGIN
  
  -- Reset signal
  PROCESS
  BEGIN
    rst <= '1';
    WAIT FOR trst;
    rst <= '0';
    WAIT;
  END PROCESS;
  
  -- Clock signal
  PROCESS
  BEGIN
    clk <= '1';
    WAIT FOR tpck;
    WHILE TRUE LOOP
      clk <= '0';
      WAIT FOR (tclk / 2);
      clk <= '1';
      WAIT FOR (tclk / 2);
    END LOOP;
  END PROCESS;
  
  -- Signal 1
  PROCESS
  BEGIN
    out1 <= '0';
    WAIT FOR ti1;
    out1 <= '1';
    WAIT FOR (tf1 - ti1);
    out1 <= '0';
    WAIT;
  END PROCESS;
  
  -- Signal 2
  PROCESS
  BEGIN
    out2 <= '0';
    WAIT FOR ti1;
    out2 <= '1';
    WAIT FOR (tf2 - ti2);
    out2 <= '0';
    WAIT;
  END PROCESS;
  
END dataflow;