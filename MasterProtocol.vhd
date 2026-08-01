----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 10.04.2026 10:02:20
-- Design Name:
-- Module Name: Master_protocol - Behavioral
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

entity Master_protocol is
Port ( clk100, clken_1ms, Reset_sync_clk100: in std_logic;
    start : in std_logic;
    start_INIT : out std_logic;
    INIT_out : in std_logic_vector(1 downto 0);
    start_Write : out std_logic ;
    Write_out : in std_logic;
    Byte_to_Write : out std_logic_vector(7 downto 0);
    start_Read : out std_logic;
    Read_out : in std_logic
);
end Master_protocol;


architecture Behavioral of Master_protocol is
    --declaration du type state
    type state is (Idle, wait_INIT, Write_XCC, Write_X44, Write_XBE, wait_800ms, Read);
    signal state_now : state;
    --signal pour svoir dans quelle etape decriture on est
    signal etape: integer range 1 to 2;
    --signal pour compter a chaque fois
    signal cpt_1ms: integer range 0 to 800;
    begin
    process(clk100, Reset_sync_clk100)
        begin
        if Reset_sync_clk100 = '1' then
            etape <= 1;
            start_INIT<='0';
            start_Write<='0';
            Byte_to_Write<="00000000";
            start_Read<='0';
            cpt_1ms<=0;
            state_now <= Idle;
        elsif rising_edge(clk100) then
            case state_now is
                --etat d initialisation:
                when Idle =>
                    etape <= 1;
                    start_INIT<='0';
                    start_Write<='0';
                    Byte_to_Write<="00000000";
                    start_Read<='0';
                    cpt_1ms<=0;
                    if start = '1' then
                        --quand start ='1' je comence mon INIT
                        start_INIT<='1';
                        state_now <= wait_INIT;
                    else
                        state_now <= Idle;
                    end if;
                    -- j'attend la reponse de mon INIT
                when wait_INIT =>
                    start_INIT<='0';
                    --tout ce passe bien dans INIT donc je passe a Write
                    if INIT_out = "11" then
                        state_now <= Write_XCC;
                        start_Write<='1';
                        Byte_to_Write<="11001100";
                    -- INIT est finie mais il y une erreure donc je remonte a Idle
                    elsif INIT_out = "10" then
                        state_now <= Idle;
                    else 
                        state_now <= wait_INIT;
                    end if;
                    --j'attend l'ectriture de XCC est je decide letat dapres apartir du signal etape
                when Write_XCC =>
                    start_Write<='0';
                    if ( Write_out ='1' and etape =1 ) then
                        state_now <= Write_X44;
                        start_Write<='1';
                        Byte_to_Write<="01000100";
                    elsif ( Write_out ='1' and etape =2 ) then
                        state_now <= Write_XBE;
                        start_Write<='1';
                        Byte_to_Write<="10111110";
                    else 
                        state_now <= Write_XCC;
                    end if;
                --j'attend l'ectriture de X44 est je decide letat dapres apartir du signal etape
                when Write_X44 =>
                    start_Write<='0';
                    if Write_out ='1' then
                        state_now <= wait_800ms;
                    else 
                        state_now <= Write_X44;
                    end if;
                --j'attend 800ms avant la 2 eme etape
                when wait_800ms =>
                    if cpt_1ms = 80 then
                        start_INIT<='1';
                        state_now <= wait_INIT;
                        etape <= 2;
                    elsif clken_1ms ='1' then
                        cpt_1ms <= cpt_1ms + 1;
                        state_now <= wait_800ms;
                    end if;
                --j'attend la fin de Write_BE pour comencer la lecture
                when Write_XBE =>
                    start_Write<='0';
                    if Write_out ='1' then
                        state_now <= Read;
                    else 
                        state_now <= Write_XBE;
                    end if;
                --Quand la lecture est finie je remonte à Idle
                when Read =>
                    start_Write<='0';
                    if Read_out ='1' then
                        state_now <= Idle;
                    else 
                        state_now <= Read;
                    end if;
                when others => state_now <= Idle;
            end case;
        end if;
    end process;



end Behavioral;
