library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.own_library.all;

entity Laboratorio08_1 is
	generic (
		FCLK: NATURAL := 50_000_000;
		MIN_VALUE: INTEGER := -255;
		MAX_VALUE: INTEGER := 255;
		BASE_NUM 	: natural := 16
	);
	
	port (
		BTN_DEC: IN STD_LOGIC;
		BTN_INC: IN STD_LOGIC;
		SSDS: out SSDArray(((natural(FLOOR(LOG(real(MAX_VALUE), real(BASE_NUM))) + 1.0))) downto 0);
		CLK: IN STD_LOGIC
	);
end entity;
--
architecture Laboratorio08_1 of Laboratorio08_1 IS
	signal decWatch, incWatch, changeWatch: std_logic;
	signal totalValue: integer range MIN_VALUE to MAX_VALUE := 0;
begin
	
	btnDec: entity work.debouncer PORT MAP (clk => CLK, button => BTN_DEC, result => decWatch);
	btnInc: entity work.debouncer PORT MAP (clk => CLK, button => BTN_INC, result => incWatch);
	
	num2disp: entity work.HexToSSD GENERIC MAP (MIN_VALUE => MIN_VALUE, MAX_VALUE => MAX_VALUE, BASE_NUM => BASE_NUM) PORT MAP (numValue => totalValue, ssds => SSDS);

	changeWatch <= decWatch nand incWatch;
	
	process (changeWatch, incWatch, totalValue, decWatch)
	begin 
		if rising_edge (changeWatch) then
			if incWatch = '1' then
				totalValue <= totalValue + 1;
				if (totalValue >= MAX_VALUE) then
					totalValue <= MAX_VALUE;
				end if;
			elsif decWatch = '1' then
				totalValue <= totalValue - 1;
				if (totalValue <= MIN_VALUE) then
					totalValue <= MIN_VALUE;
				end if;
			end if;
		end if;
	end process;
end architecture;