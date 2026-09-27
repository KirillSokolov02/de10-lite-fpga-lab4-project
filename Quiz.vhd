library ieee;
use ieee.std_logic_1164.all;

entity Quiz is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        output : out std_logic_vector(3 downto 0));
end Quiz;
architecture bhv of Quiz is 
type state is (state_0, state_1, state_2, state_3, state_5, state_6, state_7);
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
				output <= "0011";
				state_r <= state_1;
			when state_1 =>
				output <= "0111";
				state_r <= state_3;
			when state_3 =>
				output <= "0010";
				state_r <= state_2;
			when state_2 =>
				output <= "0100";
				state_r <= state_6;
			when state_6 =>
				output <= "1001";
				state_r <= state_7;
			when state_7 =>
				output <= "0001";
				state_r <= state_5;
			when state_5 =>
				output <= "0110";
				state_r <= state_0;
		end case;
	end if;
end process;	
end architecture;
