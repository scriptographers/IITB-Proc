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
			PC, IR     : out std_logic_vector(15 downto 0);
			done       : out std_logic;
			C, Z       : out std_logic;
			reg0, reg1, reg2, reg3,
			reg4, reg5, reg6, reg7 : out std_logic_vector(15 downto 0)
		);
	end component;

	signal clk : std_logic := '0';
	signal rst : std_logic := '0';
	signal PC, IR : std_logic_vector(15 downto 0);
	signal done : std_logic;
	signal C, Z : std_logic;
	signal reg0, reg1, reg2, reg3,
	reg4, reg5, reg6, reg7 : std_logic_vector(15 downto 0);

begin

	dut_instance : IITBProc
	port map(
		clk => clk, reset => rst,
		PC => PC, IR => IR,
		done => done,
		C => C, Z => Z,
		reg0 => reg0, reg1 => reg1, reg2 => reg2, reg3 => reg3,
		reg4 => reg4, reg5 => reg5, reg6 => reg6, reg7 => reg7
	);

	clk <= not clk after 5 ns;

	process
	begin

		rst <= '0';
		wait for 1000 ns;

	end process;

end architecture;
