library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity reset_gen is
  Port ( 
  --les entrees /sorties de notre resete synchrone
  clk100 : in std_logic;
  reset : in std_logic;
  reset_sync_clk100 : out std_logic 
  );
end reset_gen;

architecture Behavioral of reset_gen is
-- on utilsera deux filp flop pour eviter le cas ou l'input reset 
-- ne respecte pas les temps de hold et temps de set up
-- signaux : 1 er signal: est la sortie de la premier bascule
-- signaux : 2 eme signal: est la sortie de la deuxieme bascule
signal reset_signal1 : std_logic;
signal reset_signal2 : std_logic;
signal async_reset : std_logic;
begin

process(clk100, reset)
    begin    
        if reset = '1' then  
            reset_signal1  <= '1';
            reset_signal2  <= '1';
            reset_sync_clk100 <= '1';   
        elsif rising_edge(clk100) then    
        -- 1 er Flip Flop
            reset_signal1 <= '0';
         -- 2 ieme Flip Flop
            reset_sync_clk100 <= reset_signal1;
        end if;
        
 end process;
 -- assigner le signal de sortie du duexieme Flip Flop 
 -- à l'output du Bloc
 
end Behavioral;
