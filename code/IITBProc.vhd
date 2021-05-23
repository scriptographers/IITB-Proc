-- Top Level Entity
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity IITBProc is
	port (
		clk, reset : in std_logic;
		PC, IR     : out std_logic_vector(15 downto 0);
		done       : out std_logic;
		Cr, Zr     : out std_logic;
		reg0, reg1, reg2, reg3,
		reg4, reg5, reg6, reg7 : out std_logic_vector(15 downto 0)
	);
end entity;

architecture arch of IITBProc is

	component RegisterFile is
		port (
			clk, write_flag        : in std_logic;
			addr1, addr2, addr3    : in std_logic_vector(2 downto 0);
			data_write3            : in std_logic_vector(15 downto 0);
			data_read1, data_read2 : out std_logic_vector(15 downto 0);
			reg0, reg1, reg2, reg3,
			reg4, reg5, reg6, reg7 : out std_logic_vector(15 downto 0)
		);
	end component;

	component OneBitRegister is
		port (
			clk, write_flag, data_write : in std_logic;
			data_read                   : out std_logic
		);
	end component;

	component SixteenBitRegister is
		port (
			data_write      : in std_logic_vector(15 downto 0);
			clk, write_flag : in std_logic;
			data_read       : out std_logic_vector(15 downto 0));
	end component;

	component MUX1_2x1 is
		port (
			a, b, s0 : in std_logic;
			y        : out std_logic);
	end component;

	component MUX3_2x1 is
		port (
			a, b : in std_logic_vector(2 downto 0);
			s0   : in std_logic;
			y    : out std_logic_vector(2 downto 0));
	end component;

	component MUX3_4x1 is
		port (
			a, b, c, d : in std_logic_vector(2 downto 0);
			s1, s0     : in std_logic;
			y          : out std_logic_vector(2 downto 0));
	end component;

	component MUX16_2x1 is
		port (
			a, b : in std_logic_vector(15 downto 0);
			s0   : in std_logic;
			y    : out std_logic_vector(15 downto 0));
	end component;

	component MUX16_4x1 is
		port (
			a, b, c, d : in std_logic_vector(15 downto 0);
			s1, s0     : in std_logic;
			y          : out std_logic_vector(15 downto 0));
	end component;

	component ALU is
		port (
			a, b       : in std_logic_vector(15 downto 0);
			op         : in std_logic;
			output     : out std_logic_vector(15 downto 0);
			zero, cout : out std_logic
		);
	end component;

	component Memory is
		port (
			addr, data_write : in std_logic_vector(15 downto 0);
			clk, write_flag  : in std_logic;
			data_read        : out std_logic_vector(15 downto 0));
	end component;

	component FSM is
		port (
			instruction, T1, T2, T3, mem    : in std_logic_vector(15 downto 0);
			rst, clk, init_carry, init_zero : in std_logic;
			W1, W2, W3, W4, W5, W6, W7,
			M1, M20, M21, M30, M31, M4, M50, M51, M60, M61,
			M70, M71, M8, M90, M91, M100, M101, M11, M12,
			carry_write, zero_write, done, alu_control : out std_logic);
	end component;

	signal reg0_out, reg1_out, reg2_out, reg3_out, reg4_out, reg5_out, reg6_out, reg7_out : std_logic_vector(15 downto 0);

	signal PC_out, IR_out, ALU_a, ALU_b, ALU_c, T1_out, T2_out, T3_out, Mem_out, D1_out, D2_out,
	M1_out, M2_out, M5_out, M6_out, M7_out, M8_out, M12_out, Imm9e16, SEImm9, SEImm6 : std_logic_vector(15 downto 0);

	signal M4_out, M3_out : std_logic_vector(2 downto 0);

	signal W1, W2, W3, W4, W5, W7, W6,
	M1, M21, M20, M4, M30, M31, M50, M51, M60, M61, M70, M71, M8, M90, M91, M100, M101, M12,
	Z_out, C_out, WC, WZ, Cr_out, Zr_out, T1_zero, M11, M11_out, alu_control : std_logic;

	signal temp1 : std_logic_vector(9 downto 0);
	signal temp2 : std_logic_vector(6 downto 0);

	constant Z16 : std_logic_vector(15 downto 0) := (others => '0');
	constant O16 : std_logic_vector(15 downto 0) := (0 => '1', others => '0');

begin

	FSM_R : FSM
	port map(
		-- in
		instruction => IR_out, T1 => M8_out, T2 => M7_out, T3 => T3_out, mem => Mem_out,
		rst => reset, clk => clk, init_carry => Cr_out, init_zero => Zr_out,
		-- out
		W1 => W1, W2 => W2, W3 => W3, W4 => W4, W5 => W5, W6 => W6, W7 => W7,
		M1 => M1, M20 => M20, M21 => M21, M30 => M30, M31 => M31, M4 => M4,
		M50 => M50, M51 => M51, M60 => M60, M61 => M61, M70 => M70, M71 => M71, M8 => M8,
		M90 => M90, M91 => M91, M100 => M100, M101 => M101, M11 => M11, M12 => M12,
		carry_write => WC, zero_write => WZ, done => done, alu_control => alu_control
	);

	MUX1 : MUX16_2x1
	port map(
		-- in
		a => ALU_c, b => T2_out,
		-- select
		s0 => M1,
		-- out
		y => M1_out
	);

	PC_R : SixteenBitRegister
	port map(
		-- in
		data_write => M1_out, clk => clk,
		-- control pin
		write_flag => W1,
		-- out
		data_read => PC_out
	);

	MUX2 : MUX16_4x1
	port map(
		-- in
		a => T2_out, b => PC_out, c => ALU_c, d => T1_out,
		-- select
		s1 => M21, s0 => M20,
		-- out
		y => M2_out
	);

	Mem1 : Memory
	port map(
		-- in
		addr => M2_out, data_write => M12_out, clk => clk,
		-- control pin
		write_flag => W2,
		-- out
		data_read => Mem_out
	);

	IR_R : SixteenBitRegister
	port map(
		-- in
		data_write => Mem_out, clk => clk,
		-- control pin
		write_flag => W3,
		--out
		data_read => IR_out
	);

	MUX4 : MUX3_2x1
	port map(
		-- in
		a => IR_out(11 downto 9), b => T3_out(2 downto 0),
		-- select
		s0 => M4,
		-- out
		y => M4_out
	);

	MUX3 : MUX3_4x1
	port map(
		-- in
		a => IR_out(11 downto 9), b => IR_out(8 downto 6),
		c => IR_out(5 downto 3), d => T3_out(2 downto 0),
		-- select
		s1 => M31, s0 => M30,
		-- out
		y => M3_out
	);

	Imm9e16 <= IR_out(8 downto 0) & "0000000";

	temp1 <= (others => IR_out(5));

	SEImm6 <= temp1 & IR_out(5 downto 0);

	temp2 <= (others => IR_out(8));

	SEImm9 <= temp2 & IR_out(8 downto 0);

	MUX5 : MUX16_4x1
	port map(
		-- in
		a => PC_out, b => Imm9e16, c => T2_out, d => T3_out,
		-- select
		s1 => M51, s0 => M50,
		-- out
		y => M5_out
	);

	Rf : RegisterFile
	port map(
		-- in
		addr1 => M4_out, addr2 => IR_out(8 downto 6), addr3 => M3_out,
		data_write3 => M5_out, clk => clk,
		-- control pin
		write_flag => W4,
		-- out
		data_read1 => D1_out, data_read2 => D2_out,
		reg0 => reg0_out, reg1 => reg1_out, reg2 => reg2_out, reg3 => reg3_out,
		reg4 => reg4_out, reg5 => reg5_out, reg6 => reg6_out, reg7 => reg7_out
	);

	MUX8 : MUX16_2x1
	port map(
		-- in
		a => D1_out, b => ALU_c,
		-- select
		s0 => M8,
		-- out
		y => M8_out
	);

	MUX7 : MUX16_4x1
	port map(
		-- in
		a => D1_out, b => D2_out, c => ALU_c, d => Mem_out,
		-- select
		s0 => M70, s1 => M71,
		--out
		y => M7_out
	);

	MUX6 : MUX16_4x1
	port map(
		-- in
		a => Mem_out, b => Z16, c => ALU_c, d => Z16,
		-- select
		s1 => M61, s0 => M60,
		--out
		y => M6_out
	);

	T1_reg : SixteenBitRegister
	port map(
		-- in
		data_write => M8_out, clk => clk,
		-- control pin
		write_flag => W7,
		--out
		data_read => T1_out
	);

	T2_reg : SixteenBitRegister
	port map(
		-- in
		data_write => M7_out, clk => clk,
		-- control pin
		write_flag => W6,
		--out
		data_read => T2_out
	);

	T3_reg : SixteenBitRegister
	port map(
		-- in
		data_write => M6_out, clk => clk,
		-- control pin
		write_flag => W5,
		-- out
		data_read => T3_out
	);

	MUX9 : MUX16_4x1
	port map(
		-- in
		a => SEImm9, b => SEImm6, c => T2_out, d => O16,
		-- select
		s1 => M91, s0 => M90,
		-- out
		y => ALU_b
	);

	MUX10 : MUX16_4x1
	port map(
		-- in
		a => T3_out, b => PC_out, c => T1_out, d => T2_out,
		-- select
		s1 => M101, s0 => M100,
		-- out
		y => ALU_a
	);

	ALU_R : ALU
	port map(
		-- in
		a => ALU_a, b => ALU_b,
		-- control pin
		op => alu_control,
		-- out
		output => ALU_c,
		--out flags
		zero => Z_out, cout => C_out
	);

	C : OneBitRegister
	port map(
		-- in
		data_write => C_out,
		clk        => clk,
		-- control pin
		write_flag => WC,
		-- out
		data_read => Cr_out
	);

	T1_zero <= not(T1_out(0) or T1_out(1) or T1_out(2) or T1_out(3) or T1_out(4) or T1_out(5) or T1_out(6) or T1_out(7)
		or T1_out(8) or T1_out(9) or T1_out(10) or T1_out(11) or T1_out(12) or T1_out(13) or T1_out(14) or T1_out(15));

	MUX11 : MUX1_2x1
	port map(
		-- in
		a => Z_out, b => T1_zero,
		-- select
		s0 => M11,
		-- out
		y => M11_out
	);

	Z : OneBitRegister
	port map(
		-- in
		data_write => M11_out,
		clk        => clk,
		-- control pin
		write_flag => WZ,
		--out
		data_read => Zr_out
	);

	MUX12 : MUX16_2x1
	port map(
		-- in
		a => T1_out, b => T2_out,
		-- select
		s0 => M12,
		--out
		y => M12_out
	);

	PC <= PC_out;
	IR <= IR_out;
	Cr <= Cr_out;
	Zr <= Zr_out;
	reg0 <= reg0_out;
	reg1 <= reg1_out;
	reg2 <= reg2_out;
	reg3 <= reg3_out;
	reg4 <= reg4_out;
	reg5 <= reg5_out;
	reg6 <= reg6_out;
	reg7 <= reg7_out;

end architecture;
