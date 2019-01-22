`include "vga_CONFIG.vh"
module vga_driver( hsync, vsync, hc, vc, vidon, clk, rst_n);
	 //VGAµÄÇý¶¯³ÌÐò
	 input clk, rst_n;
	 output hsync, vsync, vidon;
	 output [9:0] hc, vc;
	 
	 reg hsync, vsync, vidon;
	 reg [9:0] hc, vc;
	 reg vsenable;
	 
	 always @(posedge clk)
		begin
		
			if(~rst_n) begin
				hc <= 0;
				vsenable <= 0;
			end
			else
				begin
				
					if(hc == `H_TOTAL - 1)
						begin
						
							hc <= 0;
							vsenable <= 1;
						
						end
					else
						begin
						
							hc <= hc + 1;
							vsenable <= 0;
						end
				end
		
		end
		
	  always @(*)
		begin
		
			if(hc < `H_SYNC)
				hsync = 0;
			else
				hsync = 1;
		
		end
		
	  always @(posedge clk)
		begin
		
			if(~rst_n)
				vc <= 0;
			else
				begin
				
					if(vsenable == 1)
						begin
						
							if(vc == `V_TOTAL - 1)
								vc <= 0;
							else
								vc <= vc + 1;
						
						end
				
				end
		
		end
		
	  always @(*)
		begin
		
			if(vc < `V_SYNC)
				vsync = 0;
			else
				vsync = 1;
		
		end
		
	  always @(*)
		begin
		
			if((hc < `H_SYNC + `H_BACK + `H_DISP) && (hc >= `H_SYNC + `H_BACK) && (vc < `V_SYNC + `V_BACK + `V_DISP) && (vc >= `V_SYNC + `V_BACK))
				vidon = 1;
			else
				vidon = 0;
		
	   end


endmodule