library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use work.MyPackage.all;

entity Laboratorio_05_2 is
	generic (
		NUM_SWITCHES:NATURAL := 5;
		NUM_BUTTONS:NATURAL := 5
	);
	
	port (
		SW: IN STD_LOGIC_VECTOR (NUM_SWITCHES - 1 DOWNTO 0);
		BTN: IN STD_LOGIC_VECTOR (NUM_BUTTONS - 1 DOWNTO 0);
		
		ssds: out SSDArray(NATURAL(FLOOR (LOG10(((2.0**REAL(NUM_SWITCHES))-1.0)*(2.0**REAL(NUM_BUTTONS))))) DOWNTO 0)
	);
end entity;
--
architecture Laboratorio_05_2 of Laboratorio_05_2 IS
	CONSTANT SDD_N: NATURAL := NATURAL(FLOOR (LOG10(((2.0**REAL(NUM_SWITCHES))-1.0)*(2.0**REAL(NUM_BUTTONS)))));

	TYPE natural_array IS ARRAY (NUM_SWITCHES - 1 DOWNTO 0) OF NATURAL RANGE 0 TO NUM_SWITCHES;
	TYPE mult_array IS ARRAY (NUM_BUTTONS - 1 DOWNTO 0) OF NATURAL;
	TYPE div_array IS ARRAY (SDD_N + 1 DOWNTO 0) OF NATURAL;
	
	SIGNAL sum: NATURAL;
	SIGNAL mult: mult_array;
	SIGNAL disp, div: div_array;
	
begin
	
	sum <= conv_integer(SW);
	
	--------------------------------------
	
	mult(0) <= sum * 2 when BTN(0) = '0' else
				  sum;
	MULTIPLICADOR: FOR j IN 1 TO NUM_BUTTONS-1 GENERATE
		mult(j) <= mult (j-1) * 2 when BTN (j) = '0' else
					  mult (j-1);
	END GENERATE MULTIPLICADOR;
	
	--------------------------------------
	
	disp(0) <= mult (NUM_BUTTONS-1) mod 10;
	div(0) <= mult (NUM_BUTTONS-1) / 10;
	DIVISOR: FOR k IN 0 TO SDD_N GENERATE
	
		ssds(k) <= NUM_0 WHEN disp(k) = 0 ELSE
					  NUM_1 WHEN disp(k) = 1 ELSE
					  NUM_2 WHEN disp(k) = 2 ELSE
					  NUM_3 WHEN disp(k) = 3 ELSE
					  NUM_4 WHEN disp(k) = 4 ELSE
					  NUM_5 WHEN disp(k) = 5 ELSE
					  NUM_6 WHEN disp(k) = 6 ELSE
					  NUM_7 WHEN disp(k) = 7 ELSE
					  NUM_8 WHEN disp(k) = 8 ELSE
					  NUM_9 WHEN disp(k) = 9;
					  
					  
		disp(k+1) <= div(k) mod 10;
		div(k+1) <= div(k) / 10;
	
	END GENERATE DIVISOR;
	
end architecture;

