----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.03.2026 10:58:43
-- Design Name: 
-- Module Name: Write8b - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Write8b is
  Port (
  clk100 : in std_logic;
  clk10us : in std_logic;
  clk1us : in std_logic;
  reset : in std_logic;
  enable : in std_logic;
  message8b_in : in std_logic_vector(7 downto 0);
  message8b_out : out std_logic
   );
end Write8b;

architecture Behavioral of Write8b is
-- definition de la machine d'etat por la fonction write
type w_state is (S_idle, S_start, S_read, S_wait_60us, S_wait_10us, S_release,S_counter);
signal p_state : w_state := S_idle;

-- compteur qui pointe vers le bit qu'on est entrain d'envoyer
signal counter : integer range 0 to 10 := 0;
-- signal qui sauvegarde le maessage à transmettre le message_in : mot de 8 bits
signal sig_8bit_word : std_logic_vector(7 downto 0);
-- signal of the current bit 
signal p_bite : std_logic;
-- counter clk 10us and 1 us
signal count_10us : integer range 0 to 10;
signal count_1us : integer range 0 to 10;
begin

process(clk100,reset)
begin
    if reset = '1' then
        p_state <= S_idle;
    elsif rising_edge(clk100) then
        case p_state is
            -- etat par defaut sirtie ets mise à 1
            when S_idle => 
                message8b_out <= '1';
                
                counter <= 0;
                if enable = '1' then
                    p_state <= S_start;
                end if;
            -- apres enable est activée on rentre d ans la machine d'etat
            when S_start =>
                counter <= 0;
                sig_8bit_word <= message8b_in;
                p_state <= S_read;
            -- verifier le bit qu'on est entrain d'envoyer
            when S_read => 
                count_10us <= 0;
                count_1us <= 0;
                -- bite 0
                if sig_8bit_word(counter) = '0' then
                    p_state <= S_wait_60us;
                -- bite 1
                else
                    p_state <= S_wait_10us;
                end if;
            -- pour envoyer 0 on attende 60 us
            when S_wait_60us =>             
                message8b_out <= '0';
                if clk10us = '1' then
                    count_10us <= count_10us + 1;       
                end if ;  
                if count_10us = 6 then
                    p_state <= S_release;
                end if;
            -- pour envoyer 1 on attend e10 us à 0 puis 60 us à 1
            when S_wait_10us =>   
                if count_10us = 0 then
                    message8b_out <= '0';
                    p_state <= S_wait_10us;
                elsif count_10us = 1 then
                    message8b_out <= '1'; 
                    p_state <= S_wait_10us;   
                elsif count_10us = 6 then
                    message8b_out <= '1';
                    p_state <= S_release;      
                end if;
                if clk10us = '1' then
                    count_10us <= count_10us + 1;       
                end if ;  
 
            -- entre deux bits il faut attendre 1 us
            when S_release =>
                message8b_out <= '1';
                if clk1us = '1' then
                    count_1us <= count_1us + 1;
                end if;
                if count_1us = 1 then 
                    p_state <= S_counter;
                end if;
            -- on met à jour le compteur pour lire les 8 bits
            when S_counter =>
                if counter < 7 then
                    counter <= counter + 1;
                    p_state <= S_read;
                else
                    
                    p_state <= S_idle;
                    
                end if;
                
            when others =>
                p_state <= S_idle;
                
            
        end case;
    end if;
    
end process;

end Behavioral;
