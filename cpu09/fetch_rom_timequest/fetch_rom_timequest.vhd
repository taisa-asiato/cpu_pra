-- fetch_rom_timequest.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- 入出力の宣言
entity fetch_rom_timequest is 
	port 
	(
		ADDR	: in std_logic_vector(7 downto 0);
		CLK		:	in std_logic;
		Q2		:	out std_logic_vector(14 downto 0)
	);
end fetch_rom_timequest;

-- 回路の記述
architecture RTL of fetch_rom_timequest is 

-- コンポーネントの宣言
component fetch_rom is 
	port
	(
		address	:	in std_logic_vector(7 downto 0);
		clock	:	in std_logic;
		q		:	out std_logic_vector(14 downto 0)
	);
end component;

-- 内部信号の定義
signal Q		: std_logic_vector(14 downto 0);

begin 
-- コンポーネントの宣言
	C1	:	fetch_rom port map (
		address	=>	ADDR,
		clock	=>	CLK,
		q		=>	Q
	);
-- 受け側DFFの記述
	process(CLK)
	begin
		if (CLK'event and CLK = '1') then 
			Q2	<= Q;
		end if;
	end process;
end RTL;
