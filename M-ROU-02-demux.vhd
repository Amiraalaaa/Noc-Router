library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.all;

entity Modulee2 is 
port (
       d_in : in std_logic_vector(7 downto 0);
       d_out1 : out std_logic_vector(7 downto 0);
       d_out2 : out std_logic_vector(7 downto 0);
       d_out3 : out std_logic_vector(7 downto 0);
       d_out4 : out std_logic_vector(7 downto 0);
       SEL : in std_logic_vector(1 downto 0);
       En : in std_logic
      );

end entity Modulee2 ;

architecture Behavv2 of Modulee2 is 

signal SELout:  std_logic_vector(1 downto 0);
begin

P1:Process(d_in,Sel,En)
begin
if En = '1' Then
case SEL is 
when "00" => d_out1 <= d_in ;
d_out2 <= "00000000";
d_out3 <= "00000000";
d_out4 <= "00000000";

when "01" => d_out2 <= d_in ;
d_out1 <= "00000000";
d_out3 <= "00000000";
d_out4 <= "00000000";

when "10"=>d_out3<= d_in ;
d_out1 <= "00000000";
d_out2 <= "00000000";
d_out4 <= "00000000";
when "11" => d_out4 <= d_in ;
d_out1 <= "00000000";
d_out2 <= "00000000";
d_out3 <= "00000000";

when others =>d_out1 <= "00000000" ;
d_out2 <= "00000000";
d_out3 <= "00000000";
d_out4 <= "00000000";
end case;
end if ; 
end Process;
end Behavv2;