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

entity Laboratorio_06_02 is
	generic (
		MAX_SIZE	:	natural 	:= 31;
		
		FCLK		: 	natural 	:= 50_000_000;
		
		TIME_MS	: 	natural	:= 500;
		
		BASE_NUM	:	natural	:= 10
	);
	
	port (
		ssds	: out SSDArray(((natural(FLOOR(LOG10(real(MAX_SIZE))))) / (1)) downto 0);
		
		clock	: in std_logic
	);
end entity;

-------------------------------------------

architecture Laboratorio_06_02 of Laboratorio_06_02 is
	
	constant LIMIT_TIMER	: natural := FCLK / (1000 * TIME_MS);
	
	constant SDD_N			: natural := natural(FLOOR(LOG10(real(MAX_SIZE))));
	
	type 		div_array is array((SDD_N + 1) downto 0) of natural;
	
	signal 	clockTimer	: std_logic;
	
	signal 	disp			: div_array;
	
	signal 	div			: div_array;
	
	signal counter_disp	: natural range 0 to MAX_SIZE;
	
	begin
	
		-- Combinational part
		disp(0) <= counter_disp mod BASE_NUM;
		
		div(0) <= counter_disp / BASE_NUM;
		
		DIVISOR: FOR k IN 0 TO SDD_N GENERATE
		
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
						  
			disp(k + 1) <= div(k) mod BASE_NUM;
			
			div(k + 1) <= div(k) / BASE_NUM;
		END GENERATE DIVISOR;
		
		-- Clock quarter second
		process (clock)
			variable counter	:	natural range 0 to LIMIT_TIMER;
		
		begin 
			if rising_edge (clock) then
				counter := counter + 1;
				
				if counter = LIMIT_TIMER - 1 then
					clockTimer <= '1';
					
					counter := 0;
				
				else 
				
					clockTimer <= '0';
				end if;
			end if;
		end process;
		
		-- Increese position
		process(clockTimer)
		begin	
			if rising_edge (clockTimer) then
				counter_disp <= counter_disp + 1;
				
				if counter_disp >= MAX_SIZE then
					counter_disp <= 0;
				end if;
			end if;
		end process;
		
end architecture;

