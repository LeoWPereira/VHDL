-------------------------------------------

-- Construa um circuito que lê NUM_SWITCHES chaves como um número binário e NUM_BUTTONS como uma exponenciação de base	
-- binária (e.g. 2 botões apertados -> 2**2 = 4) e multiplica esses dois valores, mostrando o resultado nos SSDs.	
-- Esse exercício deve ser completamente genérico.

-------------------------------------------

library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use work.own_Library.all;

-------------------------------------------

entity Laboratorio_05_2 is
	generic (
		numChaves : natural := 5;
		
		numBotoes : natural := 5
	);
	
	port (
		chaves: in std_logic_vector ((numChaves - 1) downto 0);
		
		BTN: in std_logic_vector ((numBotoes - 1) downto 0);
		
		ssds: out SSDArray(natural(FLOOR (LOG10(((2.0**real(numChaves))-1.0)*(2.0**real(numBotoes))))) DOWNTO 0)
	);
end entity;

-------------------------------------------

architecture Laboratorio_05_2 of Laboratorio_05_2 IS
	CONSTANT SDD_N: NATURAL := NATURAL(FLOOR (LOG10(((2.0**REAL(numChaves))-1.0)*(2.0**REAL(numBotoes)))));

	TYPE natural_array IS ARRAY (numChaves - 1 DOWNTO 0) OF NATURAL RANGE 0 TO numChaves;
	TYPE mult_array IS ARRAY (numBotoes - 1 DOWNTO 0) OF NATURAL;
	TYPE div_array IS ARRAY (SDD_N + 1 DOWNTO 0) OF NATURAL;
	
	SIGNAL sum: NATURAL;
	SIGNAL mult: mult_array;
	SIGNAL disp, div: div_array;
	
begin
	
	sum <= conv_integer(chaves);
	
	--------------------------------------
	
	mult(0) <= sum * 2 when BTN(0) = '0' else
				  sum;
	MULTIPLICADOR: FOR j IN 1 TO numBotoes-1 GENERATE
		mult(j) <= mult (j-1) * 2 when BTN (j) = '0' else
					  mult (j-1);
	END GENERATE MULTIPLICADOR;
	
	--------------------------------------
	
	disp(0) <= mult (numBotoes-1) mod 10;
	div(0) <= mult (numBotoes-1) / 10;
	DIVISOR: FOR k IN 0 TO SDD_N GENERATE
	
		ssds(k) <= SSD_0 WHEN disp(k) = 0 ELSE
					  SSD_1 WHEN disp(k) = 1 ELSE
					  SSD_2 WHEN disp(k) = 2 ELSE
					  SSD_3 WHEN disp(k) = 3 ELSE
					  SSD_4 WHEN disp(k) = 4 ELSE
					  SSD_5 WHEN disp(k) = 5 ELSE
					  SSD_6 WHEN disp(k) = 6 ELSE
					  SSD_7 WHEN disp(k) = 7 ELSE
					  SSD_8 WHEN disp(k) = 8 ELSE
					  SSD_9 WHEN disp(k) = 9;
					  
					  
		disp(k+1) <= div(k) mod 10;
		div(k+1) <= div(k) / 10;
	
	END GENERATE DIVISOR;
	
end architecture;

