-- Component: Async Memory
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

library std;
use std.standard.all;

use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- since The Memory is asynchronous read, there is no read signal, but you can use it based on your preference.
-- this memory gives 16 Bit data in one clock cycle, so edit the file to your requirement.

entity MemoryReadWrite is
	port (
		address, Mem_datain : in std_logic_vector(15 downto 0);
		clk, Mem_wrbar      : in std_logic;
		Mem_dataout         : out std_logic_vector(15 downto 0));
end entity;

architecture struct of MemoryReadWrite is

	type regarray is array(31 downto 0) of std_logic_vector(15 downto 0); -- defining a new type
	signal Memory : regarray := (
		0 => x"4054",
		1 => x"6000",
		2 => x"c042",
		3 => x"0210",
		4 => x"c4c3",
		7 => x"13be",
		8 => x"2128",
		9 => x"0a32",
		10 => x"c982",
		11 => x"212a",
		12 => x"3caa",
		13 => x"5044",
		14 => x"8202",
		16 => x"91c0",
		18 => x"7000",
		19 => x"f000",
		20 => x"0014",
		21 => x"0002",
		23 => x"0016",
		24 => x"ffff",
		26 => x"ffff",
		27 => x"0012",
		others => x"0000"
	);
	-- Uncomment the following to get another set of instructions
	-- signal Memory : regarray := (
	-- 	0 => x"3000",
	-- 	1 => x"3000",
	-- 	2 => x"1057",
	-- 	3 => x"4442",
	-- 	4 => x"0458",
	-- 	5 => x"2460",
	-- 	6 => x"2921",
	-- 	7 => x"1111",
	-- 	8 => x"2921",
	-- 	9 => x"58c0",
	-- 	10 => x"7292",
	-- 	11 => x"6e60",
	-- 	12 => x"c040",
	-- 	13 => x"127f",
	-- 	14 => x"c241",
	-- 	16 => x"9440",
	-- 	22 => x"83f5",
	-- 	25 => x"ffed",
	-- 	26 => x"ffff",
	-- 	others => x"0000"
	-- );

	-- you can use the below mentioned way to initialise the memory with the instructions and the data as required to test your processor

begin

	Mem_dataout <= Memory(conv_integer(address));
	Mem_write : process (Mem_wrbar, Mem_datain, address, clk)
	begin
		if (Mem_wrbar = '0') then
			if (rising_edge(clk)) then
				Memory(conv_integer(address)) <= Mem_datain;
			end if;
		end if;
	end process;

end struct;
