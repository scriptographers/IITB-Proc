-- Component: 16-bit NAND operation
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity SixteenBitNand is
	port (
		a, b : in std_logic_vector(15 downto 0);
		output : out std_logic_vector(15 downto 0)
    );
end entity;

architecture arch of SixteenBitNand is
begin

	nand_loop : for i in 0 to 15 generate
		output(i) <= not((a(i) and b(i)));
	end generate nand_loop;

end architecture;
