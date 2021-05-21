library ieee;
use ieee.std_logic_1164.all;

entity FSM is
	port (
		instruction, T1, T2, T3, mem  : in std_logic_vector(15 downto 0);
		r, clk, init_carry, init_zero : in std_logic;
		w1, w2, w3, w4, w5, w6, w7,
		m1, m20, m21, m30, m31, m4, m50, m51, m60, m61, m70, m71, m8, m90, m91, m100, m101, mux,
		carry, zero, done, alucont, m12 : out std_logic);
end entity;

architecture Behave4 of FSM is

	type StateSymbol is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, sa);
	signal fsm_state_symbol : StateSymbol;
	-- constant Z32: std_logic_vector(31 downto 0) := (others => '0');

begin
	process (r, clk, instruction, init_carry, init_zero, T1, T2, T3, fsm_state_symbol)
		variable nq_var : StateSymbol;
		variable w1_var, w2_var, w3_var, w4_var, w5_var, w6_var, w7_var,
		m1_var, m20_var, m21_var, m30_var, m31_var, m4_var, m50_var, m51_var, m60_var, m61_var, m70_var, m71_var, m8_var, m90_var, m91_var, m100_var, m101_var,
		carry_var, zero_var, mux_var, done_var, alu_var, m12_var : std_logic;

	begin

		nq_var := fsm_state_symbol;
		w1_var := '1';
		w2_var := '1';
		w3_var := '1';
		w4_var := '1';
		w5_var := '1';
		w6_var := '1';
		w7_var := '1';
		m1_var := '0';
		m20_var := '1';
		m21_var := '0';
		m30_var := '0';
		m31_var := '0';
		m4_var := '0';
		m50_var := '0';
		m51_var := '0';
		m60_var := '0';
		m61_var := '0';
		m70_var := '0';
		m71_var := '0';
		m8_var := '0';
		m90_var := '0';
		m91_var := '0';
		m100_var := '0';
		m101_var := '0';
		carry_var := '1';
		zero_var := '1';
		mux_var := '0';
		done_var := '0';
		alu_var := '0';
		m12_var := '0';
		-- compute next-state, output
		case fsm_state_symbol is
			when s0 =>
				w3_var := '0';
				m20_var := '1';
				m21_var := '0';

				if (mem(15 downto 12) = "0011") then
					nq_var := s6;

				elsif (mem(15 downto 13) = "100") then
					nq_var := s16;

				elsif (mem(15 downto 12) = "1111") then
					nq_var := s0;

				else
					nq_var := s1;

				end if;

			when s1 =>
				w5_var := '0';
				w6_var := '0';
				w7_var := '0';
				m60_var := '1';
				m61_var := '0';
				m70_var := '1';
				m71_var := '0';
				m8_var := '0';
				if (instruction(15 downto 13) = "010") then
					nq_var := s7;
				elsif ((instruction(15 downto 12) = "0000" or instruction(15 downto 12) = "0010")
					and ((instruction(1 downto 0) = "10" and init_carry = '1') or (instruction(1 downto 0) = "01" and init_zero = '1') or (instruction(1 downto 0) = "00"))) then
					nq_var := s2;

				elsif (instruction(15 downto 12) = "0001") then
					nq_var := s4;

				elsif (instruction(15 downto 12) = "1100" and (T1 = T2)) then
					nq_var := s17;

				elsif (instruction(15 downto 12) = "0110") then
					nq_var := s11;

				elsif (instruction(15 downto 12) = "0111") then
					nq_var := s13;

				else
					nq_var := sa;

				end if;

			when s2 =>
				w5_var := '0';
				m90_var := '0';
				m91_var := '1';
				m100_var := '0';
				m101_var := '1';
				m60_var := '0';
				m61_var := '1';
				if (instruction(15 downto 12) = "0000") then
					carry_var := '0';
				end if;
				zero_var := '0';
				if (instruction(15 downto 12) = "0010") then
					alu_var := '1';
				else
					alu_var := '0';
				end if;
				nq_var := s3;
			when s3 =>
				w4_var := '0';
				m50_var := '1';
				m51_var := '1';
				m30_var := '0';
				m31_var := '1';

				nq_var := sa;
			when s4 =>
				w5_var := '0';
				m90_var := '1';
				m91_var := '0';
				m100_var := '0';
				m101_var := '1';
				m60_var := '0';
				m61_var := '1';
				carry_var := '0';
				zero_var := '0';

				nq_var := s5;
			when s5 =>
				w4_var := '0';
				m30_var := '1';
				m31_var := '0';
				m50_var := '1';
				m51_var := '1';

				nq_var := sa;
			when s6 =>
				w4_var := '0';
				m30_var := '0';
				m31_var := '0';
				m50_var := '1';
				m51_var := '0';

				nq_var := sa;
			when s7 =>
				w6_var := '0';
				m90_var := '1';
				m91_var := '0';
				m100_var := '1';
				m101_var := '1';
				m70_var := '0';
				m71_var := '1';

				if (instruction(15 downto 12) = "0100") then
					nq_var := s8;

				else
					-- sb7 : 0101
					nq_var := s9;

				end if;

			when s8 =>
				w5_var := '0';
				m20_var := '0';
				m21_var := '0';
				m60_var := '0';

				m61_var := '0';
				zero_var := '0';
				mux_var := '1';

				nq_var := s10;

			when s9 =>
				w2_var := '0';
				m20_var := '0';
				m21_var := '0';

				nq_var := sa;
			when s10 =>
				w4_var := '0';
				m30_var := '0';
				m31_var := '0';
				m50_var := '1';
				m51_var := '1';

				nq_var := sa;
			when s11 =>
				-- change made here t1->mema
				w6_var := '0';
				w7_var := '0';
				m90_var := '1';
				m91_var := '1';
				m100_var := '0';
				m101_var := '1';
				m20_var := '1';
				m21_var := '1';
				m70_var := '1';
				m71_var := '1';
				m8_var := '1';
				nq_var := s12;
			when s12 =>
				w4_var := '0';
				w5_var := '0';
				m90_var := '1';
				m91_var := '1';
				m100_var := '0';
				m101_var := '0';
				m30_var := '1';
				m31_var := '1';
				m50_var := '0';
				m51_var := '1';
				m60_var := '0';
				m61_var := '1';

				if (T3(2 downto 0) = "111") then
					nq_var := sa;

				else
					nq_var := s11;

				end if;

			when s13 =>
				w6_var := '0';
				w5_var := '0';
				m90_var := '1';
				m91_var := '1';
				m100_var := '0';
				m101_var := '0';
				m60_var := '0';
				m61_var := '1';
				m70_var := '0';
				m71_var := '0';
				m4_var := '1';

				nq_var := s14;

			when s14 =>
				-- changes made
				w2_var := '0';
				w7_var := '0';
				m90_var := '1';
				m91_var := '1';
				m100_var := '0';
				m101_var := '1';
				m20_var := '1';
				m21_var := '1';
				m8_var := '1';
				m12_var := '1';
				if (T3(2 downto 0) = "000") then
					nq_var := sa;

				else
					nq_var := s13;

				end if;

			when s15 =>
				w1_var := '0';
				m90_var := '0';
				m91_var := '0';
				m100_var := '1';
				m101_var := '0';
				m1_var := '0';

				nq_var := s0;
				done_var := '1';

			when s16 =>
				w4_var := '0';
				w6_var := '0';
				m30_var := '0';
				m31_var := '0';
				m50_var := '0';
				m51_var := '0';
				m70_var := '1';
				m71_var := '0';

				if (instruction(15 downto 12) = "1000") then
					nq_var := s15;

				else
					-- opcode : 1001
					nq_var := s18;

				end if;

			when s17 =>
				w1_var := '0';
				m90_var := '1';
				m91_var := '0';
				m100_var := '1';
				m101_var := '0';
				m1_var := '0';

				nq_var := s0;
				done_var := '1';

			when s18 =>
				w1_var := '0';
				m1_var := '1';

				nq_var := s0;
				done_var := '1';

			when sa =>
				w1_var := '0';
				m90_var := '1';
				m91_var := '1';
				m100_var := '1';
				m101_var := '0';
				m1_var := '0';

				nq_var := s0;
				done_var := '1';

			when others => null;

		end case;
		-- y(k)

		w1 <= w1_var;
		w2 <= w2_var;
		w3 <= w3_var;
		w4 <= w4_var;
		w5 <= w5_var;
		w6 <= w6_var;
		w7 <= w7_var;
		m1 <= m1_var;
		m20 <= m20_var;
		m21 <= m21_var;
		m30 <= m30_var;
		m31 <= m31_var;
		m4 <= m4_var;
		m50 <= m50_var;
		m51 <= m51_var;
		m60 <= m60_var;
		m61 <= m61_var;
		m70 <= m70_var;
		m71 <= m71_var;
		m8 <= m8_var;
		m90 <= m90_var;
		m91 <= m91_var;
		m100 <= m100_var;
		m101 <= m101_var;
		carry <= carry_var;
		zero <= zero_var;
		mux <= mux_var;
		done <= done_var;
		alucont <= alu_var;
		m12 <= m12_var;
		-- q(k+1) = nq(k)
		if (rising_edge(clk)) then
			if (r = '1') then
				fsm_state_symbol <= s0;
			else
				fsm_state_symbol <= nq_var;
			end if;
		end if;

	end process;

end Behave4;
