--------------------------------------------------------------------------------
-- company:
-- engineer:
--
-- create date:   15:30:43 11/07/2013
-- design name:
-- module name:   /home/javier/proyectos/master/master-asd/tb_crc_21/tb_crc.vhd
-- project name:  tb_crc
-- target device:
-- tool versions:
-- description:
--
-- vhdl test bench created by ise for module: crc
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

entity tb_crc is
end tb_crc;

architecture structural of tb_crc is

    -- component declaration for the unit under test (uut)

    component crc
      port(
        rst : in  std_logic;
        clk : in  std_logic;
        stream : in  std_logic;
        crc : out  std_logic_vector(7 downto 0)
      );
    end component;

    component tb_stream is
      generic (
        constant trst :in time := 320 ns;
        constant tclk :in time := 100 ns
      );
      port (
        signal rst :out std_logic;
        signal clk :out std_logic;
        signal stream :out std_logic
      );
    end component;


   --inputs
   signal rst : std_logic;
   signal clk : std_logic ;
   signal stream : std_logic ;

   --outputs
   signal crc_i : std_logic_vector(7 downto 0);

   -- clock period definitions
   constant clk_period : time := 10 ns;

begin

  -- instantiate the unit under test (uut)
   cr: crc port map (
      rst => rst,
      clk => clk,
      stream => stream,
      crc => crc_i
    );
    STR: tb_stream port map(
      rst => rst,
      clk => clk,
      stream => stream
    );

end;
