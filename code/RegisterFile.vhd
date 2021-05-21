-- Component: Register file
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RegisterFile is
	port (
		address1, address2, address3 : in std_logic_vector(2 downto 0);
		data_write3                  : in std_logic_vector(15 downto 0);
		clk, write_flag              : in std_logic;
		data_read1, data_read2   : out std_logic_vector(15 downto 0)
	);
end entity;

architecture arch of RegisterFile is
	
	-- A new type: vector of 8 elements, where each element is a 16-bit vector
	type RegisterArray is array(7 downto 0) of std_logic_vector(15 downto 0);
	signal registers : RegisterArray := (others => x"0000");

begin

	data_read1 <= registers(conv_integer(address1));
	data_read2 <= registers(conv_integer(address2));

	proc_write : process (write_flag, data_write3, address3, clk)
	begin
		if (write_flag = '0') then
			if (rising_edge(clk)) then
				registers(conv_integer(address3)) <= data_write3;
			end if;
		end if;
	end process;

end architecture;
