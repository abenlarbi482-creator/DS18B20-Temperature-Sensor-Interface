----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.04.2026 16:21:24
-- Design Name: 
-- Module Name: wire_out - Behavioral
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

entity wire_out is
Port ( onewire_out_clk100_INIT : in std_logic;
onewire_out_clk100_Write: in std_logic;
onewire_out_clk100_Read : in std_logic;
onewire_out_clk100 : out std_logic
);
end wire_out;

architecture Behavioral of wire_out is

begin


end Behavioral;
