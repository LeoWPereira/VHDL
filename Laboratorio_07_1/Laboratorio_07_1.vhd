library ieee;
use ieee.std_logic_1164.all;
--
entity Laboratorio_07_1 is
	generic (
		FCLK: NATURAL := 50_000_000;
		NUM_BTN: NATURAL := 3;
		TIME_DEBOUNCE_MS: NATURAL := 2000;
		TIME_MS: NATURAL := 10
	);
	port (
		BTN: IN STD_LOGIC_VECTOR (NUM_BTN-1 DOWNTO 0);
		LED: OUT STD_LOGIC_VECTOR (NUM_BTN-1 DOWNTO 0);
		CLK: IN STD_LOGIC
	);
end entity;
--
architecture Laboratorio_07_1 of Laboratorio_07_1 IS
	constant LIMIT_TIMER: natural := FCLK / 1000 * TIME_MS;
	signal clockTimer: std_logic;
	
	type BtnArray is array (NUM_BTN-1 downto 0) of STD_LOGIC;
	type DebounceArray is array (NUM_BTN-1 downto 0) of natural range 0 to TIME_DEBOUNCE_MS / TIME_MS;
	
	signal debounceCounter:DebounceArray;
	signal btnState:BtnArray;
	signal btnValue:BtnArray;
begin
	-- Combinational part
	g1: FOR i IN 0 TO NUM_BTN - 1 GENERATE
		LED(i) <= '1' when btnValue(i) = '1' else
					 '0';
	END GENERATE g1;
	
	-- Clock to TIME_MS generic variable
	process (CLK, clockTimer)
		variable counter:natural range 0 to LIMIT_TIMER;
	begin 
		if rising_edge (CLK) then
			counter := counter + 1;
			
			if counter = LIMIT_TIMER - 1 then
				clockTimer <= '1';
				counter := 0;
			else 
				clockTimer <= '0';
			end if;
		end if;
	end process;
	
	-- Increase debounceCounter
	process (clockTimer, BTN, btnState, debounceCounter, btnValue)
	begin	
		if rising_edge (clockTimer) then
			for i in 0 to NUM_BTN - 1 loop
				if (BTN(i) = btnState(i)) then
					debounceCounter(i) <= debounceCounter(i) + 1;
				else
					debounceCounter(i) <= 0;
				end if;
				
				-- Botão pressionado
				-- Passa o valor do botão para o LED
				if debounceCounter(i) >= (TIME_DEBOUNCE_MS / TIME_MS) then
					debounceCounter(i) <= 0;
					btnValue(i) <= BTN(i);
				end if;
				
				btnState(i) <= BTN(i);
			end loop;
		end if;
	end process;
end architecture;