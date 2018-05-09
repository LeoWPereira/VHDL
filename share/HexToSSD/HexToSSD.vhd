library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use work.own_Library.all;

entity HexToSSD is
	generic (
		MIN_VALUE	:	integer 	:= 0;
		MAX_VALUE	:	integer 	:= 10;
		BASE_NUM		:	natural	:= 10
	);
	
	port (
		numValue: in integer range MIN_VALUE to MAX_VALUE;
		
		ssds	: out SSDArray(((natural(FLOOR(LOG(real(MAX_VALUE), real(BASE_NUM))) + 1.0))) downto 0)
	);
end entity;
--
architecture HexToSSD of HexToSSD IS
	constant SDD_N			: natural := natural(FLOOR(LOG(real(MAX_VALUE), real(BASE_NUM))) + 1.0);
	
	type 		div_array is array((SDD_N + 1) downto 0) of natural;
	
	SIGNAL disp, div: div_array;
	
	signal posValue: integer range MIN_VALUE to MAX_VALUE;
	
begin
	
	posValue <= abs(numValue);
	
	disp(0) <= posValue mod BASE_NUM;
		
	div(0) <= posValue / BASE_NUM;
		
	DIVISOR: FOR k IN 0 TO SDD_N -1 GENERATE
	
		ssds(k) <= SSD_0 when disp(k) = 0  else
					  SSD_1 when disp(k) = 1  else
					  SSD_2 when disp(k) = 2  else
					  SSD_3 when disp(k) = 3  else
					  SSD_4 when disp(k) = 4  else
					  SSD_5 when disp(k) = 5  else
					  SSD_6 when disp(k) = 6  else
					  SSD_7 when disp(k) = 7  else
					  SSD_8 when disp(k) = 8  else
					  SSD_9 when disp(k) = 9  else
					  SSD_A when disp(k) = 10 else
					  SSD_B when disp(k) = 11 else
					  SSD_C when disp(k) = 12 else
					  SSD_D when disp(k) = 13 else
					  SSD_E when disp(k) = 14 else
					  SSD_F;
					  
					  
		disp(k+1) <= div(k) mod BASE_NUM;
		div(k+1) <= div(k) / BASE_NUM;
	
	END GENERATE DIVISOR;
	
	ssds(SDD_N) <= NEG_SINE when numValue < 0 else
						BLANK;
	
end architecture;

