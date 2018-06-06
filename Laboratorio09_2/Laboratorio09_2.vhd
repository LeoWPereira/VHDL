library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.own_library.all;

entity Laboratorio09_2 is
	generic (
		NUM_SEMAFOROS : NATURAL := 2;
		BASE_NUM:	NATURAL	:= 16;
		
		SEMAFORO_VERDE:	INTEGER	:= 15;
		SEMAFORO_VERMELHO:	INTEGER	:= -15
	);
	
	port (
		SSDS_SEMAFORO1: out SSDArray(((natural(FLOOR(LOG(real(NUM_SEMAFOROS), real(BASE_NUM))) + 1.0))) downto 0);
		SSDS_SEMAFORO2: out SSDArray(((natural(FLOOR(LOG(real(NUM_SEMAFOROS), real(BASE_NUM))) + 1.0))) downto 0);
		
		BTN_INPUT: IN STD_LOGIC;
		
		CLK: IN STD_LOGIC
	);
end entity;
--
architecture Laboratorio09_2 of Laboratorio09_2 IS
	signal inputPressed: std_logic := '0';
	
	signal SEMAFORO1: integer range SEMAFORO_VERMELHO to SEMAFORO_VERDE := SEMAFORO_VERMELHO;
	signal SEMAFORO2: integer range SEMAFORO_VERMELHO to SEMAFORO_VERDE := SEMAFORO_VERMELHO;

	TYPE STATE IS (START, ESTADO1, ESTADO2, ESTADO_INT_1, ESTADO_INT_2);
	SIGNAL pr_state, nx_state : STATE;

	begin
	btnInput: entity work.debouncer PORT MAP (
		clk => CLK, 
		button => BTN_INPUT, 
		result => inputPressed
	);
	
	ssdSemaforo1: entity work.HexToSSD GENERIC MAP (
		MIN_VALUE => SEMAFORO_VERMELHO, 
		MAX_VALUE => SEMAFORO_VERDE, 
		BASE_NUM => BASE_NUM
	) 
	PORT MAP (
		numValue => SEMAFORO1, 
		ssds => SSDS_SEMAFORO1
	);
	
	ssdSemaforo2: entity work.HexToSSD GENERIC MAP (
		MIN_VALUE => SEMAFORO_VERMELHO, 
		MAX_VALUE => SEMAFORO_VERDE, 
		BASE_NUM => BASE_NUM
	) 
	PORT MAP (
		numValue => SEMAFORO2, 
		ssds => SSDS_SEMAFORO2
	);
	
	process (CLK, pr_state, nx_state)
	begin 
		if rising_edge (CLK) then
			pr_state <= nx_state;
		end if;
	end process;

	PROCESS(pr_state, SEMAFORO1, SEMAFORO2, inputPressed, nx_state)
	BEGIN
		CASE pr_state IS
			WHEN START =>
				SEMAFORO1 <= SEMAFORO_VERMELHO;
				SEMAFORO2 <= SEMAFORO_VERMELHO;
				nx_state <= ESTADO1;
			WHEN ESTADO1 =>
				SEMAFORO1 <= SEMAFORO_VERDE;
				SEMAFORO2 <= SEMAFORO_VERMELHO;
				IF inputPressed = '0' then
					nx_state <= ESTADO_INT_1;
				ELSE 
					nx_state <= ESTADO1;
				END IF;
			WHEN ESTADO_INT_1 =>
				SEMAFORO1 <= SEMAFORO_VERMELHO;
				SEMAFORO2 <= SEMAFORO_VERDE;
				
				IF inputPressed = '1' then
					nx_state <= ESTADO2;
				ELSE 
					nx_state <= ESTADO_INT_1;
				END IF;
			WHEN ESTADO2 =>
				SEMAFORO1 <= SEMAFORO_VERMELHO;
				SEMAFORO2 <= SEMAFORO_VERDE;
				IF inputPressed = '0' then
					nx_state <= ESTADO_INT_2;
				ELSE 
					nx_state <= ESTADO2;
				END IF;	
			WHEN ESTADO_INT_2 =>
				SEMAFORO1 <= SEMAFORO_VERDE;
				SEMAFORO2 <= SEMAFORO_VERMELHO;
				
				IF inputPressed = '1' then
					nx_state <= ESTADO1;
				ELSE 
					nx_state <= ESTADO_INT_2;
				END IF;
		END CASE;		
	END PROCESS;
	
end architecture;