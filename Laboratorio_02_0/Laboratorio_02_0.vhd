-------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-------------------------------------
ENTITY Laboratorio_02_0 IS
	PORT (
		grayIn  : in STD_LOGIC_VECTOR (3 downto 0);
		binIn   : in STD_LOGIC_VECTOR (3 downto 0);
		
		grayOut : out STD_LOGIC_VECTOR (3 downto 0);
		binOut  : out STD_LOGIC_VECTOR (3 downto 0));
END ENTITY;
------------------------------------
ARCHITECTURE Laboratorio_02_0 OF Laboratorio_02_0 IS
BEGIN	
		-------------------
		--- GRAY TO BIN ---
		-------------------
		
		binOut(3)<= grayIn(3);

		binOut(2)<= grayIn(3) xor grayIn(2);

		binOut(1)<= grayIn(3) xor grayIn(2) xor grayIn(1);

		binOut(0)<= grayIn(3) xor grayIn(2) xor grayIn(1) xor grayIn(0);

		-------------------
		--- BIN TO GRAY ---
		-------------------
		
		grayOut(3)<= binIn(3);
		
		grayOut(2)<= binIn(3) xor binIn(2);

		grayOut(1)<= binIn(2) xor binIn(1);

		grayOut(0)<= binIn(1) xor binIn(0);
END ARCHITECTURE;