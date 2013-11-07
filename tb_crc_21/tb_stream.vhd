library ieee;
use ieee.std_logic_1164.all;

entity tb_stream is
  generic (
    constant trst :in time := 320 ns;
    constant tclk :in time := 100 ns
  );
  port (
    signal rst :out std_logic;
    signal clk :out std_logic;
    signal stream :out std_logic
  );
end tb_stream;

architecture dataflow of tb_stream is
  component clktyp is
    generic (
      tclk : in time
    );
    port (
      clk :out std_logic
    );
  end component;
  signal rst_in : std_logic;
  signal clk_in : std_logic;
  signal cnt : integer := 0;
  type binfile is file of character;
  file fich : binfile open read_mode is "fichlectura.txt";
begin
    -- clock
  clock : clktyp
    generic map (
      tclk => tclk
    )
    port map (
      clk => clk_in
    );
  clk <= clk_in;

  -- reset
  process
  begin
    rst_in <= '1';
    wait for trst;
    rst_in <= '0';
    wait;
  end process;

  rst <= rst_in;

  -- file reading now

  -- file read
  process(clk_in)
    variable cont : boolean;
    variable char: character; -- reading var
    variable data_pack : std_logic_vector(7 downto 0);
  begin
    if (rising_edge(clk_in) and rst_in = '0') then
      cont := true;
      while cont loop
        cont := false;
        if endfile(fich) then
          if cnt = 8 then
            read(fich, char);
          else
            cnt <= cnt + 1;
            char := '0';
          end if;
        else
          read(fich, char);
        end if;
        case char is
          when '0' => stream <= '0';
          when '1' => stream <= '1';
          when others => cont := true;
        end case;
      end loop;
    end if;
  end process;

end dataflow;