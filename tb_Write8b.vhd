----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.04.2026 10:28:13
-- Design Name: 
-- Module Name: tb_Write8b - Behavioral
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

entity tb_Write8b is
--  Port ( );
end tb_Write8b;

architecture Behavioral of tb_Write8b is
-- component
component Write8b 
  Port (
  clk100 : in std_logic;
  clk10us : in std_logic;
  clk1us : in std_logic;
  reset : in std_logic;
  enable : in std_logic;
  message8b_in : in std_logic_vector(7 downto 0);
  message8b_out : out std_logic
  
   );
end component;


component Time_gen 
 Port (
           clk100 : in STD_LOGIC;
           Reset_sync_clk100 : in STD_LOGIC;
           clken_1us : out STD_LOGIC;
           clken_10us : out STD_LOGIC;
           clken_1ms : out STD_LOGIC
            );
end component;

--signaux de test bunch
signal tb_clk100 :  std_logic;
signal tb_enable : std_logic;
signal tb_message8b_in : std_logic_vector(7 downto 0);
signal tb_message8b_out : std_logic;


-- compoent time gen
signal tb_reset_sync : STD_LOGIC;
signal tb_clken_1us : STD_LOGIC;
signal tb_clken_10us : STD_LOGIC;
signal tb_clken_1ms :  STD_LOGIC;

begin

UUT2 : Time_gen port map(
clk100 => tb_clk100,
Reset_sync_clk100 => tb_reset_sync,
clken_1us => tb_clken_1us ,
clken_10us => tb_clken_10us,
clken_1ms => tb_clken_1ms
);
UUT : Write8b port map(
clk100 => tb_clk100,
clk10us => tb_clken_10us,
clk1us => tb_clken_1us ,
reset => tb_reset_sync,
enable => tb_enable,
message8b_in => tb_message8b_in,
message8b_out => tb_message8b_out

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


tb_message8b_in <= "10001110";


tbb_enable : process 
begin
tb_enable <= '0';
wait for 1us;
tb_enable <= '1';
wait;
end process;

end Behavioral;
