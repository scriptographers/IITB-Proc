library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity OneBitAdder is
  port (
    A, B, Cin : in std_logic;
    S, Cout   : out std_logic);
end OneBitAdder;

architecture Struct of OneBitAdder is
begin
  
  S <= A xor B xor Cin;
  Cout <= (A and B) or (A and Cin) or (B and Cin);

end Struct;