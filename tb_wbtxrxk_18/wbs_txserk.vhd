library ieee;
use ieee.std_logic_1164.all;

entity wbs_txserk is
  generic (
    constant nvt :in integer := 10
  );
  port (
    signal rst_i, clk_i, stb_i, we_i :in std_logic;
    signal dat_i :in std_logic_vector(7 downto 0);
    signal tx, ack_o, rdy_o :out std_logic
  );
end wbs_txserk;

architecture behavioral of wbs_txserk is
  type status_type is (
    sby,
    str,
    b0,
    b1,
    b2,
    b3,
    b4,
    b5,
    b6,
    b7,
    sto
  );
  signal sta : status_type := sby;
  signal stn : status_type;
  signal cnt : integer := 0;
  signal tc, m, ld, en, ini : std_logic := '0';
  signal in_dat : std_logic_vector(7 downto 0);
begin
  -- status progress
  process(stb_i, sta, tc)
    begin
      case sta is
        when sby =>
          if stb_i = '1' then
            stn <= str;
          end if;
        when str =>
          if tc = '1' then
            stn <= b0;
          end if;
        when b0 =>
          if tc = '1' then
            stn <= b1;
          end if;
        when b1 =>
          if tc = '1' then
            stn <= b2;
          end if;
        when b2 =>
          if tc = '1' then
            stn <= b3;
          end if;
        when b3 =>
          if tc = '1' then
            stn <= b4;
          end if;
        when b4 =>
          if tc = '1' then
            stn <= b5;
          end if;
        when b5 =>
          if tc = '1' then
            stn <= b6;
          end if;
        when b6 =>
          if tc = '1' then
            stn <= b7;
          end if;
        when b7 =>
          if tc = '1' then
            stn <= sto;
          end if;
        when sto =>
          if tc = '1' then
            stn <= sby;
          end if;
      end case;
    end process;

  -- change status
  process(clk_i)
    begin
      if rising_edge(clk_i) then
        sta <= stn;
      end if;
    end process;

  -- tx out pin
  with sta select
  tx <= '0' when str,
        '1' when sby | sto,
        m when others;

  -- ld out pin
  with sta select
  ld <= '1' when sby,
        '0' when others;

  -- en out pin
  with sta select
  en <= '0' when sby | str | sto,
        '1' when others;

  -- ini out pin
  with sta select
  ini <= '1' when sby,
         '0' when others;

  with sta select
  rdy_o <= '1' when sby | sto,
           '0' when others;

  -- retarded
  process(clk_i) begin
    if rising_edge(clk_i) then
      if ini='1' then
        cnt <= 0;
      else
        if cnt = nvt-1 then
          cnt <= 0;
          tc <= '1';
        else
          cnt <= cnt + 1;
          tc <= '0';
        end if;
      end if;
    end if;
  end process;

  process (clk_i) begin
      if rising_edge(clk_i) then
        if ld = '1' then
          in_dat <= dat_i;
        elsif en = '1' then
          if tc = '1' then
            in_dat <= '0' & in_dat(7 downto 1);
          end if;
        end if;
      end if;
    end process;
  m <= in_dat(0);

  process(we_i, stb_i, sta) begin
    ack_o <= '0';
    case sta is
      when sto =>
        if we_i = '1' then
          if stb_i = '1' then
            ack_o <= '1';
          end if;
        end if;
      when others =>
    end case;
  end process;
  ld <= we_i and stb_i;

end behavioral;
