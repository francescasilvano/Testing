LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;

ENTITY bist_controller is
  GENERIC (NUMBER_PATTERNS, DEPTH_SCANCHAIN : integer);
  PORT (clk, rst : IN STD_LOGIC;  --clock signals
		start_test: IN STD_LOGIC; --input signal from the external world
		testing, go_nogo: OUT STD_LOGIC;  --output signal to the external world
		test_mode, test_point: OUT STD_LOGIC;  --output to the scan chain
		misr_scan_en, lfsr_scan_en, misr_po_en, lfsr_pi_en: OUT STD_LOGIC;
		misr_scan_q: IN STD_LOGIC_VECTOR(50 DOWNTO 0);
	    misr_po_q: IN STD_LOGIC_VECTOR(300 DOWNTO 0)
       );  
END bist_controller;

ARCHITECTURE fsm OF bist_controller IS

TYPE stateType IS (START, UPLOAD_SCAN, UPLOAD_DOWNLOAD_SCAN, CAPTURE_PO, COMPLETE, COMPARE, TEST_PASS, TEST_FAIL);
SIGNAL currState: stateType;
SIGNAL scanCounter: STD_LOGIC_VECTOR((integer(ceil(log2(real(DEPTH_SCANCHAIN))))+1) downto 0);
SIGNAL patternCounter: STD_LOGIC_VECTOR ((integer(ceil(log2(real(NUMBER_PATTERNS))))+1) downto 0);

BEGIN

	PROCESS (clk, rst)
	BEGIN
		IF (RST = '1') THEN
			currState <= START;
			testing <= '0';
			go_nogo <= '0';
			test_mode <= '0';
			misr_scan_en <= '0';
			lfsr_scan_en <= '0';
			misr_po_en <= '0';
			lfsr_pi_en <= '0';
			test_point <= '0';
			scanCounter <= (OTHERS => '0');
			patternCounter <= (OTHERS => '0');
		ELSIF (rising_edge(clk)) THEN
			CASE currState IS
				WHEN START =>
					testing <= '0';
					go_nogo <= '0';
					test_mode <= '0';
					misr_scan_en <= '0';
					lfsr_scan_en <= '0';
					misr_po_en <= '0';
					lfsr_pi_en <= '0';
					test_point <= '0';
					IF (start_test = '1') then
						currState <= UPLOAD_SCAN;
					ELSE
						currState <= START;
					END IF;
				WHEN UPLOAD_SCAN =>
					testing <= '1';
					go_nogo <= '0';
					test_mode <= '1';
					misr_scan_en <= '0';
					lfsr_scan_en <= '1';
					misr_po_en <= '0';
					lfsr_pi_en <= '0';
					test_point <= '1';
					scanCounter <= std_logic_vector(unsigned(scanCounter) + 1);
					IF(to_integer(unsigned(scanCounter)) = DEPTH_SCANCHAIN - 1) THEN
						currState <= CAPTURE_PO;
					ELSE
						currState <= UPLOAD_SCAN;
					END IF;
			    WHEN UPLOAD_DOWNLOAD_SCAN =>
					testing <= '1';
					go_nogo <= '0';
					test_mode <= '1';
					misr_scan_en <= '1';
					lfsr_scan_en <= '1';
					misr_po_en <= '0';
					lfsr_pi_en <= '0';
					test_point <= '1';
					scanCounter <= std_logic_vector(unsigned(scanCounter) + 1);
					IF(to_integer(unsigned(scanCounter)) = DEPTH_SCANCHAIN - 1) THEN
						currState <= CAPTURE_PO;
					ELSE
						currState <= UPLOAD_DOWNLOAD_SCAN;
					END IF;
				WHEN CAPTURE_PO => 
					testing <= '1';
					go_nogo <= '0';
					test_mode <= '0';
					misr_scan_en <= '0';
					lfsr_scan_en <= '0';
					misr_po_en <= '1';
					lfsr_pi_en <= '1';
					test_point <= '1';
					scanCounter <= (OTHERS => '0');
					patternCounter <= std_logic_vector(unsigned(patternCounter) + 1);
					IF (to_integer(unsigned(patternCounter)) = NUMBER_PATTERNS) then
						currState <= COMPLETE;
					ELSE
						currState <= UPLOAD_DOWNLOAD_SCAN;
					END IF;
				WHEN COMPLETE =>
					testing <= '1';
					go_nogo <= '0';
					test_mode <= '0';
					misr_scan_en <= '0';
					lfsr_scan_en <= '0';
					misr_po_en <= '0';
					lfsr_pi_en <= '0';
					test_point <= '0';
					patternCounter <=  (OTHERS => '0');
					currState <= COMPARE;
				WHEN COMPARE => 
					testing <= '1';
					go_nogo <= '0';
					test_mode <= '0';
					misr_scan_en <= '0';
					lfsr_scan_en <= '0';
					misr_po_en <= '0';
					lfsr_pi_en <= '0';
					test_point <= '0';
					IF (misr_scan_q = "000"&X"00000000FF3E" AND misr_po_q = '0'&X"0000000000000000012032F789E71C8C50D4DC139C24A36FFCD61F88E1C4B563ECE163D3F24") then
						currState <= TEST_PASS;
					ELSE
						currState <= TEST_FAIL;
					END IF;
				WHEN TEST_PASS =>
					testing <= '0';
					go_nogo <= '1';
					test_mode <= '0';
					misr_scan_en <= '0';
					lfsr_scan_en <= '0';
					misr_po_en <= '0';
					lfsr_pi_en <= '0';
					test_point <= '0';
					currState <= TEST_PASS;
				WHEN TEST_FAIL =>
					testing <= '0';
					go_nogo <= '0';
					test_mode <= '0';
					misr_scan_en <= '0';
					lfsr_scan_en <= '0';
					misr_po_en <= '0';
					lfsr_pi_en <= '0';
					test_point <= '0';
					currState <= TEST_FAIL;
				WHEN OTHERS =>
					currState <= START;
			END CASE;
		END IF;
	END PROCESS;

END fsm;
