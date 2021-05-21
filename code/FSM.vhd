-- Component: The Finite State Machine
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity FSM is
	port (
		instruction, T1, T2, T3, mem    : in std_logic_vector(15 downto 0);
		rst, clk, init_carry, init_zero : in std_logic;
		w1, w2, w3, w4, w5, w6, w7,
		m1, m20, m21, m30, m31, m4, m50, m51, m60, m61, m70, m71, m8, m90, m91, m100, m101, m12,
		carry, zero, mux, done, alucont : out std_logic);
end entity;

architecture struct of FSM is

	type StateSymbol is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, sa);
	signal fsm_state_symbol : StateSymbol;

begin
	process (rst, clk, instruction, init_carry, init_zero, T1, T2, T3, fsm_state_symbol)
		variable next_state : StateSymbol;
		variable W1_v, W2_v, W3_v, W4_v, W5_v, W6_v, W7_v,
		M1_v, M20_v, M21_v, M30_v, M31_v, M4_v, M50_v, M51_v, M60_v, M61_v,
		M70_v, M71_v, M8_v, M90_v, M91_v, M100_v, M101_v, M12_v,
		carry_v, zero_v, mux_v, done_v, alu_v : std_logic;

	begin

		next_state := fsm_state_symbol;
		W1_v := '1';
		W2_v := '1';
		W3_v := '1';
		W4_v := '1';
		W5_v := '1';
		W6_v := '1';
		W7_v := '1';
		M1_v := '0';
		M20_v := '1';
		M21_v := '0';
		M30_v := '0';
		M31_v := '0';
		M4_v := '0';
		M50_v := '0';
		M51_v := '0';
		M60_v := '0';
		M61_v := '0';
		M70_v := '0';
		M71_v := '0';
		M8_v := '0';
		M90_v := '0';
		M91_v := '0';
		M100_v := '0';
		M101_v := '0';
		carry_v := '1';
		zero_v := '1';
		mux_v := '0';
		done_v := '0';
		alu_v := '0';
		M12_v := '0';

		-- compute next-state, output
		case fsm_state_symbol is
			when s0 =>
				W3_v := '0';
				M20_v := '1';
				M21_v := '0';

				if (mem(15 downto 12) = "0011") then
					next_state := s6;

				elsif (mem(15 downto 13) = "100") then
					next_state := s16;

				elsif (mem(15 downto 12) = "1111") then
					next_state := s0;

				else
					next_state := s1;

				end if;

			when s1 =>
				W5_v := '0';
				W6_v := '0';
				W7_v := '0';
				M60_v := '1';
				M61_v := '0';
				M70_v := '1';
				M71_v := '0';
				M8_v := '0';
				if (instruction(15 downto 13) = "010") then
					next_state := s7;
				elsif ((instruction(15 downto 12) = "0000" or instruction(15 downto 12) = "0010")
					and ((instruction(1 downto 0) = "10" and init_carry = '1') or (instruction(1 downto 0) = "01" and init_zero = '1') or (instruction(1 downto 0) = "00"))) then
					next_state := s2;

				elsif (instruction(15 downto 12) = "0001") then
					next_state := s4;

				elsif (instruction(15 downto 12) = "1100" and (T1 = T2)) then
					next_state := s17;

				elsif (instruction(15 downto 12) = "0110") then
					next_state := s11;

				elsif (instruction(15 downto 12) = "0111") then
					next_state := s13;

				else
					next_state := sa;

				end if;

			when s2 =>
				W5_v := '0';
				M90_v := '0';
				M91_v := '1';
				M100_v := '0';
				M101_v
				:= '1';
				M60_v := '0';
				M61_v := '1';
				if (instruction(15 downto 12) = "0000") then
					carry_v := '0';
				end if;
				zero_v := '0';
				if (instruction(15 downto 12) = "0010") then
					alu_v := '1';
				else
					alu_v := '0';
				end if;
				next_state := s3;
			when s3 =>
				W4_v := '0';
				M50_v := '1';
				M51_v := '1';
				M30_v := '0';
				M31_v := '1';

				next_state := sa;
			when s4 =>
				W5_v := '0';
				M90_v := '1';
				M91_v := '0';
				M100_v := '0';
				M101_v
				:= '1';
				M60_v := '0';
				M61_v := '1';
				carry_v := '0';
				zero_v := '0';

				next_state := s5;
			when s5 =>
				W4_v := '0';
				M30_v := '1';
				M31_v := '0';
				M50_v := '1';
				M51_v := '1';

				next_state := sa;
			when s6 =>
				W4_v := '0';
				M30_v := '0';
				M31_v := '0';
				M50_v := '1';
				M51_v := '0';

				next_state := sa;
			when s7 =>
				W6_v := '0';
				M90_v := '1';
				M91_v := '0';
				M100_v := '1';
				M101_v
				:= '1';
				M70_v := '0';
				M71_v := '1';

				if (instruction(15 downto 12) = "0100") then
					next_state := s8;

				else
					-- sb7 : 0101
					next_state := s9;

				end if;

			when s8 =>
				W5_v := '0';
				M20_v := '0';
				M21_v := '0';
				M60_v := '0';

				M61_v := '0';
				zero_v := '0';
				mux_v := '1';

				next_state := s10;

			when s9 =>
				W2_v := '0';
				M20_v := '0';
				M21_v := '0';

				next_state := sa;
			when s10 =>
				W4_v := '0';
				M30_v := '0';
				M31_v := '0';
				M50_v := '1';
				M51_v := '1';

				next_state := sa;
			when s11 =>
				-- change made here t1->mema
				W6_v := '0';
				W7_v := '0';
				M90_v := '1';
				M91_v := '1';
				M100_v := '0';
				M101_v
				:= '1';
				M20_v := '1';
				M21_v := '1';
				M70_v := '1';
				M71_v := '1';
				M8_v := '1';
				next_state := s12;
			when s12 =>
				W4_v := '0';
				W5_v := '0';
				M90_v := '1';
				M91_v := '1';
				M100_v := '0';
				M101_v
				:= '0';
				M30_v := '1';
				M31_v := '1';
				M50_v := '0';
				M51_v := '1';
				M60_v := '0';
				M61_v := '1';

				if (T3(2 downto 0) = "111") then
					next_state := sa;

				else
					next_state := s11;

				end if;

			when s13 =>
				W6_v := '0';
				W5_v := '0';
				M90_v := '1';
				M91_v := '1';
				M100_v := '0';
				M101_v
				:= '0';
				M60_v := '0';
				M61_v := '1';
				M70_v := '0';
				M71_v := '0';
				M4_v := '1';

				next_state := s14;

			when s14 =>
				-- changes made
				W2_v := '0';
				W7_v := '0';
				M90_v := '1';
				M91_v := '1';
				M100_v := '0';
				M101_v
				:= '1';
				M20_v := '1';
				M21_v := '1';
				M8_v := '1';
				M12_v := '1';
				if (T3(2 downto 0) = "000") then
					next_state := sa;

				else
					next_state := s13;

				end if;

			when s15 =>
				W1_v := '0';
				M90_v := '0';
				M91_v := '0';
				M100_v := '1';
				M101_v
				:= '0';
				M1_v := '0';

				next_state := s0;
				done_v := '1';

			when s16 =>
				W4_v := '0';
				W6_v := '0';
				M30_v := '0';
				M31_v := '0';
				M50_v := '0';
				M51_v := '0';
				M70_v := '1';
				M71_v := '0';

				if (instruction(15 downto 12) = "1000") then
					next_state := s15;

				else
					-- opcode : 1001
					next_state := s18;

				end if;

			when s17 =>
				W1_v := '0';
				M90_v := '1';
				M91_v := '0';
				M100_v := '1';
				M101_v
				:= '0';
				M1_v := '0';

				next_state := s0;
				done_v := '1';

			when s18 =>
				W1_v := '0';
				M1_v := '1';

				next_state := s0;
				done_v := '1';

			when sa =>
				W1_v := '0';
				M90_v := '1';
				M91_v := '1';
				M100_v := '1';
				M101_v
				:= '0';
				M1_v := '0';

				next_state := s0;
				done_v := '1';

			when others => null;

		end case;

		w1 <= W1_v;
		w2 <= W2_v;
		w3 <= W3_v;
		w4 <= W4_v;
		w5 <= W5_v;
		w6 <= W6_v;
		w7 <= W7_v;
		m1 <= M1_v;
		m20 <= M20_v;
		m21 <= M21_v;
		m30 <= M30_v;
		m31 <= M31_v;
		m4 <= M4_v;
		m50 <= M50_v;
		m51 <= M51_v;
		m60 <= M60_v;
		m61 <= M61_v;
		m70 <= M70_v;
		m71 <= M71_v;
		m8 <= M8_v;
		m90 <= M90_v;
		m91 <= M91_v;
		m100 <= M100_v;
		m101 <= M101_v;
		carry <= carry_v;
		zero <= zero_v;
		mux <= mux_v;
		done <= done_v;
		alucont <= alu_v;
		m12 <= M12_v;
		if (rising_edge(clk)) then
			if (rst = '1') then
				fsm_state_symbol <= s0;
			else
				fsm_state_symbol <= next_state;
			end if;
		end if;

	end process;

end struct;
