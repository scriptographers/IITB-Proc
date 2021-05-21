-- Component: ALU
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity ALU is
	port (
		a, b : in std_logic_vector(15 downto 0);
		op : in std_logic;
		c : out std_logic_vector(15 downto 0);
		z, cout : out std_logic
	);
end ALU;

architecture arch of ALU is

	signal t1, t2, t3, t7 : std_logic_vector(15 downto 0);
	signal t4, t5, t6 : std_logic;

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

	c1 : SixteenBitAdder 
	port map(
		a => a, 
		b => b, 
		sum => t1, 
		cout => t4
	);

	c2 : SixteenBitNand 
	port map(a => a, b => b, output => t2);

	t3 <= (others => op);
	t7 <= (t3 and t2) or (t1 and not t3);

	c <= t7;

	cout <= t4 and not op;
	t6 <= not(t7(0) or t7(1) or t7(2) or t7(3) or t7(4) or t7(5) or t7(6) or t7(7) or t7(8) or t7(9)
		or t7(10) or t7(11) or t7(12) or t7(13) or t7(14) or t7(15));

	z <= t6;

end architecture;
