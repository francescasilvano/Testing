library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

entity riscv_top_testbench is
end riscv_top_testbench;

architecture tb of riscv_top_testbench is

component riscv_top IS
   port(--clock
		clk_i : in std_logic; 
        rst_ni: in std_logic;
		--BIST control signals		
		start_test_i: in std_logic;
		testing_o, go_nogo_o: out std_logic;
		--processor PIs and POs
  		clock_en_i: in std_logic;
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
        ext_perf_counters_i: in std_logic_vector(2 downto 1)
		);
END component;

		signal clk_i_s : std_logic:= '0';
        signal rst_ni_s: std_logic:= '1';
		signal start_test_i_s: std_logic:= '0';
		signal testing_o_s, go_nogo_o_s: std_logic;
  		signal clock_en_i_s: std_logic:= '1';
  		signal fregfile_disable_i_s: std_logic:= '0';
  		signal boot_addr_i_s: std_logic_vector(31 downto 0):= (OTHERS => '0');
        signal core_id_i_s: std_logic_vector(3 downto 0):= (OTHERS => '0');
  		signal cluster_id_i_s: std_logic_vector(5 downto 0):= (OTHERS => '0'); 
  		signal instr_req_o_s: std_logic:= '0';
 		signal instr_gnt_i_s: std_logic:= '0'; 
 		signal instr_rvalid_i_s: std_logic:= '0';
        signal instr_addr_o_s: std_logic_vector(31 downto 0):= (OTHERS => '0');
  		signal instr_rdata_i_s: std_logic_vector(127 downto 0):= (OTHERS => '0');  
  		signal data_req_o_s: std_logic:= '0'; 
  		signal data_gnt_i_s: std_logic:= '0';
  		signal data_rvalid_i_s: std_logic:= '0';
        signal data_we_o_s: std_logic:= '0';  
  		signal data_be_o_s: std_logic_vector(3 downto 0):= (OTHERS => '0');
  		signal data_addr_o_s: std_logic_vector(31 downto 0):= (OTHERS => '0');
  		signal data_wdata_o_s: std_logic_vector(31 downto 0):= (OTHERS => '0'); 
  		signal data_rdata_i_s: std_logic_vector(31 downto 0):= (OTHERS => '0');
        signal apu_master_req_o_s: std_logic:= '0'; 
  		signal apu_master_ready_o_s: std_logic:= '0';  
  		signal apu_master_gnt_i_s: std_logic:= '0';
        signal apu_master_operands_o_s: std_logic_vector(95 downto 0):= (OTHERS => '0');
  		signal apu_master_op_o_s: std_logic_vector(5 downto 0):= (OTHERS => '0');
  		signal apu_master_type_o_s: std_logic_vector(2 downto 1):= (OTHERS => '0');
        signal apu_master_flags_o_s: std_logic_vector(14 downto 0):= (OTHERS => '0');  
  		signal apu_master_valid_i_s: std_logic:= '0';
  		signal apu_master_result_i_s: std_logic_vector(31 downto 0):= (OTHERS => '0');
        signal apu_master_flags_i_s: std_logic_vector(4 downto 0):= (OTHERS => '0');
  		signal irq_i_s: std_logic:= '0';
  		signal irq_id_i_s: std_logic_vector(4 downto 0):= (OTHERS => '0');
  		signal irq_ack_o_s: std_logic:= '0';
  		signal irq_id_o_s: std_logic_vector(4 downto 0):= (OTHERS => '0');
  		signal irq_sec_i_s: std_logic:= '0';
        signal sec_lvl_o_s: std_logic:= '0';
  		signal debug_req_i_s: std_logic:= '0';
  		signal fetch_enable_i_s: std_logic:= '0';
  		signal core_busy_o_s: std_logic:= '0';
        signal ext_perf_counters_i_s: std_logic_vector(2 downto 1) := (OTHERS => '0');

begin

dut: riscv_top 
	port map(
		clk_i => clk_i_s,
        rst_ni => rst_ni_s,
		--BIST control signals		
		start_test_i => start_test_i_s,
		testing_o => testing_o_s, 
		go_nogo_o => go_nogo_o_s,
		--processor PIs and POs
  		clock_en_i => '1',
  		fregfile_disable_i  => fregfile_disable_i_s,
  		boot_addr_i => boot_addr_i_s,
        core_id_i => core_id_i_s,
  		cluster_id_i => cluster_id_i_s,
  		instr_req_o => instr_req_o_s,
 		instr_gnt_i => instr_gnt_i_s, 
 		instr_rvalid_i => instr_rvalid_i_s,
        instr_addr_o => instr_addr_o_s,
  		instr_rdata_i => instr_rdata_i_s, 
  		data_req_o => data_req_o_s, 
  		data_gnt_i => data_gnt_i_s,
  		data_rvalid_i => data_rvalid_i_s,
        data_we_o => data_we_o_s,
  		data_be_o => data_be_o_s,
  		data_addr_o => data_addr_o_s,
  		data_wdata_o => data_wdata_o_s,
  		data_rdata_i => data_rdata_i_s,
        apu_master_req_o => apu_master_req_o_s,
  		apu_master_ready_o => apu_master_ready_o_s,
  		apu_master_gnt_i => apu_master_gnt_i_s,
        apu_master_operands_o => apu_master_operands_o_s,
  		apu_master_op_o => apu_master_op_o_s,
  		apu_master_type_o => apu_master_type_o_s,
        apu_master_flags_o => apu_master_flags_o_s,
  		apu_master_valid_i => apu_master_valid_i_s,
  		apu_master_result_i => apu_master_result_i_s,
        apu_master_flags_i => apu_master_flags_i_s,
  		irq_i => irq_i_s,
  		irq_id_i => irq_id_i_s,
  		irq_ack_o => irq_ack_o_s,
  		irq_id_o => irq_id_o_s,
  		irq_sec_i => irq_sec_i_s,
        sec_lvl_o => sec_lvl_o_s,
  		debug_req_i => debug_req_i_s,
  		fetch_enable_i => fetch_enable_i_s,
  		core_busy_o => core_busy_o_s,
        ext_perf_counters_i => ext_perf_counters_i_s
	);

clock_generation : process
	begin
		loop
			wait for 25 ns; clk_i_s <= '1';
			wait for 50 ns; clk_i_s <= '0';
			wait for 25 ns;
		end loop;
	end process;

	rst_ni_s <= '1', '0' after 20 ns, '1' after 200 ns;
	start_test_i_s <= '0', '1' after 300 ns, '0' after 600 ns;

end tb;


