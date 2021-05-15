-- ram_dc_wb.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- 入出力の宣言
entity ram_dc_wb is 
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
end ram_dc_wb;

-- 回路の記述
architecture RTL of ram_dc_wb is 
-- 内部信号の定義
subtype RAM_WORD is std_logic_vector(15 downto 0);
type RMA_ARRAY_TYPE is array (0 to 63) of RAM_WORD;
signal RAM_ARRAY	:	RAM_ARRAY_TYPE;
signal ADDR_INT		:	integer range 0 to 255;

begin 
	ADDR_INT	<= conv_integer(RAM_ADDR);
-- 配列RAM_ARRAYの読み出し処理
	process(CLK_DC)
	begin 
		if (CLK_DC'event and CLK_DC = '1') then 
			if (ADDR_IN	< 64) then 
				RAM_OUT	<= RAM_ARRAY(ADDR_INT);
			elsif (ADDR_INT = 65) then 
				RAM_OUT <= IO65_IN;
			end if;
		end if;
	end process;
-- 配列RAM_ARRAY の書き込み処理
	process(CLK_WB)
	begin 
		if (CLK_WB'event and CLK_WB = '1') then 
			if (RAM_WEN = '1') then 
				if (ADDR_INT < 64) then 
					RAM_ARRAY(ADDR_INT) <= RAM_IN;
				elsif (ADDR_INT = 64) then 
					IO64_OUT <= RAM_IN;
				end if;
			end if;
		end if;
	end process;
end RTL;

