-- cpu_dec.vhd
library IEEE;
use IEEE.std_logic_1164.all;

-- 入出力の宣言
entity cpu_dec is 
	port (
		CLK		:	in std_logic;
		RESET_N	:	in std_logic;
		IO65_IN	:	in std_logic_vector(15 downto 0);
		IO64_OUt:	out std_logic_vector(15 downto 0);
		HEX4	:	out std_logic_vector(6 downto 0);
		HEX3	:	out std_logic_vector(6 downto 0);
		HEX2 	:	out std_logic_vector(6 downto 0);
		HEX1	:	out std_logic_vector(6 downto 0);
		HEX0	:	out std_logic_vector(6 downto 0)
	);
end cpu_dec;
-- 回路の記述
architecture RTL of cpu_dec is 
-- CPU(本体)の宣言
	component CPU15 
		port (
			CLK		:	in std_logic;
			RESET_N	:	in std_logic;
			IO65_IN	:	in std_logic_vector(15 downto 0);
			IO64_OUT:	out std_logic_vector(15 downto 0)
		);
	end component;
-- 2進数-10進数変換回路(5桁目)
	component bin_dec10000
		port (
			BIN_IN	:	in std_logic_vector(15 downto 0);
			DEC_OUT4	:	out std_logic_vector(3 downto 0);
			REMINDER4	:	out std_logic_vector(13 downto 0)
		);
	end component;
-- 2進数-10進数変換回路(4桁目)
	component bin_dec1000
		port (
			BIN_IN3		:	in	std_logic_vector(13 downto 0);
			DEC_OUT3	:	out std_logic_vector(3 downto 0);
			REMINDER3	:	out std_logic_vector(9 downto 0)
		);
	end component;
-- 2進数-10進数変換回路(3桁目)
	component bin_dec100
		port (
			BIN_IN2		:	in std_logic_vector(9 downto 0);
			DEC_OUT2	:	out std_logic_vector(3 downto 0);
			REMINDER2	:	out std_logic_Vector(6 downto 0)
		);
	end component;
-- 2進数-10進数変換回路(2桁目)
	component bin_dec10
		port (
			BIN_IN1		:	in std_logic_vector(6 downto 0);
			DEC_OUT1	:	out std_logic_vector(3 downto 0);
			REMINDER1	:	out std_logic_Vector(3 downto 0)
		);
	end component;
-- 7セグメント用デコーダ回路の宣言
	component dec_7seg
		port (
			DIN			:	in std_logic_vector(3 downto 0);
			SEG7		:	out std_logic_vector(6 downto 0)
		);
	end component;
--	内部信号の定義
signal	IO64_OUT_TP		:	std_logic_vector(15 downto 0);
signal	DEC_OUT4		:	std_logic_vector(15 downto 0);
signal	DEC_OUT3		:	std_logic_vector(15 downto 0);
signal	DEC_OUT2		:	std_logic_vector(15 downto 0);
signal	DEC_OUT1		:	std_logic_vector(15 downto 0);
signal	DEC_OUT0		:	std_logic_vector(15 downto 0);
signal	REMINDER4		:	std_logic_vector(13 downto 0);
signal	REMINDER3		:	std_logic_vector(9 downto 0);
signal	REMINDER2		:	std_logic_vector(6 downto 0);

begin 
-- CPU(本体)の実体化と入出力の相互接続
	C1	:	cpu15
		port map (
			CLK			=>	CLK,
			RESET_N		=>	RESET_N,
			IO65_IN		=>	IO65_IN and "0000001111111111",
			IO64_OUt	=>	IO64_OUT_TP
		);
-- 2進数-10進数変換回路(4桁目)の実体化と入出力の相互接続
	C2	:	bin_dec10000
		port map (
			BIN_IN		=>	IO64_OUT_TP,
			DEC_OUT4	=>	DEC_OUT4,
			REMINDER4	=>	REMINDER4
		);
-- 2進数-10進数変換回路(3桁目)の実体化と入出力の相互接続
	C3	:	bin_dec1000
		port map (
			BIN_IN3		=>	REMINDER4,
			DEC_OUT3	=>	DEC_OUT3,
			REMINDER3	=>	REMINDER3
		);
-- 2進数-10進数変換回路(2桁目)の実体化と入出力の相互接続
	C4	:	bin_dec100
		port map (
			BIN_IN2		=>	REMINDER3,
			DEC_OUT2	=>	DEC_OUT2,
			REMINDER2	=>	REMINDER2
		);
-- 2進数-10進数変換回路(1桁目)の実体化と入出力の相互接続
	C5	:	bin_dec10
		port map (
			BIN_IN1		=>	REMINDER2,
			DEC_OUT1	=>	DEC_OUT1,
			REMINDER1	=>	DEC_OUT0
		);
-- 7セグメントLED用デコーダ(5桁目)の実体化と入出力の相互接続
	C6	:	dec_7seg
		port map (
			DIN			=>	DEC_OUT4,
			SEG7		=>	HEX4
		);
-- 7セグメントLED用デコーダ(4桁目)の実体化と入出力の相互接続
	C7	:	dec_7seg
		port map (
			DIN			=>	DEC_OUT3,
			SEG7		=>	HEX3
		);
-- 7セグメントLED用デコーダ(3桁目)の実体化と入出力の相互接続
	C8	:	dec_7seg
		port map (
			DIN			=>	DEC_OUT2,
			SEG7		=>	HEX2
		);
-- 7セグメントLED用デコーダ(2桁目)の実体化と入出力の相互接続
	C9	:	dec_7seg
		port map (
			DIN			=>	DEC_OUT1,
			SEG7		=>	HEX1
		);
-- 7セグメントLED用デコーダ(1桁目)の実体化と入出力の相互接続
	C10	:	dec_7seg
		port map (
			DIN			=>	DEC_OUT0,
			SEG7		=>	HEX0
		);
-- 計算結果の出力
	IO64_OUT	<=	IO64_OUT_TP;
end RTL;
