-- cpu_dec_slow.vhd
library IEEE;
use IEEE.std_logic_1164.all;

-- 入出力の宣言
entity cpu15_dec_slow is 
	port 
	(
		CLK		:	in std_logic;
		RESET_N	:	in std_logic;
		IO65_IN	:	in std_logic_vector(15 downto 0);
		IO64_OUT:	out std_logic_vector(15 downto 0);
		HEX4	:	out std_logic_vector(6 downto 0);
		HEX3	:	out std_logic_vector(6 downto 0);
		HEX2	:	out std_logic_vector(6 downto 0);
		HEX1	:	out std_logic_vector(6 downto 0);
		HEX0	:	out std_logic_vector(6 downto 0)
	);
end cpu15_dec_slow;

-- 回路の記述
architecture RTL of cpu15_dec_slow is 
-- clk_downの宣言
component clk_down
	port 
	(
		CLK_IN	:	in std_logic;
		CLK_OUT	:	out	std_logic
	);
end component;
-- CPU(cpu_dec)の宣言
component cpu_dec
	port 
	(
		CLK		:	in std_logic;
		RESET_N	:	in std_logic;
		IO65_IN	:	in std_logic_vector(15 downto 0);	
		IO64_OUT:	out	std_logic_vector(15 downto 0);
		HEX4	:	out std_logic_vector(6 downto 0);
		HEX3	:	out std_logic_vector(6 downto 0);
		HEX2	:	out std_logic_vector(6 downto 0);
		HEX1	:	out std_logic_vector(6 downto 0);
		HEX0	:	out std_logic_vector(6 downto 0)
	);
end component;
-- 内部変数の定義
signal CLK_SLOW	:	std_logic;
-- clk_downの実体化と入出力の相互接続
begin 
	C1	:	clk_down
		port map (
			CLK_IN	=>	CLK,
			CLK_OUT	=>	CLK_SLOW
		);
--	cpu_decの実体化と入出力の相互接続
	C2	:	cpu_dec
		port map (
			CLK	=>	CLK_SLOW,
			RESET_N	=>	RESET_N,
			IO65_IN	=>	IO65_IN,
			IO64_OUT	=>	IO64_OUT,
			HEX4	=>	HEX4,
			HEX3	=>	HEX3,
			HEX2	=>	HEX2,
			HEX1	=>	HEX1,
			HEX0	=>	HEX0
		);
end RTL;
