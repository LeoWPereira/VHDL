library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.own_library.all;

entity Laboratorio09_2 is
	generic (
		FCLK: NATURAL := 50_000_000;
		NUM_SEMAFOROS : NATURAL := 2;
		BASE_NUM:	NATURAL	:= 16;
		
		INIT_TIME_LED: NATURAL := 1000; -- value in ms
		
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
	constant LIMIT_TIMER: natural := FCLK / 1000;
	
	signal inicioSistema: std_logic := '0';
	signal inputPressed: std_logic := '0';
	
	signal sistemaInicializado: std_logic := '0';
	
	signal SEMAFORO1: integer range SEMAFORO_VERMELHO to SEMAFORO_VERDE := SEMAFORO_VERMELHO;
	signal SEMAFORO2: integer range SEMAFORO_VERMELHO to SEMAFORO_VERDE := SEMAFORO_VERMELHO;

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
	
	-- Timer
	process (CLK, inicioSistema)
	variable initCounter:integer range 0 to 1000000000 := 0;
	begin
		if rising_edge (CLK) then
			initCounter := initCounter + 1;
		end if;
		
		if initCounter = 1000000000 then
			inicioSistema <= '1';
		else
			inicioSistema <= '0';
		end if;
	end process;
	
	process (inputPressed, sistemaInicializado, SEMAFORO1, SEMAFORO2)
	variable counter:integer range SEMAFORO_VERMELHO to SEMAFORO_VERDE;
	begin 
		if falling_edge (inputPressed) then
			counter := SEMAFORO1;
			SEMAFORO1 <= SEMAFORO2;
			SEMAFORO2 <= counter;
		end if;
		
		if inicioSistema = '1' and sistemaInicializado = '0' then
			SEMAFORO1 <= SEMAFORO_VERDE;
			SEMAFORO2 <= SEMAFORO_VERMELHO;
			
			--sistemaInicializado <= '0';
		end if;
	end process;
	
end architecture;