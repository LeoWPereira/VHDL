library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
use work.own_library.all;

ENTITY Laboratorio09_1 IS
	GENERIC (
		MIN_VALUE	:	integer 	:= 0;
		MAX_VALUE	:	integer 	:= 255;
		NUM_CHAVES : INTEGER := 9;
		BASE_NUM : INTEGER := 10
	);
	PORT(
		SSDS_INPUT: out SSDArray(((natural(FLOOR(LOG(real(MAX_VALUE), real(BASE_NUM))) + 1.0))) downto 0);
		LED : OUT STD_LOGIC;
		BTN_INPUT : IN STD_LOGIC;
		CHAVES_CHAR : IN STD_LOGIC_VECTOR(NUM_CHAVES-1 DOWNTO 0);
		CHAVE_OVERLAP: IN STD_LOGIC;
		CLK : IN STD_LOGIC
	);
END;

ARCHITECTURE Laboratorio09_1 OF Laboratorio09_1 IS
	TYPE STATE IS (INICIO, PRIMEIRO_A, B, SEGUNDO_A);
	SIGNAL pr_state, nx_state : STATE;
	SIGNAL inputPressed : STD_LOGIC;
	SIGNAL char : CHARACTER;
BEGIN
	
	btnInput: entity work.debouncer PORT MAP (clk => CLK, button => BTN_INPUT, result => inputPressed);
	
	ssdInput: entity work.HexToSSD GENERIC MAP (MIN_VALUE => MIN_VALUE, MAX_VALUE => MAX_VALUE, BASE_NUM => BASE_NUM) PORT MAP (numValue => to_integer(unsigned(CHAVES_CHAR)), ssds => SSDS_INPUT);
	
	char <= CHARACTER'VAL(to_integer(unsigned(CHAVES_CHAR)));
	
	PROCESS(inputPressed)
	BEGIN
		IF(rising_edge(inputPressed)) THEN
			pr_state <= nx_state;
		END IF;
	END PROCESS;
	
	PROCESS(pr_state)
	BEGIN
		CASE pr_state IS
			WHEN INICIO =>
				LED <= '0';
				IF(char = 'a') THEN
					nx_state <= PRIMEIRO_A;
				ELSE
					nx_state <= INICIO;
				END IF;
			WHEN PRIMEIRO_A =>
				LED <= '0';
				IF(char = 'b') THEN
					nx_state <= B;
				ELSE
					nx_state <= INICIO;
				END IF;
			WHEN B =>
				LED <= '0';
				IF(char = 'a') THEN
					nx_state <= SEGUNDO_A;
				ELSE
					nx_state <= INICIO;
				END IF;	
			WHEN SEGUNDO_A =>
				LED <= '1';
				IF(char = 'b' and CHAVE_OVERLAP = '1') THEN
					nx_state <= B;
				ELSIF(char = 'a') THEN
					nx_state <= PRIMEIRO_A;
				ELSE
					nx_state <= INICIO;
				END IF;
		END CASE;		
	END PROCESS;
	
	
END;
