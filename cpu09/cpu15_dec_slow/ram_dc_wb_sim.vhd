-- ram_dc_wb_sim.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- 入出力の宣言
entity ram_dc_wb_sim is 
end ram_dc_wb_sim;

-- 回路の記述
architecture SIM of ram_dc_wb_sim is 
-- コンポーネントの宣言
component ram_dc_wb 
	port 
	(
		CLK_DC	:	in std_logic;
		CLK_WB	:	in std_logic;
		RAM_ADDR:	in std_logic_vector(7 downto 0);
		RAM_IN	:	in std_logic_vector(15 downto 0);
		IO65_IN	:	in std_logic_vector(15 downto 0);
		RAM_WEN	:	in std_logic;
		RAM_OUT	:	out std_logic_vector(15 downto 0);
		IO64_OUT:	out std_logic_vector(15 downto 0)
	);
end component;
-- 内部信号の定義
signal CLK_DC	:	std_logic := '0';
signal CLK_WB	:	std_logic := '0';
signal RAM_ADDR	:	std_logic_vector(7 downto 0) := (others => '0');
signal RAM_IN	:	std_logic_vector(15 downto 0) := (others => '0');
signal IO65_IN	:	std_logic_vector(15 downto 0) := (others => '0');
signal RAM_WEN	:	std_logic := '1';
signal RAM_OUT	:	std_logic_vector(15 downto 0);
signal IO64_OUT	:	std_logic_vector(15 downto 0);
begin
-- コンポーネントram_dc_wbの実体化と入出力の相互接続
	C1	:	ram_dc_wb port map (
		CLK_DC	=>	CLK_DC,
		CLK_WB	=>	CLK_WB,
		RAM_ADDR=>	RAM_ADDR,
		RAM_IN	=>	RAM_IN,
		IO65_IN	=>	IO65_IN,
		RAM_WEN	=>	RAM_WEN,
		RAM_OUT	=>	RAM_OUT,
		IO64_OUT=>	IO64_OUTM_IN,
		IO65_IN	=>	IO65_IN,
		RAM_WEN	=>	RAM_WEN,
		RAM_OUT	=>	RAM_OUT,
		IO64_OUT=>	IO64_OUT
	);
-- 入力信号CLK_DCの波形を記述
	process begin 
		CLK_DC <= '0';
		wait for 10 ns;
		CLK_DC <= '1';
		wait for 20 ns;
	end process;
-- 入力信号CLK_WBの波形を記述
	process begin 
		CLK_WB	<= '0';
		wait for 30 ns;
		CLK_WB	<= '1';
		wait for 10 ns;
	end process;
-- 入力信号RAM_ADDRの波形を記述
	process begin 
		for I in 0 to 1 loop
			RAM_ADDR <= (others => '0');
			for J in 0 to 15 loop
				wait for 40 ns;
				RAM_ADDR	<= RAM_ADDR	+ 1;
			end loop;
		end loop;
	end process;
-- 入力信号RAM_INの波形を記述
	process begin 
		RAM_IN	<=	"0000000000000010";
		wait for 40 ns;
		RAM_IN	<=	"0000000000000100";
		wait for 40 ns;
		RAM_IN	<=	"0000000000000110";
		wait for 40 ns;
		RAM_IN	<=	"0000000000001000"; 
		wait for 40 ns;
		RAM_IN	<=	"0000000000000111";
		wait for 40 ns;
		RAM_IN	<=	"0000000000000101";
		wait for 40 ns;
		RAM_IN	<=	"0000000000000011";
		wait for 40 ns;
	end process;
-- 入力信号RAM_WENの波形を記述
	process begin
		RAM_WEN	<=	'1';
		wait for 640 ns;
		RAM_WEN	<=	'0';
		wait;
	end process;
end SIM;
