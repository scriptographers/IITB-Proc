-- Component: The Finite State Machine
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity FSM is
	port (
		instruction, T1, T2, T3, mem    : in std_logic_vector(15 downto 0);
		rst, clk, init_carry, init_zero : in std_logic;
		W1, W2, W3, W4, W5, W6, W7,
		M1, M20, M21, M30, M31, M4, M50, M51, M60, M61,
		M70, M71, M8, M90, M91, M100, M101, M11, M12,
		carry_write, zero_write, done, alu_control : out std_logic);
end entity;

architecture struct of FSM is

	type StateSymbol is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S18, S_alpha);
	signal fsm_state_symbol : StateSymbol;

begin
	process (rst, clk, instruction, init_carry, init_zero, T1, T2, T3, fsm_state_symbol)
		variable state_v : StateSymbol;
		variable W1_v, W2_v, W3_v, W4_v, W5_v, W6_v, W7_v,
		M1_v, M20_v, M21_v, M30_v, M31_v, M4_v, M50_v, M51_v, M60_v, M61_v,
		M70_v, M71_v, M8_v, M90_v, M91_v, M100_v, M101_v, M12_v,
		carry_v, zero_v, M11_v, done_v, alu_v : std_logic;

	begin

		state_v := fsm_state_symbol;
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
		M11_v := '0';
		M12_v := '0';
		carry_v := '1';
		zero_v := '1';
		done_v := '0';
		alu_v := '0';

		-- compute next-state, output
		case fsm_state_symbol is
			when S0 =>
				W3_v := '0';
				M20_v := '1';
				M21_v := '0';

				if (mem(15 downto 12) = "0011") then
					state_v := S6;
				elsif (mem(15 downto 13) = "100") then
					state_v := S16;
				elsif (mem(15 downto 12) = "1111") then
					state_v := S0;
				else
					state_v := S1;
				end if;

			when S1 =>
				W5_v := '0';
				W6_v := '0';
				W7_v := '0';
				M60_v := '1';
				M61_v := '0';
				M70_v := '1';
				M71_v := '0';
				M8_v := '0';

				if (instruction(15 downto 13) = "010") then
					state_v := S7;
				elsif ((instruction(15 downto 12) = "0000" or instruction(15 downto 12) = "0010")
					and ((instruction(1 downto 0) = "10" and init_carry = '1') or (instruction(1 downto 0) = "01" and init_zero = '1') or (instruction(1 downto 0) = "00"))) then
					state_v := S2;
				elsif (instruction(15 downto 12) = "0001") then
					state_v := S4;
				elsif (instruction(15 downto 12) = "1100" and (T1 = T2)) then
					state_v := S15;
				elsif (instruction(15 downto 12) = "0110") then
					state_v := S11;
				elsif (instruction(15 downto 12) = "0111") then
					state_v := S13;
				else
					state_v := S_alpha;
				end if;

			when S2 =>
				W5_v := '0';
				M60_v := '0';
				M61_v := '1';
				M90_v := '0';
				M91_v := '1';
				M100_v := '0';
				M101_v := '1';

				if (instruction(15 downto 12) = "0000") then
					carry_v := '0';
				end if;
				zero_v := '0';

				if (instruction(15 downto 12) = "0010") then
					alu_v := '1';
				else
					alu_v := '0';
				end if;

				state_v := S3;

			when S3 =>
				W4_v := '0';
				M30_v := '0';
				M31_v := '1';
				M50_v := '1';
				M51_v := '1';

				state_v := S_alpha;

			when S4 =>
				W5_v := '0';
				M60_v := '0';
				M61_v := '1';
				M90_v := '1';
				M91_v := '0';
				M100_v := '0';
				M101_v := '1';

				carry_v := '0';
				zero_v := '0';

				state_v := S5;

			when S5 =>
				W4_v := '0';
				M30_v := '1';
				M31_v := '0';
				M50_v := '1';
				M51_v := '1';

				state_v := S_alpha;

			when S6 =>
				W4_v := '0';
				M30_v := '0';
				M31_v := '0';
				M50_v := '1';
				M51_v := '0';

				state_v := S_alpha;

			when S7 =>
				W6_v := '0';
				M70_v := '0';
				M71_v := '1';
				M90_v := '1';
				M91_v := '0';
				M100_v := '1';
				M101_v := '1';

				if (instruction(15 downto 12) = "0100") then
					state_v := S8;
				else
					state_v := S9;
				end if;

			when S8 =>
				W5_v := '0';
				M20_v := '0';
				M21_v := '0';
				M60_v := '0';
				M61_v := '0';
				M11_v := '1';

				zero_v := '0';

				state_v := S10;

			when S9 =>
				W2_v := '0';
				M20_v := '0';
				M21_v := '0';

				state_v := S_alpha;

			when S10 =>
				W4_v := '0';
				M30_v := '0';
				M31_v := '0';
				M50_v := '1';
				M51_v := '1';

				state_v := S_alpha;

			when S11 =>
				W6_v := '0';
				W7_v := '0';
				M20_v := '1';
				M21_v := '1';
				M70_v := '1';
				M71_v := '1';
				M8_v := '1';
				M90_v := '1';
				M91_v := '1';
				M100_v := '0';
				M101_v := '1';

				state_v := S12;

			when S12 =>
				W4_v := '0';
				W5_v := '0';
				M30_v := '1';
				M31_v := '1';
				M50_v := '0';
				M51_v := '1';
				M60_v := '0';
				M61_v := '1';
				M90_v := '1';
				M91_v := '1';
				M100_v := '0';
				M101_v := '0';

				if (T3(2 downto 0) = "111") then
					state_v := S_alpha;
				else
					state_v := S11;
				end if;

			when S13 =>
				W5_v := '0';
				W6_v := '0';
				M4_v := '1';
				M60_v := '0';
				M61_v := '1';
				M70_v := '0';
				M71_v := '0';
				M90_v := '1';
				M91_v := '1';
				M100_v := '0';
				M101_v := '0';

				state_v := S14;

			when S14 =>
				W2_v := '0';
				W7_v := '0';
				M20_v := '1';
				M21_v := '1';
				M8_v := '1';
				M90_v := '1';
				M91_v := '1';
				M100_v := '0';
				M101_v := '1';
				M12_v := '1';

				if (T3(2 downto 0) = "000") then
					state_v := S_alpha;
				else
					state_v := S13;
				end if;

			when S15 =>
				W1_v := '0';
				M1_v := '0';
				M90_v := '0';
				M91_v := '0';
				M100_v := '1';
				M101_v := '0';

				state_v := S0;
				done_v := '1';

			when S16 =>
				W4_v := '0';
				W6_v := '0';
				M30_v := '0';
				M31_v := '0';
				M50_v := '0';
				M51_v := '0';
				M70_v := '1';
				M71_v := '0';

				if (instruction(15 downto 12) = "1000") then
					state_v := S15;
				else
					state_v := S18;
				end if;

			when S18 =>
				W1_v := '0';
				M1_v := '1';

				state_v := S0;
				done_v := '1';

			when S_alpha =>
				W1_v := '0';
				M1_v := '0';
				M90_v := '1';
				M91_v := '1';
				M100_v := '1';
				M101_v := '0';

				state_v := S0;
				done_v := '1';

			when others => null;

		end case;

		W1 <= W1_v;
		W2 <= W2_v;
		W3 <= W3_v;
		W4 <= W4_v;
		W5 <= W5_v;
		W6 <= W6_v;
		W7 <= W7_v;
		M1 <= M1_v;
		M20 <= M20_v;
		M21 <= M21_v;
		M30 <= M30_v;
		M31 <= M31_v;
		M4 <= M4_v;
		M50 <= M50_v;
		M51 <= M51_v;
		M60 <= M60_v;
		M61 <= M61_v;
		M70 <= M70_v;
		M71 <= M71_v;
		M8 <= M8_v;
		M90 <= M90_v;
		M91 <= M91_v;
		M100 <= M100_v;
		M101 <= M101_v;
		M11 <= M11_v;
		M12 <= M12_v;
		carry_write <= carry_v;
		zero_write <= zero_v;
		done <= done_v;
		alu_control <= alu_v;

		if (rising_edge(clk)) then
			if (rst = '1') then
				fsm_state_symbol <= S0;
			else
				fsm_state_symbol <= state_v;
			end if;
		end if;

	end process;

end struct;
