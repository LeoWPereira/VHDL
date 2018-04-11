library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--
entity Laboratorio_05_3 is
	generic (
		M:NATURAL := 3;
		N:NATURAL := 7
	);
	
	port (
		MASK: IN STD_LOGIC_VECTOR (M-1 DOWNTO 0);
		BUSCA: IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
		LED: OUT STD_LOGIC
	);
end entity;
--
architecture Laboratorio_05_3 of Laboratorio_05_3 IS
	TYPE DETECTOR IS ARRAY (0 TO N-M) OF STD_LOGIC;
	SIGNAL detect: DETECTOR;
begin
	
	detect(0) <= '1' when (BUSCA(M-1 DOWNTO 0) AND MASK) = MASK else
					 '0';
					 
	BUSCA_GEN: FOR i IN 1 TO N-M GENERATE
		
		detect(i) <= detect(i-1) or '1' when (BUSCA(M-1+i DOWNTO i) AND MASK) = MASK else
						 detect(i-1) or '0';
						 
	END GENERATE BUSCA_GEN;
	
	LED <= detect(N-M);
	
end architecture;

