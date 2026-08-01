----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.04.2026 23:43:03
-- Design Name: 
-- Module Name: Read - Behavioral
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

entity Read is
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
end Read;

architecture Behavioral of Read is

-- machine d'etat 
type w_state is (R_idle,R_0_for1us, R_wait10us, R_read, R_wait60us,R_wait1us,R_end);
signal p_state : w_state := R_idle;

--signaux de comptage
signal cpt_10us : integer range 0 to 6:=0; 
signal cpt_1us : integer range 0 to 2:=0;
signal cpt_60us : integer range 0 to 6:=0; 
signal counter : integer range 0 to 9:=0; 

signal wire_value : std_logic_vector(8 downto 0) := (others => '0');

begin

process(clk100,reset)
begin
    if reset = '1' then
        p_state <= R_idle;
    elsif rising_edge(clk100) then
        case p_state is
        -- initialiser tous les compteurs et attendre le enable
        -- pour commencer la lecture
            when R_idle =>
                cpt_10us <= 0;
                cpt_1us <= 0;
                counter <= 0;
                end_read <= '0';
                --mettre 1 
                if enable = '1' then
                    p_state <= R_0_for1us;
                end if;
                -- FPGA le master va agir en preimeri en mettant le wre à 0 
                -- pendat 1 us
                
            when R_0_for1us =>
            -- n'oublie pas de mettre cpt_1us à O apres la find ela amichine d'etat avant de lite le bit prochain
                if cpt_1us = 1 then
                    onewire_out <= '1';
                    cpt_1us <= 0;
                    p_state <= R_wait10us;
                else
                    onewire_out <= '0';
                    p_state <= R_0_for1us;
                end if;
                if clk1us = '1' then
                    cpt_1us <= cpt_1us + 1;
               end if;
               -- lire le wire apres 10 us
            when R_wait10us =>
                if cpt_10us = 1 then
                    p_state <= R_read;
                elsif clk10us = '1' then
                    cpt_10us <= cpt_10us +1;
                   
                    p_state <= R_wait10us;
                end if;
                -- lire le wire apres 10 us
            when R_read =>
                wire_value(counter) <= onewire_in; 
                p_state <= R_wait60us;
                -- attendre le cyxle de la leclecture dechaque bit
                -- qui dure 60 us avant de lire à nouveau
            when R_wait60us =>
                if cpt_60us = 5 then
                    p_state <= R_end;
                elsif  clk10us ='1' then
                    cpt_60us <= cpt_60us + 1;
                end if;
                -- verifier si on a lu les 9 bits si non on incremente 
                --le compteur de position de bit entrain d'etre lu
            when R_end =>
                if counter = 8 then 
                    end_read <= '1';
                    p_state <= R_end;
                 else
                    cpt_10us <= 0;
                    cpt_1us <= 0;
                    cpt_60us <= 0;
                    counter <= counter + 1;  
                    p_state <= R_0_for1us;     
                 end if;
                                
            when others =>
                p_state <= R_idle; 
        end case;
    end if;
 end process;
value_out <= wire_value;
end Behavioral;
