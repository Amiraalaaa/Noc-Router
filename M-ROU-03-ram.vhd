LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY M_ROU_03 IS
	port(d_in: in std_logic_vector(7 downto 0);
	     d_out: out std_logic_vector(7 downto 0);
	     WEA: in std_logic;
	     REA: in std_logic;
	     ADDRA: in std_logic_vector(2 downto 0);
 	     ADDRB: in std_logic_vector(2 downto 0);
	     CLKA: in std_logic;
	     CLKB: in std_logic);
END ENTITY M_ROU_03;

ARCHITECTURE ARCH_M_ROU_03 of M_ROU_03 is

	type rm is array (0 to 5) of std_logic_vector (7 downto 0); -- array of 5 words 8 bits each  
	shared variable word: rm; 

	
begin
	P1: process(CLKA)
	begin
		if( CLKA' event and CLKA='1' and WEA='1') then 
				word(conv_integer(ADDRA)):= d_in; --write
		end if;
	end process  P1;

	P2: process(CLKB)
	begin
		if(CLKB' event and CLKB='1' and REA='1') then 
				d_out <= word(conv_integer(ADDRB)); -- read
		elsif(REA ='0') then
			d_out<="ZZZZZZZZ"; -- Shhh! the ram is sleeping
		end if;

	end process  P2;

END ARCHITECTURE ARCH_M_ROU_03;
