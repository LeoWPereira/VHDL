library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.own_library.all;

entity Laboratorio08_2 is
	generic (
		FCLK: NATURAL := 50_000_000;
		NUM_LEDS: NATURAL := 8;
		INIT_TIME_LED: NATURAL := 2000; -- value in ms
		MAX_POINTS: INTEGER := 5;
		TIME_MS: NATURAL := 10
	);
	
	port (
		START_GAME: IN STD_LOGIC;
		BTN_INPUT: IN STD_LOGIC;
		SSDS_POINTS: out SSDArray(NATURAL(FLOOR (LOG10(REAL (MAX_POINTS))) + 1.0) DOWNTO 0);	
		SSD_RANDOM_POSITION: out SSDArray(NATURAL(FLOOR (LOG10(REAL (NUM_LEDS))) + 1.0) DOWNTO 0);
		CLK: IN STD_LOGIC
	);
end entity;
--
architecture Laboratorio08_2 of Laboratorio08_2 IS
	signal inputPressed, startGamePressed: std_logic;
	signal totalPoints: integer range 0 to MAX_POINTS + 1;

	constant LIMIT_TIMER: natural := FCLK / 1000 * TIME_MS;
	signal time_led: natural := INIT_TIME_LED;
	signal clockTimer: std_logic;
	signal gameRunning: std_logic;
	signal btnNotPressed: std_logic;
	signal num2BePressed:natural range 0 to NUM_LEDS;
	signal led2BeTurnedOn: natural range 0 to NUM_LEDS;
begin

	btnInput: entity work.debouncer PORT MAP (clk => CLK, button => BTN_INPUT, result => inputPressed);
	btnStartGame: entity work.debouncer PORT MAP (clk => CLK, button => START_GAME, result => startGamePressed);
	
	num2dispPoints: entity work.HexToSSD GENERIC MAP (MIN_VALUE => 0, MAX_VALUE => MAX_POINTS) PORT MAP (numValue => totalPoints, ssds => SSDS_POINTS);
	num2dispRandomNumber: entity work.HexToSSD GENERIC MAP (MIN_VALUE => 1, MAX_VALUE => MAX_POINTS) PORT MAP (numValue => num2BePressed, ssds => SSD_RANDOM_POSITION);


		
	-- Process to start game and set signal gameRunning
	process (startGamePressed, gameRunning, totalPoints, btnNotPressed)
	begin 
		if rising_edge (startGamePressed) then
			gameRunning <= '1';
			totalPoints <= 0;
			btnNotPressed <= '0';
		end if;
	end process;

	-- Clock to generate rising_edge for the game depending on the time_led variable
	process (CLK, clockTimer, time_led)
		variable counter:natural;
	begin 
		if rising_edge (CLK) then
			counter := counter + 1;
			
			if counter = LIMIT_TIMER * time_led - 1 then
				clockTimer <= '1';
				counter := 0;
			else 
				clockTimer <= '0';
			end if;
		end if;
	end process;

	-- Change led block: changes the led after the time has run out
	process (gameRunning, clockTimer, num2BePressed, led2BeTurnedOn, btnNotPressed)
	begin 
		if gameRunning = '1' then
			if rising_edge (clockTimer) then
				if num2BePressed = led2BeTurnedOn AND btnNotPressed = '1' then
					-- game over
					gameRunning <= '0';
				else
					-- Generate another random led position
					
					-- button resets to not pressed
					btnNotPressed <= '1';
				end if;
			end if;
		end if;
	end process;
	
	-- Input Block: checks if the led corresponds to the led to be pressed
	
end architecture;