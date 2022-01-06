
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
signal r_reg: std_logic_vector(N downto 0);
begin
	behaviour: process(clk)
	begin
    if clk'event and clk = '1' then 
        r_reg <= input_p(0) & input_p(N downto 1);
	end if;
	end process;
	output_p<= r_reg XOR input_p;
              
end beh;