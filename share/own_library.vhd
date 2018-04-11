library ieee;

use ieee.std_logic_1164.all;

PACKAGE own_library IS

--------------------------------------------------
TYPE SSD IS ARRAY (6 DOWNTO 0) OF std_logic;
--------------------------------------------------

--------------------------------------------------
constant SSD_0: SSD := "1000000";
constant SSD_1: SSD := "1111001";
constant SSD_2: SSD := "0100100";
constant SSD_3: SSD := "0110000";
constant SSD_4: SSD := "0011001";
constant SSD_5: SSD := "0010010";
constant SSD_6: SSD := "0000010";
constant SSD_7: SSD := "1111000";
constant SSD_8: SSD := "0000000";
constant SSD_9: SSD := "0011000";
constant SSD_A: SSD := "0001000";
constant SSD_B: SSD := "0000011";
constant SSD_C: SSD := "1000110";
constant SSD_D: SSD := "0100001";
constant SSD_E: SSD := "0000110";
constant SSD_F: SSD := "0001110";
--------------------------------------------------



END own_library;