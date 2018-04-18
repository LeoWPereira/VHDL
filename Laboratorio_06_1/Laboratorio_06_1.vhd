library ieee;
use ieee.std_logic_1164.all;
--
entity Laboratorio_06_1 is
	generic (
		NUM_LEDS: NATURAL := 5;
		FCLK: NATURAL := 50_000_000;
		TIME_MS: NATURAL := 250
	);
	port (
		LED: OUT STD_LOGIC_VECTOR (NUM_LEDS-1 DOWNTO 0);
		CLK: IN STD_LOGIC
	);
end entity;
--
architecture Laboratorio_06_1 of Laboratorio_06_1 IS
	constant LIMIT_TIMER: natural := FCLK / 1000 * TIME_MS;
	signal clockTimer: std_logic;
	signal position:natural range 0 to NUM_LEDS - 1;
begin
	-- Combinational part
	g1: FOR i IN 0 TO NUM_LEDS - 1 GENERATE
		LED(i) <= '1' when i = position else
					 '0';
	END GENERATE g1;
	
	-- Clock quarter second
	process (CLK)
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
	
	-- Increese position
	process(clockTimer)
	begin	
		if rising_edge (clockTimer) then
			position <= position + 1;
			
			if position >= (NUM_LEDS - 1) then
				position <= 0;
			end if;
		end if;
	end process;
	
end architecture;