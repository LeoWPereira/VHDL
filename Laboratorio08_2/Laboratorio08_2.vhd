-------------------------------------------------------------------------------
-- File downloaded from http://www.nandland.com
-------------------------------------------------------------------------------
-- Description: Simple Testbench for LFSR.vhd.  Set c_NUM_BITS to different
-- values to verify operation of LFSR
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.own_library.all;
 
entity Laboratorio08_2 is
	generic (
		FCLK			: NATURAL := 50_000_000;
		MIN_VALUE	: INTEGER := 0;
		MAX_VALUE	: INTEGER := 9;
		BASE_NUM		: NATURAL := 10
	);
	
	port (
		CLK				: IN STD_LOGIC;
		BTN				: IN STD_LOGIC;
		
		SSDS: out SSDArray(((natural(FLOOR(LOG(real(MAX_VALUE), real(BASE_NUM))) + 1.0))) downto 0)
	);
end entity;
 
architecture behave of Laboratorio08_2 is 
	signal totalValue: integer range MIN_VALUE to MAX_VALUE := 0;
begin
	num2disp: entity work.HexToSSD 
		GENERIC MAP (
			MIN_VALUE 	=> MIN_VALUE, 
			MAX_VALUE 	=> MAX_VALUE, 
			BASE_NUM 	=> BASE_NUM
		) 
		PORT MAP (
			numValue 	=> totalValue, 
			ssds 			=> SSDS
		);
		
	rand: entity work.RNG
		GENERIC MAP (
			MIN_VALUE 	=> MIN_VALUE, 
			MAX_VALUE 	=> MAX_VALUE
		) 
		PORT MAP (
			i_clk			=> CLK,
			i_btn			=> BTN,
			numValue 	=> totalValue
		);
		
		process (CLK) begin 
		if rising_edge (CLK) then
			
		end if;
	end process;
end architecture behave;