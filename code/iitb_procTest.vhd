library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;

entity iitb_procTest is
end entity;

architecture tb of iitb_procTest is
	component iitb_proc is
		port (
			clk, reset : in std_logic;
			O          : out std_logic_vector(15 downto 0);
			Done       : out std_logic);
	end component;

	signal clk : std_logic := '1';
	signal rst : std_logic := '0';
	signal o : std_logic_vector(15 downto 0);
	signal d : std_logic;

begin
	dut_instance : iitb_proc
	port map(clk => clk, reset => rst, O => o, Done => d);

	clk <= not clk after 5 ns;
	process
	begin
		rst <= '1';
		wait for 14 ns;

		rst <= '0';
		wait for 1000 ns;

	end process;

end architecture;
