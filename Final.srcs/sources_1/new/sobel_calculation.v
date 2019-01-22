module Sobel_Calculation(clk25M, rst_n, result,
            matrix_p11, matrix_p12, matrix_p13, 
            matrix_p21,  matrix_p22,  matrix_p23, 
            matrix_p31,  matrix_p32,  matrix_p33
);

input clk25M, rst_n;
output reg [11:0] result;

input [3:0] matrix_p11,  matrix_p12,  matrix_p13, 
            matrix_p21,  matrix_p22,  matrix_p23, 
            matrix_p31,  matrix_p32,  matrix_p33;

//计算水平梯度的平均值
reg [9:0] Gx_temp1;//正解
reg [9:0] Gx_temp2;//负解
reg [9:0] Gx_data;//水平梯度数值
always @(posedge clk25M)
begin
      Gx_temp1 <= matrix_p13 + (matrix_p23 << 1) + matrix_p33;//正解
      Gx_temp2 <= matrix_p11 + (matrix_p21 << 1) + matrix_p31;//负解
      Gx_data <= (Gx_temp1 >= Gx_temp2) ? Gx_temp1 - Gx_temp2 : Gx_temp2 - Gx_temp1;
end

//计算垂直梯度的绝对值
reg   [9:0]   Gy_temp1;//正解
reg   [9:0]   Gy_temp2;//负解
reg   [9:0]   Gy_data;//垂直梯度数值
always @(posedge clk25M)
begin
      Gy_temp1 <= matrix_p11 + (matrix_p12 << 1) + matrix_p13;//正解
      Gy_temp2 <= matrix_p31 + (matrix_p32 << 1) + matrix_p33;//负解
      Gy_data <= (Gy_temp1 >= Gy_temp2) ? Gy_temp1 - Gy_temp2 : Gy_temp2 - Gy_temp1;
end


//计算平方和 = (Gx^2 + Gy^2)
reg [20:0] Gxy_square;
always @(posedge clk25M)
begin
      Gxy_square <= Gx_data * Gx_data + Gy_data * Gy_data;
end

always @(posedge clk25M)
begin
     if(Gxy_square>80) result<=12'hfff;//阈值设置为80
     else result<=12'h000;
end

endmodule