LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY tb_waitd IS
  PORT (
    SIGNAL tc :OUT STD_LOGIC
  );
END tb_waitd;

ARCHITECTURE structural OF tb_waitd IS
  COMPONENT waitd IS
    GENERIC (
      CONSTANT ntb :IN INTEGER := 10
    );

    PORT (
      SIGNAL clk :IN STD_LOGIC;
      SIGNAL ini :IN STD_LOGIC;
      SIGNAL tc :OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT rstclk IS
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
  END COMPONENT;

  SIGNAL in_clk : STD_LOGIC;
  SIGNAL in_ini : STD_LOGIC;
BEGIN
  RST : rstclk
    PORT MAP (
      clk => in_clk,
      out1 => in_ini
    );
  WTD : waitd
    PORT MAP (
      clk => in_clk,
      ini => in_ini,
      tc => tc
    );
END structural;