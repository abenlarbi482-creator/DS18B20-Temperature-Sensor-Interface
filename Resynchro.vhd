----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.03.2026 08:59:27
-- Design Name: 
-- Module Name: Resynchro - Behavioral
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

entity Resynchro is
Port ( 
  --les entrees /sorties de notre resete synchrone
  clk100 : in std_logic;
  reset_sync : in std_logic;
  debug_in : in std_logic_vector(7 downto 0);
  onewire_in : in std_logic;
  onewire_in_clk : out std_logic;
  debug_in_clk : out std_logic_vector(7 downto 0)
  
  
  );
end Resynchro;

architecture Behavioral of Resynchro is
-- signaux intermediares pour entre les deux bascules D "Flip Flop"
signal sig_onewire_in_clk : std_logic;
signal sig_debug_in_clk : std_logic_vector(7 downto 0);
begin 
process(clk100,reset_sync)
begin
-- reset  remet tout à 0
if reset_sync = '1' then
    sig_onewire_in_clk <= '0';
    sig_debug_in_clk <= (others => '0');
    onewire_in_clk <= '0';
    debug_in_clk <= (others => '0');
    
elsif rising_edge(clk100) then
-- 1 ere Flip Flop
   sig_onewire_in_clk <= onewire_in;
   sig_debug_in_clk <= debug_in;
-- 2 ieme Flip Flop
    onewire_in_clk <= sig_onewire_in_clk;
    debug_in_clk <= sig_debug_in_clk;
end if;
end process;
end Behavioral;
