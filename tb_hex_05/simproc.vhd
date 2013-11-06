LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY simproc IS
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
END simproc;

ARCHITECTURE dataflow OF simproc IS

  COMPONENT clktyp IS
    GENERIC (
      tclk : IN TIME
    );
    PORT (
      clk :OUT STD_LOGIC
    );
  END COMPONENT;

  SIGNAL rst_in, clk_in, sta_in : STD_LOGIC;
  TYPE BinFile IS FILE OF CHARACTER;
  FILE fich : BinFile OPEN READ_MODE IS "fichlectura.txt";
BEGIN

  -- Clock
  CLOCK : clktyp
    GENERIC MAP (
      tclk => tclk
    )
    PORT MAP (
      clk => clk_in
    );
  clk <= clk_in;

  -- Reset
  PROCESS
  BEGIN
    rst_in <= '1';
    WAIT FOR trst;
    rst_in <= '0';
    WAIT;
  END PROCESS;

  rst <= rst_in;

  -- File read
  PROCESS(clk_in)
    VARIABLE cont : INTEGER RANGE 0 TO 2;
    VARIABLE char: CHARACTER; -- reading var
    VARIABLE data_pack : STD_LOGIC_VECTOR(7 downto 0);
  BEGIN
    IF (RISING_EDGE(clk_in) AND rst_in = '0') THEN
      IF sta_in = '1' THEN
         sta <= '1';
         sta_in <= '0';
       ELSE
         sta <= '0';
       END IF;
       cont := 2;
       WHILE (cont > 0) LOOP
         cont := cont - 1;
        READ(fich, char);
        CASE char IS
          WHEN '0' => data_pack := data_pack(3 DOWNTO 0) & "0000";
          WHEN '1' => data_pack := data_pack(3 DOWNTO 0) & "0001";
          WHEN '2' => data_pack := data_pack(3 DOWNTO 0) & "0010";
          WHEN '3' => data_pack := data_pack(3 DOWNTO 0) & "0011";
          WHEN '4' => data_pack := data_pack(3 DOWNTO 0) & "0100";
          WHEN '5' => data_pack := data_pack(3 DOWNTO 0) & "0101";
          WHEN '6' => data_pack := data_pack(3 DOWNTO 0) & "0110";
          WHEN '7' => data_pack := data_pack(3 DOWNTO 0) & "0111";
          WHEN '8' => data_pack := data_pack(3 DOWNTO 0) & "1000";
          WHEN '9' => data_pack := data_pack(3 DOWNTO 0) & "1001";
          WHEN 'A' => data_pack := data_pack(3 DOWNTO 0) & "1010";
          WHEN 'B' => data_pack := data_pack(3 DOWNTO 0) & "1011";
          WHEN 'C' => data_pack := data_pack(3 DOWNTO 0) & "1110";
          WHEN 'D' => data_pack := data_pack(3 DOWNTO 0) & "1101";
          WHEN 'E' => data_pack := data_pack(3 DOWNTO 0) & "1110";
          WHEN 'F' => data_pack := data_pack(3 DOWNTO 0) & "1111";
          WHEN 'a' => data_pack := data_pack(3 DOWNTO 0) & "1010";
          WHEN 'b' => data_pack := data_pack(3 DOWNTO 0) & "1011";
          WHEN 'c' => data_pack := data_pack(3 DOWNTO 0) & "1100";
          WHEN 'd' => data_pack := data_pack(3 DOWNTO 0) & "1101";
          WHEN 'e' => data_pack := data_pack(3 DOWNTO 0) & "1110";
          WHEN 'f' => data_pack := data_pack(3 DOWNTO 0) & "1111";
          WHEN OTHERS =>
            cont := cont + 1;
            sta <= '1';
        END CASE;
      END LOOP;
      dat <= data_pack;
    ELSIF RISING_EDGE(clk_in) THEN
      sta <= '0';
      sta_in <= '1';
    END IF;
  END PROCESS;

END dataflow;