LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_alu IS
END tb_alu;

ARCHITECTURE structural OF tb_alu IS
  COMPONENT alup IS
    GENERIC(
      CONSTANT nb :IN INTEGER := 4
    );
    PORT (
      SIGNAL fun :IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      SIGNAL a :IN STD_LOGIC_VECTOR((nb-1) DOWNTO 0);
      SIGNAL b :IN STD_LOGIC_VECTOR((nb-1) DOWNTO 0);
      SIGNAL dat :OUT STD_LOGIC_VECTOR((nb-1) DOWNTO 0);
      SIGNAL c :OUT STD_LOGIC;
      SIGNAL z :OUT STD_LOGIC;
      SIGNAL e :OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT simdat IS
    GENERIC (
      CONSTANT tclk :IN TIME := 100 ns;
      CONSTANT ti1 :IN TIME := 320 ns;
      CONSTANT tf1 :IN TIME := 5000 ns;
      CONSTANT ti2 :IN TIME := 310 ns;
      CONSTANT tf2 :IN TIME := 1900 ns
    );

    PORT (
      SIGNAL clk :OUT STD_LOGIC;
      SIGNAL cnt :OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      SIGNAL data :OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      SIGNAL out1 :OUT STD_LOGIC;
      SIGNAL out2 :OUT STD_LOGIC
    );
  END COMPONENT;
  SIGNAL in_dat : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL in_cnt : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
  ALU : alup
    PORT MAP (
      a => in_dat(7 DOWNTO 4),
      b => in_dat(3 DOWNTO 0),
      fun => in_cnt
    );

  SIM : simdat
    PORT MAP (
      cnt => in_cnt,
      data => in_dat
    );

END structural;