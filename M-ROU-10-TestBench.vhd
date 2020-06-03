Library ieee;
USE ieee.std_logic_1164.ALL;

USE ieee.numeric_std.ALL;

ENTITY M10 IS
END ENTITY M10;

ARCHITECTURE behave of M10 IS
		SIGNAL wclock, rclock, rst:  std_logic;
		SIGNAL datai1,datai2, datai3, datai4: std_logic_vector ( 7 DOWNTO 0);
		SIGNAL wr1, wr2, wr3, wr4: std_logic;
		SIGNAL datao1,datao2, datao3, datao4: std_logic_vector ( 7 DOWNTO 0);

COMPONENT Router IS

	port(	wclock, rclock, rst: IN std_logic;
		datai1,datai2, datai3, datai4: IN std_logic_vector ( 7 DOWNTO 0);
		wr1, wr2, wr3, wr4: IN std_logic;
		datao1,datao2, datao3, datao4: OUT std_logic_vector ( 7 DOWNTO 0));

END COMPONENT Router;

FOR fourportRouter: Router USE ENTITY WORK.M9(ROUTER);

BEGIN

fourportRouter : Router PORT MAP (wclock, rclock, rst,datai1,datai2, datai3, datai4,wr1, wr2, wr3, wr4,datao1,datao2, datao3, datao4);
writeClock: PROCESS IS
BEGIN
wclock <= '0','1' AFTER 50 ns;
WAIT FOR 100 ns;
END PROCESS writeClock;

readClock: PROCESS IS
BEGIN
rclock <= '0','1' AFTER 50 ns;
WAIT FOR 100 ns;

END PROCESS readClock;


test_strategy: PROCESS IS
BEGIN

rst<='1';
rst<='0';

datai1 <= "11111100","ZZZZZZZZ" AFTER 100 ns;
datai2 <= "11111101","ZZZZZZZZ" AFTER 100 ns;  
datai3 <= "11111110","ZZZZZZZZ" AFTER 100 ns; 
datai4 <= "11111111","ZZZZZZZZ" AFTER 100 ns;
  wr1 <= '1','0' AFTER 100 ns; 
wr2 <= '1','0' AFTER 100 ns; 
 wr3 <= '1','0' AFTER 100 ns; 
  wr4 <= '1','0' AFTER 100 ns; 
WAIT FOR 250 ns;
ASSERT datao1 = "11111100" REPORT  "error: testcase01"SEVERITY warning;
WAIT FOR 100 ns;
ASSERT datao2 = "11111101" REPORT  "error: testcase02"SEVERITY warning;  
WAIT FOR 100 ns;
ASSERT datao3 = "11111110" REPORT  "error: testcase03"SEVERITY warning;
WAIT FOR 100 ns;
ASSERT datao4 = "11111111" REPORT  "error: testcase04"SEVERITY warning;


datai1 <= "00001111","ZZZZZZZZ" AFTER 100 ns;
datai2 <= "00001100","ZZZZZZZZ" AFTER 100 ns;  
datai3 <= "00001101","ZZZZZZZZ" AFTER 100 ns; 
datai4 <= "00001110","ZZZZZZZZ" AFTER 100 ns;
wr1 <= '1','0' AFTER 100 ns; 
wr2 <= '1','0' AFTER 100 ns; 
wr3 <= '1','0' AFTER 100 ns; 
wr4 <= '1','0' AFTER 100 ns;
WAIT FOR 250 ns;


ASSERT datao1 = "00001100" REPORT  "error: testcase05"SEVERITY warning; 
WAIT FOR 100 ns;  
ASSERT datao2 = "00001101" REPORT  "error: testcase06"SEVERITY warning;
WAIT FOR 100 ns; 
ASSERT datao3 = "00001110" REPORT  "error: testcase07"SEVERITY warning;
WAIT FOR 100 ns;   
ASSERT datao4 = "00001111" REPORT  "error: testcase08"SEVERITY warning;
WAIT FOR 100 ns;



datai1 <= "10001110","ZZZZZZZZ" AFTER 100 ns;
datai2 <= "10001111","ZZZZZZZZ" AFTER 100 ns;  
datai3 <= "10001100","ZZZZZZZZ" AFTER 100 ns; 
datai4 <= "10001101","ZZZZZZZZ" AFTER 100 ns;
wr1 <= '1','0' AFTER 100 ns; 
wr2 <= '1','0' AFTER 100 ns; 
wr3 <= '1','0' AFTER 100 ns; 
wr4 <= '1','0' AFTER 100 ns;
WAIT FOR 250 ns;
ASSERT datao1 = "10001100" REPORT  "error: testcase09"SEVERITY warning;   
WAIT FOR 100 ns;
ASSERT datao2 = "10001101" REPORT  "error: testcase10"SEVERITY warning;  
WAIT FOR 100 ns;
ASSERT datao3 = "00001110" REPORT  "error: testcase11"SEVERITY warning;   
WAIT FOR 100 ns; 
ASSERT datao4 = "00001111" REPORT  "error: testcase12"SEVERITY warning;  
WAIT FOR 100 ns;

datai1 <= "11001101","ZZZZZZZZ" AFTER 100 ns;
datai2 <= "11001110","ZZZZZZZZ" AFTER 100 ns;  
datai3 <= "11001111","ZZZZZZZZ" AFTER 100 ns; 
datai4 <= "11001100","ZZZZZZZZ" AFTER 100 ns;
	wr1 <= '1','0' AFTER 100 ns; 
wr2 <= '1','0' AFTER 100 ns; 
wr3 <= '1','0' AFTER 100 ns; 
wr4 <= '1','0' AFTER 100 ns;
WAIT FOR 250 ns;  
ASSERT datao1 = "11001100" REPORT  "error: testcase13"SEVERITY warning;  
WAIT FOR 100 ns; 
ASSERT datao2 = "11001101" REPORT  "error: testcase14"SEVERITY warning;   
WAIT FOR 100 ns;
ASSERT datao3 = "11001110" REPORT  "error: testcase15"SEVERITY warning;   
WAIT FOR 100 ns;
ASSERT datao4 = "11001111" REPORT  "error: testcase16"SEVERITY warning;  
WAIT FOR 100 ns;




wait;
END PROCESS test_strategy;



END behave;
