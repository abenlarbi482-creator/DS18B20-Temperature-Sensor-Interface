library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity tb_Time_gen is
--  Port ( );
end tb_Time_gen;

architecture Behavioral of tb_Time_gen is
component Time_gen
Port (
           clk100 : in STD_LOGIC;
           Reset_sync_clk100 : in STD_LOGIC;
           clken_1us : out STD_LOGIC;
           clken_10us : out STD_LOGIC;
           clken_1ms : out STD_LOGIC
            );
end component;
signal tb_clk100 : std_logic;
signal tb_reset_sync : std_logic;
signal tb_clken_1us : std_logic;
signal tb_clken_10us : std_logic;
signal tb_clken_1ms : std_logic;
begin
UUT : Time_gen port map(
    clk100 => tb_clk100,
    Reset_sync_clk100 =>tb_reset_sync ,
    clken_1us  =>tb_clken_1us ,
    clken_10us  =>tb_clken_10us ,
    clken_1ms  =>tb_clken_1ms 
);


tb_clk : process
begin
   tb_clk100 <= '0'; wait for 5ns;
   tb_clk100 <= '1' ; wait for 5ns;
end process;

tb_rst : process 
begin  
tb_reset_sync <= '1' ; wait for 25ns;
tb_reset_sync <= '0'; wait;
end process;
end Behavioral;
