-- Component: Async Memory with Read/Write
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Memory is
	port (
		clk, write_flag  : in std_logic;
		addr, data_write : in std_logic_vector(15 downto 0);
		data_read        : out std_logic_vector(15 downto 0)
	);
end entity;

architecture arch of Memory is

	-- A new type: Array of 32 elements, where each element is a 16-bit vector
	type MemoryArray is array(31 downto 0) of std_logic_vector(15 downto 0);
	-- Original Test
	-- signal mem : MemoryArray := (
	-- 	0 => x"4054",
	-- 	1 => x"6000",
	-- 	2 => x"c042",
	-- 	3 => x"0210",
	-- 	4 => x"c4c3",
	-- 	7 => x"13be",
	-- 	8 => x"2128",
	-- 	9 => x"0a32",
	-- 	10 => x"c982",
	-- 	11 => x"212a",
	-- 	12 => x"3caa",
	-- 	13 => x"5044",
	-- 	14 => x"8202",
	-- 	16 => x"91c0",
	-- 	18 => x"7000",
	-- 	19 => x"f000",
	-- 	20 => x"0014",
	-- 	21 => x"0002",
	-- 	23 => x"0016",
	-- 	24 => x"ffff",
	-- 	26 => x"ffff",
	-- 	27 => x"0012",
	-- 	others => x"0000"
	-- );

	-- LHI Test
	-- signal mem : MemoryArray := (
	-- 	0 => x"3009", -- LHI R0 9
	-- 	1 => x"33ff", -- LHI R1 511
	-- 	2 => x"3400", -- LHI R2 0
	-- 	3 => x"3601", -- LHI R3 1
	-- 	others => x"0000"
	-- );

	-- ADI Test
	signal mem : MemoryArray := (
		0 => x"1009", -- ADI R0 R0 9
		1 => x"1046", -- ADI R0 R1 6
		2 => x"1281", -- ADI R1 R2 1
		3 => x"14c0", -- ADI R2 R3 0
		others => x"0000"
	);

begin

	-- Read
	data_read <= mem(conv_integer(addr));

	proc_write : process (write_flag, data_write, addr, clk)
	begin
		if (write_flag = '0') then
			if (rising_edge(clk)) then
				-- Write
				mem(conv_integer(addr)) <= data_write;
			end if;
		end if;
	end process;

end architecture;
