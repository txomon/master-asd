library ieee;
use ieee.std_logic_1164.all;

entity tb_wbtxrxp is
end tb_wbtxrxp;

architecture behavioral of tb_wbtxrxp is
  component wbm_dgen is
    generic (
      constant tp :in time := 10 ns;
      constant trst :in time := 320 ns;
      constant tclk :in time := 100 ns;
      constant npause :in integer := 10
    );

    port (
      signal rst_o, clk_o, we_o, stb_o :out std_logic;
      signal ack_i, rdy_i :in std_logic;
      signal dat_o :out std_logic_vector(7 downto 0)
    );
  end component;

  component wbs_txserp IS
    generic (
      constant nvt :in integer := 10
    );
    port (
      signal rst_i, clk_i, stb_i, we_i :in std_logic;
      signal dat_i :in std_logic_vector(7 downto 0);
      signal tx, ack_o, rdy_o :out std_logic
    );
  end component;

  component wbs_rxserp is
    generic (
      constant nvt :in integer := 10
    );
    port (
      signal rst_i, clk_i :in std_logic;
      signal stb_i, we_i :in std_logic;
      signal rx :in std_logic;
      signal rdy_o, ack_o, error_o :out std_logic;
      signal dat_o :out std_logic_vector(7 downto 0)
    );
  end component;

  component wbm_dmon IS
    generic (
      constant tp :in time := 10 ns
    );
    port (
      signal clk_i, rst_i, ack_i, rdy_i, error_i :in std_logic;
      signal we_o, stb_o :out std_logic;
      signal dat_i :in std_logic_vector(7 downto 0)
    );
  end component;

  signal dat1, dat2 : std_logic_vector(7 downto 0);
  signal clk, rst, txrx : std_logic;
  signal we1, stb1, ack1, rdy1 : std_logic;
  signal we2, stb2, ack2, rdy2, err : std_logic;

begin
  GEN : wbm_dgen
    port map (
      rst_o => rst,
      clk_o => clk,
      dat_o => dat1,
      we_o => we1,
      stb_o => stb1,
      ack_i => ack1,
      rdy_i => rdy1
    );

  TX : wbs_txserp
    port map (
      rst_i => rst,
      clk_i => clk,
      dat_i => dat1,
      we_i => we1,
      stb_i => stb1,
      ack_o => ack1,
      tx => txrx,
      rdy_o => rdy1
    );

  RX : wbs_rxserp
    port map (
      rst_i => rst,
      clk_i => clk,
      dat_o => dat2,
      we_i => we2,
      stb_i => stb2,
      ack_o => ack2,
      rdy_o => rdy2,
      rx => txrx,
      error_o => err
    );

  MON : wbm_dmon
    port map (
      rst_i => rst,
      clk_i => clk,
      dat_i => dat2,
      we_o => we2,
      stb_o => stb2,
      ack_i => ack2,
      rdy_i => rdy2,
      error_i => err
    );
end behavioral;
