-- meag_ram_sim.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- 入出力の宣言
entity mega_ram_sim is
end mega_ram_sim;

-- 回路の記述
architecture SIM of mega_ram_sim is

-- コンポーネントのmega_ramの宣言
component mega_ram
	port (
		CLK		:	in std_logic;
		CLK_EX	:	in std_logic;
		RAM_ADDR:	in std_logic_vector(7 downto 0);
		RAM_IN	:	in std_logic_vector(15 downto 0);
		IO65_IN	:	in std_logic_vector(15 downto 0);
		RAM_WEN	:	in std_logic;
		RAM_OUT	:	out std_logic_vector(15 downto 0);
		IO64_OUT:	out std_logic_vector(15 downto 0)
	);
end component;

-- 内部信号の定義
signal CLK		:	std_logic	:= '1';
signal CLK_EX	:	std_logic	:= '0';
signal RAM_ADDR	:	std_logic_vector(7 downto 0);
signal RAM_IN	:	std_logic_vector(15 downto 0);
signal IO65_IN	:	std_logic_vector(15 downto 0);
signal RAM_WEN	:	std_logic	:= '0';
signal RAM_OUT	:	std_logic_vector(15 downto 0);
signal IO64_OUT	:	std_logic_vector(15 downto 0);

begin 
-- コンポーネントのmega_ramの実体化と入出力の相互接続
	C1	:	mega_ram
				port map (
					CLK	=> CLK,
					CLK_EX	=> CLK_EX,
					RAM_ADDR	=> RAM_ADDR,
					RAM_IN		=> RAM_IN,
					IO65_IN	=>	IO65_IN,
					RAM_WEN	=>	RAM_WEN,
					RAM_OUT	=>	RAM_OUT,
					IO64_OUT	=>	IO64_OUT
				);
-- 入力信号CLKの波形
				process	begin 
					CLK <= '1';
					wait for 10 ns;
					CLK	<= '0';
					wait for 10 ns;
				end process;
-- 入力信号CLK_EXの波形
				process begin 
					CLK_EX <= '0';
					wait for 2 ns;
					CLK_EX <= '1';
					wait for 20 ns;
					CLK_EX <= '0';
					wait for 58 ns;
				end process;
-- 入力信号RAM_ADDRの波形
				process begin 
					RAM_ADDR <= "00000001";
					wait for 44 ns;
					RAM_ADDR <= "00000010";
					wait for 80 ns;
					RAM_ADDR <= "00000011";
					wait for 80 ns;
					RAM_ADDR <= "00000100";
					wait for 80 ns;
				end process;
-- 入力信号RAM_INの波形
				process begin 
					RAM_IN <= "0000000000000000";
					wait for 4 ns;
					RAM_IN <= "0000000000000010";
					wait for 80 ns;
					RAM_IN <= "0000000000000100";
					wait for 80 ns;
					RAM_IN <= "0000000000000110";
					wait for 80 ns;
					RAM_IN <= "0000000000001000";
					wait for 80 ns;
				end process;
-- 入力信号RAM_WENの波形
			process begin 
				RAM_WEN <= '0';
				wait for 164 ns;
				RAM_WEN <= '1';
				wait for 80 ns;
			end process;
end SIM;
