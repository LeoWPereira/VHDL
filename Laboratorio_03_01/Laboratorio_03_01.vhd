-------------------------------------

LIBRARY ieee;

USE ieee.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.own_library.ALL;

-------------------------------------

ENTITY Laboratorio_03_01 IS

PORT (

sel: IN STD_LOGIC_VECTOR(1 DOWNTO 0);

num1: IN STD_LOGIC_VECTOR(1 DOWNTO 0);

num2: IN STD_LOGIC_VECTOR(1 DOWNTO 0);

outSSD: OUT SSD);

END ENTITY;

------------------------------------

ARCHITECTURE Laboratorio_03_01 OF Laboratorio_03_01 IS

	signal counter1: STD_LOGIC_VECTOR(3 DOWNTO 0);
	
BEGIN
	
	counter1 <= ("00" & num1) + ("00" & num2) WHEN (sel = "00") ELSE
					("00" & num1) - ("00" & num2) WHEN (sel = "01") ELSE
					(num1) * (num2) WHEN (sel = "10") ELSE
					"0000";
					
	
	---
	--- SSD
	---

	outSSD <= SSD_0 when (counter1="0000") ELSE 
				 SSD_1 when (counter1="0001") ELSE
				 SSD_2 when (counter1="0010") ELSE
				 SSD_3 when (counter1="0011") ELSE
				 SSD_4 when (counter1="0100") ELSE
				 SSD_5 when (counter1="0101") ELSE
				 SSD_6 when (counter1="0110") ELSE
				 SSD_7 when (counter1="0111") ELSE
				 SSD_8 when (counter1="1000") ELSE
				 SSD_9 when (counter1="1001") ELSE
				 SSD_A when (counter1="1010") ELSE
				 SSD_B when (counter1="1011") ELSE
				 SSD_C when (counter1="1100") ELSE
				 SSD_D when (counter1="1101") ELSE
				 SSD_E when (counter1="1110") ELSE
				 SSD_F;
		
END ARCHITECTURE;