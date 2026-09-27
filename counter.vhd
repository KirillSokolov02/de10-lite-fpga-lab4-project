library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        up_n   : in  std_logic;         -- Active low
        load_n : in  std_logic;         -- Active low
        input  : in  std_logic_vector(3 downto 0);
        output : out std_logic_vector(3 downto 0));
end counter;

architecture bhv of counter is 
signal temp : std_logic_vector(3 downto 0) := "0000";
begin
process(clk,rst) begin
	if (rst = '1') then
		temp <= "0000";
	elsif (rising_edge(clk)) then
		if (load_n = '0') then
			temp <= input;
		elsif (up_n = '0') then
			temp <= std_logic_vector(unsigned(temp) + ("0001"));
		elsif (up_n = '1') then
			temp <= std_logic_vector(unsigned(temp) - ("0001"));
		end if;
	end if;
end process; 
output <= temp;
end architecture;
