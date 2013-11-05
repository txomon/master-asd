
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY tb_waits IS
  PORT (
    SIGNAL tc :OUT STD_LOGIC
  );
END tb_waits;

ARCHITECTURE structural OF tb_waits IS
  COMPONENT waits IS
    GENERIC (
      CONSTANT ntb :IN INTEGER := 10
    );

    PORT (
      SIGNAL clk :IN STD_LOGIC;
      SIGNAL ini :IN STD_LOGIC;
      SIGNAL stp :IN STD_LOGIC;
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
  SIGNAL in_stp : STD_LOGIC;
BEGIN
  RST : rstclk
    PORT MAP (
      clk => in_clk,
      out1 => in_ini,
      out2 => in_stp
    );
  WTD : waits
    PORT MAP (
      clk => in_clk,
      ini => in_ini,
      stp => in_stp,
      tc => tc
    );
END structural;