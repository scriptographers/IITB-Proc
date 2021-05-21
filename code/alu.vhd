-- Component: ALU
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity ALU is
	port (
		a, b : in std_logic_vector(15 downto 0);
		op : in std_logic;
		output : out std_logic_vector(15 downto 0);
		zero, cout : out std_logic
	);
end ALU;

architecture arch of ALU is

	signal carry: std_logic;
	signal addition_result, nand_result, extended_op, temp : std_logic_vector(15 downto 0);

	component SixteenBitAdder is
		port (
		    a : in std_logic_vector (15 downto 0);
		    b : in std_logic_vector (15 downto 0);
		    sum : out std_logic_vector (15 downto 0);
		    cout: out std_logic
		);
	end component SixteenBitAdder;

	component SixteenBitNand is
		port (
			a, b : in std_logic_vector(15 downto 0);
			output : out std_logic_vector(15 downto 0)
	    );
	end component SixteenBitNand;

begin

	extended_op <= (others => op); -- Repeats op value at each of the 16 positions of extended_op

	op_add : SixteenBitAdder 
	port map(
		a => a, 
		b => b, 
		sum => addition_result, 
		cout => carry
	);

	cout <= carry and (not op);

	op_nand : SixteenBitNand 
	port map(a => a, b => b, output => nand_result);

	-- If op = 1, then return nand result, else return addition result
	temp <= (extended_op and nand_result) or (addition_result and not extended_op);

	-- zero is 1 iff all bits of the output are 0
	zero <= not(
		temp(0) or temp(1) or temp(2) or temp(3) or 
		temp(4) or temp(5) or temp(6) or temp(7) or 
		temp(8) or temp(9) or temp(10) or temp(11) or 
		temp(12) or temp(13) or temp(14) or temp(15)
	);

	output <= temp;

end architecture;
