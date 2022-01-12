LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;

ENTITY multiplexer is
  GENERIC (N : integer);
  PORT (input_pi, input_lfsr: IN STD_LOGIC_VECTOR(N DOWNTO 0);
		output_port: OUT STD_LOGIC_VECTOR(N DOWNTO 0);
		testing: IN STD_LOGIC
       );  
END multiplexer;

ARCHITECTURE df OF multiplexer IS

BEGIN

		output_port <= input_pi WHEN testing = '0' ELSE 
					   input_lfsr;

END df;

