LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY clktyp IS
  GENERIC (
    CONSTANT tclk :IN TIME := 5 ns
  );

  PORT   (
    SIGNAL clk :OUT STD_LOGIC
  );
END clktyp;

ARCHITECTURE dataflow OF clktyp IS
BEGIN
  PROCESS
  BEGIN
    WHILE TRUE LOOP
      clk <= '0';
      WAIT FOR tclk;
      clk <= '1';
      WAIT FOR tclk;
    END LOOP;
  END PROCESS;
END dataflow;