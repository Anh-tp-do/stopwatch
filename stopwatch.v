module stopwatch 
	(
	input wire clk,					// clock signal
	input wire go, res,				// go and reset
	output wire [3:0]  d1, d0
	);
	
	localparam MDV = 250 000; 			// 25MHz clock on board 
	reg [21:0] ms_reg;					// 1001100010010110100000 at most 
	wire [21:0] ms_next;
	reg [3:0]  d1_reg, d0_reg;			// 1001 at most 
	wire [3:0] d1_next, d0_next;
	wire d1_en, d2_en;
	wire ms_tick, d1_tick, d0_tick;
	
	always @(posedge clk)
	begin 							// register 
		ms_reg <= ms_next;
		d1_reg <= d1_next;
		d0_reg <= d0_next;
	end
	
	// mod-2500000
	
	// 1 sec tick
	assign ms_next = (res || (ms_reg == MDV && go)) ? 4'b0 : 
						(go) ? (ms_reg + 1) : ms_reg;
	assign ms_tick = (ms_reg == MDV) ? 1'b1 : 1'b0;
	
	// 1 sec counter 
	assign d0_en = ms_tick;
	assign d0_next = (res || (d0_en && d0_reg ==9)) ? 4'b0 :
						(d0_en) ? (d0_reg + 1) : d0_reg;
	assign d0_tick = (d0_reg == 9) ? 1'b1 : 1'b0 ;
	
	
	// 10 sec counter 
	assign d1_en = ms_tick & d0_tick;
	assign d1_next = (res || (d1_en && d0_reg == 9)) ? 4'b0:
						(d1_en) ? d1_reg + 1: d1_reg;	
	assign d1_tick = (d1_reg == 9) ? 1'b1 : 1'b0;
	
	// output 
	assign d0 = d0_reg;
	assign d1 = d1_reg;
	assign d2 = d2_reg;
	
endmodule 