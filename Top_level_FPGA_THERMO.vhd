library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Top_level_FPGA_THERMO is
  Port ( clk100, reset : in std_logic;
  onewire_in : in std_logic;
  debug_in : in std_logic_vector( 7 downto 0);
  onewire_out : out std_logic;
  value : out std_logic_vector(8 downto 0);
  start : in std_logic
  );
end Top_level_FPGA_THERMO;

architecture Behavioral of Top_level_FPGA_THERMO is


  component Time_gen
  Port (
  clk100 : in std_logic;
  Reset_sync_clk100 : in std_logic;
  clken_1us : out std_logic;
  clken_10us : out std_logic;
  clken_1ms : out std_logic
  );
  end component;
  
  component INIT is
  Port (
    clk100, clken_10us, Reset_sync_clk100: in std_logic;
    start : in std_logic;
    onewire_in_clk100: in std_logic;
    onewire_out_clk100: out std_logic;
    INIT_out : out std_logic_vector(1 downto 0)
    );
  end component;
  
  component Reset_gen is
  Port (
    clk100 : in std_logic;
    reset : in std_logic;
    Reset_sync_clk100 : out std_logic
    );
  end component;
  
  component Tristate_buffer is
    Port(
    onewire_out_clk100: in std_logic;
    onewire_out: out std_logic
    );
  end component;
  
  component Resynchro is
  Port (
    clk100 : in std_logic;
    reset_sync : in std_logic;
    debug_in : in std_logic_vector(7 downto 0);
    onewire_in : in std_logic;
    onewire_in_clk : out std_logic;
    debug_in_clk : out std_logic_vector(7 downto 0)
    );
  end component;
  
  component Write8b is
  Port (
    clk100 : in std_logic;
    clk10us : in std_logic;
    clk1us : in std_logic;
    reset : in std_logic;
    enable : in std_logic;
    message8b_in : in std_logic_vector(7 downto 0);
    message8b_out : out std_logic;
    write_out : out std_logic
    );
  end component;
  
  component Master_protocol is
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
  end component;
  
  component wire_out is
    Port ( onewire_out_clk100_INIT : in std_logic;
    onewire_out_clk100_Write: in std_logic;
    onewire_out_clk100_Read : in std_logic;
    onewire_out_clk100 : out std_logic
    );
  end component;
  
  component Read is
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
  
  
  signal clken_1us: std_logic := '0';
  signal clken_10us: std_logic := '0';
  signal clken_1ms : std_logic := '0';
  signal onewire_in_clk100 : std_logic := '1';
  signal onewire_out_clk100 : std_logic := '1';
  signal Reset_sync_clk100 : std_logic := '1';
  signal debug_in_clk100 : std_logic_vector(7 downto 0);
  signal debug_out_clk100 : std_logic_vector(7 downto 0);
  signal INIT_out_interne : std_logic_vector(1 downto 0);
  signal start_INIT: std_logic ;
  signal start_Write: std_logic ;
  signal Write_out: std_logic ;
  signal Byte_to_Write: std_logic_vector(7 downto 0) ;
  signal start_Read: std_logic ;
  signal Read_out: std_logic ;
  signal onewire_out_clk100_INIT: std_logic ;
  signal onewire_out_clk100_Write: std_logic ;
  signal onewire_out_clk100_Read: std_logic ;
  begin
  
  -- Instanciation Reset_gen
  UU1 : Reset_gen
  port map( clk100 => clk100,
  reset => reset,
  Reset_sync_clk100 => Reset_sync_clk100
  );
  
  -- Instanciation Time_gen
  UU2 : Time_gen
    port map(
    clk100 => clk100,
    Reset_sync_clk100 => Reset_sync_clk100,
    clken_1us => clken_1us,
    clken_10us => clken_10us,
    clken_1ms => clken_1ms
    );
  
  -- Instanciation Resynchro
  UU3 : Resynchro
  port map(
    clk100 => clk100,
    reset_sync => Reset_sync_clk100,
    debug_in => debug_in_clk100,
    onewire_in => onewire_in,
    onewire_in_clk => onewire_in_clk100,
    debug_in_clk => debug_in_clk100
    );
  
  -- Instanciation INIT
  UU4 : INIT
  port map(
    clk100 => clk100,
    clken_10us => clken_10us,
    Reset_sync_clk100 => Reset_sync_clk100,
    start => start_INIT,
    onewire_in_clk100 => onewire_in_clk100,
    onewire_out_clk100 => onewire_out_clk100_INIT,
    INIT_out => INIT_out_interne
    );
  
  -- Instanciation Tristate_buffer
  UU5: Tristate_buffer
  port map(onewire_out_clk100 => onewire_out_clk100,
    onewire_out => onewire_out
    );
    
  -- Instanciation Write
  UU6 : Write8b
  port map(
    clk100 => clk100,
    clk10us => clken_10us,
    clk1us => clken_1us,
    reset => Reset_sync_clk100,
    enable => start_Write,
    message8b_in => Byte_to_Write,
    message8b_out => onewire_out_clk100_Write,
    write_out => Write_out
    );
  
  -- Instanciation Master_protocol
  UU7 : Master_protocol
  Port map ( clk100 => clk100,
    clken_1ms => clken_1ms,
    Reset_sync_clk100=> Reset_sync_clk100,
    start => start,
    start_INIT => start_INIT,
    INIT_out => INIT_out_interne,
    start_Write => start_Write,
    Write_out => write_out,
    Byte_to_Write => Byte_to_Write,
    start_Read => start_Read,
    Read_out => Read_out );
    
  -- Instanciation Read
  UU9: Read
  Port map( clk100 => clk100,
    clk10us => clken_10us,
    clk1us => clken_1ms,
    reset => Reset_sync_clk100,
    enable => start_Read,
    onewire_in => onewire_in_clk100,
    onewire_out => onewire_out_clk100_Read,
    value_out => value,
    end_read => Read_out
  );
  
  -- Instanciation wire out
  UU10: wire_out
  port map(onewire_out_clk100_Write => onewire_out_clk100_Write,
    onewire_out_clk100_INIT => onewire_out_clk100_INIT,
    onewire_out_clk100_Read => onewire_out_clk100_Read,
    onewire_out_clk100 => onewire_out_clk100
  );

end Behavioral;
