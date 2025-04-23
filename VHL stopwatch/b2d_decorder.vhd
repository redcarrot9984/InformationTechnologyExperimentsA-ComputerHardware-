library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity B2D_DECODER is
    Port ( D_IN : in std_logic_vector(1 downto 0);
           D_OUT : out std_logic_vector(3 downto 0));
end B2D_DECODER;

architecture DATAFLOW of B2D_DECODER is
begin
    process (D_IN) begin
        case D_IN is
            when "00" => D_OUT <= "1110";
            when "01" => D_OUT <= "1101";
            when "10" => D_OUT <= "1011";
            when "11" => D_OUT <= "0111";
            when others => D_OUT <= "1111"; -- No display
        end case;
    end process;
end DATAFLOW;
