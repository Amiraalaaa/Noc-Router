
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY M_ROU_08 IS
	port(clock: in std_logic;
	     din1: in std_logic_vector(7 downto 0);
	     din2: in std_logic_vector(7 downto 0);
	     din3: in std_logic_vector(7 downto 0);
	     din4: in std_logic_vector(7 downto 0);
	     dout: out std_logic_vector(7 downto 0)
);
END ENTITY M_ROU_08;

ARCHITECTURE ARCH_M_ROU_08 of M_ROU_08 is

	TYPE state_type IS (turn1, turn2, turn3, turn4);
	SIGNAL current_state: state_type;
	SIGNAL next_state: state_type;
BEGIN

	P1:PROCESS(clock)
	BEGIN
		IF rising_edge(clock) THEN
			current_state <= next_state;
		END IF;
	END PROCESS P1;

	P2:PROCESS(current_state, din1, din2, din3, din4)
	BEGIN
		CASE current_state IS
			WHEN turn1 =>
				 dout <= din1;  next_state <= turn2;
			WHEN turn2 =>
				 dout <= din2;  next_state <= turn3;
			WHEN turn3 =>
				 dout <= din3;  next_state <= turn4;
			WHEN turn4 =>
				 dout <= din4;  next_state <= turn1;
		END CASE;
	END PROCESS P2; 


END ARCHITECTURE ARCH_M_ROU_08;