LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Gray3 IS
PORT ( clock, Reset, En : IN STD_LOGIC;
	Count_out : OUT STD_LOGIC_VECTOR (2 downto 0));
END ENTITY Gray3;

ARCHITECTURE GC3 OF Gray3 IS
SIGNAL si : STD_LOGIC_VECTOR(2 downto 0):="001";
BEGIN
	p1 : PROCESS(clock) IS BEGIN
	  IF clock = '1' AND clock'event THEN
	  IF Reset = '1' THEN si <= "001";
	  ELSIF En = '1' THEN
		CASE si IS
		WHEN "000" => si <= "001";
		WHEN "001" => si <= "011";
		WHEN "011" => si <= "010";
		WHEN "010" => si <= "110";
		WHEN "110" => si <= "111";
		WHEN "111" => si <= "101";
		WHEN "101" => si <= "100";
		WHEN OTHERS => si <= "000";
		END CASE;
	   END IF;
	END IF;
      END PROCESS p1;
  Count_out <= si;
END ARCHITECTURE GC3;
