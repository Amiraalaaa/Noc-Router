
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY decider IS
port (	     clock: in std_logic;
	     Eflag1,Eflag2,Eflag3,Eflag4: in std_logic;
	     outFlag: out std_ulogic
	
      );
END ENTITY decider;

ARCHITECTURE behaveofdecider of decider is

	TYPE state_type IS (E1,E2,E3,E4);
	SIGNAL current_state: state_type;
	SIGNAL next_state: state_type;
	
BEGIN
	--turn<= E1;

	P1:PROCESS(clock)
	BEGIN
		IF rising_edge(clock) THEN
			current_state <= next_state;
			--turn<= next_state;
		END IF;

	END PROCESS P1;

	P2:PROCESS(current_state, Eflag1, Eflag2, Eflag3, Eflag4)
	BEGIN
		CASE current_state IS
			WHEN E1 =>
				next_state <= E2; 
				if Eflag1 = '0' then
				outFlag <= '1';
				else
				outFlag<='0';
				end if;
			WHEN E2 =>
				next_state <= E3;
				if Eflag2 = '0' then
				outFlag <= '1';
				else
				outFlag<='0';
				end if;
			WHEN E3 =>
				next_state <= E4;
				if Eflag3 = '0' then
				outFlag <= '1';
				else
				outFlag<='0';
				end if;
			WHEN E4 =>
				next_state <= E1;
				if Eflag4 = '0' then
				outFlag <= '1';
				else
				outFlag<='0';
				end if;

		END CASE;
	END PROCESS P2; 


END ARCHITECTURE behaveofdecider;
