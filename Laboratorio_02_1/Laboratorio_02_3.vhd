-------------------------------------

LIBRARY ieee;

USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-------------------------------------

ENTITY Laboratorio_02_3 IS

PORT (

chaves: IN STD_LOGIC_VECTOR(3 DOWNTO 0);

led: OUT STD_LOGIC);

END ENTITY;

------------------------------------

ARCHITECTURE Laboratorio_02_3 OF Laboratorio_02_3 IS

	signal counter1: unsigned(0 to 3);
	signal counter2: unsigned(0 to 3);
	signal counter3: unsigned(0 to 3);
	signal counter4: unsigned(0 to 3);
	
BEGIN
	
	counter1 <= "0001" WHEN (chaves(0) = '1') ELSE
					"0000";
	
	counter2 <= counter1 + 1 WHEN (chaves(1) = '1') ELSE 
					counter1;
					
	counter3 <= counter2 + 1 WHEN (chaves(2) = '1') ELSE 
					counter2;
					
	counter4 <= counter3 + 1 WHEN (chaves(3) = '1') ELSE 
					counter3;
	
	---
	--- LEDS 
	---
	
	led <= '1' when (counter4 = "0010") OR (counter4 = "0011") ELSE '0';
	
END ARCHITECTURE;