LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_regsp IS
  PORT (
    SIGNAL dat :OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END tb_regsp;

ARCHITECTURE structural OF tb_regsp IS
  COMPONENT rstclk IS
    GENERIC (
      CONSTANT trst :IN TIME := 320 ns;
      CONSTANT tpck :IN TIME := 30 ns;
      CONSTANT tclk :IN TIME := 100 ns;
      CONSTANT ti1 :IN TIME := 800 ns;
      CONSTANT tf1 :IN TIME := 2000 ns;
      CONSTANT ti2 :IN TIME := 1200 ns;
      CONSTANT tf2 :IN TIME := 2300 ns
    );

    PORT (
      SIGNAL rst :OUT STD_LOGIC;
      SIGNAL clk :OUT STD_LOGIC;
      SIGNAL out1 :OUT STD_LOGIC;
      SIGNAL out2 :OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT regserpar IS
    GENERIC (
      CONSTANT n_b :IN INTEGER := 8
    );

    PORT (
      SIGNAL clk :IN STD_LOGIC;
      SIGNAL d :IN STD_LOGIC;
      SIGNAL en :IN STD_LOGIC;
      SIGNAL dat :OUT STD_LOGIC_VECTOR(n_b-1 DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL in_clk : STD_LOGIC;
  SIGNAL in_d : STD_LOGIC;
  SIGNAL in_en : STD_LOGIC;
BEGIN
  SIM : rstclk
    PORT MAP(
      clk => in_clk,
      out1 => in_d,
      out2 => in_en
      );
  REG : regserpar
    PORT MAP(
      clk => in_clk,
      d => in_d,
      en => in_en,
      dat => dat
    );
END structural;
