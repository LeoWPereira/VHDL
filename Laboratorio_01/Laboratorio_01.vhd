-------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-------------------------------------
ENTITY Laboratorio_01 IS
	PORT (
		c1, c2, c3, c4, c5, c6, c7, c8, c9, c10: IN STD_LOGIC;
		y: OUT STD_LOGIC);
END ENTITY;
------------------------------------
ARCHITECTURE Laboratorio_01 OF Laboratorio_01 IS
BEGIN
	y <= c1 and c2 and c3 and c4 and c5 and c6 and c7 and c8 and c9 and c10; 
END ARCHITECTURE;
	