library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity clk_gen is
    generic (
        ms_period : positive);          -- Number of elapsed ms while button is
                                        -- pressed before creating clock pulse
    port (
        clk50MHz : in  std_logic;
        rst      : in  std_logic;
        button_n : in  std_logic;
        clk_out  : out std_logic);
end clk_gen;

architecture bhv of clk_gen is
signal temp : std_logic;
signal count : natural;
signal temp2 : std_logic;
signal count2 : natural;
begin

	U_CLK_DIV : entity work.clk_div
        generic map (
            clk_in_freq  => 50000000,
            clk_out_freq => 1000)
        port map (
            clk_in  => clk50MHz,
            clk_out => temp,
            rst     => rst);
	
	process(temp, rst) begin
		if (rst = '1') then
			clk_out <= '0';
			count <= 1;
			temp2 <= '0';
			count2 <= 1;
		elsif (rising_edge(temp)) then
		 	if(button_n = '0') then
				if count = ms_period/2 then
					if(count2 >= ms_period) then
						temp2 <= not temp2;
					end if;
						count <=1;
				else 
					count <= count + 1;
				end if;
				count2 <= count2 + 1;
			else 
				count <= 0;
				clk_out <= '0';
			end if;	
			clk_out <= temp2;
		end if;
	end process;
end bhv;
