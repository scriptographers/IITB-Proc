-- Component: Package of MUXes used
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

package MUXes is
	
	-- (a) MUX1_2x1: 2 inputs, 1 output, 1 selector, each input is a single bit
	component MUX1_2x1 is
		port (
			A, B, S0 : in std_logic;
			y        : out std_logic
		);
	end component MUX1_2x1;

	-- (b) MUX1_4x1: 4 inputs, 1 output, 2 selectors, each input is a single bit
	component MUX1_4x1 is
		port (
			A, B, C, D, S1, S0 : in std_logic;
			y                  : out std_logic
		);
	end component MUX1_4x1;

	-- (c) MUX3_2x1: 2 inputs, 1 output, 1 selector, each input is a 3-bit vector
	component MUX3_2x1 is
		port (
			A, B : in std_logic_vector(2 downto 0);
			S0   : in std_logic;
			y    : out std_logic_vector(2 downto 0)
		);
	end component MUX3_2x1;

	-- (d) MUX3_4x1: 4 inputs, 1 output, 2 selectors, each input is a 3-bit vector
	component MUX3_4x1 is
		port (
			A, B, C, D : in std_logic_vector(2 downto 0);
			S1, S0     : in std_logic;
			y          : out std_logic_vector(2 downto 0)
		);
	end component MUX3_4x1;

	-- (e) MUX16_2x1: 2 inputs, 1 output, 1 selector, each input is a 16-bit vector
	component MUX16_2x1 is
		port (
			A, B : in std_logic_vector(15 downto 0);
			S0   : in std_logic;
			y    : out std_logic_vector(15 downto 0)
		);
	end component MUX16_2x1;

	-- (f) MUX16_4x1: 4 inputs, 1 output, 2 selectors, each input is a 16-bit vector
	component MUX16_4x1 is
		port (
			A, B, C, D : in std_logic_vector(15 downto 0);
			S1, S0     : in std_logic;
			y          : out std_logic_vector(15 downto 0)
		);
	end component MUX16_4x1;

end package MUXes;


-- (a) MUX1_2x1: 2 inputs, 1 output, 1 selector, each input is a single bit
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity MUX1_2x1 is
	port (
		A, B, S0 : in std_logic;
		y        : out std_logic
	);
end MUX1_2x1;

architecture arch of MUX1_2x1 is
begin
	y <= (A and not S0) or (B and S0);
end architecture;


-- (b) MUX1_4x1: 4 inputs, 1 output, 2 selectors, each input is a single bit
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity MUX1_4x1 is
	port (
		A, B, C, D, S1, S0 : in std_logic;
		y                  : out std_logic
	);
end MUX1_4x1;

architecture arch of MUX1_4x1 is
begin
	y <= (A and (not S1) and (not S0))
		or (B and (not S1) and (S0))
		or (C and (S1) and (not S0))
		or (D and (S1) and (S0));
end architecture;


-- (c) MUX3_2x1: 2 inputs, 1 output, 1 selector, each input is a 3-bit vector
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity MUX3_2x1 is
	port (
		A, B : in std_logic_vector(2 downto 0);
		S0   : in std_logic;
		y    : out std_logic_vector(2 downto 0)
	);
end MUX3_2x1;

architecture arch of MUX3_2x1 is
	component MUX1_2x1 is
		port (
			A, B, S0 : in std_logic;
			y        : out std_logic
		);
	end component;
begin
	MUXg : for i in 2 downto 0 generate
		mx : MUX1_2x1 port map(A => A(i), B => B(i), S0 => S0, y => y(i));
	end generate MUXg;
end architecture;


-- (d) MUX3_4x1: 4 inputs, 1 output, 2 selectors, each input is a 3-bit vector
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity MUX3_4x1 is
	port (
		A, B, C, D : in std_logic_vector(2 downto 0);
		S1, S0     : in std_logic;
		y          : out std_logic_vector(2 downto 0)
	);
end MUX3_4x1;

architecture arch of MUX3_4x1 is
	component MUX1_4x1 is
		port (
			A, B, C, D, S1, S0 : in std_logic;
			y                  : out std_logic
		);
	end component;
begin
	MUXg : for i in 2 downto 0 generate
		mx : MUX1_4x1 port map(A => A(i), B => B(i), C => C(i), D => D(i), S0 => S0, S1 => S1, y => y(i));
	end generate MUXg;
end architecture;


-- (e) MUX16_2x1: 2 inputs, 1 output, 1 selector, each input is a 16-bit vector
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity MUX16_2x1 is
	port (
		A, B : in std_logic_vector(15 downto 0);
		S0   : in std_logic;
		y    : out std_logic_vector(15 downto 0)
	);
end MUX16_2x1;

architecture arch of MUX16_2x1 is
	component MUX1_2x1 is
		port (
			A, B, S0 : in std_logic;
			y        : out std_logic
		);
	end component;
begin
	MUXg : for i in 15 downto 0 generate
		mx : MUX1_2x1 port map(A => A(i), B => B(i), S0 => S0, y => y(i));
	end generate MUXg;
end architecture;


-- (f) MUX16_4x1: 4 inputs, 1 output, 2 selectors, each input is a 16-bit vector
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity MUX16_4x1 is
	port (
		A, B, C, D : in std_logic_vector(15 downto 0);
		S1, S0     : in std_logic;
		y          : out std_logic_vector(15 downto 0)
	);
end MUX16_4x1;

architecture arch of MUX16_4x1 is
	component MUX1_4x1 is
		port (
			A, B, C, D, S1, S0 : in std_logic;
			y                  : out std_logic
		);
	end component;
begin
	MUXg4 : for i in 15 downto 0 generate
		mx : MUX1_4x1 port map(A => A(i), B => B(i), C => C(i), D => D(i), S0 => S0, S1 => S1, y => y(i));
	end generate MUXg4;
end architecture;
