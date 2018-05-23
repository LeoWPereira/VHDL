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
		INIT_TIME_LED: NATURAL := 800; -- value in ms
		TIME_MS: NATURAL := 1;
		MAX_POINTS: NATURAL := 5;
		BASE_NUM:	NATURAL	:= 10
	);
	
	port (
		SSDS_POINTS: out SSDArray(((natural(FLOOR(LOG(real(MAX_POINTS), real(BASE_NUM))) + 1.0))) downto 0);
		SSD_RANDOM_POSITION: out SSDArray(((natural(FLOOR(LOG(real(NUM_LEDS - 1), real(BASE_NUM))) + 1.0))) downto 0);
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
	signal gameWon: std_logic := '0';
	signal roundNumber: natural range 0 to NUM_LEDS-1 := 5;
	signal randomNumber: natural range 0 to NUM_LEDS-1 := 0;
	signal totalPoints: natural range 0 to (MAX_POINTS + 2) := 0;
	signal errorHit: std_logic := '0';
begin
	btnInput: entity work.debouncer PORT MAP (clk => CLK, button => BTN_INPUT, result => inputPressed);
	btnStartGame: entity work.debouncer PORT MAP (clk => CLK, button => START_GAME, result => startGamePressed);
	
	num2dispPoints: entity work.HexToSSD GENERIC MAP (MIN_VALUE => 0, MAX_VALUE => MAX_POINTS) PORT MAP (numValue => totalPoints, ssds => SSDS_POINTS);
	num2dispRandomNumber: entity work.HexToSSD GENERIC MAP (MIN_VALUE => 0, MAX_VALUE => NUM_LEDS - 1) PORT MAP (numValue => roundNumber, ssds => SSD_RANDOM_POSITION);

	-- Timer
	process (CLK, clockTimer, totalPoints)
		variable time_led: natural := INIT_TIME_LED;
		variable counter:natural range 0 to LIMIT_TIMER * INIT_TIME_LED;
	begin 
		if rising_edge (CLK) then
			counter := counter + 1;
			time_led := INIT_TIME_LED -(totalPoints * (INIT_TIME_LED / (MAX_POINTS*2)));
			if counter = LIMIT_TIMER * time_led - 1 then
				clockTimer <= '1';
				counter := 0;
			else 
				clockTimer <= '0';
			end if;
		end if;
	end process;
	
	-- Control Start_game
	process (startGamePressed, gameRunning, errorHit, gameWon)
	begin 
		if falling_edge(startGamePressed) then
			gameRunning <= '1';
		end if;
		
		if errorHit = '1' then
			gameRunning <= '0';
		end if;
		
		if gameWon = '1' then
			gameRunning <= '0';
		end if;
			
	end process;
	
	-- Game won
	process (totalPoints, gameRunning, gameWon)
	begin 		
		if totalPoints = (MAX_POINTS + 1) then
			gameWon <= '1';
		end if;	

		if gameRunning = '0' then
			gameWon <= '0';
		end if;
	end process;
	
	process (startGamePressed, gameRunning, inputPressed, randomNumber, roundNumber, errorHit, totalPoints)
		variable successHit: std_logic := '0';
		variable hitNotDetected: std_logic := '0';
	begin 
		if (falling_edge(inputPressed) AND gameRunning = '1') then
			-- Hit detection
			if randomNumber = roundNumber then
				successHit := '1';
			else
				errorHit <= '1';
			end if;
			
			if successHit = '1' then
				-- Control roundNumber
				roundNumber <= roundNumber - 1;
				
				-- Control points
				totalPoins <= totalPoints + 1;
			end if;
		end if;
		
		-- Control randomNumber
		if (rising_edge(clockTimer) AND gameRunning = '1') then
			if randomNumber = roundNumber AND successHit = '0' then
				hitNotDetected := '1';
			else
				hitNotDetected := '0';
			end if;
			-- incrementador de led			
			if randomNumber = (NUM_LEDS-1) then
				randomNumber <= 0;
			else
				randomNumber <= randomNumber + 1;
			end if;
		end if;
		
		if hitNotDetected = '1' then
			errorHit <= hitNotDetected;
		end if;
		
		if gameRunning = '0' then
			errorHit <= '0';
			-- roundNumber default is 5
			roundNumber <= 5;
			-- totalPoints default is 0
			totalPoints <= 0;
			-- led starts at 0
			randomNumber <= 0;
		end if;
		
		successHit := '0';
		hitNotDetected := '0';
		
	end process;
	
	ACENDE_LED: for i in 0 to (NUM_LEDS - 1) generate
		LEDS(i) <= '1' when (i = randomNumber) 	else
					  '0';
	end generate ACENDE_LED;

end architecture;