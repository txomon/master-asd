LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_txrx IS
END tb_txrx;

ARCHITECTURE structural OF tb_txrx IS

  COMPONENT txser IS
    GENERIC (
      CONSTANT nvt :IN INTEGER := 10
    );
    PORT (
      SIGNAL rst, clk, stb :IN STD_LOGIC;
      SIGNAL dat :IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      SIGNAL tx :OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT rxser IS
    GENERIC (
      CONSTANT nvt :IN INTEGER := 10
    );
    PORT (
      SIGNAL rst :IN STD_LOGIC;
      SIGNAL clk :IN STD_LOGIC;
      SIGNAL rx :IN STD_LOGIC;
      SIGNAL rdy :OUT STD_LOGIC;
      SIGNAL dat :OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT clktyp IS
    GENERIC (
      CONSTANT tclk :IN TIME := 5 ns
    );

    PORT   (
      SIGNAL clk :OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT dgen IS
    GENERIC (
      CONSTANT tp :IN TIME := 10 ns;
      CONSTANT trst :IN TIME := 320 ns;
      CONSTANT tclk :IN TIME := 100 ns;
      CONSTANT npause :IN INTEGER := 200
    );

    PORT (
      SIGNAL rst :OUT STD_LOGIC;
      SIGNAL clk :OUT STD_LOGIC;
      SIGNAL stb :OUT STD_LOGIC;
      SIGNAL dat :OUT STD_LOGIC_VECTOR(7 downto 0)
    );

  END COMPONENT;

  COMPONENT dmon IS
    PORT (
      SIGNAL clk :IN STD_LOGIC;
      SIGNAL rst :IN STD_LOGIC;
      SIGNAL stb :IN STD_LOGIC;
      SIGNAL dat :IN STD_LOGIC_VECTOR(7 downto 0)
    );
  END COMPONENT;

  SIGNAL in_rst : STD_LOGIC;
  SIGNAL in_clk : STD_LOGIC;
  SIGNAL in_stb1, in_stb2 : STD_LOGIC;
  SIGNAL in_dat1, in_dat2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL in_tx : STD_LOGIC;

BEGIN
  DGE : dgen
    PORT MAP (
      rst => in_rst,
      clk => in_clk,
      stb => in_stb1,
      dat => in_dat1
    );

  TXS : txser
    PORT MAP (
      rst => in_rst,
      clk => in_clk,
      stb => in_stb1,
      dat => in_dat1,
      tx => in_tx
    );

  RXS : rxser
    PORT MAP (
      rst => in_rst,
      clk => in_clk,
      rx => in_tx,
      rdy => in_stb2,
      dat => in_dat2
    );

  DMO : dmon
    PORT MAP (
      rst => in_rst,
      clk => in_clk,
      stb => in_stb2,
      dat => in_dat2
    );
END structural;
