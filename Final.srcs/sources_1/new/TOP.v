module vga_640x480_picture_top(hsync, vsync, red, green, blue, clk, rst_n, ena, wea);
	 
	 input clk, rst_n,ena,wea;
	 output hsync, vsync;
	 output [3:0] red, green, blue;
	 
	 wire clk25M, vidon;
	 wire [9:0] hc, vc;//vga相关
	 wire [11:0] M_o, M_c;//转灰度图用
	 wire [11:0] M11,M12,M13,M21,M22,M23,M31,M32,M33;//3X3的子矩阵
	 wire [14:0] rom_addr15;//地址
	 reg [11:0]dina, temp;//写入端
	 wire [11:0] result;//每个3X3的子矩阵的卷积结果
	 
	 always @(posedge clk25M)
	 begin//平均值法转灰度图
	   temp<=(M_o[3:0]+M_o[11:8]+M_o[7:4])/3;
	   dina<={temp[3:0],temp[3:0],temp[3:0]};
	 end
	 
	 
    clkdiv U1(.clk25M(clk25M), .clk(clk), .rst_n(rst_n));//时钟分频为25M Hz
    vga_driver U2(.hsync(hsync), .vsync(vsync), .hc(hc), .vc(vc), .vidon(vidon), .clk(clk25M), .rst_n(rst_n));//VGA驱动
	vga_data U3(.rom_addr15(rom_addr15), .red(red), .green(green), .blue(blue), .vidon(vidon), .hc(hc), .vc(vc), .M(result));//计算像素地址，并计算RGB的值
	origin_picture_rom U4(.clka(clk25M), .addra(rom_addr15), .douta(M_o),.ena(ena));//ROM储存原图的像素
	 
	gray_picture_ram U11(.clka(clk25M), .addra(rom_addr15-161), .douta(M11),.dina(dina),.ena(ena),.wea(wea));//生成3X3的子矩阵
	gray_picture_ram U12(.clka(clk25M), .addra(rom_addr15-160), .douta(M12),.dina(dina),.ena(ena),.wea(wea));
	gray_picture_ram U13(.clka(clk25M), .addra(rom_addr15-159), .douta(M13),.dina(dina),.ena(ena),.wea(wea));
	gray_picture_ram U21(.clka(clk25M), .addra(rom_addr15-1), .douta(M21),.dina(dina),.ena(ena),.wea(wea));
	gray_picture_ram U22(.clka(clk25M), .addra(rom_addr15), .douta(M22),.dina(dina),.ena(ena),.wea(wea));
	gray_picture_ram U23(.clka(clk25M), .addra(rom_addr15+1), .douta(M23),.dina(dina),.ena(ena),.wea(wea));
	gray_picture_ram U31(.clka(clk25M), .addra(rom_addr15+159), .douta(M31),.dina(dina),.ena(ena),.wea(wea));
	gray_picture_ram U32(.clka(clk25M), .addra(rom_addr15+160), .douta(M32),.dina(dina),.ena(ena),.wea(wea));
	gray_picture_ram U33(.clka(clk25M), .addra(rom_addr15+161), .douta(M33),.dina(dina),.ena(ena),.wea(wea));
	  
	Sobel_Calculation u(.clk25M(clk25M),.rst_n(rst_n),.result(result),
	                    .matrix_p11(M11),.matrix_p12(M12),.matrix_p13(M13), 
                        .matrix_p21(M21),.matrix_p22(M22),.matrix_p23(M23), 
                        .matrix_p31(M31),.matrix_p32(M32),.matrix_p33(M33));//计算sobel算子与灰度图的卷积

endmodule