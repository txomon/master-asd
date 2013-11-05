LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_regsp IS
  PORT (
    SIGNAL dat :OUT STD_LOGIC
  );
END tb_regsp;

ARCHITECTURE structural OF tb_regsp IS
  COMPONENT rstclk IS
    GENERIC (
      CONSTANT trst :IN TIME := 320 ns;
      CONSTANT tpck :IN TIME := 30 ns;
      CONSTANT tclk :IN TIME := 100 ns;
      CONSTANT ti1 :IN TIME := 800 ns;
      CONSTANT tf1 :IN TIME := 4000 ns;
      CONSTANT ti2 :IN TIME := 1200 ns;
      CONSTANT tf2 :IN TIME := 1600 ns
    );

    PORT (
      SIGNAL rst :OUT STD_LOGIC;
      SIGNAL clk :OUT STD_LOGIC;
      SIGNAL out1 :OUT STD_LOGIC;
      SIGNAL out2 :OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT regparser IS
    GENERIC (
      CONSTANT n_b :IN INTEGER := 8
    );
    PORT (
      SIGNAL clk :IN STD_LOGIC;
      SIGNAL dat :IN STD_LOGIC_VECTOR(n_b-1 DOWNTO 0);
      SIGNAL en :IN STD_LOGIC;
      SIGNAL ld :IN STD_LOGIC;
      SIGNAL m :OUT STD_LOGIC
    );
  END COMPONENT;

  SIGNAL in_clk : STD_LOGIC;
  SIGNAL in_ld : STD_LOGIC;
  SIGNAL in_en : STD_LOGIC;
  SIGNAL in_dat : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
  SIM : rstclk
    PORT MAP(
      clk => in_clk,
      out1 => in_en,
      out2 => in_ld
      );
  REG : regparser
    PORT MAP(
      clk => in_clk,
      ld => in_ld,
      en => in_en,
      dat => in_dat,
      m => dat
    );
  in_dat <= X"A5";
END structural;