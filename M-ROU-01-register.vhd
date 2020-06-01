library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Module1 is 
port (
      Datat_in : in std_logic_vector(7 downto 0);
      Data_out : out std_logic_vector(7 downto 0);
      clk : in std_logic;
      Clock_En : in std_logic ;
      Reset : in std_logic
      );
end entity Module1 ;

architecture Behav1 of Module1 is 
begin
process(clk,Reset)
begin
IF rising_edge(clk) and Clock_En = '1' and  Reset = '0' then
Data_out <= Datat_in ;
end if;
IF reset = '1' then 
Data_out <= "00000000";
end if;
IF Clock_En = '0' then
NULL ;
end if;
end process;
end architecture Behav1 ;
 


