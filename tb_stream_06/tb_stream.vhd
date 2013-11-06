LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_stream IS
  GENERIC (
    CONSTANT trst :IN TIME := 320 ns;
    CONSTANT tclk :IN TIME := 100 ns
  );
  PORT (
    SIGNAL rst :OUT STD_LOGIC;
    SIGNAL clk :OUT STD_LOGIC;
    SIGNAL stream :OUT STD_LOGIC
  );
END tb_stream;

ARCHITECTURE dataflow OF tb_stream IS
  COMPONENT clktyp IS
    GENERIC (
      tclk : IN TIME
    );
    PORT (
      clk :OUT STD_LOGIC
    );
  END COMPONENT;
  SIGNAL rst_in : STD_LOGIC;
  SIGNAL clk_in : STD_LOGIC;
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

  -- File reading now

  -- File read
  PROCESS(clk_in)
    VARIABLE cont : BOOLEAN;
    VARIABLE char: CHARACTER; -- reading var
    VARIABLE data_pack : STD_LOGIC_VECTOR(7 downto 0);
  BEGIN
    IF (RISING_EDGE(clk_in) AND rst_in = '0') THEN
      cont := TRUE;
       WHILE cont LOOP
         cont := FALSE;
        READ(fich, char);
        CASE char IS
          WHEN '0' => stream <= '0';
          WHEN '1' => stream <= '1';
          WHEN OTHERS => cont := TRUE;
        END CASE;
      END LOOP;
    END IF;
  END PROCESS;

END dataflow;