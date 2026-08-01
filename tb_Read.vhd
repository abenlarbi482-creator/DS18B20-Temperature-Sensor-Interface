----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.04.2026 10:53:17
-- Design Name: 
-- Module Name: tb_Read - Behavioral
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

entity tb_Read is
--  Port ( );
end tb_Read;

architecture Behavioral of tb_Read is
component Time_gen 
 Port (
           clk100 : in STD_LOGIC;
           Reset_sync_clk100 : in STD_LOGIC;
           clken_1us : out STD_LOGIC;
           clken_10us : out STD_LOGIC;
           clken_1ms : out STD_LOGIC
            );
end component;

component Read
Port (
  clk100 : in std_logic;
  clk10us : in std_logic;
  clk1us : in std_logic;
  reset : in std_logic;
  enable : in std_logic;
  onewire_in : in std_logic;
  onewire_out : out std_logic;
  value_out : out std_logic_vector(8 downto 0);
  end_read: out std_logic
);
end component;

-- compoent time gen
signal tb_reset_sync : STD_LOGIC;
signal tb_clken_1us : STD_LOGIC;
signal tb_clken_10us : STD_LOGIC;
signal tb_clken_1ms :  STD_LOGIC;
-- signaux read component
signal tb_clk100 :  std_logic;
signal tb_enable :  std_logic;
signal tb_onewire_in :  std_logic;
signal tb_onewire_out :  std_logic;
signal tb_end_read:  std_logic;
signal tb_value_out : std_logic_vector(8 downto 0);

begin

UUT2 : Time_gen port map(
clk100 => tb_clk100,
Reset_sync_clk100 => tb_reset_sync,
clken_1us => tb_clken_1us ,
clken_10us => tb_clken_10us,
clken_1ms => tb_clken_1ms
);
UUT : Read port map(
clk100 => tb_clk100 ,
clk10us => tb_clken_10us ,
clk1us => tb_clken_1us ,
reset => tb_reset_sync,
enable => tb_enable,
onewire_in => tb_onewire_in,
onewire_out => tb_onewire_out,
end_read => tb_end_read,
value_out=> tb_value_out

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

tb_enable <= '1';

tbb_onewire_in : process
begin
tb_onewire_in <= '0';
wait for 60us;
tb_onewire_in <= '1';
wait for 60us; 
end process;

end Behavioral;
