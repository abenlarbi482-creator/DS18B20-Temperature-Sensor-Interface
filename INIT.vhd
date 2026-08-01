----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 31.03.2026 08:51:50
-- Design Name:
-- Module Name: INIT - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity INIT is
Port ( clk100, clken_10us, Reset_sync_clk100: in std_logic;
onewire_in_clk100: in std_logic;
onewire_out_clk100: out std_logic;
start : in std_logic;
INIT_out : out std_logic_vector(1 downto 0) );
end INIT;

architecture Behavioral of INIT is
--declaration du type state
type state is (Idle, wait_480us, for_480us, waitDS, DSrespond, min_60us, max_240us, max_480us, Fin);
signal state_now : state;
--signal pour compter a chaque fois
signal cpt_10us: integer range 0 to 48;
begin
process(clk100, Reset_sync_clk100)
begin
if Reset_sync_clk100 = '1' then
onewire_out_clk100<='1';
INIT_out<="00";
cpt_10us<=0;
elsif rising_edge(clk100) then
case state_now is
--etat d initialisation:
when Idle =>
onewire_out_clk100<='1';
INIT_out<="00";
cpt_10us <= 0;
if start = '1' then
state_now <= for_480us;
else
state_now <= Idle;
end if;
--fpga_maintient le 0 pendant 480us
when for_480us =>
if cpt_10us = 48 then
state_now <= waitDS;
onewire_out_clk100<='1';
cpt_10us <= 0;
elsif clken_10us ='1'then
cpt_10us <= cpt_10us + 1;
end if;
--on attend la reponse de DS
when waitDs =>
if (onewire_in_clk100='1' and cpt_10us < 2) then
state_now <= DSrespond;
cpt_10us <= 0;
elsif cpt_10us > 2 then
state_now <= wait_480us;
elsif clken_10us ='1'then
cpt_10us <= cpt_10us + 1;
end if;
-- reponse Ds doit etre max 60us
when DSrespond =>
if (onewire_in_clk100='0' and cpt_10us < 6 ) then
state_now <= min_60us;
cpt_10us <= 0;
elsif cpt_10us = 6 then
state_now <= wait_480us;
elsif clken_10us ='1'then
cpt_10us <= cpt_10us + 1;
end if;
--DS doit mmaintenir la ligne a 0 au moin 60 us
when min_60us =>
if (onewire_in_clk100='1' and cpt_10us < 6) then
state_now <= wait_480us;
elsif cpt_10us = 6 then
state_now <= max_240us;
elsif clken_10us ='1'then
cpt_10us <= cpt_10us + 1;
end if;
--DS doit mmaintenir la ligne a 0 au plus 240 us
when max_240us =>
if (onewire_in_clk100='1' and cpt_10us < 24) then
state_now <= max_480us;
elsif cpt_10us = 24 then
state_now <= wait_480us;
elsif clken_10us ='1'then
cpt_10us <= cpt_10us + 1;
end if;
--La reponse totale doit etre dans une dure min de 480 us
when max_480us =>
if (onewire_in_clk100='0' and cpt_10us < 48) then
state_now <= wait_480us;
elsif cpt_10us = 48 then
state_now <= Fin;
elsif clken_10us ='1'then
cpt_10us <= cpt_10us + 1;
end if;
-- si la reponse nest pas bonne je doit quand meme attendre 480us
when wait_480us =>
if cpt_10us = 48 then
state_now <= Idle;
elsif clken_10us ='1'then
cpt_10us <= cpt_10us + 1;
end if;
--etat final
when Fin =>
Init_out <= "10";
state_now <= Idle;
when others => state_now <= Idle;
end case;
end if;
end process;
end Behavioral;
