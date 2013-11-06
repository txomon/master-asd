library ieee;
use ieee.std_logic_1164.all;

entity wbs_rxserp is
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
end wbs_rxserp;

architecture behavioral of wbs_rxserp is
  type status_type is (
    sby,
    str,
    strm,
    b0,
    b0m,
    b1,
    b1m,
    b2,
    b2m,
    b3,
    b3m,
    b4,
    b4m,
    b5,
    b5m,
    b6,
    b6m,
    b7,
    b7m,
    par,
    parm,
    sto,
    stom
  );
  signal sta, stn : status_type;
  signal ini, tc, en : std_logic;
  signal cnt : integer range 0 to nvt/2;
  signal in_dat : std_logic_vector(8 downto 0);
begin
  -- sta progress
  process(sta, tc, rx)
    begin
      case sta is
        when sby =>
          if rx = '0' then
            stn <= str;
          end if;
        when str =>
          if tc = '1' then
            stn <= strm;
          end if;
        when strm =>
          if tc = '1' then
            stn <= b0;
          end if;
        when b0 =>
          if tc = '1' then
            stn <= b0m;
          end if;
        when b0m =>
          if tc = '1' then
            stn <= b1;
          end if;
        when b1 =>
          if tc = '1' then
            stn <= b1m;
          end if;
        when b1m =>
          if tc = '1' then
            stn <= b2;
          end if;
        when b2 =>
          if tc = '1' then
            stn <= b2m;
          end if;
        when b2m =>
          if tc = '1' then
            stn <= b3;
          end if;
        when b3 =>
          if tc = '1' then
            stn <= b3m;
          end if;
        when b3m =>
          if tc = '1' then
            stn <= b4;
          end if;
        when b4 =>
          if tc = '1' then
            stn <= b4m;
          end if;
        when b4m =>
          if tc = '1' then
            stn <= b5;
          end if;
        when b5 =>
          if tc = '1' then
            stn <= b5m;
          end if;
        when b5m =>
          if tc = '1' then
            stn <= b6;
          end if;
        when b6 =>
          if tc = '1' then
            stn <= b6m;
          end if;
        when b6m =>
          if tc = '1' then
            stn <= b7;
          end if;
        when b7 =>
          if tc = '1' then
            stn <= b7m;
          end if;
        when b7m =>
          if tc = '1' then
            stn <= par;
          end if;
        when par =>
          if tc = '1' then
            stn <= parm;
          end if;
        when parm =>
          if tc = '1' then
            stn <= sto;
          end if;
        when sto =>
          if tc = '1' then
            stn <= stom;
          end if;
        when stom =>
          if tc = '1' then
            stn <= sby;
          end if;
      end case;
    end process;

  process(clk_i, rst_i)
    begin
      if rising_edge(clk_i) then
        if rst_i = '1' then
          sta <= sby;
        else
          sta <= stn;
        end if;
      end if;
    end process;


  -- rdy out pin
  with sta select
  rdy_o <= tc when sto,
           '0' when others;

  -- ack out pin
  ack_o <= we_i and stb_i;

  -- en out pin
  with sta select
  en <= tc when b0 | b1 | b2 | b3 | b4 | b5 | b6 | b7 | par,
        '0' when others;

  -- ini out pin
  with sta select
  ini <= '1' when sby,
         '0' when others;

  -- retarded
  process(clk_i) begin
    if rising_edge(clk_i) then
      if ini='1' then
        cnt <= 0;
        tc <= '0';
      else
        if cnt = (nvt/2)-1 then
          cnt <= 0;
          tc <= '1';
        else
          cnt <= cnt + 1;
          tc <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk_i)
  begin
    if rising_edge(clk_i) then
      if en = '1' then
        in_dat <= rx & in_dat(8 downto 1);
      end if;
    end if;
  end process;
  dat_o <= in_dat(7 downto 0);
  error_o <= in_dat(0) xor
             in_dat(1) xor
             in_dat(2) xor
             in_dat(3) xor
             in_dat(4) xor
             in_dat(5) xor
             in_dat(6) xor
             in_dat(7) xor
             in_dat(8);

end behavioral;
