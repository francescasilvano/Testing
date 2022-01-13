// created by : Meher Krishna Patel
// date : 22-Dec-2016
// Modified by : Riccardo Cantoro (last change: 18-Nov-2020)


module lfsr
#(
    parameter N = 120,
    parameter SEED = 1
)

(
    input wire clk, reset, enable,
    output wire [N:0] q
);

reg [N:0] r_reg;
wire [N:0] r_next;
wire feedback_value;
                        
always @(posedge clk, posedge reset)
begin 
	if (reset)
			r_reg <= SEED;
	else if (enable)
		    r_reg <= r_next;
end

generate
case (N)
3:
	//// Feedback polynomial : x^3 + x^2 + 1
	////total sequences (maximum) : 2^3 - 1 = 7
	assign feedback_value = r_reg[3] ~^ r_reg[2] ~^ r_reg[0];

4:	assign feedback_value = r_reg[4] ~^ r_reg[3] ~^ r_reg[0];

5:  //maximum length = 28 (not 31)
	assign feedback_value = r_reg[5] ~^ r_reg[3] ~^ r_reg[0];

9:	assign feedback_value = r_reg[9] ~^ r_reg[5] ~^ r_reg[0];

10: assign feedback_value = r_reg[10] ~^ r_reg[7] ~^ r_reg[0];

16: assign feedback_value = r_reg[16] ~^ r_reg[15] ~^ r_reg[13] ~^ r_reg[4] ~^ r_reg[0];

50: assign feedback_value = r_reg[50] ~^ r_reg[49] ~^ r_reg[24] ~^ r_reg[23] ~^ r_reg[0];

100: assign feedback_value = r_reg[100] ~^ r_reg[63] ~^ r_reg[0];

114: assign feedback_value= r_reg[114] ~^ r_reg[113] ~^ r_reg[33] ~^ r_reg[32] ~^ r_reg[0];

120: assign feedback_value = r_reg[120] ~^ r_reg[113] ~^ r_reg[9] ~^ r_reg[2] ~^ r_reg[0];

150: assign feedback_value = r_reg[150] ~^ r_reg[97] ~^ r_reg[0];

300: assign feedback_value = r_reg[7] ~^ r_reg[0];

default: 
	begin
		 initial
			$display("Missing N=%d in the LFSR code, please implement it!", N);
		//illegal missing_case("please implement");
	end
endcase
endgenerate


assign r_next = {feedback_value, r_reg[N:1]};
assign q = r_reg;
endmodule
