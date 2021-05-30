-- Component: The Finite State Machine
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity FSM is
	port (
		instruction, T1, T2, T3, mem    : in std_logic_vector(15 downto 0);
		rst, clk, init_carry, init_zero : in std_logic;
		W_PC, W_MEM, W_IR, W_RF, W_T3, W_T2, W_T1,
		M1, M20, M21, M3, M40, M41,
		M50, M51, M6, M70, M71, M80, M81,
		M90, M91, M100, M101, M11, M12,
		carry_write, zero_write, done, alu_control : out std_logic
	);
end entity;

architecture arch of FSM is

	type StateSymbol is (Si, S0, S1A, S1B, S2A, S2B, S3, S4, S5A, S5B, S6, S7A, S7B, S8A, S8B, S9, S10, S11, S12, Sf);
	signal fsm_state_symbol : StateSymbol;

begin
	process (rst, clk, instruction, init_carry, init_zero, T1, T2, T3, fsm_state_symbol)
		variable state_v : StateSymbol;
		variable W_PC_v, W_MEM_v, W_IR_v, W_RF_v, W_T3_v, W_T2_v, W_T1_v,
		M1_v, M20_v, M21_v, M3_v, M40_v, M41_v, M50_v, M51_v, M6_v,
		M70_v, M71_v, M80_v, M81_v, M90_v, M91_v, M100_v, M101_v, M12_v,
		carry_v, zero_v, M11_v, done_v, alu_v : std_logic;

	begin

		state_v := fsm_state_symbol;

		W_PC_v := '0';
		W_MEM_v := '0';
		W_IR_v := '0';
		W_RF_v := '0';
		W_T1_v := '0';
		W_T2_v := '0';
		W_T3_v := '0';

		M1_v := '0';
		M20_v := '1';
		M21_v := '0';
		M3_v := '0';
		M40_v := '0';
		M41_v := '0';
		M50_v := '0';
		M51_v := '0';
		M6_v := '0';
		M70_v := '0';
		M71_v := '0';
		M80_v := '0';
		M81_v := '0';
		M90_v := '0';
		M91_v := '0';
		M100_v := '0';
		M101_v := '0';
		M11_v := '0';
		M12_v := '0';

		carry_v := '0';
		zero_v := '0';
		done_v := '0';
		alu_v := '0';

		-- compute next-state, output
		case fsm_state_symbol is
			when Si =>
				W_IR_v := '1';
				M20_v := '1';
				M21_v := '0';

				if (mem(15 downto 12) = "0011") then
					state_v := S3;
				elsif (mem(15 downto 13) = "100") then
					state_v := S10;
				elsif (mem(15 downto 12) = "1111") then
					state_v := Si;
				else
					state_v := S0;
				end if;

			when S0 =>
				W_T1_v := '1';
				W_T2_v := '1';
				W_T3_v := '1';
				M6_v := '0';
				M70_v := '1';
				M71_v := '0';
				M80_v := '1';
				M81_v := '0';

				if (instruction(15 downto 13) = "010") then
					state_v := S4;
				elsif ((instruction(15 downto 12) = "0000" or instruction(15 downto 12) = "0010")
					and ((instruction(1 downto 0) = "10" and init_carry = '1') or (instruction(1 downto 0) = "01" and init_zero = '1') or (instruction(1 downto 0) = "00"))) then
					state_v := S1A;
				elsif (instruction(15 downto 12) = "0001") then
					state_v := S2A;
				elsif (instruction(15 downto 12) = "1100" and (T1 = T2)) then
					state_v := S9;
				elsif (instruction(15 downto 12) = "0110") then
					state_v := S7A;
				elsif (instruction(15 downto 12) = "0111") then
					state_v := S8A;
				else
					state_v := Sf;
				end if;

			when S1A =>
				W_T3_v := '1';
				M80_v := '0';
				M81_v := '1';
				M90_v := '0';
				M91_v := '1';
				M100_v := '0';
				M101_v := '1';

				if (instruction(15 downto 12) = "0000") then
					carry_v := '1';
				end if;
				zero_v := '0';

				if (instruction(15 downto 12) = "0010") then
					alu_v := '1';
				else
					alu_v := '0';
				end if;

				state_v := S1B;

			when S1B =>
				W_RF_v := '1';
				M40_v := '0';
				M41_v := '1';
				M50_v := '1';
				M51_v := '1';

				state_v := Sf;

			when S2A =>
				W_T3_v := '1';
				M80_v := '0';
				M81_v := '1';
				M90_v := '1';
				M91_v := '0';
				M100_v := '0';
				M101_v := '1';

				carry_v := '1';
				zero_v := '1';

				state_v := S2B;

			when S2B =>
				W_RF_v := '1';
				M40_v := '1';
				M41_v := '0';
				M50_v := '1';
				M51_v := '1';

				state_v := Sf;

			when S3 =>
				W_RF_v := '1';
				M40_v := '0';
				M41_v := '0';
				M50_v := '1';
				M51_v := '0';

				state_v := Sf;

			when S4 =>
				W_T2_v := '1';
				M70_v := '0';
				M71_v := '1';
				M90_v := '1';
				M91_v := '0';
				M100_v := '1';
				M101_v := '1';

				if (instruction(15 downto 12) = "0100") then
					state_v := S5A;
				else
					state_v := S6;
				end if;

			when S5A =>
				W_T3_v := '1';
				M20_v := '0';
				M21_v := '0';
				M80_v := '0';
				M81_v := '0';
				M11_v := '1';

				zero_v := '1';

				state_v := S5B;

			when S5B =>
				W_RF_v := '1';
				M40_v := '0';
				M41_v := '0';
				M50_v := '1';
				M51_v := '1';

				state_v := Sf;

			when S6 =>
				W_MEM_v := '1';
				M20_v := '0';
				M21_v := '0';

				state_v := Sf;

			when S7A =>
				W_T1_v := '1';
				W_T2_v := '1';
				M20_v := '1';
				M21_v := '1';
				M6_v := '1';
				M70_v := '1';
				M71_v := '1';
				M90_v := '1';
				M91_v := '1';
				M100_v := '0';
				M101_v := '1';

				state_v := S7B;

			when S7B =>
				W_RF_v := '1';
				W_T3_v := '1';
				M40_v := '1';
				M41_v := '1';
				M50_v := '0';
				M51_v := '1';
				M80_v := '0';
				M81_v := '1';
				M90_v := '1';
				M91_v := '1';
				M100_v := '0';
				M101_v := '0';

				if (T3(2 downto 0) = "111") then
					state_v := Sf;
				else
					state_v := S7A;
				end if;

			when S8A =>
				W_T2_v := '1';
				W_T3_v := '1';
				M3_v := '1';
				M70_v := '0';
				M71_v := '0';
				M80_v := '0';
				M81_v := '1';
				M90_v := '1';
				M91_v := '1';
				M100_v := '0';
				M101_v := '0';

				state_v := S8B;

			when S8B =>
				W_MEM_v := '1';
				W_T1_v := '1';
				M20_v := '1';
				M21_v := '1';
				M6_v := '1';
				M90_v := '1';
				M91_v := '1';
				M100_v := '0';
				M101_v := '1';
				M12_v := '1';

				if (T3(2 downto 0) = "000") then
					state_v := Sf;
				else
					state_v := S8A;
				end if;

			when S9 =>
				W_PC_v := '1';
				M1_v := '0';
				M90_v := '1';
				M91_v := '0';
				M100_v := '1';
				M101_v := '0';

				state_v := Si;
				done_v := '1';

			when S10 =>
				W_RF_v := '1';
				W_T2_v := '1';
				M40_v := '0';
				M41_v := '0';
				M50_v := '0';
				M51_v := '0';
				M70_v := '1';
				M71_v := '0';

				if (instruction(15 downto 12) = "1000") then
					state_v := S11;
				else
					state_v := S12;
				end if;

			when S11 =>
				W_PC_v := '1';
				M1_v := '0';
				M90_v := '0';
				M91_v := '0';
				M100_v := '1';
				M101_v := '0';

				state_v := Si;
				done_v := '1';

			when S12 =>
				W_PC_v := '1';
				M1_v := '1';

				state_v := Si;
				done_v := '1';

			when Sf =>
				W_PC_v := '1';
				M1_v := '0';
				M90_v := '1';
				M91_v := '1';
				M100_v := '1';
				M101_v := '0';

				state_v := Si;
				done_v := '1';

			when others => null;

		end case;

		W_PC <= W_PC_v;
		W_MEM <= W_MEM_v;
		W_IR <= W_IR_v;
		W_RF <= W_RF_v;
		W_T1 <= W_T1_v;
		W_T2 <= W_T2_v;
		W_T3 <= W_T3_v;

		M1 <= M1_v;
		M20 <= M20_v;
		M21 <= M21_v;
		M3 <= M3_v;
		M40 <= M40_v;
		M41 <= M41_v;
		M50 <= M50_v;
		M51 <= M51_v;
		M6 <= M6_v;
		M70 <= M70_v;
		M71 <= M71_v;
		M80 <= M80_v;
		M81 <= M81_v;
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
				fsm_state_symbol <= Si;
			else
				fsm_state_symbol <= state_v;
			end if;
		end if;

	end process;

end architecture;
