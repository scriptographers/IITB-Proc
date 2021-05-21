-- Component: 16-bit NAND operation
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity SixteenBitNand is
	port (
		A, B : in std_logic_vector(15 downto 0);
		C    : out std_logic_vector(15 downto 0));
end entity;

architecture arch of SixteenBitNand is
begin
	nand_loop : for i in 0 to 15 generate
		C(i) <= not((A(i) and B(i)));
	end generate nand_loop;
end architecture;
