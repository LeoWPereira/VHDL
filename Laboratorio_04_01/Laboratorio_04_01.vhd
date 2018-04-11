-------------------------------------

library ieee;

use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use work.own_library.all;

-------------------------------------

entity Laboratorio_04_01 is
	generic (
        DATA_SIZE: integer := 3
    );

	port (
		a: in std_logic_vector((DATA_SIZE - 1) downto 0);

		parry_sel: in std_logic;

		paro: out std_logic);
end entity;

------------------------------------

architecture Laboratorio_04_01 of Laboratorio_04_01 is
	signal parry: std_logic_vector((DATA_SIZE - 1) downto 0);
	
	begin
		parry(0) <= a(0);
		
		c: for i in 1 to (DATA_SIZE - 1) generate
			parry(i) <= parry(i - 1) xor a(i);
		end generate;
		
		paro <= '0' when (parry(DATA_SIZE - 1)='1' and parry_sel='1') or (parry(DATA_SIZE - 1)='0' and parry_sel='0') else
				  '1';
		
		---
		--- SSD
		---

				
end architecture;