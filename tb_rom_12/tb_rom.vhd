LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_rom IS
  PORT (
    dat_o :OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
  );
END tb_rom;

ARCHITECTURE structural OF tb_rom IS
  COMPONENT rom16x14 IS
    PORT (
      SIGNAL clk :IN STD_LOGIC;
      SIGNAL adr :IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      SIGNAL stb :IN STD_LOGIC;
      SIGNAL dat_o :OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
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
  
  SIGNAL in_clk : STD_LOGIC;
  SIGNAL in_adr : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL in_stb : STD_LOGIC;
BEGIN
  SIM : simdat
    PORT MAP (
      clk => in_clk,
      cnt => in_adr,
      out1 => in_stb
    );

  ROM : rom16x14
    PORT MAP (
      clk => in_clk,
      adr => in_adr,
      stb => in_stb,
      dat_o => dat_o
    );
END structural;