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
		Reg_datain3                  : in std_logic_vector(15 downto 0);
		clk, write_flag              : in std_logic;
		Reg_dataout1, Reg_dataout2   : out std_logic_vector(15 downto 0)
	);
end entity;

architecture arch of RegisterFile is

	type regarray is array(7 downto 0) of std_logic_vector(15 downto 0);
	signal RegisterF : regarray := (others => x"0000");

begin

	Reg_dataout1 <= RegisterF(conv_integer(address1));
	Reg_dataout2 <= RegisterF(conv_integer(address2));

	A : process (write_flag, Reg_datain3, address3, clk)
	begin
		if (write_flag = '0') then
			if (rising_edge(clk)) then
				RegisterF(conv_integer(address3)) <= Reg_datain3;
			end if;
		end if;
	end process;

end architecture;
