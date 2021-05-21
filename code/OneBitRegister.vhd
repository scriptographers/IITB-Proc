-- Component: Single bit register
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity OneBitRegister is
	port (
		Reg_datain     : in std_logic;
		clk, Reg_wrbar : in std_logic;
		Reg_dataout    : out std_logic);
end entity;

architecture struct of OneBitRegister is

	signal R : std_logic := '0';

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
