-- Component: Async Register file
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RegisterFile is
	port (
		clk, write_flag        : in std_logic;
		addr1, addr2, addr3    : in std_logic_vector(2 downto 0);
		data_write3            : in std_logic_vector(15 downto 0);
		data_read1, data_read2 : out std_logic_vector(15 downto 0);
		reg0, reg1, reg2, reg3,
		reg4, reg5, reg6, reg7 : out std_logic_vector(15 downto 0)
	);
end entity;

architecture arch of RegisterFile is

	-- A new type: vector of 8 elements, where each element is a 16-bit vector
	type RegisterArray is array(7 downto 0) of std_logic_vector(15 downto 0);
	signal registers : RegisterArray := (others => x"0000"); -- initialize all positions to all zeros

begin

	-- Read
	data_read1 <= registers(conv_integer(addr1));
	data_read2 <= registers(conv_integer(addr2));

	proc_write : process (write_flag, data_write3, addr3, clk)
	begin
		if (write_flag = '1') then
			if (rising_edge(clk)) then
				-- Write
				registers(conv_integer(addr3)) <= data_write3;
			end if;
		end if;
	end process;

	reg0 <= registers(0);
	reg1 <= registers(1);
	reg2 <= registers(2);
	reg3 <= registers(3);
	reg4 <= registers(4);
	reg5 <= registers(5);
	reg6 <= registers(6);
	reg7 <= registers(7);

end architecture;
