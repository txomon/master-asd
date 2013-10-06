LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY simdat IS
  GENERIC (
    CONSTANT tclk :IN TIME := 100 ns;
    CONSTANT ti1 :IN TIME := 320 ns;
    CONSTANT tf1 :IN TIME := 5000 ns;
    CONSTANT ti2 :IN TIME := 310 ns;
    CONSTANT tf2 :IN TIME := 1900 ns;
    CONSTANT dat_nibbles : IN INTEGER := 2
  );
  
  PORT (
    SIGNAL clk :OUT STD_LOGIC;
    SIGNAL cnt :OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL data :OUT STD_LOGIC_VECTOR((dat_nibbles * 4 - 1) DOWNTO 0);
    SIGNAL out1 :OUT STD_LOGIC;
    SIGNAL out2 :OUT STD_LOGIC
  );
END ENTITY;

ARCHITECTURE dataflow OF simdat IS
  COMPONENT clktyp IS
    GENERIC (
      tclk : IN TIME
    );
    PORT (
      clk :OUT STD_LOGIC
    );
  END COMPONENT;
  
  SIGNAL in_clk: STD_LOGIC;
  SIGNAL counter : unsigned (3 DOWNTO 0);
  SIGNAL in_out1, in_out2 : STD_LOGIC;
BEGIN
  -- Clock component
  CLOCK : clktyp
    GENERIC MAP (
      tclk => tclk
    )
    PORT MAP (
      clk => in_clk
    );

  clk <= in_clk;
  
  -- out1 and out2 generation
  PROCESS
  BEGIN
    counter <= (others => '0');
    in_out1 <= '0';
    WAIT FOR ti1;
    in_out1 <= '1';
    WAIT FOR tf1;
    in_out1 <= '0';
    WAIT;
  END PROCESS;
  
  PROCESS
  BEGIN
    in_out2 <= '0';
    WAIT FOR ti2;
    in_out2 <= '1';
    WAIT FOR tf2;
    in_out2 <= '0';
    WAIT;
  END PROCESS;
  
  out1 <= in_out1;
  out2 <= in_out2;  
  
  -- File read
  PROCESS (in_clk)
    TYPE BinFile IS FILE OF CHARACTER;
    FILE fich : BinFile OPEN READ_MODE IS "fichlectura.txt";
    VARIABLE char: CHARACTER; -- reading var
    VARIABLE data_pack : STD_LOGIC_VECTOR((dat_nibbles * 4 - 1) downto 0);
  BEGIN
 	  IF (RISING_EDGE(in_clk) and in_out1 = '1') THEN
 	    FOR I IN 0 TO (dat_nibbles) LOOP -- In file is character stream and (dat_nibbles - 1) in case it's not
	      READ(fich, char);
	      CASE char IS
          WHEN '0' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "0000";
          WHEN '1' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "0001";
          WHEN '2' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "0010";
          WHEN '3' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "0011";
          WHEN '4' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "0100";
          WHEN '5' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "0101";
          WHEN '6' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "0110";
          WHEN '7' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "0111";
          WHEN '8' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "1000";
          WHEN '9' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "1001";
          WHEN 'A' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "1010";
          WHEN 'B' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "1011";
          WHEN 'C' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "1110";
          WHEN 'D' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "1101";
          WHEN 'E' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "1110";
          WHEN 'F' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "1111";
          WHEN 'a' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "1010";
          WHEN 'b' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "1011";
          WHEN 'c' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "1100";
          WHEN 'd' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "1101";
          WHEN 'e' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "1110";
          WHEN 'f' => data_pack := data_pack((((dat_nibbles - 1) * 4) - 1) DOWNTO 0) & "1111";
          WHEN OTHERS => 
        END CASE;
      END LOOP;

 	    counter <= counter + 1;
      data <= data_pack;
    END IF;
  END PROCESS;
  
  cnt <= std_logic_vector(counter);
  
END dataflow;