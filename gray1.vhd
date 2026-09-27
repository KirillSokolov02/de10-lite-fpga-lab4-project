library ieee;
use ieee.std_logic_1164.all;

entity gray1 is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        output : out std_logic_vector(3 downto 0));
end gray1;
architecture bhv of gray1 is 
type state is (state_0, state_1, state_2, state_3, state_4, state_5, state_6, state_7, state_8, state_9, state_10, state_11, state_12, state_13, state_14, state_15);
signal state_r : state;
begin

process(clk,rst)
begin
	if (rst = '1') then
		state_r <= state_0;
		output <= "0000";
	elsif (rising_edge(clk)) then
		case (state_r) is
			when state_0 =>
				output <= "0000";
				state_r <= state_1;
			when state_1 =>
				output <= "0001";
				state_r <= state_3;
			when state_3 =>
				output <= "0011";
				state_r <= state_2;
			when state_2 =>
				output <= "0010";
				state_r <= state_6;
			when state_6 =>
				output <= "0110";
				state_r <= state_7;
			when state_7 =>
				output <= "0111";
				state_r <= state_5;
			when state_5 =>
				output <= "0101";
				state_r <= state_4;
			when state_4 =>
				output <= "0100";
				state_r <= state_12;
			when state_12 =>
				output <= "1100";
				state_r <= state_13;
			when state_13 =>
				output <= "1101";
				state_r <= state_15;
			when state_15 =>
				output <= "1111";
				state_r <= state_14;
			when state_14 =>
				output <= "1110";
				state_r <= state_10;
			when state_10 =>
				output <= "1010";
				state_r <= state_11;
			when state_11 =>
				output <= "1011";
				state_r <= state_9;
			when state_9 =>
				output <= "1001";
				state_r <= state_8;
			when state_8 =>
				output <= "1000";
				state_r <= state_0;
		end case;
	end if;
end process;	
end architecture;