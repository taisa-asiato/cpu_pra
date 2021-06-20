-- ram_1port_sim.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- 入出力の宣言
entity ram_1port_sim is 
end ram_1port_sim;

-- 回路の記述
architecture SIM of ram_1port_sim is 
-- コンポーネントの宣言
component ram_1port 
	port (
		address	:	in std_logic_vector(5 downto 0);
		clock	:	in std_logic;
		data	:	in std_logic_vector(15 downto 0);
		wren 	:	in std_logic;
		q		:	out std_logic_vector(15 downto 0)
	);
end component;
-- 内部信号の定義
signal ADDRESS	:	std_logic_vector(5 downto 0);
signal CLK		:	std_logic;
signal DATA		:	std_logic_vector(15 downto 0);
signal WREN		:	std_logic;
signal Q		:	std_logic_vector(15 downto 0);

begin 
-- コンポーネントの宣言
	C1	:	ram_1port port map (
		address	=>	ADDRESS,
		clock	=>	CLK,
		data	=>	DATA,
		wren	=>	WREN,
		q		=>	Q
	);
-- 入力信号CLKの波形を記述
	process begin 
		CLK	<=	'0';
		wait for 10 ns;
		CLK	<= 	'1';
		wait for 10 ns;
	end process;
-- 入力信号ADDRESSの波形を記述
	process	begin 
		ADDRESS	<=	"000001";
		wait for 40 ns;
		ADDRESS	<=	"000011";
		wait for 40 ns;
		ADDRESS	<=	"000001";
		wait for 40 ns;
	end process;
-- 入力信号DATAの波形を記述
	process begin 
		DATA	<= "0000000000000010";
		wait for 40 ns;
		DATA	<= "0000000000000100";
		wait for 40 ns;
		DATA	<= "0000000000000110";
		wait for 40 ns;
	end process;
-- 入力信号のWRENの波形を記述
	process	begin 
		WREN	<=	'0';
		wait for 20 ns;
		WREN	<=	'1';
		wait for 20 ns;
	end process;
end SIM;
