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
			output  : out std_logic_vector(15 downto 0);
			zero, cout : out std_logic
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

	signal m1out, m2out, pcout, alu_a, alu_b, alu_c, t1out, t2out, t3out, memout, irout,
	Imm9e16, m5out, D1out, D2out, m8out, m7out, m12out, m6out, seImm9, seImm6 : std_logic_vector(15 downto 0);

	signal tm4out, tm3out : std_logic_vector(2 downto 0);

	signal W1, W2, W3, W4, W5, W7, W6,
	M1, M21, M20, M4, M30, M31, M50, M51, M8, M70, M71, M61, M60, M91, M90, M100, M101, M12,
	Z_out, C_out, WC, Cr_out, T1_zero, Mux, M11_out, WZ, Zr_out, alu_control : std_logic;

	signal temp1 : std_logic_vector(9 downto 0);

	signal temp2 : std_logic_vector(6 downto 0);

	constant Z16 : std_logic_vector(15 downto 0) := (others => '0');

	constant O16 : std_logic_vector(15 downto 0) := (0 => '1', others => '0');

begin

	fsm1 : FSM
	port map(
		-- in
		instruction => irout, T1 => m8out, T2 => m7out, T3 => t3out,
		r => reset, clk => clk, init_carry => Cr_out, init_zero => Zr_out,
		-- out
		w1 => W1, w2 => W2, w3 => W3, w4 => W4, w5 => W5, w6 => W6, w7 => W7,
		m1 => M1, m20 => M20, m21 => M21, m30 => M30, m31 => M31, m4 => M4,
		m50 => M50, m51 => M51, m8 => M8, m70 => M70, m71 => M71, m61 => M61, m60 => M60,
		m91 => M91, m90 => M90, m100 => M100, m101 => M101, mux => Mux, carry => WC,
		zero => WZ, done => Done, alucont => alu_control, mem => memout, m12 => M12
	);

	Mux1 : MUX16_2x1
	port map(
		-- in
		A => alu_c, B => t2out,
		-- select
		S0 => M1,
		-- out
		y => m1out
	);

	PC : Register16
	port map(
		-- in
		Reg_datain => m1out, clk => clk,
		-- control pin
		Reg_wrbar => W1,
		-- out
		Reg_dataout => pcout
	);

	Mux2 : MUX16_4x1
	port map(
		-- in
		A => t2out, B => pcout, C => alu_c, D => t1out,
		-- select
		S1 => M21, S0 => M20,
		-- out
		y => m2out
	);

	Mem1 : Memory_asyncread_syncwrite
	port map(
		-- in
		address => m2out, Mem_datain => m12out, clk => clk,
		-- control pin
		Mem_wrbar => W2,
		-- out
		Mem_dataout => memout
	);

	IR : Register16
	port map(
		-- in
		Reg_datain => memout, clk => clk,
		-- control pin
		Reg_wrbar => W3,
		--out
		Reg_dataout => irout
	);

	Mux4 : MUX3_2x1
	port map(
		-- in
		A => irout(11 downto 9), B => t3out(2 downto 0),
		-- select
		S0 => M4,
		-- out
		y => tm4out
	);

	Mux3 : MUX3_4x1
	port map(
		-- in
		A => irout(11 downto 9), B => irout(8 downto 6),
		C => irout(5 downto 3), D => t3out(2 downto 0),
		-- select
		S1 => M31, S0 => M30,
		-- out
		y => tm3out
	);

	Imm9e16 <= irout(8 downto 0) & "0000000";

	temp1 <= (others => irout(5));

	seImm6 <= temp1 & irout(5 downto 0);

	temp2 <= (others => irout(8));

	seImm9 <= temp2 & irout(8 downto 0);

	Mux5 : MUX16_4x1
	port map(
		-- in
		A => pcout, B => Imm9e16, C => t2out, D => t3out,
		-- select
		S1 => M51, S0 => M50,
		-- out
		y => m5out
	);

	Rf : Register_file
	port map(
		-- in
		address1 => tm4out, address2 => irout(8 downto 6), address3 => tm3out,
		Reg_datain3 => m5out, clk => clk,
		-- control pin
		Reg_wrbar => W4,
		-- out
		Reg_dataout1 => D1out, Reg_dataout2 => D2out
	);

	Mux8 : MUX16_2x1
	port map(
		-- in
		A => D1out, B => alu_c,
		-- select
		S0 => M8,
		-- out
		y => m8out
	);

	Mux7 : MUX16_4x1
	port map(
		-- in
		A => D1out, B => D2out, C => alu_c, D => memout,
		-- select
		S0 => M70, S1 => M71,
		--out
		y => m7out
	);

	Mux6 : MUX16_4x1
	port map(
		-- in
		A => memout, B => Z16, C => alu_c, D => Z16,
		-- select
		S1 => M61, S0 => M60,
		--out
		y => m6out
	);

	T1_reg : Register16
	port map(
		-- in
		Reg_datain => m8out, clk => clk,
		-- control pin
		Reg_wrbar => W7,
		--out
		Reg_dataout => t1out
	);

	T2_reg : Register16
	port map(
		-- in
		Reg_datain => m7out, clk => clk,
		-- control pin
		Reg_wrbar => W6,
		--out
		Reg_dataout => t2out
	);

	T3_reg : Register16
	port map(
		-- in
		Reg_datain => m6out, clk => clk,
		-- control pin
		Reg_wrbar => W5,
		-- out
		Reg_dataout => t3out
	);

	Mux9 : MUX16_4x1
	port map(
		-- in
		A => seImm9, B => seImm6, C => t2out, D => O16,
		-- select
		S1 => M91, S0 => M90,
		-- out
		y => alu_b
	);

	Mux10 : MUX16_4x1
	port map(
		-- in
		A => t3out, B => pcout, C => t1out, D => t2out,
		-- select
		S1 => M101, S0 => M100,
		-- out
		y => alu_a
	);

	ALU_en : ALU
	port map(
		-- in
		a => alu_a, b => alu_b,
		-- control pin
		op => alu_control,
		-- out
		output => alu_c,
		--out flags
		zero => Z_out, cout => C_out
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

	T1_zero <= not(t1out(0) or t1out(1) or t1out(2) or t1out(3) or t1out(4) or t1out(5) or t1out(6) or t1out(7)
		or t1out(8) or t1out(9) or t1out(10) or t1out(11) or t1out(12) or t1out(13) or t1out(14) or t1out(15));

	Mux11 : MUX1_2x1
	port map(
		-- in
		A => Z_out, B => T1_zero,
		-- select
		S0 => Mux,
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

	Mux12 : MUX16_2x1
	port map(
		-- in
		A => t1out, B => t2out,
		-- select
		S0 => M12,
		--out
		y => m12out
	);

	O <= memout;

end Form;
