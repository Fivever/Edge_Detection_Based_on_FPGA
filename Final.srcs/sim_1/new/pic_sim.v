module pic_sim;
    reg clk, rst_n,ena,wea;
    wire hsync, vsync;
    wire [3:0] red, green, blue;
    vga_640x480_picture_top u( hsync, vsync, red, green, blue, clk, rst_n, ena,wea);
    
    always
    begin
        #5 clk=~clk;
    end
    
    initial
    begin
        rst_n=0;
        clk=0;
        ena=0;
        wea=0;
        #20 ena=1;rst_n=1;
        
        #800
        $finish;
    end
endmodule
