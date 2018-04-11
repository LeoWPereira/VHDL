----------------------------------------

-- Conte o número de chaves ligadas e botões apertados e acenda, em sequencia, os LEDs, baseado nessa contagem.

----------------------------------------

library ieee;

use ieee.std_logic_1164.all;
use work.own_library.all;

----------------------------------------

entity Laboratorio_05_1 is
	generic (
		N: NATURAL := 13
	);
	
	port (
		botoesChaves: in STD_LOGIC_VECTOR (N-1 downto 0);
		leds: out STD_LOGIC_VECTOR (N-1 downto 0)
	);
end entity;

----------------------------------------

architecture Laboratorio_05_1 of Laboratorio_05_1 IS
	
	type arrayInteiros is array (N downto 0) of natural range 0 to N;
	
	signal soma: arrayInteiros;
	
	begin
		soma(0) <= 0;
		
		SOMA_ENTRADAS: for i in 1 to N generate
			soma(i) <= soma(i - 1) + 1 when (botoesChaves(i-1) = '0') else
						 soma(i - 1);
		END GENERATE SOMA_ENTRADAS;
		
		ACENDE_LEDS: for i in 0 to (N - 1) generate
			leds(i) <= '1' when (i < soma(N) and i < 10) 	else
						  '0' when (i < soma(N) and i >= 10) 	else
						  '0' when (i > soma(N) and i < 10) 	else
						  '1' when (i >= soma(N) and i >= 10) 	else
						  '0';
		end generate ACENDE_LEDS;
end architecture;