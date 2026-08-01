----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.03.2026 16:47:38
-- Design Name: 
-- Module Name: tb_reset_gen - Behavioral
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

entity tb_reset_gen is
--  Port ( );
end tb_reset_gen;

architecture Behavioral of tb_reset_gen is
-- reste gen comoponent
component reset_gen
Port(
    clk100 : in std_logic;
    reset : in std_logic;
    reset_sync_clk100 : out std_logic 
);
end component;
-- siganux de test bench
signal tb_clk100 : std_logic :='0';
signal tb_reset : std_logic := '0';
signal tb_reset_sync_clk100 : std_logic :='0';

begin

-- component
UUT : reset_gen port map(
    clk100 => tb_clk100,
    reset =>tb_reset ,
    reset_sync_clk100 => tb_reset_sync_clk100
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

    tb_reset <= '1'; wait for 40 ns;
    tb_reset <= '0' ; wait for 40ns;
    tb_reset <= '1'; wait;
end process;

end Behavioral;
