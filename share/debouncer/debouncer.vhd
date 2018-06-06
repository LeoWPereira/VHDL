LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.math_real.all;

ENTITY debouncer IS
GENERIC(
	FCLK: NATURAL := 50_000_000
);
PORT (
	clk: IN STD_LOGIC;
	button: IN STD_LOGIC;
	result: OUT STD_LOGIC
);
END ENTITY;

architecture arch of debouncer is
	constant TEMPO_25MS: NATURAL := FCLK / 40;	-- 100ms
	signal aux_output: STD_LOGIC;
begin
process(clk)
variable counter: natural range 0 to TEMPO_25MS;
variable old_input: STD_LOGIC;
begin
	if rising_edge(clk) then
		if old_input = button then
			counter := counter + 1;
			if counter = TEMPO_25MS - 1 then
				aux_output <= button;
			end if;
		else
			counter := 0;
		end if;
		old_input := button;	
	end if;	
end process;

process(clk)
variable old_input: STD_LOGIC;
begin
	if rising_edge(clk) then
		if aux_output = '1' and old_input = '0' then
			result <= '1';
		else
			result <= '0';
		end if;
		old_input := aux_output;	
	end if;
end process;
end architecture;