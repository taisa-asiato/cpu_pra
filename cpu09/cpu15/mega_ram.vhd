-- mega_ram.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- 入出力の宣言
entity mega_ram is 
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
end mega_ram;

-- 回路の記述
architecture RTL of mega_ram is 
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
signal RAM_OUT_MEGA	:	std_logic_vector(15 downto 0);
signal ADDR_INT		:	integer range 0 to 255;
signal RAM_SEL		:	std_logic;
signal RAM_WREN		:	std_logic;

begin 

	ADDR_INT <= conv_integer(RAM_ADDR);
	RAM_WREN <= RAM_WEN and CLK_EX and RAM_SEL;

-- コンポーネントの実体化と入出力の相互接続
	C1 : ram_1port port map (
		address => RAM_ADDR(5 downto 0),
		clock	=> CLK,
		data	=> RAM_IN,
		wren 	=> RAM_WREN,
		q		=> RAM_OUT_MEGA
	);
-- コンポーネントの入力信号を生成する組み合わせ回路
	process(ADDR_INT, RAM_OUT_MEGA, IO65_IN)
	begin 
		if (ADDR_INT < 64) then 
			RAM_OUT	<= RAM_OUT_MEGA;
			RAM_SEL	<= '1';
		elsif (ADDR_INT = 65) then 
			RAM_OUT <= IO65_IN;
			RAM_SEL <= '0';
		else 
			RAM_OUT <= (others => '0');
			RAM_SEL <= '0';
		end if;
	end process;
-- I/O出力信号IO64_OUTの生成
	process(CLK)
	begin 
		if (CLK'event and CLK = '1') then 
			if (ADDR_INT = 64) then 
				if((RAM_WEN = '1') and (CLK_EX = '1')) then 
					IO64_OUT <= RAM_IN;
				end if;
			end if;
		end if;
	end process;
end RTL;
