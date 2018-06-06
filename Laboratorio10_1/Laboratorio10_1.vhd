LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.meupacote.all;
USE ieee.math_real.all;

ENTITY Laboratorio10_1 IS
	GENERIC(
		FCLK: NATURAL := 50_000_000;
		NUM_LEDS: NATURAL := 10;
		MAX_INST: NATURAL := 500;
		NUM_MAX: NATURAL := 11
	);
	PORT (
		clk: IN STD_LOGIC;
		in_put, in_remove, in_rst: IN STD_LOGIC;
		output_debug: OUT SSDARRAY (NATURAL(CEIL(LOG10(REAL(NUM_MAX))))-1 DOWNTO 0);
		output: OUT STD_LOGIC_VECTOR (NUM_LEDS - 1 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE arch OF Laboratorio10_1 IS
	TYPE TIPODISP IS ARRAY (NATURAL(CEIL(LOG10(REAL(NUM_MAX))))-1 DOWNTO 0) OF INTEGER RANGE 0 TO 9;
	TYPE DIV IS ARRAY(NATURAL(CEIL(LOG10(REAL(NUM_MAX))))-1 DOWNTO 0) OF NATURAL RANGE 0 TO 10**(NATURAL(CEIL(LOG10(REAL(NUM_MAX))))-1);
	signal divisor: DIV;
	signal aux_disp: TIPODISP;
		
	CONSTANT TEMPO_500MS: NATURAL := FCLK / 2;	
	CONSTANT tmax: NATURAL := FCLK * 5;
	
	SIGNAL put, remove, rst: STD_LOGIC;
	SIGNAL sys_clk: STD_LOGIC;		
	SIGNAL pos_atual: NATURAL RANGE 0 TO NUM_LEDS := NUM_LEDS;
	SIGNAL num_acesos: NATURAL RANGE 0 TO NUM_LEDS - 1 := 0;
	
-- FLAGS
	SIGNAL flag_put, flag_remove, flag_end_put, flag_end_remove: STD_LOGIC := '0';
BEGIN
	DB1: entity work.debounce port map (clk => clk, input => not in_put, output => put);
	DB2: entity work.debounce port map (clk => clk, input => not in_remove, output => remove);
	DB3: entity work.debounce port map (clk => clk, input => not in_rst, output => rst);
	
--GERA SYS_CLK
PROCESS(clk)
VARIABLE counter: NATURAL RANGE 0 TO tmax;
BEGIN
	IF rising_edge(clk) THEN
		counter := counter + 1;
		IF counter = TEMPO_500MS - 1 THEN
			sys_clk <= '1';
			counter := 0;
		ELSE
			sys_clk <= '0';
		END IF;
	END IF;
END PROCESS;

-- BOTAO
PROCESS(clk)
VARIABLE index_vector: NATURAL RANGE 0 TO MAX_INST := 0;
VARIABLE buffer_instructions: STD_LOGIC_VECTOR(MAX_INST DOWNTO 0) := (OTHERS => '0');
BEGIN
	IF rising_edge(clk) THEN
		IF put = '1' THEN
			index_vector := index_vector + 1;
			buffer_instructions(index_vector) := '1';
		ELSIF remove = '1' THEN
			index_vector := index_vector + 1;
			buffer_instructions(index_vector) := '0';
		ELSIF flag_end_put = '1' THEN
			flag_put <= '0';
		ELSIF flag_end_remove = '1' THEN
			flag_remove <= '0';
		ELSIF index_vector > 0 THEN
			IF flag_put = '0' AND flag_remove = '0' THEN
				IF buffer_instructions(1) = '1' THEN
					flag_put <= '1';
				ELSE
					flag_remove <= '1';
				END IF;
				index_vector := index_vector - 1;
				buffer_instructions := '0' & buffer_instructions(MAX_INST DOWNTO 1); 
			END IF;
		END IF;
	END IF;
END PROCESS;

-- PUT / REMOVE
PROCESS(sys_clk, clk)
VARIABLE flag_already_removed: STD_LOGIC := '0';
BEGIN
	IF rising_edge(sys_clk) THEN
		IF flag_put = '1' THEN
			IF num_acesos = NUM_LEDS THEN
				pos_atual <= NUM_LEDS;
				flag_end_put <= '1';
			ELSIF pos_atual = 0 OR pos_atual = num_acesos THEN
				num_acesos <= num_acesos + 1;
				pos_atual <= NUM_LEDS;
				flag_end_put <= '1';
			ELSE
				pos_atual <= pos_atual - 1;
			END IF;
		ELSE
			flag_end_put <= '0';
		END IF;
	
		IF flag_remove = '1' THEN
			IF num_acesos = 0 AND flag_already_removed = '0' THEN
				flag_end_remove <= '1';
			ELSE
				IF pos_atual = NUM_LEDS THEN
					IF flag_already_removed = '0' THEN
						pos_atual <= num_acesos - 1;
						num_acesos <= num_acesos - 1;
						flag_already_removed := '1';
					ELSE
						flag_end_remove <= '1';
					END IF;	
				ELSE
					pos_atual <= pos_atual + 1;
				END IF;
			END IF;	
		ELSE
			flag_already_removed := '0';
			flag_end_remove <= '0';
		END IF;
	END IF;
END PROCESS;


G0: for i in 0 to NUM_LEDS - 1 generate
	output(i) <= '1' when i = pos_atual or i < num_acesos else '0';
end generate G0;

divisor(0) <= 1;
	G1: FOR i IN 1 TO NATURAL(CEIL(LOG10(REAL(NUM_MAX))))-1 GENERATE
		divisor(i) <= divisor(i-1)*10;
	END GENERATE G1;

G3: FOR i IN 0 TO NATURAL(CEIL(LOG10(REAL(NUM_MAX))))-1 GENERATE
		aux_disp(i) <= (pos_atual / divisor(i)) MOD 10;
		output_debug(i) <= num_0 WHEN aux_disp(i) = 0 ELSE
		  num_1 WHEN aux_disp(i) = 1 ELSE
		  num_2 WHEN aux_disp(i) = 2 ELSE
		  num_3 WHEN aux_disp(i) = 3 ELSE
		  num_4 WHEN aux_disp(i) = 4 ELSE
		  num_5 WHEN aux_disp(i) = 5 ELSE
		  num_6 WHEN aux_disp(i) = 6 ELSE
		  num_7 WHEN aux_disp(i) = 7 ELSE
		  num_8 WHEN aux_disp(i) = 8 ELSE
		  num_9 WHEN aux_disp(i) = 9 ELSE
		  num_a WHEN aux_disp(i) = 10 ELSE
		  num_b WHEN aux_disp(i) = 11 ELSE
		  num_c WHEN aux_disp(i) = 12 ELSE
		  num_d WHEN aux_disp(i) = 13 ELSE
		  num_e WHEN aux_disp(i) = 14 ELSE
		  num_f;
	END GENERATE G3;
	
END ARCHITECTURE;