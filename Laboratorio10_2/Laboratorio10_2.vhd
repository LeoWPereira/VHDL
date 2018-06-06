LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.own_library.all;
USE ieee.math_real.all;

ENTITY Laboratorio10_2 IS
	GENERIC(
		FCLK: NATURAL := 50_000_000
	);
	PORT (
		clk: IN STD_LOGIC;
		in_button1, in_button2, in_rst: IN STD_LOGIC;
		out_red1, out_red2, out_yellow1, out_yellow2, out_green1, out_green2: OUT STD_LOGIC
	);
END ENTITY;

ARCHITECTURE arch OF Laboratorio10_2 IS
	TYPE state IS (R1_G2_STABLE, R1_G2, R1_Y2, G1_R2_STABLE, G1_R2, Y1_R2);
	SIGNAL pr_state, nx_state: state;
	
	CONSTANT TEMPO_2S: NATURAL := FCLK * 2;	
	CONSTANT TEMPO_3S: NATURAL := FCLK * 3;	
	CONSTANT tmax: NATURAL := FCLK * 5;
	SIGNAL t: NATURAL RANGE 0 TO tmax;
	
	SIGNAL button1, button2, rst: STD_LOGIC;
BEGIN
	DB1: entity work.debouncer port map (clk => clk, button => not in_button1, result => button1);
	DB2: entity work.debouncer port map (clk => clk, button => not in_button2, result => button2);
	DB3: entity work.debouncer port map (clk => clk, button => not in_rst, result => rst);
	
-- STATE MACHINE

-- TIMER
PROCESS(clk, rst)
BEGIN
	IF rst = '1' THEN
		t <= 0;
	ELSIF rising_edge(clk) THEN
		IF pr_state /= nx_state THEN 
			t <= 0;
		ELSIF t /= tmax THEN
			t <= t + 1;
		END IF;
	END IF;
END PROCESS;

-- LOWER SECTION
PROCESS(clk, rst)
BEGIN
	IF rst = '1' THEN
		pr_state <= R1_G2_STABLE;	
	ELSIF rising_edge(clk) THEN
		pr_state <= nx_state;
	END IF;
END PROCESS;

-- UPPER SECTION
PROCESS(clk, rst)
BEGIN
	CASE pr_state IS
		WHEN R1_G2_STABLE =>
			out_red1		<= '0';
			out_yellow1 <= '1';
			out_green1	<= '1';
			out_red2		<= '1';
			out_yellow2 <= '1';
			out_green2	<= '0';
			
			IF button1 = '1' THEN
				nx_state <= R1_G2;
			ELSE
				nx_state <= R1_G2_STABLE;
			END IF;
			
		WHEN R1_G2 =>
			out_red1		<= '0';
			out_yellow1 <= '1';
			out_green1	<= '1';
			out_red2		<= '1';
			out_yellow2 <= '1';
			out_green2	<= '0';
			
			IF t >= TEMPO_3S THEN
				nx_state <= R1_Y2;
			ELSE
				nx_state <= R1_G2;
			END IF;	
			
		WHEN R1_Y2 =>
			out_red1		<= '0';
			out_yellow1 <= '1';
			out_green1	<= '1';
			out_red2		<= '1';
			out_yellow2 <= '0';
			out_green2	<= '1';
			
			IF t >= TEMPO_2S THEN
				nx_state <= G1_R2_STABLE;
			ELSE
				nx_state <= R1_Y2;
			END IF;	
			
		WHEN G1_R2_STABLE =>
			out_red1		<= '1';
			out_yellow1 <= '1';
			out_green1	<= '0';
			out_red2		<= '0';
			out_yellow2 <= '1';
			out_green2	<= '1';
			
			IF button2 = '1' THEN
				nx_state <= G1_R2;
			ELSE
				nx_state <= G1_R2_STABLE;
			END IF;

		WHEN G1_R2 =>
			out_red1		<= '1';
			out_yellow1 <= '1';
			out_green1	<= '0';
			out_red2		<= '0';
			out_yellow2 <= '1';
			out_green2	<= '1';
			
			IF t >= TEMPO_3S THEN
				nx_state <= Y1_R2;
			ELSE
				nx_state <= G1_R2;
			END IF;	

		WHEN Y1_R2 =>
			out_red1		<= '1';
			out_yellow1 <= '0';
			out_green1	<= '1';
			out_red2		<= '0';
			out_yellow2 <= '1';
			out_green2	<= '1';
			
			IF t >= TEMPO_2S THEN
				nx_state <= R1_G2_STABLE;
			ELSE
				nx_state <= Y1_R2;
			END IF;			
	END CASE;
END PROCESS;




END ARCHITECTURE;