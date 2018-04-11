-------------------------------------

-- Crie um detector de padrões simples, utilizando M chaves para o padrão a ser procurado e N chaves para o vetor	de	busca.	
-- A saída do circuito deve indicar se o padrão foi encontrado no vetor ou não. Por exemplo, com M = 3 e se o padrão for “101” e	
-- o vetor de busca “1101000” (N = 7), o padrão foi encontrado e o saida deve estar acesso.

-------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-------------------------------------

entity Laboratorio_05_3 is
	generic (
		N : natural := 7;
		
		M : natural := 3
	);
	
	port (
		mascara			: in std_logic_vector ((M - 1) downto 0);
		
		vetorEntrada	: in std_logic_vector ((N - 1) downto 0);
		
		saida				: out std_logic
	);
end entity;

-------------------------------------

architecture Laboratorio_05_3 of Laboratorio_05_3 is
	type COMPARADOR is array (0 to (N - M)) of std_logic;
	
	signal procuraPadrao: COMPARADOR;
	
	begin
		procuraPadrao(0) <= '1' when ((vetorEntrada((M - 1) downto 0) and mascara) = mascara) else
						 '0';
						 
		BUSCA: for i in 1 to N-M generate
			procuraPadrao(i) <= procuraPadrao(i - 1) or '1' when ((vetorEntrada((M - 1 + i) downto i) and mascara) = mascara) else
									  procuraPadrao(i - 1) or '0';
		END GENERATE BUSCA;
		
		saida <= procuraPadrao(N - M);	
end architecture;

