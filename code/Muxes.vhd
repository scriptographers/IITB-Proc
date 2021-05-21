library ieee;
use ieee.std_logic_1164.all;

package Muxes is
	component Mux1_2_1 is
		port (
			A, B, S0 : in std_logic;
			y        : out std_logic);
	end component Mux1_2_1;

	component Mux1_4_1 is
		port (
			A, B, C, D, S1, S0 : in std_logic;
			y                  : out std_logic);
	end component Mux1_4_1;

	component Mux3_2_1 is
		port (
			A, B : in std_logic_vector(2 downto 0);
			S0   : in std_logic;
			y    : out std_logic_vector(2 downto 0));
	end component Mux3_2_1;

	component Mux3_4_1 is
		port (
			A, B, C, D : in std_logic_vector(2 downto 0);
			S1, S0     : in std_logic;
			y          : out std_logic_vector(2 downto 0));
	end component Mux3_4_1;

	component Mux16_2_1 is
		port (
			A, B : in std_logic_vector(15 downto 0);
			S0   : in std_logic;
			y    : out std_logic_vector(15 downto 0));
	end component Mux16_2_1;

	component Mux16_4_1 is
		port (
			A, B, C, D : in std_logic_vector(15 downto 0);
			S1, S0     : in std_logic;
			y          : out std_logic_vector(15 downto 0));
	end component Mux16_4_1;

end package Muxes;

-- Mux1_2_1
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Mux1_2_1 is
	port (
		A, B, S0 : in std_logic;
		y        : out std_logic);
end Mux1_2_1;

architecture arch of Mux1_2_1 is
begin
	y <= (A and not S0) or (B and S0);
end arch;

-- Mux1_4_1
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Mux1_4_1 is
	port (
		A, B, C, D, S1, S0 : in std_logic;
		y                  : out std_logic);
end Mux1_4_1;

architecture arch of Mux1_4_1 is
begin
	y <= (A and (not S1) and (not S0))
		or (B and (not S1) and (S0))
		or (C and (S1) and (not S0))
		or (D and (S1) and (S0));
end arch;

-- Mux3_2_1
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Mux3_2_1 is
	port (
		A, B : in std_logic_vector(2 downto 0);
		S0   : in std_logic;
		y    : out std_logic_vector(2 downto 0));
end Mux3_2_1;

architecture arch of Mux3_2_1 is
	component Mux1_2_1 is
		port (
			A, B, S0 : in std_logic;
			y        : out std_logic);
	end component;
begin
	muxg : for i in 2 downto 0 generate
		mx : Mux1_2_1 port map(A => A(i), B => B(i), S0 => S0, y => y(i));
	end generate muxg;
end arch;

-- Mux3_4_1
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Mux3_4_1 is
	port (
		A, B, C, D : in std_logic_vector(2 downto 0);
		S1, S0     : in std_logic;
		y          : out std_logic_vector(2 downto 0));
end Mux3_4_1;

architecture arch of Mux3_4_1 is
	component Mux1_4_1 is
		port (
			A, B, C, D, S1, S0 : in std_logic;
			y                  : out std_logic);
	end component;
begin
	muxg : for i in 2 downto 0 generate
		mx : Mux1_4_1 port map(A => A(i), B => B(i), C => C(i), D => D(i), S0 => S0, S1 => S1, y => y(i));
	end generate muxg;
end arch;

-- Mux16_2_1
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Mux16_2_1 is
	port (
		A, B : in std_logic_vector(15 downto 0);
		S0   : in std_logic;
		y    : out std_logic_vector(15 downto 0));
end Mux16_2_1;

architecture arch of Mux16_2_1 is
	component Mux1_2_1 is
		port (
			A, B, S0 : in std_logic;
			y        : out std_logic);
	end component;
begin
	muxg : for i in 15 downto 0 generate
		mx : Mux1_2_1 port map(A => A(i), B => B(i), S0 => S0, y => y(i));
	end generate muxg;
end arch;

-- Mux16_4_1
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Mux16_4_1 is
	port (
		A, B, C, D : in std_logic_vector(15 downto 0);
		S1, S0     : in std_logic;
		y          : out std_logic_vector(15 downto 0));
end Mux16_4_1;

architecture arch of Mux16_4_1 is
	component Mux1_4_1 is
		port (
			A, B, C, D, S1, S0 : in std_logic;
			y                  : out std_logic);
	end component;
begin
	muxg4 : for i in 15 downto 0 generate
		mx : Mux1_4_1 port map(A => A(i), B => B(i), C => C(i), D => D(i), S0 => S0, S1 => S1, y => y(i));
	end generate muxg4;
end arch;
