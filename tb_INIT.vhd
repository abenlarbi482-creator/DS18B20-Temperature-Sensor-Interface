library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_INIT is
-- Port ( );
end tb_INIT;

architecture Behavioral of tb_INIT is

signal out_1us: std_logic := '0';
signal out_10us: std_logic := '0';
signal out_1ms : std_logic := '0';
signal clk100 : std_logic := '0';
signal onewire_in : std_logic := '1';
signal onewire_out : std_logic := '1';
signal INIT_out_0 : std_logic := '0';
signal rst : std_logic := '1';
signal start : std_logic :='0';

component Time_gen
Port (
clk100 : in std_logic;
Reset_sync_clk100 : in std_logic;
clken_1us : out std_logic;
clken_10us : out std_logic;
clken_1ms : out std_logic
);
end component;

component INIT is
Port (
clk100, clken_10us, Reset_sync_clk100: in std_logic;
start : in std_logic;
onewire_in_clk100: in std_logic;
onewire_out_clk100: out std_logic;
INIT_out : out std_logic
);
end component;

begin

-- Clock 100 MHz
clk100 <= not clk100 after 5 ns;

-- Reset
rst <= '1', '0' after 100 ns;


-- Instanciation Time_gen
UU1 : Time_gen
port map(
clk100 => clk100,
Reset_sync_clk100 => rst,
clken_1us => out_1us,
clken_10us => out_10us,
clken_1ms => out_1ms
);

--Instanciation INIT
UU2 : INIT
port map(
start => start,
clk100 => clk100,
Reset_sync_clk100 => rst,
clken_10us => out_10us,
onewire_in_clk100 => onewire_in,
onewire_out_clk100 => onewire_out,
INIT_out => INIT_out_0
);

-- simulation du capteur DS
process
begin
--tentative1
start <= '0';
wait for 150 ns ;
wait until rising_edge(clk100);
start <= '1';
wait until rising_edge(clk100);
start <= '0';
wait for 500 us;
-- DS répond (presence pulse)
onewire_in <= '0';
wait for 150 us;
onewire_in <= '1';

wait for 480 us;

--tentative2
wait until rising_edge(clk100);
start <= '1';
wait until rising_edge(clk100);
start <= '0';
wait for 500 us;
-- DS répond (presence pulse)
onewire_in <= '0';
wait for 250 us;
onewire_in <= '1';

wait;
end process;

end Behavioral;
