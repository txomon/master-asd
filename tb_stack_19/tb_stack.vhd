--------------------------------------------------------------------------------
-- company:
-- engineer:
--
-- create date:   16:40:06 11/06/2013
-- design name:
-- module name:   /home/javier/proyectos/master/master-asd/tb_stack_19/tb_stack.vhd
-- project name:  tb_stack
-- target device:
-- tool versions:
-- description:
--
-- vhdl test bench created by ise for module: stack
--
-- dependencies:
--
-- revision:
-- revision 0.01 - file created
-- additional comments:
--
-- notes:
-- this testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  xilinx recommends
-- that these types always be used for the top-level i/o of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation
-- simulation model.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
--use ieee.numeric_std.all;

entity tb_stack is
end tb_stack;

architecture behavior of tb_stack is

    -- component declaration for the unit under test (uut)

    component stack
    port(
         clk : in  std_logic;
         dat_i : in  std_logic_vector(7 downto 0);
         we : in  std_logic;
         stb : in  std_logic;
         dat_o : out  std_logic_vector(7 downto 0)
        );
    end component;

    component simdat is
      generic (
        constant tclk :in time := 100 ns;
        constant ti1 :in time := 350 ns;
        constant tf1 :in time := 1150 ns;
        constant ti2 :in time := 350 ns;
        constant tf2 :in time := 5000 ns
      );

      port (
        signal clk :out std_logic;
        signal cnt :out std_logic_vector(3 downto 0);
        signal data :out std_logic_vector(7 downto 0);
        signal out1 :out std_logic;
        signal out2 :out std_logic
      );
    end component;

   --inputs
   signal clk : std_logic;
   signal dat_i : std_logic_vector(7 downto 0);
   signal we : std_logic;
   signal stb : std_logic;

   --outputs
   signal dat_o : std_logic_vector(7 downto 0);

begin
    SIM : simdat port map (
      clk => clk,
      cnt => open,
      data => dat_i,
      out1 => we,
      out2 => stb
    );

    LIFO: stack port map (
          clk => clk,
          dat_i => dat_i,
          we => we,
          stb => stb,
          dat_o => dat_o
    );


end;
