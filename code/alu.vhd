library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity alu is
	port (
		A, B    : in std_logic_vector(15 downto 0);
		op      : in std_logic;
		C       : out std_logic_vector(15 downto 0);
		Z, Cout : out std_logic);
end alu;

architecture Struct of alu is

	component SixteenBitAdder is
		port (
		    a : in std_logic_vector (15 downto 0);
		    b : in std_logic_vector (15 downto 0);
		    sum : out std_logic_vector (15 downto 0);
		    cout: out std_logic
		);
	end component SixteenBitAdder;

	component nandbit is
		port (
			A, B : in std_logic_vector(15 downto 0);
			C    : out std_logic_vector(15 downto 0));
	end component nandbit;

	signal t1, t2, t3, t7 : std_logic_vector(15 downto 0);
	signal t4, t5, t6 : std_logic;

begin

	c1 : SixteenBitAdder port map(
		a => A, 
		b => B, 
		sum => t1, 
		cout => t4
	);

	c2 : nandbit port map(A, B, t2);

	t3 <= (others => op);
	t7 <= (t3 and t2) or (t1 and not t3);

	C <= t7;

	Cout <= t4 and not op;
	t6 <= not(t7(0) or t7(1) or t7(2) or t7(3) or t7(4) or t7(5) or t7(6) or t7(7) or t7(8) or t7(9)
		or t7(10) or t7(11) or t7(12) or t7(13) or t7(14) or t7(15));

	Z <= t6;

end Struct;
