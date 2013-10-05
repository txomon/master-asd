LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY tb_bin IS
END tb_bin;

ARCHITECTURE structural OF tb_bin IS
  COMPONENT dgen
    PORT (
      SIGNAL rst :OUT STD_LOGIC;
      SIGNAL clk :OUT STD_LOGIC;
      SIGNAL stb :OUT STD_LOGIC;
      SIGNAL dat :OUT STD_LOGIC_VECTOR(7 downto 0)
    );
  END COMPONENT;

  COMPONENT dmon
    PORT (
      SIGNAL clk :IN STD_LOGIC;
      SIGNAL rst :IN STD_LOGIC;
      SIGNAL stb :IN STD_LOGIC;
      SIGNAL dat :IN STD_LOGIC_VECTOR(7 downto 0)
    );
  END COMPONENT;

  SIGNAL clk : STD_LOGIC;
  SIGNAL rst : STD_LOGIC;
  SIGNAL stb : STD_LOGIC;
  SIGNAL dat : STD_LOGIC_VECTOR(7 downto 0);

BEGIN

  GENERATOR : dgen
    PORT MAP (
      clk => clk,
      rst => rst,
      stb => stb,
      dat => dat
    );

  MONITOR : dmon
    PORT MAP (
      clk => clk,
      rst => rst,
      stb => stb,
      dat => dat
    );

END structural;
