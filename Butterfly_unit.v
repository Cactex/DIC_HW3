module  Butterfly_unit(
    input signed [15:0]proceed_fir0,
    input signed [15:0]proceed_fir1,
    input signed [15:0]proceed_fir2,
    input signed [15:0]proceed_fir3,
    input signed [15:0]proceed_fir4,
    input signed [15:0]proceed_fir5,
    input signed [15:0]proceed_fir6,
    input signed [15:0]proceed_fir7,
    input signed [15:0]proceed_fir8,
    input signed [15:0]proceed_fir9,
    input signed [15:0]proceed_fir10,
    input signed [15:0]proceed_fir11,
    input signed [15:0]proceed_fir12,
    input signed [15:0]proceed_fir13,
    input signed [15:0]proceed_fir14,
    input signed [15:0]proceed_fir15,
    output signed [15:0]out_real0,
    output signed [15:0]out_real1,
    output signed [15:0]out_real2,
    output signed [15:0]out_real3,
    output signed [15:0]out_real4,
    output signed [15:0]out_real5,
    output signed [15:0]out_real6,
    output signed [15:0]out_real7,
    output signed [15:0]out_real8,
    output signed [15:0]out_real9,
    output signed [15:0]out_real10,
    output signed [15:0]out_real11,
    output signed [15:0]out_real12,
    output signed [15:0]out_real13,
    output signed [15:0]out_real14,
    output signed [15:0]out_real15,
    output signed [15:0]out_image0,
    output signed [15:0]out_image1,
    output signed [15:0]out_image2,
    output signed [15:0]out_image3,
    output signed [15:0]out_image4,
    output signed [15:0]out_image5,
    output signed [15:0]out_image6,
    output signed [15:0]out_image7,
    output signed [15:0]out_image8,
    output signed [15:0]out_image9,
    output signed [15:0]out_image10,
    output signed [15:0]out_image11,
    output signed [15:0]out_image12,
    output signed [15:0]out_image13,
    output signed [15:0]out_image14,
    output signed [15:0]out_image15
); 

wire signed [31:0]fir1_real[0:15];
wire signed [31:0]fir1_image [0:15];
wire signed [31:0]fir2_real[0:15];
wire signed [31:0]fir2_image[0:15];
wire signed [31:0]fir3_real[0:15];
wire signed [31:0]fir3_image[0:15];
wire signed [31:0]fir4_real[0:15];
wire signed [31:0]fir4_image[0:15];
wire signed [47:0]fir1_tmpr8, fir1_tmpi8, fir1_tmpr9, fir1_tmpi9, fir1_tmpr10, fir1_tmpi10, fir1_tmpr11, fir1_tmpi11, fir1_tmpr12, fir1_tmpi12,
            fir1_tmpr13, fir1_tmpi13, fir1_tmpr14, fir1_tmpi14, fir1_tmpr15, fir1_tmpi15;
wire signed [63:0]fir2_tmpr8, fir2_tmpi8, fir2_tmpr9, fir2_tmpi9, fir2_tmpr10, fir2_tmpi10, fir2_tmpr11, fir2_tmpi11, fir2_tmpr12, fir2_tmpi12,
            fir2_tmpr13, fir2_tmpi13, fir2_tmpr14, fir2_tmpi14, fir2_tmpr15, fir2_tmpi15;
wire signed [63:0]fir3_tmpr8, fir3_tmpi8, fir3_tmpr9, fir3_tmpi9, fir3_tmpr10, fir3_tmpi10, fir3_tmpr11, fir3_tmpi11, fir3_tmpr12, fir3_tmpi12,
            fir3_tmpr13, fir3_tmpi13, fir3_tmpr14, fir3_tmpi14, fir3_tmpr15, fir3_tmpi15;
wire signed [63:0]fir4_tmpr8, fir4_tmpi8, fir4_tmpr9, fir4_tmpi9, fir4_tmpr10, fir4_tmpi10, fir4_tmpr11, fir4_tmpi11, fir4_tmpr12, fir4_tmpi12,
            fir4_tmpr13, fir4_tmpi13, fir4_tmpr14, fir4_tmpi14, fir4_tmpr15, fir4_tmpi15;
wire signed [15:0] tmp_minus;

wire signed [31:0]w0_real = 32'h00010000, w0_image = 32'h00000000, w1_real = 32'h0000EC83, w1_image =  32'hFFFF9E09,
            w2_real = 32'h0000B504, w2_image = 32'hFFFF4AFC, w3_real = 32'h000061F7, w3_image =  32'hFFFF137D,
            w4_real = 32'h00000000, w4_image = 32'hFFFF0000, w5_real = 32'hFFFF9E09, w5_image =  32'hFFFF137D,
            w6_real = 32'hFFFF4AFC, w6_image = 32'hFFFF4AFC, w7_real = 32'hFFFF137D, w7_image =  32'hFFFF9E09;

//fir1 0-7
assign fir1_real[0] = {{8{proceed_fir0[15]}}, proceed_fir0, 8'd0} + {{8{proceed_fir8[15]}}, proceed_fir8, 8'd0};
assign fir1_image[0] = 32'd0;
assign fir1_real[1] = {{8{proceed_fir1[15]}} , proceed_fir1, 8'd0} + {{8{proceed_fir9[15]}} ,proceed_fir9 , 8'd0};
assign fir1_image[1] = 32'd0;
assign fir1_real[2] = {{8{proceed_fir2[15]}} , proceed_fir2, 8'd0} + {{8{proceed_fir10[15]}} ,proceed_fir10 , 8'd0};
assign fir1_image[2] = 32'd0;
assign fir1_real[3] = {{8{proceed_fir3[15]}} , proceed_fir3, 8'd0} + {{8{proceed_fir11[15]}} ,proceed_fir11 , 8'd0};
assign fir1_image[3] = 32'd0;
assign fir1_real[4] = {{8{proceed_fir4[15]}} , proceed_fir4, 8'd0} + {{8{proceed_fir12[15]}} ,proceed_fir12 , 8'd0};
assign fir1_image[4] = 32'd0;
assign fir1_real[5] = {{8{proceed_fir5[15]}} , proceed_fir5, 8'd0} + {{8{proceed_fir13[15]}} ,proceed_fir13 , 8'd0};
assign fir1_image[5] = 32'd0;
assign fir1_real[6] = {{8{proceed_fir6[15]}} , proceed_fir6, 8'd0} + {{8{proceed_fir14[15]}} ,proceed_fir14 , 8'd0};
assign fir1_image[6] = 32'd0;
assign fir1_real[7] = {{8{proceed_fir7[15]}} , proceed_fir7, 8'd0} + {{8{proceed_fir15[15]}} ,proceed_fir15 , 8'd0};
assign fir1_image[7] = 32'd0;

//16*32 48   16 8 24
//assign fir1_tmpr8 = ({{8{proceed_fir0[15]}}, proceed_fir0, 8'd0 } - {{8{proceed_fir8[15]}}, proceed_fir8, 8'd0}) * w0_real;
assign fir1_tmpr8 = (proceed_fir0 - proceed_fir8) * w0_real;
assign fir1_tmpi8 = (proceed_fir0 - proceed_fir8) * w0_image;
assign fir1_tmpr9 = (proceed_fir1 - proceed_fir9) * w1_real;
assign fir1_tmpi9 = (proceed_fir1 - proceed_fir9) * w1_image;
assign fir1_tmpr10 = (proceed_fir2 - proceed_fir10) * w2_real;
assign fir1_tmpi10 = (proceed_fir2 - proceed_fir10) * w2_image;
assign fir1_tmpr11 = (proceed_fir3 - proceed_fir11) * w3_real;
assign fir1_tmpi11 = (proceed_fir3 - proceed_fir11) * w3_image;
assign fir1_tmpr12 = (proceed_fir4 - proceed_fir12) * w4_real;
assign fir1_tmpi12 = (proceed_fir4 - proceed_fir12) * w4_image;
assign fir1_tmpr13 = (proceed_fir5 - proceed_fir13) * w5_real;
assign fir1_tmpi13 = (proceed_fir5 - proceed_fir13) * w5_image;
assign fir1_tmpr14 = (proceed_fir6 - proceed_fir14) * w6_real;
assign fir1_tmpi14 = (proceed_fir6 - proceed_fir14) * w6_image;
assign fir1_tmpr15 = (proceed_fir7 - proceed_fir15) * w7_real;
assign fir1_tmpi15 = (proceed_fir7 - proceed_fir15) * w7_image;

//fir1 8-15
assign fir1_real[8] = {{8{fir1_tmpr8[31]}}, fir1_tmpr8[31:8]};
assign fir1_image[8] = {{8{fir1_tmpi8[31]}}, fir1_tmpi8[31:8]};
assign fir1_real[9] = {{8{fir1_tmpr9[31]}}, fir1_tmpr9[31:8]};
assign fir1_image[9] = {{8{fir1_tmpi9[31]}}, fir1_tmpi9[31:8]};
assign fir1_real[10] = {{8{fir1_tmpr10[31]}}, fir1_tmpr10[31:8]};
assign fir1_image[10] = {{8{fir1_tmpi10[31]}}, fir1_tmpi10[31:8]};
assign fir1_real[11] = {{8{fir1_tmpr11[31]}}, fir1_tmpr11[31:8]};
assign fir1_image[11] ={{8{fir1_tmpi11[31]}}, fir1_tmpi11[31:8]};
assign fir1_real[12] = {{8{fir1_tmpr12[31]}}, fir1_tmpr12[31:8]};
assign fir1_image[12] ={{8{fir1_tmpi12[31]}}, fir1_tmpi12[31:8]};
assign fir1_real[13] = {{8{fir1_tmpr13[31]}}, fir1_tmpr13[31:8]};
assign fir1_image[13] ={{8{fir1_tmpi13[31]}}, fir1_tmpi13[31:8]};
assign fir1_real[14] = {{8{fir1_tmpr14[31]}}, fir1_tmpr14[31:8]};
assign fir1_image[14] ={{8{fir1_tmpi14[31]}}, fir1_tmpi14[31:8]};
assign fir1_real[15] = {{8{fir1_tmpr15[31]}}, fir1_tmpr15[31:8]};
assign fir1_image[15] ={{8{fir1_tmpi15[31]}}, fir1_tmpi15[31:8]};

//fir2
assign fir2_real[0] = fir1_real[0] + fir1_real[4];
assign fir2_image[0] = fir1_image[0] + fir1_image[4];
assign fir2_real[1] = fir1_real[1] + fir1_real[5];
assign fir2_image[1] = fir1_image[1] + fir1_image[5];
assign fir2_real[2] = fir1_real[2] + fir1_real[6];
assign fir2_image[2] = fir1_image[2] + fir1_image[6];
assign fir2_real[3] = fir1_real[3] + fir1_real[7];
assign fir2_image[3] = fir1_image[3] + fir1_image[7];
assign fir2_real[8] = fir1_real[8] + fir1_real[12];
assign fir2_image[8] = fir1_image[8] + fir1_image[12];
assign fir2_real[9] = fir1_real[9] + fir1_real[13];
assign fir2_image[9] = fir1_image[9] + fir1_image[13];
assign fir2_real[10] = fir1_real[10] + fir1_real[14];
assign fir2_image[10] = fir1_image[10] + fir1_image[14];
assign fir2_real[11] = fir1_real[11] + fir1_real[15];
assign fir2_image[11] = fir1_image[11] + fir1_image[15];


assign fir2_tmpr8 = (fir1_real[0] - fir1_real[4]) * w0_real + (fir1_image[4] - fir1_image[0]) * w0_image;
assign fir2_tmpi8 = (fir1_real[0] - fir1_real[4]) * w0_image + (fir1_image[0] - fir1_image[4]) * w0_real;
assign fir2_tmpr9 = (fir1_real[1] - fir1_real[5]) * w2_real + (fir1_image[5] - fir1_image[1]) * w2_image;
assign fir2_tmpi9 = (fir1_real[1] - fir1_real[5]) * w2_image + (fir1_image[1] - fir1_image[5]) * w2_real;
assign fir2_tmpr10 = (fir1_real[2] - fir1_real[6]) * w4_real + (fir1_image[6] - fir1_image[2]) * w4_image;
assign fir2_tmpi10 = (fir1_real[2] - fir1_real[6]) * w4_image + (fir1_image[2] - fir1_image[6]) * w4_real;
assign fir2_tmpr11 = (fir1_real[3] - fir1_real[7]) * w6_real + (fir1_image[7] - fir1_image[3]) * w6_image;
assign fir2_tmpi11 = (fir1_real[3] - fir1_real[7]) * w6_image + (fir1_image[3] - fir1_image[7]) * w6_real;
assign fir2_tmpr12 = (fir1_real[8] - fir1_real[12]) * w0_real + (fir1_image[12] - fir1_image[8]) * w0_image;
assign fir2_tmpi12 = (fir1_real[8] - fir1_real[12]) * w0_image + (fir1_image[8] - fir1_image[12]) * w0_real;
assign fir2_tmpr13 = (fir1_real[9] - fir1_real[13]) * w2_real + (fir1_image[13] - fir1_image[9]) * w2_image;
assign fir2_tmpi13 = (fir1_real[9] - fir1_real[13]) * w2_image + (fir1_image[9] - fir1_image[13]) * w2_real;
assign fir2_tmpr14 = (fir1_real[10] - fir1_real[14]) * w4_real + (fir1_image[14] - fir1_image[10]) * w4_image;
assign fir2_tmpi14 = (fir1_real[10] - fir1_real[14]) * w4_image + (fir1_image[10] - fir1_image[14]) * w4_real;
assign fir2_tmpr15 = (fir1_real[11] - fir1_real[15]) * w6_real + (fir1_image[15] - fir1_image[11]) * w6_image;
assign fir2_tmpi15 = (fir1_real[11] - fir1_real[15]) * w6_image + (fir1_image[11] - fir1_image[15]) * w6_real;

assign fir2_real[4] = fir2_tmpr8[47:16];
assign fir2_image[4] = fir2_tmpi8[47:16];
assign fir2_real[5] = fir2_tmpr9[47:16];
assign fir2_image[5] = fir2_tmpi9[47:16];
assign fir2_real[6] = fir2_tmpr10[47:16];
assign fir2_image[6] = fir2_tmpi10[47:16];
assign fir2_real[7] = fir2_tmpr11[47:16];
assign fir2_image[7] = fir2_tmpi11[47:16];
assign fir2_real[12] = fir2_tmpr12[47:16];
assign fir2_image[12] = fir2_tmpi12[47:16];
assign fir2_real[13] = fir2_tmpr13[47:16];
assign fir2_image[13] = fir2_tmpi13[47:16];
assign fir2_real[14] = fir2_tmpr14[47:16];
assign fir2_image[14] = fir2_tmpi14[47:16];
assign fir2_real[15] = fir2_tmpr15[47:16];
assign fir2_image[15] = fir2_tmpi15[47:16];

//fir3
assign fir3_real[0] = fir2_real[0] + fir2_real[2];
assign fir3_image[0] = fir2_image[0] + fir2_image[2];
assign fir3_real[1] = fir2_real[1] + fir2_real[3];
assign fir3_image[1] = fir2_image[1] + fir2_image[3];
assign fir3_real[4] = fir2_real[4] + fir2_real[6];
assign fir3_image[4] = fir2_image[4] + fir2_image[6];
assign fir3_real[5] = fir2_real[5] + fir2_real[7];
assign fir3_image[5] = fir2_image[5] + fir2_image[7];
assign fir3_real[8] = fir2_real[8] + fir2_real[10];
assign fir3_image[8] = fir2_image[8] + fir2_image[10];
assign fir3_real[9] = fir2_real[9] + fir2_real[11];
assign fir3_image[9] = fir2_image[9] + fir2_image[11];
assign fir3_real[12] = fir2_real[12] + fir2_real[14];
assign fir3_image[12] = fir2_image[12] + fir2_image[14];
assign fir3_real[13] = fir2_real[13] + fir2_real[15];
assign fir3_image[13] = fir2_image[13] + fir2_image[15];

assign fir3_tmpr8 = (fir2_real[0] - fir2_real[2]) * w0_real + (fir2_image[2] - fir2_image[0]) * w0_image;
assign fir3_tmpi8 = (fir2_real[0] - fir2_real[2]) * w0_image + (fir2_image[0] - fir2_image[2]) * w0_real;
assign fir3_tmpr9 = (fir2_real[1] - fir2_real[3]) * w4_real + (fir2_image[3] - fir2_image[1]) * w4_image;
assign fir3_tmpi9 = (fir2_real[1] - fir2_real[3]) * w4_image + (fir2_image[1] - fir2_image[3]) * w4_real;
assign fir3_tmpr10 = (fir2_real[4] - fir2_real[6]) * w0_real + (fir2_image[6] - fir2_image[4]) * w0_image;
assign fir3_tmpi10 = (fir2_real[4] - fir2_real[6]) * w0_image + (fir2_image[4] - fir2_image[6]) * w0_real;
assign fir3_tmpr11 = (fir2_real[5] - fir2_real[7]) * w4_real + (fir2_image[7] - fir2_image[5]) * w4_image;
assign fir3_tmpi11 = (fir2_real[5] - fir2_real[7]) * w4_image + (fir2_image[5] - fir2_image[7]) * w4_real;
assign fir3_tmpr12 = (fir2_real[8] - fir2_real[10]) * w0_real + (fir2_image[10] - fir2_image[8]) * w0_image;
assign fir3_tmpi12 = (fir2_real[8] - fir2_real[10]) * w0_image + (fir2_image[8] - fir2_image[10]) * w0_real;
assign fir3_tmpr13 = (fir2_real[9] - fir2_real[11]) * w4_real + (fir2_image[11] - fir2_image[9]) * w4_image;
assign fir3_tmpi13 = (fir2_real[9] - fir2_real[11]) * w4_image + (fir2_image[9] - fir2_image[11]) * w4_real;
assign fir3_tmpr14 = (fir2_real[12] - fir2_real[14]) * w0_real + (fir2_image[14] - fir2_image[12]) * w0_image;
assign fir3_tmpi14 = (fir2_real[12] - fir2_real[14]) * w0_image + (fir2_image[12] - fir2_image[14]) * w0_real;
assign fir3_tmpr15 = (fir2_real[13] - fir2_real[15]) * w4_real + (fir2_image[15] - fir2_image[13]) * w4_image;
assign fir3_tmpi15 = (fir2_real[13] - fir2_real[15]) * w4_image + (fir2_image[13] - fir2_image[15]) * w4_real;

assign fir3_real[2] = fir3_tmpr8[47:16];
assign fir3_image[2] = fir3_tmpi8[47:16];
assign fir3_real[3] = fir3_tmpr9[47:16];
assign fir3_image[3] = fir3_tmpi9[47:16];
assign fir3_real[6] = fir3_tmpr10[47:16];
assign fir3_image[6] = fir3_tmpi10[47:16];
assign fir3_real[7] = fir3_tmpr11[47:16];
assign fir3_image[7] = fir3_tmpi11[47:16];
assign fir3_real[10] = fir3_tmpr12[47:16];
assign fir3_image[10] = fir3_tmpi12[47:16];
assign fir3_real[11] = fir3_tmpr13[47:16];
assign fir3_image[11] = fir3_tmpi13[47:16];
assign fir3_real[14] = fir3_tmpr14[47:16];
assign fir3_image[14] = fir3_tmpi14[47:16];
assign fir3_real[15] = fir3_tmpr15[47:16];
assign fir3_image[15] = fir3_tmpi15[47:16];

//fir4
assign fir4_real[0] = fir3_real[0] + fir3_real[1];
assign fir4_image[0] = fir3_image[0] + fir3_image[1];
assign fir4_real[2] = fir3_real[2] + fir3_real[3];
assign fir4_image[2] = fir3_image[2] + fir3_image[3];
assign fir4_real[4] = fir3_real[4] + fir3_real[5];
assign fir4_image[4] = fir3_image[4] + fir3_image[5];
assign fir4_real[6] = fir3_real[6] + fir3_real[7];
assign fir4_image[6] = fir3_image[6] + fir3_image[7];
assign fir4_real[8] = fir3_real[8] + fir3_real[9];
assign fir4_image[8] = fir3_image[8] + fir3_image[9];
assign fir4_real[10] = fir3_real[10] + fir3_real[11];
assign fir4_image[10] = fir3_image[10] + fir3_image[11];
assign fir4_real[12] = fir3_real[12] + fir3_real[13];
assign fir4_image[12] = fir3_image[12] + fir3_image[13];
assign fir4_real[14] = fir3_real[14] + fir3_real[15];
assign fir4_image[14] = fir3_image[14] + fir3_image[15];

assign fir4_tmpr8 = (fir3_real[0] - fir3_real[1]) * w0_real + (fir3_image[1] - fir3_image[0]) * w0_image;
assign fir4_tmpi8 = (fir3_real[0] - fir3_real[1]) * w0_image + (fir3_image[0] - fir3_image[1]) * w0_real;
assign fir4_tmpr9 = (fir3_real[2] - fir3_real[3]) * w0_real + (fir3_image[3] - fir3_image[2]) * w0_image;
assign fir4_tmpi9 = (fir3_real[2] - fir3_real[3]) * w0_image + (fir3_image[2] - fir3_image[3]) * w0_real;
assign fir4_tmpr10 = (fir3_real[4] - fir3_real[5]) * w0_real + (fir3_image[5] - fir3_image[4]) * w0_image;
assign fir4_tmpi10 = (fir3_real[4] - fir3_real[5]) * w0_image + (fir3_image[4] - fir3_image[5]) * w0_real;
assign fir4_tmpr11 = (fir3_real[6] - fir3_real[7]) * w0_real + (fir3_image[7] - fir3_image[6]) * w0_image;
assign fir4_tmpi11 = (fir3_real[6] - fir3_real[7]) * w0_image + (fir3_image[6] - fir3_image[7]) * w0_real;
assign fir4_tmpr12 = (fir3_real[8] - fir3_real[9]) * w0_real + (fir3_image[9] - fir3_image[8]) * w0_image;
assign fir4_tmpi12 = (fir3_real[8] - fir3_real[9]) * w0_image + (fir3_image[8] - fir3_image[9]) * w0_real;
assign fir4_tmpr13 = (fir3_real[10] - fir3_real[11]) * w0_real + (fir3_image[11] - fir3_image[10]) * w0_image;
assign fir4_tmpi13 = (fir3_real[10] - fir3_real[11]) * w0_image + (fir3_image[10] - fir3_image[11]) * w0_real;
assign fir4_tmpr14 = (fir3_real[12] - fir3_real[13]) * w0_real + (fir3_image[13] - fir3_image[12]) * w0_image;
assign fir4_tmpi14 = (fir3_real[12] - fir3_real[13]) * w0_image + (fir3_image[12] - fir3_image[13]) * w0_real;
assign fir4_tmpr15 = (fir3_real[14] - fir3_real[15]) * w0_real + (fir3_image[15] - fir3_image[14]) * w0_image;
assign fir4_tmpi15 = (fir3_real[14] - fir3_real[15]) * w0_image + (fir3_image[14] - fir3_image[15]) * w0_real;

assign fir4_real[1] = fir4_tmpr8[47:16];
assign fir4_image[1] = fir4_tmpi8[47:16];
assign fir4_real[3] = fir4_tmpr9[47:16];
assign fir4_image[3] = fir4_tmpi9[47:16];
assign fir4_real[5] = fir4_tmpr10[47:16];
assign fir4_image[5] = fir4_tmpi10[47:16];
assign fir4_real[7] = fir4_tmpr11[47:16];
assign fir4_image[7] = fir4_tmpi11[47:16];
assign fir4_real[9] = fir4_tmpr12[47:16];
assign fir4_image[9] = fir4_tmpi12[47:16];
assign fir4_real[11] = fir4_tmpr13[47:16];
assign fir4_image[11] = fir4_tmpi13[47:16];
assign fir4_real[13] = fir4_tmpr14[47:16];
assign fir4_image[13] = fir4_tmpi14[47:16];
assign fir4_real[15] = fir4_tmpr15[47:16];
assign fir4_image[15] = fir4_tmpi15[47:16];

assign out_real0 = fir4_real[0][23:8];
assign out_image0 = fir4_image[0][23:8];
assign out_real1 = fir4_real[8][23:8];
assign out_image1 = fir4_image[8][23:8];
assign out_real2 = fir4_real[4][23:8];
assign out_image2 = fir4_image[4][23:8];
assign out_real3 = fir4_real[12][23:8];
assign out_image3 = fir4_image[12][23:8];
assign out_real4 = fir4_real[2][23:8];
assign out_image4 = fir4_image[2][23:8];
assign out_real5 = fir4_real[10][23:8];
assign out_image5 = fir4_image[10][23:8];
assign out_real6 = fir4_real[6][23:8];
assign out_image6 = fir4_image[6][23:8];
assign out_real7 = fir4_real[14][23:8];
assign out_image7 = fir4_image[14][23:8];
assign out_real8 = fir4_real[1][23:8];
assign out_image8 = fir4_image[1][23:8];
assign out_real9 = fir4_real[9][23:8];
assign out_image9 = fir4_image[9][23:8];
assign out_real10 = fir4_real[5][23:8];
assign out_image10 = fir4_image[5][23:8];
assign out_real11 = fir4_real[13][23:8];
assign out_image11 = fir4_image[13][23:8];
assign out_real12 = fir4_real[3][23:8];
assign out_image12 = fir4_image[3][23:8];
assign out_real13 = fir4_real[11][23:8];
assign out_image13 = fir4_image[11][23:8];
assign out_real14 = fir4_real[7][23:8];
assign out_image14 = fir4_image[7][23:8];
assign out_real15 = fir4_real[15][23:8];
assign out_image15 = fir4_image[15][23:8];


endmodule