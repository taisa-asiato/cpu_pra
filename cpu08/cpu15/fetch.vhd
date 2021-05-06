-- fetch.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- 入出力の宣言
entity fetch is
    port
        (
            CLK_FT  	:   in std_logic;
            P_COUNT		:   in std_logic_vector(7 downto 0);
            PROM_OUT    :   out std_logic_vector(14 downto 0)       
        );
end fetch;

-- 回路の記述
architecture RTL of fetch is

subtype WORD is std_logic_vector(14 downto 0);

type MEMORY is array (0 to 15) of WORD;

constant MEM : MEMORY := 
    (
        "100100000000000",  -- ldh REG0, 0
        "100000000000000",  -- ldl REG0, 0
        "100100100000000",  -- ldh REG1, 0
        "100000100000001",  -- ldl REG1, 1
        "100101000000000",  -- ldh REG2, 0
        "100001000000000",  -- ldl REG2, 0
        "100101100000000",  -- ldh REG3, 0
        "100001100001010",  -- ldl REG3, 10
        "000101000100000",  -- add REG2, REG1
        "000100001000000",  -- add REG0, REG2
        "111000001000000",  -- st REG0, 64(40h)
        "101001001100000",  -- cmp REG2, REG3
        "101100000001110",  -- je 14 (EH)
        "110000000001000",  -- jmp 8 
        "111100000000000",  -- hlt
        "000000000000000"	-- nop
    );
begin 
    process(CLK_FT)
    begin 
        if (CLK_FT'event and  CLK_FT = '1') then 
            PROM_OUT <= MEM(conv_integer(P_COUNT(3 downto 0)));
        end if;
    end process;
end RTL;
