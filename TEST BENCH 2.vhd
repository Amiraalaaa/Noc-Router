library ieee;
use ieee.std_logic_1164.all;

ENTITY testbench2 IS
END ENTITY testbench2;

architecture test2 of testbench2 is
component Modulee2 is
port (
       d_in : in std_logic_vector(7 downto 0);
       d_out1 : out std_logic_vector(7 downto 0);
       d_out2 : out std_logic_vector(7 downto 0);
       d_out3 : out std_logic_vector(7 downto 0);
       d_out4 : out std_logic_vector(7 downto 0);
       SEL : in std_logic_vector(1 downto 0);
       En : in std_logic
      );
end component Modulee2 ;



SIGNAL X_d_in:  std_logic_vector(7 downto 0):="00000000" ;
SIGNAL X_d_out1 :  std_logic_vector(7 downto 0):="00000000";
SIGNAL X_d_out2 :  std_logic_vector(7 downto 0):="00000000";
SIGNAL X_d_out3 :  std_logic_vector(7 downto 0):="00000000";
SIGNAL X_d_out4 :  std_logic_vector(7 downto 0):="00000000";
SIGNAL X_SEL :  std_logic_vector(1 downto 0) := "00" ; 
SIGNAL X_En : std_logic := '0';
constant delay_time: time := 2 ns;

BEGIN
dut: Modulee2 Port Map(X_d_in,X_d_out1,X_d_out2,X_d_out3,X_d_out4,X_SEL,X_En);

p2:process is 
BEGIN
X_En <= '1' ,  '0' AFTER 10 ns;
WAIT FOR 20 ns;
END process p2;


p3: process is 
BEGIN
X_d_in <= "00000000" ;
X_SEL <="00";
wait for delay_time;
X_SEL <="01";
wait for delay_time;
X_SEL <="10";
wait for delay_time;
X_SEL <="11";
wait for delay_time;

X_d_in <= "11111111" ;
X_SEL <="00";
wait for delay_time;
X_SEL <="01";
wait for delay_time;
X_SEL <="10";
wait for delay_time;
X_SEL <="11";
wait for delay_time;

end process p3;


End architecture test2 ;







