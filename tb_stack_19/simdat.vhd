library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity simdat is
  generic (
    constant tclk :in time := 100 ns;
    constant ti1 :in time := 320 ns;
    constant tf1 :in time := 5000 ns;
    constant ti2 :in time := 310 ns;
    constant tf2 :in time := 1900 ns
  );

  port (
    signal clk :out std_logic;
    signal cnt :out std_logic_vector(3 downto 0);
    signal data :out std_logic_vector(7 downto 0);
    signal out1 :out std_logic;
    signal out2 :out std_logic
  );
end entity;

architecture dataflow of simdat is
  signal in_clk: std_logic := '0';
  signal counter : unsigned (3 downto 0) := "0000";
  signal in_out1, in_out2 : std_logic := '0';
  type binfile is file of character;
  file fich : binfile open read_mode is "fichlectura.txt";
begin
  -- clock component
  process
  begin
    while true loop
      in_clk <= '0';
      wait for tclk;
      in_clk <= '1';
      wait for tclk;
    end loop;
  end process;
  clk <= in_clk;

  -- out1 and out2 generation
  process
  begin
    in_out1 <= '0';
    wait for ti1;
    in_out1 <= '1';
    wait for tf1;
    in_out1 <= '0';
    wait;
  end process;

  process
  begin
    in_out2 <= '0';
    wait for ti2;
    in_out2 <= '1';
    wait for tf2;
    in_out2 <= '0';
    wait;
  end process;

  out1 <= in_out1;
  out2 <= in_out2;

  -- file read
  process (in_clk)
    variable char: character; -- reading var
    variable data_pack : std_logic_vector(7 downto 0);
  begin
     if (rising_edge(in_clk) and in_out1 = '1') then
       for i in 0 to 2 loop
        read(fich, char);
        case char is
          when '0' => data_pack := data_pack(3 downto 0) & "0000";
          when '1' => data_pack := data_pack(3 downto 0) & "0001";
          when '2' => data_pack := data_pack(3 downto 0) & "0010";
          when '3' => data_pack := data_pack(3 downto 0) & "0011";
          when '4' => data_pack := data_pack(3 downto 0) & "0100";
          when '5' => data_pack := data_pack(3 downto 0) & "0101";
          when '6' => data_pack := data_pack(3 downto 0) & "0110";
          when '7' => data_pack := data_pack(3 downto 0) & "0111";
          when '8' => data_pack := data_pack(3 downto 0) & "1000";
          when '9' => data_pack := data_pack(3 downto 0) & "1001";
          when 'A' => data_pack := data_pack(3 downto 0) & "1010";
          when 'B' => data_pack := data_pack(3 downto 0) & "1011";
          when 'C' => data_pack := data_pack(3 downto 0) & "1110";
          when 'D' => data_pack := data_pack(3 downto 0) & "1101";
          when 'E' => data_pack := data_pack(3 downto 0) & "1110";
          when 'F' => data_pack := data_pack(3 downto 0) & "1111";
          when 'a' => data_pack := data_pack(3 downto 0) & "1010";
          when 'b' => data_pack := data_pack(3 downto 0) & "1011";
          when 'c' => data_pack := data_pack(3 downto 0) & "1100";
          when 'd' => data_pack := data_pack(3 downto 0) & "1101";
          when 'e' => data_pack := data_pack(3 downto 0) & "1110";
          when 'f' => data_pack := data_pack(3 downto 0) & "1111";
          when others =>
        end case;
      end loop;

      data <= data_pack;
    end if;
  end process;

  process(in_clk)
  begin
     if falling_edge(in_clk) then
       if in_out1 = '1' then
         counter <= counter + 1;
      elsif in_out1 = '0' then
        counter <= (others => '0');
      end if;
    end if;
  end process;

  cnt <= std_logic_vector(counter);

end dataflow;