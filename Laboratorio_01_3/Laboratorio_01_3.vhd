-------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-------------------------------------
ENTITY Laboratorio_01_3 IS
	PORT (
		c1, c2: IN STD_LOGIC;
		led1, led2, led3, led4: OUT STD_LOGIC);
END ENTITY;
------------------------------------
ARCHITECTURE Laboratorio_01_3 OF Laboratorio_01_3 IS
BEGIN	
	led1 <= not(c1) and not(c2);
	led2 <= not(c1) and c2;
	led3 <= c1 and not(c2); 
	led4 <= c1 and c2;
END ARCHITECTURE;