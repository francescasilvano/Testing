
library std;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity phase_shifter is
    generic (N    : integer);
    port (clk   : in std_logic;
		  input_p: in std_logic_vector(N downto 0);
          output_p  : out std_logic_vector(N downto 0));
end phase_shifter;

architecture beh of phase_shifter is
begin

	output_p<= (input_p(0) & input_p(N downto 1)) XOR input_p XOR (input_p(0) & input_p(1) & input_p(N downto 2));

	
              
end beh;
