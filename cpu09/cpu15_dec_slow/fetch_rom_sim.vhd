-- fetch_rom_sim.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- 入出力の宣言
entity fetch_rom_sim is 
end fetch_rom_sim;

-- 回路の記述
architecture SIM of fetch_rom_sim is 

--コンポーネントの宣言
component fetch_rom 
	port 
	(
		address	:	in std_logic_vector(7 downto 0);
		clok	:	in std_logic;
		q		:	out std_logic_vector(14 downto 0)
	);
end component;

-- 内部信号の定義
signal ADDRESS	:	std_logic_vector(7 downto 0);
signal CLK		:	std_logic;
signal Q		:	std_logic_vector(14 downto 0);

begin 
--	コンポーネントの実体化と入出力の相互接続
	C1	:	fetch_rom port map (
		address	=>	ADDRESS,
		clok	=>	CLK,
		q		=>	Q
	);
-- 入力信号CLKの波形を記述
	process begin 
		CLK	<=	'0';
		wait for 10 ns;
		CLK	<=	'1';
		wait for 10 ns;
	end process;
-- 入力信号ADDRESSの波形を記述
	process begin 
		ADDRESS	<=	"00000000";
		for I in 0 to 15 loop
			wait for 20 ns;
			ADDRESS	<= ADDRESS + 1;
		end loop;
		wait;
	end process;
end SIM;
