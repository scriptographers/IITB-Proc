-- Component: 16 Bit Full Adder
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity SixteenBitAdder is
  port (
    in_a : in std_logic_vector (15 downto 0);
    in_b : in std_logic_vector (15 downto 0);
    sum  : out std_logic_vector (16 downto 0)
  );
end SixteenBitAdder;

architecture Struct of SixteenBitAdder is

  component OneBitAdder is
    port (
      a, b, cin : in std_logic;
      sum, cout : out std_logic
    );
  end component OneBitAdder;

  signal tC : std_logic_vector(16 downto 0);

begin

  tC(0) <= '0';

  add : for i in 15 downto 0 generate
    ax : OneBitAdder 
    port map(a => in_a(i), b => in_b(i), cin => tC(i), sum => sum(i), cout => tC(i + 1));
  end generate add;

  sum(16) <= tC(16);

end Struct;
