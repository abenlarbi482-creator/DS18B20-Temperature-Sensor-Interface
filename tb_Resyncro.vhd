----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.03.2026 09:53:06
-- Design Name: 
-- Module Name: tb_Resyncro - Behavioral
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

entity tb_Resyncro is
--  Port ( );
end tb_Resyncro;

architecture Behavioral of tb_Resyncro is
-- component Resynchro
component Resynchro
Port( 
  -- les entrees /sorties de notre resete synchrone
  clk100 : in std_logic;
  reset_sync : in std_logic;
  debug_in : in std_logic_vector(7 downto 0);
  onewire_in : in std_logic;
  onewire_in_clk : out std_logic;
  debug_in_clk : out std_logic_vector(7 downto 0)
  );
end component;

-- signaux du test bunch
signal tb_clk100 :  std_logic;
signal tb_reset_sync :  std_logic;
signal tb_debug_in :  std_logic_vector(7 downto 0);
signal tb_onewire_in :  std_logic;
signal tb_onewire_in_clk :  std_logic;
signal tb_debug_in_clk : std_logic_vector(7 downto 0);

begin

-- component
UUT : Resynchro port map(
    clk100 => tb_clk100 ,
    reset_sync => tb_reset_sync,
    debug_in => tb_debug_in,
    onewire_in => tb_onewire_in,
    onewire_in_clk => tb_onewire_in_clk ,
    debug_in_clk => tb_debug_in_clk
);

-- clock process
tb_clk : process
begin
   tb_clk100 <= '0'; wait for 5ns;
   tb_clk100 <= '1' ; wait for 5ns;
end process;

-- reset process
tb_rst : process 
begin  
    tb_reset_sync <= '1'; 
    wait for 40 ns;
    tb_reset_sync <= '0' ; 
    wait;
end process;

-- debug process
tb_debug : process 
begin  
    tb_debug_in <=(others =>'0'); wait for 40 ns;
    tb_debug_in <=(others =>'1') ; wait;
end process;

-- one_wire process
tb_wire : process 
begin  
    tb_onewire_in <='1'; wait for 63 ns;
    tb_onewire_in <='0' ; wait;
end process;

end Behavioral;
