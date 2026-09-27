library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity clk_div is
    generic(clk_in_freq  : natural;  -- Input clock frequency
            clk_out_freq : natural); -- Output clock frequency
    port (
        clk_in  : in  std_logic;
        clk_out : out std_logic;
        rst     : in  std_logic);
end clk_div;
architecture bhv of clk_div is 
signal count : integer;
signal temp : std_logic;
begin

process(clk_in,rst)
	begin
	if(rst = '1') then
		count <= 1;
		clk_out <= '0';
		temp <= '0';

	elsif(rising_edge(clk_in)) then 
		if count = (clk_in_freq/clk_out_freq)/2 then
			count <= 1;
			temp <= not temp;
			clk_out <= temp;
		else
			count <= count + 1;
		end if;	
	end if;
	end process;
end architecture; 