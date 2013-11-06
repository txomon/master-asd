library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity wbm_dgen is
  generic (
    constant tp :in time := 10 ns;
    constant trst :in time := 320 ns;
    constant tclk :in time := 100 ns;
    constant npause :in integer := 100
  );

  port (
    signal rst_o, clk_o, we_o, stb_o :out std_logic;
    signal ack_i, rdy_i :in std_logic;
    signal dat_o :out std_logic_vector(7 downto 0)
  );

end wbm_dgen;

architecture dataflow of wbm_dgen is
  signal in_clk, in_rst_o :std_logic;
  signal stb_a, stb_b :std_logic;
  signal cont :integer range 0 to npause;
  signal lect :std_logic_vector(7 downto 0);

begin
  -- reset signal
  process
  begin
    in_rst_o <= '1';
    wait for trst;
    in_rst_o <= '0';
    wait;
  end process;

  rst_o <= in_rst_o;

  process
  begin
    while true loop
      in_clk <= '0';
      wait for tclk;
      in_clk <= '1';
      wait for tclk;
    end loop;
  end process;
  clk_o <= in_clk;
--
--  -- counter
--  process (in_clk)
--  begin
--    if rising_edge(in_clk) then
--      if (in_rst_o = '1') then
--        cont <= 0;
--      else
--        if (cont = npause) then
--          if ack_i = '1' then
--            cont <= 0;
--          end if;
--        else
--          cont <= cont + 1;
--        end if;
--      end if;
--    end if;
--  end process;

--  stb_a <= '1' when cont = npause else '0';

    stb_a <= rdy_i;

  -- file read
  process (stb_a, in_rst_o)
    type binfile is file of character;
    file fich : binfile open read_mode is "fichlectura.txt";
    variable char: character; -- reading var
  begin
    if rising_edge(in_rst_o) then
      file_close(fich);
      file_open(fich, "fichlectura.txt", read_mode);
    else
      if (in_rst_o = '0' and rising_edge(stb_a)) then
        read(fich, char);
        lect <= conv_std_logic_vector(character'pos(char),8);
      end if;
    end if;
  end process;

  -- read trigger
  stb_b <= stb_a after tp when in_rst_o = '0' else '0';
  stb_o <= stb_b;
  we_o <= stb_b;
  dat_o <= lect when stb_b = '1' else (others => 'X');

end dataflow;
