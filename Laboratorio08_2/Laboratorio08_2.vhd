library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.own_library.all;

entity Laboratorio08_2 is
	generic (
		FCLK: NATURAL := 50_000_000;
		NUM_LEDS: NATURAL := 10;
		INIT_TIME_LED: NATURAL := 2000; -- value in ms
		TIME_MS: NATURAL := 1;
		MAX_POINTS: NATURAL := 5
	);
	
	port (
		SSDS_POINTS: out SSDArray(NATURAL(FLOOR (LOG10(REAL (MAX_POINTS))) + 1.0) DOWNTO 0);	
		SSD_RANDOM_POSITION: out SSDArray(NATURAL(FLOOR (LOG10(REAL (NUM_LEDS-1) + 1.0))) DOWNTO 0);
		START_GAME: IN STD_LOGIC;
		BTN_INPUT: IN STD_LOGIC;
		LEDS : out STD_LOGIC_VECTOR((NUM_LEDS - 1) DOWNTO 0);
		CLK: IN STD_LOGIC
	);
end entity;
--
architecture Laboratorio08_2 of Laboratorio08_2 IS
	constant LIMIT_TIMER: natural := FCLK / 1000 * TIME_MS;
	signal clockTimer: std_logic;
	signal inputPressed, startGamePressed: std_logic;
	signal gameRunning: std_logic := '0';
	signal roundNumber: natural range 0 to NUM_LEDS-1 := 0;
	signal randomNumber: natural range 0 to NUM_LEDS-1 := 0;
	signal totalPoints: natural range 0 to MAX_POINTS := 0;
	signal successHit: std_logic;
	signal errorHit: std_logic;
begin
	btnInput: entity work.debouncer PORT MAP (clk => CLK, button => BTN_INPUT, result => inputPressed);
	btnStartGame: entity work.debouncer PORT MAP (clk => CLK, button => START_GAME, result => startGamePressed);
	
	num2dispPoints: entity work.HexToSSD GENERIC MAP (MIN_VALUE => 0, MAX_VALUE => MAX_POINTS) PORT MAP (numValue => totalPoints, ssds => SSDS_POINTS);
	num2dispRandomNumber: entity work.HexToSSD GENERIC MAP (MIN_VALUE => 0, MAX_VALUE => NUM_LEDS - 1) PORT MAP (numValue => roundNumber, ssds => SSD_RANDOM_POSITION);

	-- Timer
	process (CLK, clockTimer)
		variable time_led: natural := INIT_TIME_LED;
		variable counter:natural range 0 to LIMIT_TIMER * INIT_TIME_LED;
	begin 
		if rising_edge (CLK) then
			counter := counter + 1;
			time_led := INIT_TIME_LED;
			if counter = LIMIT_TIMER * time_led - 1 then
				clockTimer <= '1';
				counter := 0;
			else 
				clockTimer <= '0';
			end if;
		end if;
	end process;
	
	-- Control Start_game
	process (startGamePressed, gameRunning, errorHit)
	begin 
		if falling_edge(startGamePressed) then
			gameRunning <= '1';
		end if;
		
		if errorHit = '1' then
			gameRunning <= '0';
		end if;
	end process;
	
	-- Hit detection
	process (startGamePressed, gameRunning, inputPressed, randomNumber, roundNumber, errorHit, successHit)
	begin 
		if (falling_edge(inputPressed) AND gameRunning = '1') then
			if randomNumber = roundNumber then
				successHit <= '1';
			else
				errorHit <= '1';
			end if;
		end if;
		
		if gameRunning = '0' then
			errorHit <= '0';
		end if;
		
	end process;

	-- Control randomNumber
	process (clockTimer, randomNumber, gameRunning, successHit, totalPoints)
	begin 
		if (rising_edge(clockTimer) AND gameRunning = '1') then
			if successHit = '1' then
				totalPoints <= totalPoints + 1;
			end if;
			-- incrementador de led			
			if randomNumber = (NUM_LEDS-1) then
				randomNumber <= 0;
			else
				randomNumber <= randomNumber + 1;
			end if;
		end if;
	end process;

	-- Control roundNumber
	process (successHit, roundNumber, gameRunning)
	begin 
		if (rising_edge(successHit) AND gameRunning = '1') then
			roundNumber <= roundNumber - 1;
		end if;
	end process;
	
	ACENDE_LED: for i in 0 to (NUM_LEDS - 1) generate
		LEDS(i) <= '1' when (i = randomNumber) 	else
					  '0';
	end generate ACENDE_LED;

end architecture;