-------------------------------------------------------------------------------
-- File downloaded from http://www.nandland.com
-------------------------------------------------------------------------------
-- Description:
-- A RNG or Linear Feedback Shift Register is a quick and easy
-- way to generate pseudo-random data inside of an FPGA.  The RNG can be used
-- for things like counters, test patterns, scrambling of data, and others.
-- This module creates an RNG whose width gets set by a generic.  The
-- o_LFSR_Done will pulse once all combinations of the RNG are complete.  The
-- number of clock cycles that it takes o_LFSR_Done to pulse is equal to
-- 2^g_Num_Bits-1.  For example, setting g_Num_Bits to 5 means that o_LFSR_Done
-- will pulse every 2^5-1 = 31 clock cycles.  o_LFSR_Data will change on each
-- clock cycle that the module is enabled, which can be used if desired.
--
-- Generics:
-- g_Num_Bits - Set to the integer number of bits wide to create your RNG.
-------------------------------------------------------------------------------
 
library ieee; 
use ieee.std_logic_1164.all;
 
entity RNG is
	generic (
		MIN_VALUE	:	integer 	:= 0;
		MAX_VALUE	:	integer 	:= 15
	);
	
  port (
	  i_clk           : in  std_logic;
	  i_btn				: in  std_logic;
	  
	  numValue			: out integer range MIN_VALUE to MAX_VALUE  
	);
end entity RNG;

architecture rtl of RNG is  
	signal totalValue: integer range MIN_VALUE to MAX_VALUE := 0;
	
begin
	process (i_clk, totalValue) begin 
		if rising_edge (i_clk) then
			totalValue <= totalValue + 1;
			 
		 if(totalValue = MAX_VALUE) then
			totalValue <= MIN_VALUE;
		 end if;
		end if;
	end process;
	
	process (i_btn, totalValue) begin 
		if rising_edge (i_btn) then
			numValue <= totalValue;
		end if;
	end process;
end architecture rtl;