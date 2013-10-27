LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_ctrl IS
  PORT (
    SIGNAL tx :OUT STD_LOGIC;
    SIGNAL ld :OUT STD_LOGIC;
    SIGNAL en :OUT STD_LOGIC;
    SIGNAL ini :OUT STD_LOGIC
  );
END tb_ctrl;

ARCHITECTURE structural OF tb_ctrl IS
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

  COMPONENT ctrl IS
    PORT (
      SIGNAL rst :IN STD_LOGIC;
      SIGNAL clk :IN STD_LOGIC;
      SIGNAL stb :IN STD_LOGIC;
      SIGNAL m :IN STD_LOGIC;
      SIGNAL tx :OUT STD_LOGIC;
      SIGNAL ld :OUT STD_LOGIC;
      SIGNAL en :OUT STD_LOGIC;
      SIGNAL ini :OUT STD_LOGIC
    );
  END COMPONENT;

  SIGNAL in_clk : STD_LOGIC;
  SIGNAL in_rst : STD_LOGIC;
  SIGNAL in_stb : STD_LOGIC;
  SIGNAL in_m : STD_LOGIC;
BEGIN
  RST : rstclk
    PORT MAP (
      rst => in_rst,
      clk => in_clk,
      out1 => in_stb,
      out2 => in_m
    );

  CTL : ctrl
    PORT MAP (
      rst => in_rst,
      clk => in_clk,
      stb => in_stb,
      m => in_m,
      tx => tx,
      ld => ld,
      en => en,
      ini => ini
    );
END structural;
