-- Component: Single Bit Full Adder
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity OneBitAdder is
  port (
    a, b, cin : in std_logic;
    sum, cout : out std_logic
  );
end OneBitAdder;

architecture arch of OneBitAdder is
begin
  
  sum <= a xor b xor cin;
  cout <= (a and b) or (a and cin) or (b and cin);

end architecture;