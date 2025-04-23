library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity COUNTER1M is
    Port ( CK : in std_logic;
           Y : out std_logic;
           M : out std_logic_vector(1 downto 0));
end COUNTER1M;

architecture BEHAVIOR of COUNTER1M is
    signal COUNT: std_logic_vector(19 downto 0); -- 20 bits to count up to 1,000,000
begin
    M <= COUNT(1 downto 0); -- Lower 2 bits for M output
    Y <= '1' when COUNT = "11110100001001000000" else '0'; -- 1,000,000 in binary
    process (CK) begin
        if (CK'event and CK = '1') then
            if (COUNT = "11110100001001000000") then -- Reset at 1,000,000
                COUNT <= (others => '0');
            else
                COUNT <= COUNT + 1;
            end if;
        end if;
    end process;
end BEHAVIOR;
