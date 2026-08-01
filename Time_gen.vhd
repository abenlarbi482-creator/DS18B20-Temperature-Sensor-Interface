
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Time_gen is
Port ( clk100 : in std_logic;
Reset_sync_clk100 : in std_logic;
clken_1us : out std_logic;
clken_10us : out std_logic;
clken_1ms : out std_logic
);
end Time_gen;

architecture Behavioral of Time_gen is
--signaux pour compter
signal cpt_1us, cpt_10us, cpt_1ms : integer:= 0;
--signaux de sortie
signal out_1us, out_10us, out_1ms : std_logic:= '0';


begin
process(clk100, Reset_sync_clk100)
begin
if Reset_sync_clk100 = '1' then
cpt_1us <= 0; cpt_10us <= 0; cpt_1ms <=0;
elsif rising_edge(clk100) then
--compteur 1ms declenche donc forcement les autres
if cpt_1ms = 100000 then
out_1us <= '1'; out_10us <= '1'; out_1ms <= '1';
cpt_1us <= 0; cpt_10us <= 0; cpt_1ms <= 0;
--compteur 1ms declenche donc forcement celui de 1 us
elsif cpt_10us = 1000 then
out_1us <= '1'; out_10us <= '1'; out_1ms <= '0';
cpt_1us <= 0; cpt_10us <=0; cpt_1ms <= cpt_1ms +1;
--compteur 1us declenche
elsif cpt_1us = 100 then
out_1us <= '1'; out_10us <= '0'; out_1ms <= '0';
cpt_1us <= 0; cpt_10us <= cpt_10us + 1; cpt_1ms <= cpt_1ms +1;
--Rien n'est declenche
else
out_1us <= '0'; out_10us <= '0'; out_1ms <= '0';
cpt_1us <= cpt_1us + 1; cpt_10us <= cpt_10us + 1; cpt_1ms <= cpt_1ms +1;
end if;
end if;
end process;

clken_1us <= out_1us; clken_10us <= out_10us; clken_1ms <= out_1ms;

end Behavioral;
