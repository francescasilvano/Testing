library std;
use std.env.all;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

entity riscv_testbench is
end riscv_testbench;


architecture tb of riscv_testbench is

component bist_controller 
  GENERIC (NUMBER_PATTERNS, DEPTH_SCANCHAIN : integer);
  PORT (clk, rst : IN STD_LOGIC;  --clock signals
		start_test: IN STD_LOGIC; --input signal from the external world
		testing, go_nogo: OUT STD_LOGIC;  --output signal to the external world
		test_mode: OUT STD_LOGIC;  --output to the scan chain
		misr_scan_en, lfsr_scan_en, misr_po_en, lfsr_pi_en: OUT STD_LOGIC);  --output to lfsr and misr
END component;

component lfsr
    generic (N    : integer;
             SEED : std_logic_vector(N downto 0));
    port (clk   : in std_logic;
		  enable: in std_logic;
          reset : in std_logic;
          q     : out std_logic_vector(N downto 0));
end component;

component misr
    generic (N    : integer;
             SEED : std_logic_vector(N downto 0));
    port (clk   : in std_logic;
		  enable: in std_logic;
          reset : in std_logic;
		  invalue: in std_logic_vector(N downto 0);
          q     : out std_logic_vector(N downto 0));
end component;

component phase_shifter is
    generic (N    : integer);
    port (clk   : in std_logic;
		  input_p: in std_logic_vector(N downto 0);
          output_p  : out std_logic_vector(N downto 0));
end component;

component riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800 
   port(clk_i : in std_logic; 
        rst_ni: in std_logic;
  	clock_en_i: in std_logic;
  	test_en_i: in std_logic;
  	fregfile_disable_i: in std_logic;
  	boot_addr_i : in std_logic_vector(31 downto 0); 
        core_id_i: in std_logic_vector(3 downto 0); 
  	cluster_id_i: in std_logic_vector(5 downto 0); 
  	instr_req_o: out std_logic; 
 	instr_gnt_i: in std_logic; 
 	instr_rvalid_i: in std_logic;
        instr_addr_o: out std_logic_vector(31 downto 0); 
  	instr_rdata_i: in std_logic_vector(127 downto 0);  
  	data_req_o: out std_logic;  
  	data_gnt_i: in std_logic; 
  	data_rvalid_i: in std_logic; 
        data_we_o: out std_logic;  
  	data_be_o: out std_logic_vector(3 downto 0); 
  	data_addr_o: out std_logic_vector(31 downto 0); 
  	data_wdata_o: out std_logic_vector(31 downto 0);  
  	data_rdata_i: in std_logic_vector(31 downto 0); 
        apu_master_req_o: out std_logic;  
  	apu_master_ready_o: out std_logic;  
  	apu_master_gnt_i: in std_logic; 
        apu_master_operands_o: out std_logic_vector(95 downto 0); 
  	apu_master_op_o: out std_logic_vector(5 downto 0); 
  	apu_master_type_o: out std_logic_vector(2 downto 1); 
        apu_master_flags_o: out std_logic_vector(14 downto 0);  
  	apu_master_valid_i: in std_logic; 
  	apu_master_result_i: in std_logic_vector(31 downto 0); 
        apu_master_flags_i: in std_logic_vector(4 downto 0); 
  	irq_i: in std_logic;
  	irq_id_i: in std_logic_vector(4 downto 0);  
  	irq_ack_o: out std_logic;  
  	irq_id_o: out std_logic_vector(4 downto 0); 
  	irq_sec_i: in std_logic; 
        sec_lvl_o: out std_logic; 
  	debug_req_i: in std_logic; 
  	fetch_enable_i: in std_logic;
  	core_busy_o: out std_logic; 
        ext_perf_counters_i: in std_logic_vector(2 downto 1); 
  	test_si1: in std_logic;
  	test_so1: out std_logic; 
  	test_si2: in std_logic;
  	test_so2: out std_logic; 
  	test_si3: in std_logic;
        test_so3: out std_logic; 
  	test_si4: in std_logic;
 	test_so4: out std_logic; 
 	test_si5: in std_logic;
  	test_so5: out std_logic; 
  	test_si6: in std_logic;
  	test_so6: out std_logic; 
        test_si7: in std_logic;
  	test_so7: out std_logic; 
  	test_si8: in std_logic;
  	test_so8: out std_logic; 
  	test_si9: in std_logic;
  	test_so9: out std_logic; 
  	test_si10: in std_logic; 
        test_so10: out std_logic; 
  	test_si11: in std_logic;
  	test_so11: out std_logic; 
  	test_si12: in std_logic;
  	test_so12: out std_logic; 
  	test_si13: in std_logic;
        test_so13: out std_logic; 
  	test_si14: in std_logic;
  	test_so14: out std_logic; 
  	test_si15: in std_logic;
  	test_so15: out std_logic; 
  	test_si16: in std_logic;
        test_so16: out std_logic; 
  	test_si17: in std_logic;
  	test_so17: out std_logic; 
  	test_si18: in std_logic;
  	test_so18: out std_logic; 
  	test_mode_tp: in std_logic);
end component;


constant clock_t1      : time := 50 ns; --50 ns
constant clock_t2      : time := 30 ns;  --30 ns
constant clock_t3      : time := 20 ns;  --20 ns
constant apply_offset  : time := 0 ns;
constant apply_period  : time := 100 ns;
constant strobe_offset : time := 40 ns;
constant strobe_period : time := 100 ns;


signal tester_clock : std_logic := '0';
--PHASE SHIFTER SIGNAL 
signal phase_shifter_out1 : std_logic_vector(50 downto 0);
signal phase_shifter_out2 : std_logic_vector(300 downto 0);

--BIST CONTROLLER 
signal start_test_s, testing_s, go_nogo_s, test_mode_s: std_logic;

--LFSR OUTPUTS	

	signal enable_lfsr_1: std_logic;
	signal enable_lfsr_2: std_logic;
    signal lfsr1_out  : std_logic_vector(50 downto 0);
    signal lfsr2_out  : std_logic_vector(300 downto 0);
    signal lfsr_clock : std_logic := '0';
    signal lfsr_reset : std_logic;
    signal dut_clock  : std_logic := '0';
    signal dut_reset  : std_logic;

-- MISR SIGNAL
	signal misr_clock : std_logic := '0';
	signal enable_misr_1: std_logic;
	signal enable_misr_2: std_logic;
	signal misr_reset: std_logic;
	signal misr_out1: std_logic_vector(50 downto 0);
	signal misr_out2: std_logic_vector(300 downto 0);

-- DUT OUTPUTS

    signal instr_req_o_s : std_logic;
    signal instr_addr_o_s : std_logic_vector(31 downto 0); 
    signal data_req_o_s : std_logic;
    signal data_we_o_s : std_logic;
    signal data_be_o_s : std_logic_vector(3 downto 0);
    signal data_addr_o_s : std_logic_vector(31 downto 0); 
    signal data_wdata_o_s : std_logic_vector(31 downto 0);  
    signal apu_master_req_o_s : std_logic;  
    signal apu_master_ready_o_s : std_logic;  
    signal apu_master_operands_o_s : std_logic_vector(95 downto 0); 
    signal apu_master_op_o_s : std_logic_vector(5 downto 0); 
    signal apu_master_flags_o_s : std_logic_vector(14 downto 0);  
    signal apu_master_type_o_s: std_logic_vector(2 downto 1);
    signal irq_ack_o_s : std_logic;  
    signal irq_id_o_s : std_logic_vector(4 downto 0); 
    signal sec_lvl_o_s : std_logic; 
    signal core_busy_o_s : std_logic; 
    signal test_so1_s, test_so2_s, test_so3_s, test_so4_s, test_so5_s, test_so6_s, test_so7_s, test_so8_s, test_so9_s, test_so10_s, test_so11_s, test_so12_s, test_so13_s, test_so14_s, test_so15_s, test_so16_s, test_so17_s, test_so18_s: std_logic;  

begin

	controller: bist_controller
	generic map (NUMBER_PATTERNS => 6,
				 DEPTH_SCANCHAIN => 169)
	port map (clk => lfsr_clock,
			  rst => lfsr_reset,
			  start_test => start_test_s,
			  testing => testing_s,
			  go_nogo => go_nogo_s,
			  test_mode => test_mode_s,
			  misr_scan_en => enable_misr_1,
			  lfsr_scan_en => enable_lfsr_1,
			  misr_po_en => enable_misr_2,
			  lfsr_pi_en => enable_lfsr_2);

    stimuli1 : lfsr
    generic map (N => 50,
                 SEED => "011010001000000101110100100100100010001000100010001")
    port map (clk => lfsr_clock,
			  enable=>enable_lfsr_1,
              reset => lfsr_reset,
              q => lfsr1_out);

    phase1: phase_shifter
	generic map(N=>50)
	port map(clk => lfsr_clock,
	input_p =>lfsr1_out,
	output_p=>phase_shifter_out1);

	misr1: misr
    generic map (N => 50,
                 SEED => "011010001000000101110100100100100010001000100010001")
    port map (clk => misr_clock,
			  enable=>enable_misr_1,
              reset => misr_reset,
              invalue => "000000000000000000000000000000000"&test_so1_s & test_so2_s & test_so3_s & test_so4_s & test_so5_s & test_so6_s & test_so7_s & test_so8_s & test_so9_s & test_so10_s & test_so11_s & test_so12_s & test_so13_s & test_so14_s & test_so15_s & test_so16_s & test_so17_s & test_so18_s,
			  q=> misr_out1);

    stimuli2: lfsr
    generic map (N => 300,
                 SEED => "10010100111111101010111111111111000000000000000000010101010100000000000000111111111111111101010001001000100010001000100111110100010001001000001010100100101001111111010101111111111110000000000000000000101010101000000000000001111111111111111010100010010001000100010001001111101000100010010000010101001")
    port map (clk => lfsr_clock,
			  enable=>enable_lfsr_2,
              reset => lfsr_reset,
              q => lfsr2_out);

	phase2: phase_shifter
	generic map(N=> 300)
	port map (clk => lfsr_clock,
			  input_p => lfsr2_out,
			  output_p => phase_shifter_out2);

	misr2: misr
    generic map (N => 300,
                 SEED => "10010100111111101010111111111111000000000000000000010101010100000000000000111111111111111101010001001000100010001000100111110100010001001000001010100100101001111111010101111111111110000000000000000000101010101000000000000001111111111111111010100010010001000100010001001111101000100010010000010101001")
    port map (clk => misr_clock,
			  enable=>enable_misr_2,
              reset => misr_reset,
              invalue => "000000000000000000000000000000000000000000000000000000000000000000000" & instr_req_o_s & instr_addr_o_s & data_req_o_s & data_we_o_s & data_be_o_s & data_addr_o_s & data_wdata_o_s & apu_master_req_o_s & apu_master_ready_o_s & apu_master_operands_o_s & apu_master_op_o_s & apu_master_flags_o_s & apu_master_type_o_s & irq_ack_o_s & irq_id_o_s & sec_lvl_o_s & core_busy_o_s,
			  q=> misr_out2);

              
    dut: riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800
    port map (
    	clk_i => dut_clock, 
        rst_ni => NOT(dut_reset),
  	clock_en_i => '1',
  	test_en_i => '1', 
  	fregfile_disable_i => phase_shifter_out2(0),
  	boot_addr_i => phase_shifter_out2(32 downto 1),
        core_id_i => phase_shifter_out2(36 downto 33), 
  	cluster_id_i => phase_shifter_out2(42 downto 37), 
  	instr_req_o => instr_req_o_s,
 	instr_gnt_i => phase_shifter_out2(43),
 	instr_rvalid_i => phase_shifter_out2(44),
        instr_addr_o => instr_addr_o_s,
  	instr_rdata_i => phase_shifter_out2(255 downto 128),
  	data_req_o => data_req_o_s, 
  	data_gnt_i => phase_shifter_out2(45), 
  	data_rvalid_i => phase_shifter_out2(46), 
        data_we_o => data_we_o_s, 
  	data_be_o => data_be_o_s,
  	data_addr_o => data_addr_o_s,
  	data_wdata_o => data_wdata_o_s, 
  	data_rdata_i => phase_shifter_out2(78 downto 47), 
        apu_master_req_o => apu_master_req_o_s,  
  	apu_master_ready_o => apu_master_ready_o_s,
  	apu_master_gnt_i => phase_shifter_out2(79),
        apu_master_operands_o => apu_master_operands_o_s,
  	apu_master_op_o => apu_master_op_o_s,
  	apu_master_type_o => apu_master_type_o_s,
        apu_master_flags_o => apu_master_flags_o_s,
  	apu_master_valid_i => phase_shifter_out2(80),
  	apu_master_result_i => phase_shifter_out2(112 downto 81),
        apu_master_flags_i => phase_shifter_out2(117 downto 113), 
  	irq_i => phase_shifter_out2(118), 
  	irq_id_i => phase_shifter_out2(123 downto 119),
  	irq_ack_o => irq_ack_o_s,
  	irq_id_o => irq_id_o_s,
  	irq_sec_i => phase_shifter_out2(124),
        sec_lvl_o => sec_lvl_o_s,  
  	debug_req_i => phase_shifter_out2(125),
  	fetch_enable_i => phase_shifter_out2(126),
  	core_busy_o => core_busy_o_s,
        ext_perf_counters_i => phase_shifter_out2(128 downto 127),
  	test_si1 => phase_shifter_out1(0),
  	test_so1 => test_so1_s, 
  	test_si2 => phase_shifter_out1(2),
  	test_so2 => test_so2_s,  
  	test_si3 => phase_shifter_out1(4),
        test_so3 => test_so3_s,
  	test_si4 => phase_shifter_out1(6),
 	test_so4 => test_so4_s,
 	test_si5 => phase_shifter_out1(8),
  	test_so5 => test_so5_s,
  	test_si6 => phase_shifter_out1(15),
  	test_so6 => test_so6_s,
        test_si7 => phase_shifter_out1(17),
  	test_so7 => test_so7_s,
  	test_si8 => phase_shifter_out1(13),
  	test_so8 => test_so8_s,
  	test_si9 => phase_shifter_out1(19),
  	test_so9 => test_so9_s,
  	test_si10 => phase_shifter_out1(30),
        test_so10 => test_so10_s,
  	test_si11 => phase_shifter_out1(50),
  	test_so11 => test_so11_s,
  	test_si12 => phase_shifter_out1(32),
  	test_so12 => test_so12_s,
  	test_si13 => phase_shifter_out1(27),
        test_so13 => test_so13_s,
  	test_si14 => phase_shifter_out1(20),
  	test_so14 => test_so14_s,
  	test_si15 => phase_shifter_out1(23),
  	test_so15 => test_so15_s,
  	test_si16 => phase_shifter_out1(41),
        test_so16 => test_so16_s,
  	test_si17 => phase_shifter_out1(42),
  	test_so17 => test_so17_s,
  	test_si18 => phase_shifter_out1(49),
  	test_so18 => test_so18_s,
  	test_mode_tp => test_mode_s
    );

-- ***** CLOCK/RESET ***********************************

	clock_generation : process
	begin
		loop
			wait for clock_t1; tester_clock <= '1';
			wait for clock_t2; tester_clock <= '0';
			wait for clock_t3;
		end loop;
	end process;

-- dut  ___/----\____ ___/----\____ ___/----\____ ___
-- lfsr /----\____ ___/----\____ ___/----\____ ___/--

    dut_clock <= transport tester_clock after apply_period;
    lfsr_clock <= transport tester_clock after apply_period - clock_t1 + apply_offset;
	misr_clock <= transport lfsr_clock after 10 ns;
    dut_reset <= '0', '1' after clock_t1, '0' after clock_t1 + clock_t2;
    lfsr_reset <= '1', '0' after clock_t1 + clock_t2;
	misr_reset <= '1', '0' after clock_t1 + clock_t2;
	start_test_s <= '0', '1' after clock_t1 + clock_t2 + clock_t1, '0' after 5*clock_t1;
	
--	test_mode_generation: process
--	begin
--		loop
--			test_mode_s <= '0';
--			wait for 100 ns;
--			test_mode_s <= '1';
--          wait for 169*100 ns;
--		end loop;
--	end process;

-- ***** MONITOR **********

--    monitor : process(v_out, cts, ctr)
--		function vec2str( input : std_logic_vector ) return string is
--			variable rline : line;
--		begin
--			write( rline, input );
--			return rline.all;
--		end vec2str;
--    begin
--        std.textio.write(std.textio.output, "v_out:" & vec2str(v_out) & " cts:" & std_logic'image(cts) & " ctr:" & std_logic'image(ctr) & LF);
--    end process;

end tb;

