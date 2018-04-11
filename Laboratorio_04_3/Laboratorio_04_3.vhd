--------------------------------------

-- Conte	o	número	de	chaves	ligadas	e	mostre	esse	valor	em	 hexa	(nos	SSDs)	e	binário	(nos	LEDs).	Utilize	os	botões	
-- como	multiplicadores	por	2,	ou	 seja,	cada	botão	apertado	equivale	a	multiplicar	o	valor	por	2^N,	onde	N	é	o	número	
-- de	botões	apertados	(e.g.	4	chaves	ligadas	—>	valor	=	4	/	 2	 botões	apertados	—>	2^2	=	4	/	resultado	para	
-- aparecer	nos	LEDs	(bin)	e	SSDs	(hexa)	—>	16).
-- Utilize	todas	as	chaves	da	placa.

--------------------------------------

LIBRARY ieee;

USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.own_library.all;

-------------------------------------

ENTITY Laboratorio_04_3 IS

	generic (
		NUMERO_CHAVES : integer := 10;

		NUMERO_BOTOES: integer := 3;

		TAMANHO_HEXADECIMAL: integer := 16);

PORT (
	chaves: IN STD_LOGIC_VECTOR(NUMERO_CHAVES-1 DOWNTO 0);

	botoes: IN STD_LOGIC_VECTOR(NUMERO_BOTOES-1 DOWNTO 0); 

	outSSD_MSB: OUT SSD;

	outSSD_LSB: OUT SSD);

END ENTITY;

------------------------------------

ARCHITECTURE Laboratorio_04_3 OF Laboratorio_04_3 IS

	TYPE array_of_chaves is array((NUMERO_CHAVES) downto 0) of integer range 0 to NUMERO_CHAVES;
	
	TYPE array_of_botoes is array((NUMERO_BOTOES) downto 0) of integer range 0 to NUMERO_BOTOES;

	signal soma_chaves: array_of_chaves;
	signal soma_botoes: array_of_botoes;
	signal resultado: integer range 0 to 255;
	
	signal resultado_SSD_MSB: integer range 0 to 15; 

	signal resultado_SSD_LSB: integer range 0 to 15; 

	BEGIN 
		
		soma_chaves(0) <= 0;
		
		c: for i in 1 to NUMERO_CHAVES generate
			soma_chaves(i) <= soma_chaves(i - 1) + 1 when chaves(i - 1) = '1' else soma_chaves(i - 1);
		end generate;

		soma_botoes(0) <= 0;
		
		d: for i in 1 to NUMERO_BOTOES generate
			soma_botoes(i) <= soma_botoes(i - 1) + 1 when botoes(i - 1) = '0' else soma_botoes(i - 1);
		end generate;
		
		--soma_resultado(0) <= 1;
		
		resultado <= (2 ** soma_botoes(NUMERO_BOTOES)) * soma_chaves(NUMERO_CHAVES);
		
		-- calcula MSB

		resultado_SSD_MSB <= resultado / TAMANHO_HEXADECIMAL;

		-- calcula resto (LSB)

		resultado_SSD_LSB <= resultado - (resultado_SSD_MSB  *  TAMANHO_HEXADECIMAL);
		
		---
	--- SSD LSB
	---

	outSSD_LSB <= SSD_0 when (resultado_SSD_LSB=0) ELSE 
				 SSD_1 when (resultado_SSD_LSB=1) ELSE
				 SSD_2 when (resultado_SSD_LSB=2) ELSE
				 SSD_3 when (resultado_SSD_LSB=3) ELSE
				 SSD_4 when (resultado_SSD_LSB=4) ELSE
				 SSD_5 when (resultado_SSD_LSB=5) ELSE
				 SSD_6 when (resultado_SSD_LSB=6) ELSE
				 SSD_7 when (resultado_SSD_LSB=7) ELSE
				 SSD_8 when (resultado_SSD_LSB=8) ELSE
				 SSD_9 when (resultado_SSD_LSB=9) ELSE
				 SSD_A when (resultado_SSD_LSB=10) ELSE
				 SSD_B when (resultado_SSD_LSB=11) ELSE
				 SSD_C when (resultado_SSD_LSB=12) ELSE
				 SSD_D when (resultado_SSD_LSB=13) ELSE
				 SSD_E when (resultado_SSD_LSB=14) ELSE
				 SSD_F;
				 
	---
	--- SSD MSB
	---

	outSSD_MSB <= SSD_0 when (resultado_SSD_MSB=0) ELSE 
					 SSD_1 when (resultado_SSD_MSB=1) ELSE
					 SSD_2 when (resultado_SSD_MSB=2) ELSE
					 SSD_3 when (resultado_SSD_MSB=3) ELSE
					 SSD_4 when (resultado_SSD_MSB=4) ELSE
					 SSD_5 when (resultado_SSD_MSB=5) ELSE
					 SSD_6 when (resultado_SSD_MSB=6) ELSE
					 SSD_7 when (resultado_SSD_MSB=7) ELSE
					 SSD_8 when (resultado_SSD_MSB=8) ELSE
					 SSD_9 when (resultado_SSD_MSB=9) ELSE
					 SSD_A when (resultado_SSD_MSB=10) ELSE
					 SSD_B when (resultado_SSD_MSB=11) ELSE
 					 SSD_C when (resultado_SSD_MSB=12) ELSE
 					 SSD_D when (resultado_SSD_MSB=13) ELSE
 					 SSD_E when (resultado_SSD_MSB=14) ELSE
 					 SSD_F;
		
END ARCHITECTURE;