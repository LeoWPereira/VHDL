--------------------------------------

-- Conte	o	nÃƒÂºmero	de	chaves	ligadas	e	mostre	esse	valor	em	 hexa	(nos	SSDs)	e	binÃƒÂ¡rio	(nos	LEDs).	Utilize	os	botÃƒÂµes	
-- como	multiplicadores	por	2,	ou	 seja,	cada	botÃƒÂ£o	apertado	equivale	a	multiplicar	o	valor	por	2^N,	onde	N	ÃƒÂ©	o	nÃƒÂºmero	
-- de	botÃƒÂµes	apertados	(e.g.	4	chaves	ligadas	Ã¢â‚¬â€>	valor	=	4	/	 2	 botÃƒÂµes	apertados	Ã¢â‚¬â€>	2^2	=	4	/	resultado	para	
-- aparecer	nos	LEDs	(bin)	e	SSDs	(hexa)	Ã¢â‚¬â€>	16).
-- Utilize	todas	as	chaves	da	placa.

--------------------------------------

LIBRARY ieee;

USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.all;
use ieee.math_real.all;
use work.own_library.all;

-------------------------------------

ENTITY Laboratorio_05_2 IS

	generic (
		NUMERO_CHAVES : integer := 10;

		NUMERO_BOTOES: integer := 3;

		TAMANHO_NUMERO_SSD: integer := 10);

PORT (
	chaves: IN STD_LOGIC_VECTOR(NUMERO_CHAVES-1 DOWNTO 0);

	botoes: IN STD_LOGIC_VECTOR(NUMERO_BOTOES-1 DOWNTO 0); 

	-- Calcula quantidade de SSDs necessarios
	-- Resultado maximo obtido = (2 ** NUMERO_BOTOES) * (2**NUMERO_CHAVES - 1)
	-- Temos um numero total de SSDs com valor de log((2 ** NUMERO_BOTOES) * (2**NUMERO_CHAVES - 1))

	outSSDs: OUT SSDArray(natural(floor(LOG10(real(2 ** NUMERO_BOTOES) * real(2**NUMERO_CHAVES-1)))) DOWNTO 0)
	);
	

END ENTITY;

------------------------------------

ARCHITECTURE Laboratorio_05_2 OF Laboratorio_05_2 IS

	CONSTANT numeroSSDs: natural := natural(floor(LOG10(real(2 ** NUMERO_BOTOES) * real(2**NUMERO_CHAVES-1))));

	TYPE array_of_chaves is array((NUMERO_CHAVES) downto 0) of integer range 0 to NUMERO_CHAVES;
	TYPE array_of_botoes is array((NUMERO_BOTOES) downto 0) of integer range 0 to NUMERO_BOTOES;
	type array_of_display is array((numeroSSDs+1) downto 0) of natural;

	signal soma_chaves: array_of_chaves;
	signal soma_botoes: array_of_botoes;
	signal resultado: natural;

	signal numero_display: array_of_display;
	signal numero_resto: array_of_display;

	BEGIN 
		
		soma_chaves(0) <= 0;
		
		c: for i in 1 to NUMERO_CHAVES generate
			soma_chaves(i) <= soma_chaves(i - 1) + 1 when chaves(i - 1) = '1' else soma_chaves(i - 1);
		end generate;

		soma_botoes(0) <= 0;
		
		d: for i in 1 to NUMERO_BOTOES generate
			soma_botoes(i) <= soma_botoes(i - 1) + 1 when botoes(i - 1) = '0' else soma_botoes(i - 1);
		end generate;
		
		resultado <= (2 ** soma_botoes(NUMERO_BOTOES)) * (2 ** soma_chaves(NUMERO_CHAVES) - 1);
		
		---
		--- SSDs
		---

		numero_display(0) <= resultado mod TAMANHO_NUMERO_SSD;
		numero_resto(0) <= resultado / TAMANHO_NUMERO_SSD;

		MOSTRA_VALORES_SSDS: FOR k IN 0 TO numeroSSDs GENERATE
			outSSDs(k) <= SSD_0 when (numero_display(k)=0) ELSE 
						 SSD_1 when (numero_display(k)=1) ELSE
						 SSD_2 when (numero_display(k)=2) ELSE
						 SSD_3 when (numero_display(k)=3) ELSE
						 SSD_4 when (numero_display(k)=4) ELSE
						 SSD_5 when (numero_display(k)=5) ELSE
						 SSD_6 when (numero_display(k)=6) ELSE
						 SSD_7 when (numero_display(k)=7) ELSE
						 SSD_8 when (numero_display(k)=8) ELSE
						 SSD_9 when (numero_display(k)=9) ELSE
						 SSD_A when (numero_display(k)=10) ELSE
						 SSD_B when (numero_display(k)=11) ELSE
						 SSD_C when (numero_display(k)=12) ELSE
						 SSD_D when (numero_display(k)=13) ELSE
						 SSD_E when (numero_display(k)=14) ELSE
						 SSD_F;

			numero_display(k+1) <= numero_resto(k) mod TAMANHO_NUMERO_SSD;
			numero_resto(k+1) <= numero_resto(k) / TAMANHO_NUMERO_SSD;
		
		END GENERATE MOSTRA_VALORES_SSDS;
			
	END ARCHITECTURE;