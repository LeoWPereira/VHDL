library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all; 

entity Laboratorio_07_02 is
	generic (
		NUM_LEDS : NATURAL := 10;
		FCLK     : NATURAL := 50_000_000;
		START_SPEED_MS: NATURAL := 50
	);
	
	port (
		BTN_TAIL_UP: IN STD_LOGIC;
		BTN_TAIL_DOWN: IN STD_LOGIC;
		BTN_REVERSE: IN STD_LOGIC;
		SW_SPEED: IN STD_LOGIC_VECTOR (2 downto 0);
	
		LED: OUT STD_LOGIC_VECTOR (NUM_LEDS - 1 downto 0);
		
		CLK: IN STD_LOGIC
	);
end entity;
--
architecture Laboratorio_07_02 of Laboratorio_07_02 IS
	constant START_SPEED: natural := FCLK / 1000 * START_SPEED_MS;
	
	signal clockSpeed: std_logic;
	
	signal speed:natural range 1 to 8;
	
	signal position:integer range -1 to NUM_LEDS;
	signal tailSize: natural range 1 to NUM_LEDS - 1;
	signal directionReverse:boolean;

	signal limit_sup, limit_inf: natural range 0 to NUM_LEDS - 1;
	signal tail_limit: integer;
	
	signal tailWatch: std_logic;
	
	signal reverseWatch, tailDownWatch, tailUpWatch: std_logic;
	
	signal leds_on_off: std_logic_vector (NUM_LEDS - 1 downto 0);
begin

	speed <= to_integer(unsigned(SW_SPEED)) + 1;
	
	btnReverse: entity work.debouncer PORT MAP (clk => CLK, button => BTN_REVERSE, result => reverseWatch);
	btnTailUp: entity work.debouncer PORT MAP (clk => CLK, button => BTN_TAIL_UP, result => tailUpWatch);
	btnTailDown: entity work.debouncer PORT MAP (clk => CLK, button => BTN_TAIL_DOWN, result => tailDownWatch);

	-- leds recebem valor do sinal adquirido em um dos processos
	LED <= leds_on_off;
	
	-- processo para 
	process (CLK, clockSpeed, speed)
		variable counter_speed:natural;
	begin 
		if rising_edge (CLK) then
			----------------------------------------------
			-- COUNTER SPEED
			----------------------------------------------
			counter_speed := counter_speed + 1;
			
			if counter_speed >= (START_SPEED - 1) * speed then
				clockSpeed <= '1';
				counter_speed := 0;
			else 
				clockSpeed <= '0';
			end if;
		end if;
	end process;
	
	tailWatch <= tailDownWatch nand tailUpWatch;
	
	process (reverseWatch, directionReverse, tailWatch, tailUpWatch, tailSize)
	begin
		if rising_edge (reverseWatch) then
			directionReverse <= not directionReverse;
		end if;
		
		if rising_edge(tailWatch) then
			if (tailUpWatch = '1') then
				if (tailSize < NUM_LEDS - 1) then
					tailSize <= tailSize + 1;
				end if;
			else 
				if (tailSize > 1) then
					tailSize <= tailSize - 1;
				end if;
			end if;
		end if;
		
	end process;
	
	process (clockSpeed, position, tailSize, directionReverse, leds_on_off)
		variable current_tail, position_init:integer;
	begin	
		if rising_edge (clockSpeed) then
			----------------------------------------------
			-- Position Control
			----------------------------------------------
			if (directionReverse) then
				position <= position - 1;
				
				if position <= 0 then
					position <= NUM_LEDS - 1;
				end if;
			else
				position <= position + 1;
				if position >= NUM_LEDS - 1 then
					position <= 0;
				end if;
			end if;
			
			current_tail := tailSize;
			position_init := position;
			for i in 0 to NUM_LEDS - 1 loop
			
				if current_tail > 0 then
					leds_on_off (position_init) <= '1';
				else
					leds_on_off (position_init) <= '0';
				end if;
				
				current_tail := current_tail - 1;
				if (directionReverse) then
					position_init := position_init - 1;
					
					if position_init < 0 then
						position_init := NUM_LEDS - 1;
					end if;
				else
					position_init := position_init + 1;
					if position_init > NUM_LEDS - 1 then
						position_init := 0;
					end if;
				end if;
			end loop;
		end if;
	end process;
	
end architecture;