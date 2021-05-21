library ieee;
use ieee.std_logic_1164.all;

library work;
use work.MUXes.all;

entity iitb_proc is
	port (
		clk, reset : in std_logic;
		O          : out std_logic_vector(15 downto 0);
		Done       : out std_logic);
end entity;

architecture Form of iitb_proc is

	component Register_file is
		port (
			address1, address2, address3 : in std_logic_vector(2 downto 0);
			Reg_datain3                  : in std_logic_vector(15 downto 0);
			clk, Reg_wrbar               : in std_logic;
			Reg_dataout1, Reg_dataout2   : out std_logic_vector(15 downto 0));
	end component;

	component Register1 is
		port (
			Reg_datain     : in std_logic;
			clk, Reg_wrbar : in std_logic;
			Reg_dataout    : out std_logic);
	end component;

	component Register16 is
		port (
			Reg_datain     : in std_logic_vector(15 downto 0);
			clk, Reg_wrbar : in std_logic;
			Reg_dataout    : out std_logic_vector(15 downto 0));
	end component;

	component MUX1_2x1 is
		port (
			A, B, S0 : in std_logic;
			y        : out std_logic);
	end component;

	component MUX3_2x1 is
		port (
			A, B : in std_logic_vector(2 downto 0);
			S0   : in std_logic;
			y    : out std_logic_vector(2 downto 0));
	end component;

	component MUX3_4x1 is
		port (
			A, B, C, D : in std_logic_vector(2 downto 0);
			S1, S0     : in std_logic;
			y          : out std_logic_vector(2 downto 0));
	end component;

	component MUX16_2x1 is
		port (
			A, B : in std_logic_vector(15 downto 0);
			S0   : in std_logic;
			y    : out std_logic_vector(15 downto 0));
	end component;

	component MUX16_4x1 is
		port (
			A, B, C, D : in std_logic_vector(15 downto 0);
			S1, S0     : in std_logic;
			y          : out std_logic_vector(15 downto 0));
	end component;

	component ALU is
		port (
			a, b    : in std_logic_vector(15 downto 0);
			op      : in std_logic;
			c       : out std_logic_vector(15 downto 0);
			z, cout : out std_logic
		);
	end component;

	component Memory_asyncread_syncwrite is
		port (
			address, Mem_datain : in std_logic_vector(15 downto 0);
			clk, Mem_wrbar      : in std_logic;
			Mem_dataout         : out std_logic_vector(15 downto 0));
	end component;

	component FSM is
		port (
			instruction, T1, T2, T3, mem  : in std_logic_vector(15 downto 0);
			r, clk, init_carry, init_zero : in std_logic;
			w1, w2, w3, w4, w5, w6, w7,
			m1, m20, m21, m30, m31, m4, m50, m51, m60, m61, m70, m71, m8, m90, m91, m100, m101, mux,
			carry, zero, done, alucont, m12 : out std_logic);
	end component;

	signal PC_out, IR_out, ALU_a, ALU_b, ALU_c, T1_out, T2_out, T3_out, Mem_out, D1_out, D2_out,
	M1_out, M2_out, M5_out, M6_out, M7_out, M8_out, M12_out, Imm9e16, SEImm9, SEImm6 : std_logic_vector(15 downto 0);

	signal M4_out, M3_out : std_logic_vector(2 downto 0);

	signal W1, W2, W3, W4, W5, W7, W6,
	M1, M21, M20, M4, M30, M31, M50, M51, M8, M70, M71, M61, M60, M91, M90, M100, M101, M12,
	Z_out, C_out, WC, Cr_out, T1_zero, mux, M11_out, WZ, Zr_out, alu_control : std_logic;

	signal temp1 : std_logic_vector(9 downto 0);

	signal temp2 : std_logic_vector(6 downto 0);

	constant Z16 : std_logic_vector(15 downto 0) := (others => '0');

	constant O16 : std_logic_vector(15 downto 0) := (0 => '1', others => '0');

begin

	FSM_en : FSM
	port map(
		-- in
		instruction => IR_out, T1 => M8_out, T2 => M7_out, T3 => T3_out,
		r => reset, clk => clk, init_carry => Cr_out, init_zero => Zr_out,
		-- out
		w1 => W1, w2 => W2, w3 => W3, w4 => W4, w5 => W5, w6 => W6, w7 => W7,
		m1 => M1, m20 => M20, m21 => M21, m30 => M30, m31 => M31, m4 => M4,
		m50 => M50, m51 => M51, m8 => M8, m70 => M70, m71 => M71, m61 => M61, m60 => M60,
		m91 => M91, m90 => M90, m100 => M100, m101 => M101, mux => mux, carry => WC,
		zero => WZ, done => Done, alucont => alu_control, mem => Mem_out, m12 => M12
	);

	MUX1 : MUX16_2x1
	port map(
		-- in
		A => ALU_c, B => T2_out,
		-- select
		S0 => M1,
		-- out
		y => M1_out
	);

	PC : Register16
	port map(
		-- in
		Reg_datain => M1_out, clk => clk,
		-- control pin
		Reg_wrbar => W1,
		-- out
		Reg_dataout => PC_out
	);

	MUX2 : MUX16_4x1
	port map(
		-- in
		A => T2_out, B => PC_out, C => ALU_c, D => T1_out,
		-- select
		S1 => M21, S0 => M20,
		-- out
		y => M2_out
	);

	Mem1 : Memory_asyncread_syncwrite
	port map(
		-- in
		address => M2_out, Mem_datain => M12_out, clk => clk,
		-- control pin
		Mem_wrbar => W2,
		-- out
		Mem_dataout => Mem_out
	);

	IR : Register16
	port map(
		-- in
		Reg_datain => Mem_out, clk => clk,
		-- control pin
		Reg_wrbar => W3,
		--out
		Reg_dataout => IR_out
	);

	MUX4 : MUX3_2x1
	port map(
		-- in
		A => IR_out(11 downto 9), B => T3_out(2 downto 0),
		-- select
		S0 => M4,
		-- out
		y => M4_out
	);

	MUX3 : MUX3_4x1
	port map(
		-- in
		A => IR_out(11 downto 9), B => IR_out(8 downto 6),
		C => IR_out(5 downto 3), D => T3_out(2 downto 0),
		-- select
		S1 => M31, S0 => M30,
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
		A => PC_out, B => Imm9e16, C => T2_out, D => T3_out,
		-- select
		S1 => M51, S0 => M50,
		-- out
		y => M5_out
	);

	Rf : Register_file
	port map(
		-- in
		address1 => M4_out, address2 => IR_out(8 downto 6), address3 => M3_out,
		Reg_datain3 => M5_out, clk => clk,
		-- control pin
		Reg_wrbar => W4,
		-- out
		Reg_dataout1 => D1_out, Reg_dataout2 => D2_out
	);

	MUX8 : MUX16_2x1
	port map(
		-- in
		A => D1_out, B => ALU_c,
		-- select
		S0 => M8,
		-- out
		y => M8_out
	);

	MUX7 : MUX16_4x1
	port map(
		-- in
		A => D1_out, B => D2_out, C => ALU_c, D => Mem_out,
		-- select
		S0 => M70, S1 => M71,
		--out
		y => M7_out
	);

	MUX6 : MUX16_4x1
	port map(
		-- in
		A => Mem_out, B => Z16, C => ALU_c, D => Z16,
		-- select
		S1 => M61, S0 => M60,
		--out
		y => M6_out
	);

	T1_reg : Register16
	port map(
		-- in
		Reg_datain => M8_out, clk => clk,
		-- control pin
		Reg_wrbar => W7,
		--out
		Reg_dataout => T1_out
	);

	T2_reg : Register16
	port map(
		-- in
		Reg_datain => M7_out, clk => clk,
		-- control pin
		Reg_wrbar => W6,
		--out
		Reg_dataout => T2_out
	);

	T3_reg : Register16
	port map(
		-- in
		Reg_datain => M6_out, clk => clk,
		-- control pin
		Reg_wrbar => W5,
		-- out
		Reg_dataout => T3_out
	);

	MUX9 : MUX16_4x1
	port map(
		-- in
		A => SEImm9, B => SEImm6, C => T2_out, D => O16,
		-- select
		S1 => M91, S0 => M90,
		-- out
		y => ALU_b
	);

	MUX10 : MUX16_4x1
	port map(
		-- in
		A => T3_out, B => PC_out, C => T1_out, D => T2_out,
		-- select
		S1 => M101, S0 => M100,
		-- out
		y => ALU_a
	);

	ALU_en : ALU
	port map(
		-- in
		a => ALU_a, b => ALU_b,
		-- control pin
		op => alu_control,
		-- out
		c => ALU_c,
		--out flags
		z => Z_out, cout => C_out
	);

	C : Register1
	port map(
		-- in
		Reg_datain => C_out, clk => clk,
		-- control pin
		Reg_wrbar => WC,
		-- out
		Reg_dataout => Cr_out
	);

	T1_zero <= not(T1_out(0) or T1_out(1) or T1_out(2) or T1_out(3) or T1_out(4) or T1_out(5) or T1_out(6) or T1_out(7)
		or T1_out(8) or T1_out(9) or T1_out(10) or T1_out(11) or T1_out(12) or T1_out(13) or T1_out(14) or T1_out(15));

	MUX11 : MUX1_2x1
	port map(
		-- in
		A => Z_out, B => T1_zero,
		-- select
		S0 => mux,
		-- out
		y => M11_out
	);

	Z : Register1
	port map(
		-- in
		Reg_datain => M11_out, clk => clk,
		-- control pin
		Reg_wrbar => WZ,
		--out
		Reg_dataout => Zr_out
	);

	MUX12 : MUX16_2x1
	port map(
		-- in
		A => T1_out, B => T2_out,
		-- select
		S0 => M12,
		--out
		y => M12_out
	);

	O <= Mem_out;

end Form;
