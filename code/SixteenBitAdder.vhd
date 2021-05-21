library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity SixteenBitAdder is
  port (
    in_a : in std_logic_vector (15 downto 0);
    in_b : in std_logic_vector (15 downto 0);
    sum  : out std_logic_vector (16 downto 0));
end SixteenBitAdder;

architecture Struct of SixteenBitAdder is

  component OneBitAdder is
    port (
      A, B, Cin : in std_logic;
      S, Cout   : out std_logic);
  end component OneBitAdder;
  signal tC : std_logic_vector(16 downto 0);
  
begin

  tC(0) <= '0';

  add : for i in 15 downto 0 generate
    ax : OneBitAdder port map(A => in_a(i), B => in_b(i), Cin => tC(i), S => sum(i), Cout => tC(i + 1));
  end generate add;
  sum(16) <= tC(16);

end Struct;
