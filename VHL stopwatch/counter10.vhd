library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity COUNTER10 is
    Port ( CK : in std_logic;
           RESET : in std_logic;
           Y : out std_logic;
           D : out std_logic_vector(3 downto 0));
end COUNTER10;

architecture BEHAVIOR of COUNTER10 is
    signal COUNT: std_logic_vector(3 downto 0);
begin
    Y <= COUNT(3) and not COUNT(2) and not COUNT(1) and COUNT(0); -- Y is '1' when COUNT is "1001" (9)
    D <= COUNT;
    process (RESET, CK) begin
        if (RESET = '1') then
            COUNT <= "0000";
        elsif (CK'event and CK = '1') then -- Assuming positive edge trigger
            if (COUNT = "1001") then
                COUNT <= "0000";
            else
                COUNT <= COUNT + 1;
            end if;
        end if;
    end process;
end BEHAVIOR;
