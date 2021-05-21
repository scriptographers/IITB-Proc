-- Component: 16 bit register
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

library std;
use std.standard.all;

use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity SixteenBitRegister is
	port (
		Reg_datain     : in std_logic_vector(15 downto 0);
		clk, Reg_wrbar : in std_logic;
		Reg_dataout    : out std_logic_vector(15 downto 0));
end entity;

architecture struct of SixteenBitRegister is

	signal R : std_logic_vector(15 downto 0) := (others => '0');

begin
	Reg_dataout <= R;
	Reg_write :
	process (Reg_wrbar, Reg_datain, clk)
	begin
		if (Reg_wrbar = '0') then
			if (rising_edge(clk)) then
				R <= Reg_datain;
			end if;
		end if;
	end process;

end struct;
