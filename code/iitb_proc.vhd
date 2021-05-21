library ieee;
use ieee.std_logic_1164.all;

library work;
use work.Muxes.all;

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

	component Mux1_2_1 is
		port (
			A, B, S0 : in std_logic;
			y        : out std_logic);
	end component;

	component Mux3_2_1 is
		port (
			A, B : in std_logic_vector(2 downto 0);
			S0   : in std_logic;
			y    : out std_logic_vector(2 downto 0));
	end component;

	component Mux3_4_1 is
		port (
			A, B, C, D : in std_logic_vector(2 downto 0);
			S1, S0     : in std_logic;
			y          : out std_logic_vector(2 downto 0));
	end component;

	component Mux16_2_1 is
		port (
			A, B : in std_logic_vector(15 downto 0);
			S0   : in std_logic;
			y    : out std_logic_vector(15 downto 0));
	end component;

	component Mux16_4_1 is
		port (
			A, B, C, D : in std_logic_vector(15 downto 0);
			S1, S0     : in std_logic;
			y          : out std_logic_vector(15 downto 0));
	end component;

	component alu is
		port (
			A, B    : in std_logic_vector(15 downto 0);
			op      : in std_logic;
			C       : out std_logic_vector(15 downto 0);
			Z, Cout : out std_logic);
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
		m50 => M50, m51 => M51,	m8 => M8, m70 => M70, m71 => M71, m61 => M61, m60 => M60,
		m91 => M91, m90 => M90,	m100 => M100, m101 => M101, mux => Mux, carry => WC,
		zero => WZ, done => Done, alucont => alu_control, mem => memout, m12 => M12
	);

	Mux1 : Mux16_2_1
	port map(
		-- in
		A => alu_c, B => t2out, S0 => M1,
		-- out
		y => m1out
	);

	PC : Register16
	port map(
		Reg_datain => m1out, clk => clk, Reg_wrbar => W1, Reg_dataout => pcout
	);

	Mux2 : Mux16_4_1
	port map(
		A => t2out, B => pcout, C => alu_c, D => t1out, S1 => M21, S0 => M20, y => m2out
	);

	Mem1 : Memory_asyncread_syncwrite
	port map(
		address => m2out, Mem_datain => m12out, Mem_dataout => memout,
		clk => clk, Mem_wrbar => W2);

	IR : Register16
	port map(
		Reg_datain => memout, clk => clk, Reg_wrbar => W3, Reg_dataout => irout
	);

	Mux4 : Mux3_2_1
	port map(
		A => irout(11 downto 9), B => t3out(2 downto 0), S0 => M4, y => tm4out
	);

	Mux3 : Mux3_4_1
	port map(
		A => irout(11 downto 9), B => irout(8 downto 6), C => irout(5 downto 3),
		D => t3out(2 downto 0), S1 => M31, S0 => M30, y => tm3out
	);

	Imm9e16 <= irout(8 downto 0) & "0000000";

	temp1 <= (others => irout(5));

	seImm6 <= temp1 & irout(5 downto 0);

	temp2 <= (others => irout(8));

	seImm9 <= temp2 & irout(8 downto 0);

	Mux5 : Mux16_4_1
	port map(
		A => pcout, B => Imm9e16, C => t2out, D => t3out,
		S1 => M51, S0 => M50, y => m5out);

	Rf : Register_file
	port map(
		address1 => tm4out, address2 => irout(8 downto 6), address3 => tm3out,
		Reg_datain3 => m5out, clk => clk, Reg_wrbar => W4,
		Reg_dataout1 => D1out, Reg_dataout2 => D2out
	);

	Mux8 : Mux16_2_1
	port map(
		A => D1out, B => alu_c, S0 => M8, y => m8out
	);

	Mux7 : Mux16_4_1
	port map(
		A => D1out, B => D2out, C => alu_c, D => memout, S0 => M70, S1 => M71, y => m7out
	);

	Mux6 : Mux16_4_1
	port map(
		A => memout, B => Z16, C => alu_c, D => Z16, S1 => M61, S0 => M60, y => m6out
	);

	T1_reg : Register16
	port map(
		Reg_datain => m8out, clk => clk, Reg_wrbar => W7, Reg_dataout => t1out
	);

	T2_reg : Register16
	port map(
		Reg_datain => m7out, clk => clk, Reg_wrbar => W6, Reg_dataout => t2out
	);

	T3_reg : Register16
	port map(
		Reg_datain => m6out, clk => clk, Reg_wrbar => W5, Reg_dataout => t3out
	);

	Mux9 : Mux16_4_1
	port map(
		A => seImm9, B => seImm6, C => t2out, D => O16, S1 => M91, S0 => M90, y => alu_b
	);

	Mux10 : Mux16_4_1
	port map(
		A => t3out, B => pcout, C => t1out, D => t2out, S1 => M101, S0 => M100, y => alu_a
	);

	ALU_en : alu
	port map(
		A => alu_a, B => alu_b, C => alu_c, op => alu_control, Z => Z_out, Cout => C_out
	);

	C : Register1
	port map(
		Reg_datain => C_out, clk => clk, Reg_wrbar => WC, Reg_dataout => Cr_out
	);

	T1_zero <= not(t1out(0) or t1out(1) or t1out(2) or t1out(3) or t1out(4) or t1out(5) or t1out(6) or t1out(7)
		or t1out(8) or t1out(9) or t1out(10) or t1out(11) or t1out(12) or t1out(13) or t1out(14) or t1out(15));

	Mux11 : Mux1_2_1
	port map(
		A => Z_out, B => T1_zero, S0 => Mux, y => M11_out
	);

	Z : Register1
	port map(
		Reg_datain => M11_out, clk => clk, Reg_wrbar => WZ, Reg_dataout => Zr_out
	);

	Mux12 : Mux16_2_1
	port map(
		A => t1out, B => t2out, S0 => M12, y => m12out
	);

	O <= memout;

end Form;
