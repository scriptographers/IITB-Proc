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

	signal tm1out, tpcout, tt2out, taluc, tt1out, tm2out, tmemout, tirout, tt3out,
	Imm9e16, tm5out, tD1out, tD2out, tm8out, tm7out, tm12out, tm6out, seImm9, seImm6,
	talub, talua : std_logic_vector(15 downto 0);

	signal tm4out, tm3out : std_logic_vector(2 downto 0);

	signal tw1, tw2, tw3, tw4, tw7, tw6, tw5, tm1, tm21, tm20, tm4, tm30, tm31, tm50, tm51, tm8, tm70, tm71,
	tm61, tm60, tm91, tm90, tm100, tm101, tm12, tZout, tCout, twc, tCrout,
	tt1zero, tmux, tm11out, twz, tZrout, talucon : std_logic;

	signal temp1 : std_logic_vector(9 downto 0);

	signal temp2 : std_logic_vector(6 downto 0);

	constant Z16 : std_logic_vector(15 downto 0) := (others => '0');

	constant O16 : std_logic_vector(15 downto 0) := (0 => '1', others => '0');

begin

	fsm1 : FSM
	port map(
		instruction => tirout, T1 => tm8out, T2 => tm7out, T3 => tt3out, r => reset, clk => clk,
		init_carry => tCrout, init_zero => tZrout,
		w1 => tw1, w2 => tw2, w3 => tw3, w4 => tw4, w5 => tw5, w6 => tw6, w7 => tw7,
		m1 => tm1, m20 => tm20, m21 => tm21, m30 => tm30, m31 => tm31, m4 => tm4, m50 => tm50,
		m51 => tm51,
		m8 => tm8, m70 => tm70, m71 => tm71, m61 => tm61, m60 => tm60, m91 => tm91, m90 => tm90,
		m100 => tm100, m101 => tm101, mux => tmux, carry => twc,
		zero => twz, done => Done, alucont => talucon, mem => tmemout, m12 => tm12);

	m1 : Mux16_2_1
	port map(A => taluc, B => tt2out, S0 => tm1, y => tm1out);

	PC : Register16
	port map(Reg_datain => tm1out, clk => clk, Reg_wrbar => tw1, Reg_dataout => tpcout);

	m2 : Mux16_4_1
	port map(A => tt2out, B => tpcout, C => taluc, D => tt1out, S1 => tm21, S0 => tm20, y => tm2out);

	Mem1 : Memory_asyncread_syncwrite port map(
		address => tm2out, Mem_datain => tm12out, Mem_dataout => tmemout,
		clk => clk, Mem_wrbar => tw2);

	IR : Register16
	port map(Reg_datain => tmemout, clk => clk, Reg_wrbar => tw3, Reg_dataout => tirout);

	m4 : Mux3_2_1
	port map(A => tirout(11 downto 9), B => tt3out(2 downto 0), S0 => tm4, y => tm4out);

	m3 : Mux3_4_1
	port map(
		A => tirout(11 downto 9), B => tirout(8 downto 6), C => tirout(5 downto 3),
		D => tt3out(2 downto 0), S1 => tm31, S0 => tm30, y => tm3out);

	Imm9e16 <= tirout(8 downto 0) & "0000000";

	temp1 <= (others => tirout(5));

	seImm6 <= temp1 & tirout(5 downto 0);

	temp2 <= (others => tirout(8));

	seImm9 <= temp2 & tirout(8 downto 0);

	m5 : Mux16_4_1
	port map(
		A => tpcout, B => Imm9e16, C => tt2out, D => tt3out,
		S1 => tm51, S0 => tm50, y => tm5out);

	Rf : Register_file
	port map(
		address1 => tm4out, address2 => tirout(8 downto 6), address3 => tm3out,
		Reg_datain3 => tm5out, clk => clk, Reg_wrbar => tw4,
		Reg_dataout1 => tD1out, Reg_dataout2 => tD2out);

	m8 : Mux16_2_1
	port map(A => tD1out, B => taluc, S0 => tm8, y => tm8out);

	m7 : Mux16_4_1
	port map(A => tD1out, B => tD2out, C => taluc, D => tmemout, S0 => tm70, S1 => tm71, y => tm7out);

	m6 : Mux16_4_1
	port map(A => tmemout, B => Z16, C => taluc, D => Z16, S1 => tm61, S0 => tm60, y => tm6out);

	T1 : Register16
	port map(Reg_datain => tm8out, clk => clk, Reg_wrbar => tw7, Reg_dataout => tt1out);

	T2 : Register16
	port map(Reg_datain => tm7out, clk => clk, Reg_wrbar => tw6, Reg_dataout => tt2out);

	T3 : Register16
	port map(Reg_datain => tm6out, clk => clk, Reg_wrbar => tw5, Reg_dataout => tt3out);

	m9 : Mux16_4_1
	port map(A => seImm9, B => seImm6, C => tt2out, D => O16, S1 => tm91, S0 => tm90, y => talub);

	m10 : Mux16_4_1
	port map(A => tt3out, B => tpcout, C => tt1out, D => tt2out, S1 => tm101, S0 => tm100, y => talua);

	alu1 : alu
	port map(A => talua, B => talub, C => taluc, op => talucon, Z => tZout, Cout => tCout);

	C : Register1
	port map(Reg_datain => tCout, clk => clk, Reg_wrbar => twc, Reg_dataout => tCrout);

	tt1zero <= not(tt1out(0) or tt1out(1) or tt1out(2) or tt1out(3) or tt1out(4) or tt1out(5) or tt1out(6) or tt1out(7) or tt1out(8)
		or tt1out(9) or tt1out(10) or tt1out(11) or tt1out(12) or tt1out(13) or tt1out(14) or tt1out(15));

	m11 : Mux1_2_1
	port map(A => tZout, B => tt1zero, S0 => tmux, y => tm11out);

	Z : Register1
	port map(Reg_datain => tm11out, clk => clk, Reg_wrbar => twz, Reg_dataout => tZrout);

	O <= tmemout;

	m12 : Mux16_2_1
	port map(A => tt1out, B => tt2out, S0 => tm12, y => tm12out);

end Form;
