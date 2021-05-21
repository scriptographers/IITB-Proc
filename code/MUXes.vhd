library ieee;
use ieee.std_logic_1164.all;

package MUXes is
	component MUX1_2x1 is
		port (
			A, B, S0 : in std_logic;
			y        : out std_logic);
	end component MUX1_2x1;

	component MUX1_4x1 is
		port (
			A, B, C, D, S1, S0 : in std_logic;
			y                  : out std_logic);
	end component MUX1_4x1;

	component MUX3_2x1 is
		port (
			A, B : in std_logic_vector(2 downto 0);
			S0   : in std_logic;
			y    : out std_logic_vector(2 downto 0));
	end component MUX3_2x1;

	component MUX3_4x1 is
		port (
			A, B, C, D : in std_logic_vector(2 downto 0);
			S1, S0     : in std_logic;
			y          : out std_logic_vector(2 downto 0));
	end component MUX3_4x1;

	component MUX16_2x1 is
		port (
			A, B : in std_logic_vector(15 downto 0);
			S0   : in std_logic;
			y    : out std_logic_vector(15 downto 0));
	end component MUX16_2x1;

	component MUX16_4x1 is
		port (
			A, B, C, D : in std_logic_vector(15 downto 0);
			S1, S0     : in std_logic;
			y          : out std_logic_vector(15 downto 0));
	end component MUX16_4x1;

end package MUXes;

-- MUX1_2x1
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUX1_2x1 is
	port (
		A, B, S0 : in std_logic;
		y        : out std_logic);
end MUX1_2x1;

architecture arch of MUX1_2x1 is
begin
	y <= (A and not S0) or (B and S0);
end arch;

-- MUX1_4x1
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUX1_4x1 is
	port (
		A, B, C, D, S1, S0 : in std_logic;
		y                  : out std_logic);
end MUX1_4x1;

architecture arch of MUX1_4x1 is
begin
	y <= (A and (not S1) and (not S0))
		or (B and (not S1) and (S0))
		or (C and (S1) and (not S0))
		or (D and (S1) and (S0));
end arch;

-- MUX3_2x1
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUX3_2x1 is
	port (
		A, B : in std_logic_vector(2 downto 0);
		S0   : in std_logic;
		y    : out std_logic_vector(2 downto 0));
end MUX3_2x1;

architecture arch of MUX3_2x1 is
	component MUX1_2x1 is
		port (
			A, B, S0 : in std_logic;
			y        : out std_logic);
	end component;
begin
	MUXg : for i in 2 downto 0 generate
		mx : MUX1_2x1 port map(A => A(i), B => B(i), S0 => S0, y => y(i));
	end generate MUXg;
end arch;

-- MUX3_4x1
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUX3_4x1 is
	port (
		A, B, C, D : in std_logic_vector(2 downto 0);
		S1, S0     : in std_logic;
		y          : out std_logic_vector(2 downto 0));
end MUX3_4x1;

architecture arch of MUX3_4x1 is
	component MUX1_4x1 is
		port (
			A, B, C, D, S1, S0 : in std_logic;
			y                  : out std_logic);
	end component;
begin
	MUXg : for i in 2 downto 0 generate
		mx : MUX1_4x1 port map(A => A(i), B => B(i), C => C(i), D => D(i), S0 => S0, S1 => S1, y => y(i));
	end generate MUXg;
end arch;

-- MUX16_2x1
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUX16_2x1 is
	port (
		A, B : in std_logic_vector(15 downto 0);
		S0   : in std_logic;
		y    : out std_logic_vector(15 downto 0));
end MUX16_2x1;

architecture arch of MUX16_2x1 is
	component MUX1_2x1 is
		port (
			A, B, S0 : in std_logic;
			y        : out std_logic);
	end component;
begin
	MUXg : for i in 15 downto 0 generate
		mx : MUX1_2x1 port map(A => A(i), B => B(i), S0 => S0, y => y(i));
	end generate MUXg;
end arch;

-- MUX16_4x1
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUX16_4x1 is
	port (
		A, B, C, D : in std_logic_vector(15 downto 0);
		S1, S0     : in std_logic;
		y          : out std_logic_vector(15 downto 0));
end MUX16_4x1;

architecture arch of MUX16_4x1 is
	component MUX1_4x1 is
		port (
			A, B, C, D, S1, S0 : in std_logic;
			y                  : out std_logic);
	end component;
begin
	MUXg4 : for i in 15 downto 0 generate
		mx : MUX1_4x1 port map(A => A(i), B => B(i), C => C(i), D => D(i), S0 => S0, S1 => S1, y => y(i));
	end generate MUXg4;
end arch;
