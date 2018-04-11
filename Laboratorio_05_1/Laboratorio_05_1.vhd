library ieee;

use ieee.std_logic_1164.all;

--

entity Laboratorio_05_1 is
	generic (
		N: NATURAL := 13
	);
	
	port (
		SW: IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
		LED: OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0)
	);
end entity;

--

architecture Laboratorio_05_1 of Laboratorio_05_1 IS
	
	TYPE SUM_ARRAY IS ARRAY (N DOWNTO 0) OF NATURAL RANGE 0 TO N;
	
	SIGNAL sum: SUM_ARRAY;
	
	begin
		sum(0) <= 0;
		
		SOMA: FOR i IN 1 TO N GENERATE
			sum(i) <= sum(i-1) + 1 when SW(i-1) = '0' else
						 sum(i-1);
		END GENERATE SOMA;
		
		ACENDE_LED: FOR i IN 0 TO N-1 GENERATE
			LED(i) <= '1' when i < sum(N) else
						 '0';
		END GENERATE ACENDE_LED;
end architecture;