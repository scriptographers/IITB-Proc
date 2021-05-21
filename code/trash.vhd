library std;
use std.standard.all;
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- since The Memory is asynchronous read, there is no read signal, but you can use it based on your preference.
-- this memory gives 16 Bit data in one clock cycle, so edit the file to your requirement.

entity Trash is
	port (
		clk, Reg_wrbar : in std_logic;
		Reg_dataout    : out std_logic_vector(15 downto 0));
end entity;

architecture Form of Trash is
	--type regarray is array(7 downto 0) of std_logic_vector(15 downto 0);   -- defining a new type
	--signal Register: regarray:=(1 => x"0000",2 => x"0000",3 => x"0000",4 => x"0000",5 => x"0000",6 => x"0000",7 => x"0000");
	-- you can use the above mentioned way to initialise the memory with the instructions and the data as required to test your processor
	component CustomRegister is
		port (
			Reg_datain     : in std_logic_vector(15 downto 0);
			clk, Reg_wrbar : in std_logic;
			Reg_dataout    : out std_logic_vector(15 downto 0));
	end component;
	signal t2 : std_logic_vector(15 downto 0);
	signal t1 : std_logic_vector(15 downto 0) := (others => '0');
begin
	r1 : Register16 port map(Reg_datain => t1, clk => clk, Reg_wrbar => Reg_wrbar, Reg_dataout => t2);
	t1 <= not t2;
	Reg_dataout <= t2;
end Form;
