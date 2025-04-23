library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity STOP_WATCH is
    Port ( CK : in std_logic;
           START : in std_logic;
           STOP : in std_logic;
           RESET : in std_logic;
           S : out std_logic_vector(3 downto 0);
           Y : out std_logic_vector(7 downto 0));
end STOP_WATCH;

architecture STRUCTURE of STOP_WATCH is
    component COUNTER1M
        Port ( CK : in std_logic;
               Y : out std_logic;
               M : out std_logic_vector(1 downto 0));
    end component;

    component SWITCH
        Port ( S_IN : in std_logic;
               START : in std_logic;
               STOP : in std_logic;
               S_OUT : out std_logic);
    end component;

    component COUNTER10
        Port ( CK : in std_logic;
               RESET : in std_logic;
               Y : out std_logic;
               D : out std_logic_vector(3 downto 0));
    end component;

    component MULTIPLEXER
        Port ( D3 : in std_logic_vector(3 downto 0);
               D2 : in std_logic_vector(3 downto 0);
               D1 : in std_logic_vector(3 downto 0);
               D0 : in std_logic_vector(3 downto 0);
               SEL : in std_logic_vector(1 downto 0);
               D_OUT : out std_logic_vector(4 downto 0));
    end component;

    component B2D_DECODER
        Port ( D_IN : in std_logic_vector(1 downto 0);
               D_OUT : out std_logic_vector(3 downto 0));
    end component;

    component LED_DECODER
        Port ( D_IN : in std_logic_vector(4 downto 0);
               D_OUT : out std_logic_vector(7 downto 0));
    end component;

    signal C3, C2, C1, C0, CS : std_logic;
    signal CM : std_logic_vector(1 downto 0);
    signal X3, X2, X1, X0 : std_logic_vector(3 downto 0);
    signal XD : std_logic_vector(4 downto 0);
begin
    COMPA : COUNTER1M port map ( CK => CK, Y => CS, M => CM );
    COMPB : SWITCH port map ( S_IN => CS, START => START, STOP => STOP, S_OUT => C0 );
    COMP0 : COUNTER10 port map ( CK => C0, RESET => RESET, Y => C1, D => X0 );
    COMP1 : COUNTER10 port map ( CK => C1, RESET => RESET, Y => C2, D => X1 );
    COMP2 : COUNTER10 port map ( CK => C2, RESET => RESET, Y => C3, D => X2 );
    COMP3 : COUNTER10 port map ( CK => C3, RESET => RESET, Y => open, D => X3 );
    COMPC : MULTIPLEXER port map ( D3 => X3, D2 => X2, D1 => X1, D0 => X0, SEL => CM, D_OUT => XD );
    COMPD : B2D_DECODER port map ( D_IN => CM, D_OUT => S );
    COMPE : LED_DECODER port map ( D_IN => XD, D_OUT => Y );
end STRUCTURE;
