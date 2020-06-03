LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
library work;
use work.all;

ENTITY controller5 IS

PORT( reset, rdclk,wrclk,r_req,w_req: IN std_logic;
write_valid,read_valid,empty,full: OUT std_logic;
 wr_ptr,rd_ptr : out std_logic_vector(2 downto 0)  );

END ENTITY controller5;
ARCHITECTURE fifo OF controller5 IS
component Gray3
   PORT ( clock, Reset, En : IN STD_LOGIC;
	Count_out : OUT STD_LOGIC_VECTOR (2 downto 0));
end component;

component Converter3
PORT( gray_in : IN STD_LOGIC_VECTOR(2 downto 0);
      bin_out : OUT STD_LOGIC_VECTOR(2 downto 0));
end component;

--signal wr_en,rd_en: std_logic;
  signal wr_counter_out,rd_counter_out,wr_converter_out,rd_converter_out: std_logic_vector(2 downto 0);
shared variable written_status : std_logic_vector(7 downto 0):= "00000000";
shared variable rd_address,wr_address:std_logic_vector(2 downto 0):="000";
signal wr_en,rd_en:std_logic; 
shared variable prev_wr_converter_out,prev_rd_converter_out :std_logic_vector(2 downto 0);
BEGIN


wr_counter: Gray3 port map 
      ( clock => wrclk,Reset=>reset ,En=>wr_en,Count_out=>wr_counter_out);
wr_converter: Converter3 port map 
      ( gray_in => wr_counter_out,bin_out=>wr_converter_out );

rd_counter: Gray3 port map 
      ( clock => wrclk,Reset=>reset ,En=>rd_en,Count_out=>rd_counter_out);
rd_converter: Converter3 port map 
      ( gray_in => rd_counter_out,bin_out=>rd_converter_out );

 PROCESS (reset,wr_converter_out,rd_converter_out,r_req,w_req,wrclk)
BEGIN

IF reset = '1' THEN

empty<='1';
full<='0';
written_status:= "00000000";
END IF;
IF wr_converter_out /= prev_wr_converter_out THEN
wr_en<='0';
wr_ptr<=wr_address;
written_status( to_integer(unsigned(wr_address))):='1';
write_valid<='0';
wr_address:=wr_converter_out;
END IF;
IF rd_converter_out /= prev_rd_converter_out THEN
rd_en<='0';
rd_ptr<=rd_address;
written_status( to_integer(unsigned(rd_address))):='0';
read_valid<='0';
rd_address:=rd_converter_out;
END IF;

IF written_status="11111111" THEN
full<='1';
empty<='0';

ELSIF written_status="00000000" THEN
empty<='1';
full<='0';

ELSE
full<='0';
empty<='0';
END IF;



IF r_req = '1' and written_status( to_integer(unsigned(rd_address)))='1' THEN

rd_en<='1';
read_valid<='1';

END IF;
IF w_req = '1' and written_status( to_integer(unsigned(wr_address)))='0' THEN
--test<=written_status( to_integer(unsigned(rd_address)));
write_valid<='1';
wr_en<='1';


END IF;




prev_wr_converter_out:=wr_converter_out;
prev_rd_converter_out:=rd_converter_out;
END PROCESS ;




END ARCHITECTURE fifo;
	
