library ieee;
use ieee.std_logic_1164.all;

ENTITY testbench IS
END ENTITY testbench;

architecture test of testbench is
component Module1 is
port (
      Datat_in : in std_logic_vector(7 downto 0);
      Data_out : out std_logic_vector(7 downto 0);
      clk : in std_logic;
      Clock_En : in std_logic ;
      Reset : in std_logic
      );

end component Module1 ;

SIGNAL T_Datat_in :  std_logic_vector(7 downto 0):="00000000" ;
SIGNAL T_Data_out :  std_logic_vector(7 downto 0):="00000000";
SIGNAL t_clk : std_logic := '0'; 
SIGNAL T_Clock_En : std_logic := '0';
SIGNAL T_Reset : std_logic := '0';
constant delay_time: time := 20 ns;

BEGIN
 dut: Module1 PORT MAP(T_Datat_in,T_Data_out,t_clk,T_Clock_En,T_Reset);

clock: PROCESS IS
BEGIN
T_clk <= '0', '1' AFTER 10 ns;
WAIT FOR 20 ns;

END PROCESS clock;

p1:process is 
BEGIN

T_Datat_in <= "11111111";
T_Clock_En <= '1';
T_Reset <= '1';


wait for delay_time;

T_Datat_in <= "11111111";
T_Clock_En <= '0';
T_Reset <= '1';

wait for delay_time;

T_Datat_in <= "11111111";
T_Clock_En <= '0';
T_Reset <= '0';

wait for delay_time;

T_Datat_in <= "11111111";
T_Clock_En <= '1';
T_Reset <= '0';


wait for delay_time;
T_Datat_in <= "00000000";
T_Clock_En <= '0';
T_Reset <= '0';

wait for delay_time;
T_Datat_in <= "00000000";
T_Clock_En <= '1';
T_Reset <= '1';

wait for delay_time;
T_Datat_in <= "00000000";
T_Clock_En <= '0';
T_Reset <= '1';

		
wait for delay_time;
T_Datat_in <= "00000000";
T_Clock_En <= '1';
T_Reset <= '0';


END PROCESS p1;
End architecture test;