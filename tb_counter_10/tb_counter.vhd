LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_counter IS
  PORT (
    SIGNAL dat :OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END tb_counter;
  
ARCHITECTURE structural OF tb_counter IS
  COMPONENT counter IS
    GENERIC (
      CONSTANT ncnt :IN INTEGER := 12
    );
    PORT (
      SIGNAL rst :IN STD_LOGIC;
      SIGNAL clk :IN STD_LOGIC;
      SIGNAL dat :OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
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
  
  SIGNAL in_rst : STD_LOGIC;
  SIGNAL in_clk : STD_LOGIC;

BEGIN
  SIM : rstclk
    PORT MAP (
      rst => in_rst,
      clk => in_clk
    );

  CNT : counter
    PORT MAP (
      rst => in_rst,
      clk => in_clk,
      dat => dat
    );
END structural;