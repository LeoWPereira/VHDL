-------------------------------------

LIBRARY ieee;

USE ieee.std_logic_1164.ALL;

-------------------------------------

ENTITY Laboratorio_02_4 IS

PORT (

A, B, C, D: IN STD_LOGIC;

L, T, F, R: OUT STD_LOGIC);

END ENTITY;

------------------------------------

ARCHITECTURE Laboratorio_02_4 OF Laboratorio_02_4 IS

BEGIN

 

L <= A AND NOT(C AND D) AND NOT(B AND D);

 

T <= B AND(A AND B) AND NOT(C AND D) AND NOT(B AND D);

 

F <= C AND NOT(C AND D) AND NOT(B AND D);

 

R <= D AND NOT(C AND D) AND NOT(B AND D);

 

END ARCHITECTURE;