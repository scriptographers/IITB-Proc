-- Component: 16 Bit Full Adder
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity SixteenBitAdder is
  port (
    a : in std_logic_vector (15 downto 0);
    b : in std_logic_vector (15 downto 0);
    sum : out std_logic_vector (16 downto 0) -- MSB is cout
  );
end SixteenBitAdder;

architecture arch of SixteenBitAdder is

  signal carry : std_logic_vector(16 downto 0);

  component OneBitAdder is
    port (
      a, b, cin : in std_logic;
      sum, cout : out std_logic
    );
  end component OneBitAdder;

begin

  carry(0) <= '0'; -- cin is 0

  add_loop : for i in 15 downto 0 generate
    bit_i : OneBitAdder 
    port map(
      a => a(i), 
      b => b(i), 
      cin => carry(i), 
      sum => sum(i), 
      cout => carry(i + 1)
    );
  end generate add_loop;

  sum(16) <= carry(16);

end architecture;
