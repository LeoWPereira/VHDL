-------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-------------------------------------
ENTITY Laboratorio_01_2 IS
	PORT (
		c1, c2, c3: IN STD_LOGIC;
		led1, led2, led3, led4, led5, led6, led7, led8: OUT STD_LOGIC);
END ENTITY;
------------------------------------
ARCHITECTURE Laboratorio_01_2 OF Laboratorio_01_2 IS
BEGIN	
	led1 <= c1 and c2 and c3;
	led2 <= not(c1 and c2 and c3);
	led3 <= c1 or c2 or c3; 
	led4 <= not(c1 or c2 or c3);
	led5 <= c1 xor c2 xor c3;
	led6 <= not(c1 xor c2 xor c3);
	led7 <= not c1;
	led8 <= c1;
END ARCHITECTURE;