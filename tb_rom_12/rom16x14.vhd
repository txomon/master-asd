LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY rom16x14 IS
  PORT (
    SIGNAL clk :IN STD_LOGIC;
    SIGNAL adr :IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL stb :IN STD_LOGIC;
    SIGNAL dat_o :OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
  );
END rom16x14;

ARCHITECTURE behavioral OF rom16x14 IS
  TYPE rom_type IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR(13 DOWNTO 0);
  SIGNAL rom : rom_type:=
(
  "01"&x"234",
  "10"&x"345",
  "11"&x"456",
  "00"&x"567",
  "01"&x"678",
  "10"&x"789",
  "11"&x"89a",
  "00"&x"9ab",
  "01"&x"abc",
  "10"&x"bcd",
  "11"&x"cde",
  "00"&x"def",
  "01"&x"ef0",
  "10"&x"f01",
  "11"&x"012",
  "00"&x"123"
);
  ATTRIBUTE rom_style: string;
  ATTRIBUTE rom_style OF rom: SIGNAL IS "block";
BEGIN
  PROCESS(clk)
    BEGIN
      IF RISING_EDGE(clk) THEN
        IF stb = '1' THEN
          dat_o <= rom(CONV_INTEGER(UNSIGNED(adr)));
        END IF;
      END IF;
    END PROCESS;
END behavioral;