LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY tb_hex IS
END tb_hex;

ARCHITECTURE structural OF tb_hex IS
  COMPONENT simproc IS
    GENERIC (
      CONSTANT trst :IN TIME := 320 ns;
      CONSTANT tclk :IN TIME := 100 ns
    );
    PORT (
        SIGNAL rst :OUT STD_LOGIC;
        SIGNAL clk :OUT STD_LOGIC;
        SIGNAL sta :OUT STD_LOGIC;
        SIGNAL dat :OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT monproc IS
    PORT (
      SIGNAL clk :IN STD_LOGIC;
      SIGNAL rst :IN STD_LOGIC;
      SIGNAL sta :IN STD_LOGIC;
      SIGNAL dat :IN STD_LOGIC_VECTOR(7 downto 0)
    );
  END COMPONENT;
  SIGNAL rst : STD_LOGIC;
  SIGNAL clk : STD_LOGIC;
  SIGNAL sta : STD_LOGIC;
  SIGNAL dat : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
  SIM : simproc
    PORT MAP (
      rst => rst,
      clk => clk,
      sta => sta,
      dat => dat
    );

  MON : monproc
    PORT MAP (
      rst => rst,
      clk => clk,
      sta => sta,
      dat => dat
    );
END structural;