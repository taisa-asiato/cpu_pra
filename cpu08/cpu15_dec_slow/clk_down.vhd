-- clk_down.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- 入出力の宣言
entity clk_down is 
	port
	(
		CLK_IN	:	in std_logic;
		CLK_OUT	:	out std_logic
	);
end clk_down;

-- 回路の奇術
architecture RTL of clk_down is 
signal COUNT	:	std_logic_vector(20 downto 0);
begin
	process(CLK_IN)
	begin
		if(CLK_IN'event and CLK_IN='1') then 
			COUNT <= COUNT + 1;
		end if;
	end process;
	CLK_OUT <= COUNT(20);
end RTL;
