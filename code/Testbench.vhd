-- Testbench used

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;

library std;

entity Testbench is
end entity;

architecture tb of Testbench is

	component IITBProc is
		port (
			clk, reset : in std_logic;
			O          : out std_logic_vector(15 downto 0);
			done       : out std_logic;
			PC_deb, IR_deb, ALU_a_deb, ALU_b_deb, ALU_c_deb,
			T1_deb, T2_deb, T3_deb, Mem_deb,
			D1_deb, D2_deb : out std_logic_vector(15 downto 0)
		);
	end component;

	signal clk : std_logic := '1';
	signal rst : std_logic := '0';
	signal o : std_logic_vector(15 downto 0);
	signal d : std_logic;
	signal PC_deb, IR_deb, ALU_a_deb, ALU_b_deb, ALU_c_deb,
	T1_deb, T2_deb, T3_deb, Mem_deb,
	D1_deb, D2_deb : std_logic_vector(15 downto 0);

begin

	dut_instance : IITBProc
	port map(
		clk => clk, reset => rst, O => o, done => d,
		PC_deb => PC_deb, IR_deb => IR_deb,
		ALU_a_deb => ALU_a_deb, ALU_b_deb => ALU_b_deb, ALU_c_deb => ALU_c_deb,
		T1_deb => T1_deb, T2_deb => T2_deb, T3_deb => T3_deb, Mem_deb => Mem_deb,
		D1_deb => D1_deb, D2_deb => D2_deb
	);

	clk <= not clk after 5 ns;

	process
	begin

		rst <= '1';
		wait for 14 ns;

		rst <= '0';
		wait for 1000 ns;

	end process;

end architecture;
