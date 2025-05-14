module  FFT(
    input               clk      , 
    input               rst      , 
    input  [15:0]       fir_d    , 
    input               fir_valid,
    output reg          fft_valid, 
    output wire         done     ,
    output reg [15:0]   fft_d1   , 
    output reg [15:0]   fft_d2   ,
    output reg [15:0]   fft_d3   , 
    output reg [15:0]   fft_d4   , 
    output reg [15:0]   fft_d5   , 
    output reg [15:0]   fft_d6   , 
    output reg [15:0]   fft_d7   , 
    output reg [15:0]   fft_d8   ,
    output reg [15:0]   fft_d9   , 
    output reg [15:0]   fft_d10  , 
    output reg [15:0]   fft_d11  , 
    output reg [15:0]   fft_d12  , 
    output reg [15:0]   fft_d13  , 
    output reg [15:0]   fft_d14  , 
    output reg [15:0]   fft_d15  , 
    output reg [15:0]   fft_d0
);

reg [3:0] read_count;
reg [15:0]input_fir[0:15];
reg [15:0]proceed_fir[0:15];

//stage buffer
reg signed [31:0]stage0_real [0:15];
reg signed [31:0]stage0_image[0:15];
reg signed [31:0]stage1_real [0:15];
reg signed [31:0]stage1_image[0:15];
reg signed [31:0]stage2_real [0:15];
reg signed [31:0]stage2_image[0:15];
reg signed [31:0]stage3_real [0:15];
reg signed [31:0]stage3_image[0:15];

reg signed  [31:0] M0_mult1, M0_mult2, M4_mult1, M4_mult2;
reg signed  [31:0] M1_mult1, M1_mult2, M5_mult1, M5_mult2;
reg signed  [31:0] M2_mult1, M2_mult2, M6_mult1, M6_mult2;
reg signed  [31:0] M3_mult1, M3_mult2, M7_mult1, M7_mult2;
//multipler
wire signed [63:0] M0 = M0_mult1 * M0_mult2;
wire signed [63:0] M1 = M1_mult1 * M1_mult2;
wire signed [63:0] M2 = M2_mult1 * M2_mult2;
wire signed [63:0] M3 = M3_mult1 * M3_mult2;
wire signed [63:0] M4 = M4_mult1 * M4_mult2;
wire signed [63:0] M5 = M5_mult1 * M5_mult2;
wire signed [63:0] M6 = M6_mult1 * M6_mult2;
wire signed [63:0] M7 = M7_mult1 * M7_mult2;
wire signed [31:0]w0_real = 32'h00010000, w0_image = 32'h00000000, w1_real = 32'h0000EC83, w1_image =  32'hFFFF9E09,
            w2_real = 32'h0000B504, w2_image = 32'hFFFF4AFC, w3_real = 32'h000061F7, w3_image =  32'hFFFF137D,
            w4_real = 32'h00000000, w4_image = 32'hFFFF0000, w5_real = 32'hFFFF9E09, w5_image =  32'hFFFF137D,
            w6_real = 32'hFFFF4AFC, w6_image = 32'hFFFF4AFC, w7_real = 32'hFFFF137D, w7_image =  32'hFFFF9E09;

reg [2:0] state, next_state;
localparam  IDLE        = 3'd0,
            READ        = 3'd1,
            COMPUTE     = 3'd2,
            TRANS       = 3'd3,
            FINAL       = 3'd4,
            FINAL_TRANS = 3'd5,
            FINISH      = 3'd6;

assign done = (state == FINISH);

always@(posedge clk or posedge rst) begin
    if(rst) begin
        state <= IDLE;
    end
    else begin
        state <= next_state;
    end
end


always@(*) begin
    case(state)
        IDLE: begin
            next_state = READ;
        end
        READ: begin
            if(read_count == 4'd15) begin
                next_state = COMPUTE;
            end
            else begin
                next_state = READ;
            end
        end
        COMPUTE: begin
            if(read_count == 4'd15) begin
                next_state = TRANS;
            end
            else begin
                next_state = COMPUTE;
            end
        end
        TRANS: begin
            if(!fir_valid) begin
                next_state = FINAL;
            end
            else begin
                next_state = TRANS;
            end
        end
        FINAL: begin
            if(read_count == 4'd15) begin
                next_state = FINAL_TRANS;
            end
            else begin
                next_state = FINAL;
            end
        end
        FINAL_TRANS: begin
            if(read_count == 4'd3) begin
                next_state = FINISH;
            end
            else begin
                next_state = FINAL_TRANS;
            end
        end
        FINISH: begin
            next_state = FINISH;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

//tood take bit
always@(posedge clk) begin
        case(state)
            IDLE: begin
                read_count  <= 4'd0;
                fft_valid   <= 1'b0;
            end
            READ: begin
                read_count <= read_count + 4'd1;
                if(fir_valid) begin
                    input_fir[read_count] <= fir_d;
                end
            end
            COMPUTE: begin
                read_count <= read_count + 4'd1;
                case(read_count)
                    4'd0: begin
                        input_fir[read_count] <= fir_d;
                        proceed_fir[0] <= input_fir[0];
                        proceed_fir[1] <= input_fir[1];
                        proceed_fir[2] <= input_fir[2];
                        proceed_fir[3] <= input_fir[3];
                        proceed_fir[4] <= input_fir[4];
                        proceed_fir[5] <= input_fir[5];
                        proceed_fir[6] <= input_fir[6];
                        proceed_fir[7] <= input_fir[7];
                        proceed_fir[8] <= input_fir[8];
                        proceed_fir[9] <= input_fir[9];
                        proceed_fir[10] <= input_fir[10];
                        proceed_fir[11] <= input_fir[11];
                        proceed_fir[12] <= input_fir[12];
                        proceed_fir[13] <= input_fir[13];
                        proceed_fir[14] <= input_fir[14];
                        proceed_fir[15] <= input_fir[15];

                        //stage0 (a-c) * real
                        M0_mult1 <= {{8{input_fir[0][15]}}, input_fir[0], 8'd0} - {{8{input_fir[8][15]}}, input_fir[8], 8'd0};                                    
                        M1_mult1 <= {{8{input_fir[1][15]}}, input_fir[1], 8'd0} - {{8{input_fir[9][15]}}, input_fir[9], 8'd0};                       
                        M2_mult1 <= {{8{input_fir[2][15]}}, input_fir[2], 8'd0} - {{8{input_fir[10][15]}}, input_fir[10], 8'd0};                      
                        M3_mult1 <= {{8{input_fir[3][15]}}, input_fir[3], 8'd0} - {{8{input_fir[11][15]}}, input_fir[11], 8'd0};                        
                        M4_mult1 <= {{8{input_fir[4][15]}}, input_fir[4], 8'd0} - {{8{input_fir[12][15]}}, input_fir[12], 8'd0};                  
                        M5_mult1 <= {{8{input_fir[5][15]}}, input_fir[5], 8'd0} - {{8{input_fir[13][15]}}, input_fir[13], 8'd0};
                        M6_mult1 <= {{8{input_fir[6][15]}}, input_fir[6], 8'd0} - {{8{input_fir[14][15]}}, input_fir[14], 8'd0};
                        M7_mult1 <= {{8{input_fir[7][15]}}, input_fir[7], 8'd0} - {{8{input_fir[15][15]}}, input_fir[15], 8'd0};
                        M0_mult2 <= w0_real;
                        M1_mult2 <= w1_real;
                        M2_mult2 <= w2_real;
                        M3_mult2 <= w3_real;
                        M4_mult2 <= w4_real;
                        M5_mult2 <= w5_real;
                        M6_mult2 <= w6_real;
                        M7_mult2 <= w7_real;

                    end
                    //stage0 
                    4'd1: begin
                        input_fir[read_count] <= fir_d;
                        stage0_real[0] <= {{8{proceed_fir[0][15]}}, proceed_fir[0], 8'd0} + {{8{proceed_fir[8][15]}}, proceed_fir[8], 8'd0};
                        stage0_real[1] <= {{8{proceed_fir[1][15]}}, proceed_fir[1], 8'd0} + {{8{proceed_fir[9][15]}}, proceed_fir[9], 8'd0};
                        stage0_real[2] <= {{8{proceed_fir[2][15]}}, proceed_fir[2], 8'd0} + {{8{proceed_fir[10][15]}}, proceed_fir[10], 8'd0};
                        stage0_real[3] <= {{8{proceed_fir[3][15]}}, proceed_fir[3], 8'd0} + {{8{proceed_fir[11][15]}}, proceed_fir[11], 8'd0};
                        stage0_real[4] <= {{8{proceed_fir[4][15]}}, proceed_fir[4], 8'd0} + {{8{proceed_fir[12][15]}}, proceed_fir[12], 8'd0};
                        stage0_real[5] <= {{8{proceed_fir[5][15]}}, proceed_fir[5], 8'd0} + {{8{proceed_fir[13][15]}}, proceed_fir[13], 8'd0};
                        stage0_real[6] <= {{8{proceed_fir[6][15]}}, proceed_fir[6], 8'd0} + {{8{proceed_fir[14][15]}}, proceed_fir[14], 8'd0};
                        stage0_real[7] <= {{8{proceed_fir[7][15]}}, proceed_fir[7], 8'd0} + {{8{proceed_fir[15][15]}}, proceed_fir[15], 8'd0};
                                                
                        stage0_real[8] <= M0[47:16];
                        stage0_real[9] <= M1[47:16];
                        stage0_real[10] <= M2[47:16];
                        stage0_real[11] <= M3[47:16];
                        stage0_real[12] <= M4[47:16];
                        stage0_real[13] <= M5[47:16];
                        stage0_real[14] <= M6[47:16];
                        stage0_real[15] <= M7[47:16];

                        stage0_image[0] <= 32'd0;
                        stage0_image[1] <= 32'd0;
                        stage0_image[2] <= 32'd0;
                        stage0_image[3] <= 32'd0;
                        stage0_image[4] <= 32'd0;
                        stage0_image[5] <= 32'd0;
                        stage0_image[6] <= 32'd0;
                        stage0_image[7] <= 32'd0;

                        //stage0 (a-c) * image
                        M0_mult1 <= {{8{proceed_fir[0][15]}}, proceed_fir[0], 8'd0} - {{8{proceed_fir[8][15]}}, proceed_fir[8], 8'd0};  
                        M1_mult1 <= {{8{proceed_fir[1][15]}}, proceed_fir[1], 8'd0} - {{8{proceed_fir[9][15]}}, proceed_fir[9], 8'd0};  
                        M2_mult1 <= {{8{proceed_fir[2][15]}}, proceed_fir[2], 8'd0} - {{8{proceed_fir[10][15]}}, proceed_fir[10], 8'd0};
                        M3_mult1 <= {{8{proceed_fir[3][15]}}, proceed_fir[3], 8'd0} - {{8{proceed_fir[11][15]}}, proceed_fir[11], 8'd0};
                        M4_mult1 <= {{8{proceed_fir[4][15]}}, proceed_fir[4], 8'd0} - {{8{proceed_fir[12][15]}}, proceed_fir[12], 8'd0};
                        M5_mult1 <= {{8{proceed_fir[5][15]}}, proceed_fir[5], 8'd0} - {{8{proceed_fir[13][15]}}, proceed_fir[13], 8'd0};
                        M6_mult1 <= {{8{proceed_fir[6][15]}}, proceed_fir[6], 8'd0} - {{8{proceed_fir[14][15]}}, proceed_fir[14], 8'd0};
                        M7_mult1 <= {{8{proceed_fir[7][15]}}, proceed_fir[7], 8'd0} - {{8{proceed_fir[15][15]}}, proceed_fir[15], 8'd0};
                        M0_mult2 <= w0_image;
                        M1_mult2 <= w1_image;
                        M2_mult2 <= w2_image;
                        M3_mult2 <= w3_image;
                        M4_mult2 <= w4_image;
                        M5_mult2 <= w5_image;
                        M6_mult2 <= w6_image;
                        M7_mult2 <= w7_image;
                    end
                    4'd2: begin
                        input_fir[read_count] <= fir_d;
                        
                        stage0_image[8]  <= M0[47:16];
                        stage0_image[9]  <= M1[47:16];
                        stage0_image[10] <= M2[47:16];
                        stage0_image[11] <= M3[47:16];
                        stage0_image[12] <= M4[47:16];
                        stage0_image[13] <= M5[47:16];
                        stage0_image[14] <= M6[47:16];
                        stage0_image[15] <= M7[47:16];
                        //stage 0 finish

                        //stage 1 
                        stage1_real[0] <= stage0_real[0] + stage0_real[4];
                        stage1_real[1] <= stage0_real[1] + stage0_real[5];
                        stage1_real[2] <= stage0_real[2] + stage0_real[6];
                        stage1_real[3] <= stage0_real[3] + stage0_real[7];   
                        stage1_real[8] <= stage0_real[8] + stage0_real[12];
                        stage1_real[9] <= stage0_real[9] + stage0_real[13];
                        stage1_real[10] <= stage0_real[10] + stage0_real[14];
                        stage1_real[11] <= stage0_real[11] + stage0_real[15];

                        // stage 1 (a-c) * real
                        M0_mult1 <= stage0_real[0] - stage0_real[4];                                  
                        M1_mult1 <= stage0_real[1] - stage0_real[5];                     
                        M2_mult1 <= stage0_real[2] - stage0_real[6];                      
                        M3_mult1 <= stage0_real[3] - stage0_real[7];                        
                        M4_mult1 <= stage0_real[8] - stage0_real[12];                  
                        M5_mult1 <= stage0_real[9] - stage0_real[13];
                        M6_mult1 <= stage0_real[10] - stage0_real[14];
                        M7_mult1 <= stage0_real[11] - stage0_real[15];
                        M0_mult2 <= w0_real;
                        M1_mult2 <= w2_real;
                        M2_mult2 <= w4_real;
                        M3_mult2 <= w6_real;
                        M4_mult2 <= w0_real;
                        M5_mult2 <= w2_real;
                        M6_mult2 <= w4_real;
                        M7_mult2 <= w6_real;
                                                                                                                                                                                                                                                                                                          
                    end
                    4'd3: begin
                        input_fir[read_count] <= fir_d;
                        
                        stage1_real[4] <= M0[47:16];
                        stage1_real[5] <= M1[47:16];
                        stage1_real[6] <= M2[47:16];
                        stage1_real[7] <= M3[47:16];
                        stage1_real[12] <= M4[47:16];
                        stage1_real[13] <= M5[47:16];
                        stage1_real[14] <= M6[47:16];
                        stage1_real[15] <= M7[47:16];

                        stage1_image[0] <= stage0_image[0] + stage0_image[4];
                        stage1_image[1] <= stage0_image[1] + stage0_image[5];
                        stage1_image[2] <= stage0_image[2] + stage0_image[6];                
                        stage1_image[3] <= stage0_image[3] + stage0_image[7];
                        stage1_image[8] <= stage0_image[8] + stage0_image[12];                       
                        stage1_image[9] <= stage0_image[9] + stage0_image[13];                      
                        stage1_image[10] <= stage0_image[10] + stage0_image[14];
                        stage1_image[11] <= stage0_image[11] + stage0_image[15];

                        //stage 1 (a-c) * image
                        M0_mult2 <= w0_image;
                        M1_mult2 <= w2_image;
                        M2_mult2 <= w4_image;
                        M3_mult2 <= w6_image;
                        M4_mult2 <= w0_image;
                        M5_mult2 <= w2_image;
                        M6_mult2 <= w4_image;
                        M7_mult2 <= w6_image;

                    end
                    4'd4: begin
                        input_fir[read_count] <= fir_d;

                        stage1_image[4] <= M0[47:16];
                        stage1_image[5] <= M1[47:16];
                        stage1_image[6] <= M2[47:16];
                        stage1_image[7] <= M3[47:16];
                        stage1_image[12] <= M4[47:16];
                        stage1_image[13] <= M5[47:16];
                        stage1_image[14] <= M6[47:16];
                        stage1_image[15] <= M7[47:16];

                        //stage 1 (d-b) * image
                        M0_mult1 <= stage0_image[4] - stage0_image[0];    
                        M1_mult1 <= stage0_image[5] - stage0_image[1];    
                        M2_mult1 <= stage0_image[6] - stage0_image[2];    
                        M3_mult1 <= stage0_image[7] - stage0_image[3];    
                        M4_mult1 <= stage0_image[12] - stage0_image[8];   
                        M5_mult1 <= stage0_image[13] - stage0_image[9];
                        M6_mult1 <= stage0_image[14] - stage0_image[10];
                        M7_mult1 <= stage0_image[15] - stage0_image[11];
                   
                    end
                    4'd5: begin
                        input_fir[read_count] <= fir_d;

                        stage1_real[4] <=  stage1_real[4] + M0[47:16];
                        stage1_real[5] <=  stage1_real[5] + M1[47:16];
                        stage1_real[6] <=  stage1_real[6] + M2[47:16];
                        stage1_real[7] <=  stage1_real[7] + M3[47:16];
                        stage1_real[12] <= stage1_real[12] + M4[47:16];
                        stage1_real[13] <= stage1_real[13] + M5[47:16];
                        stage1_real[14] <= stage1_real[14] + M6[47:16];
                        stage1_real[15] <= stage1_real[15] + M7[47:16];

                        //stage 1 (d-b) * real
                        M0_mult2 <= w0_real;
                        M1_mult2 <= w2_real;
                        M2_mult2 <= w4_real;
                        M3_mult2 <= w6_real;
                        M4_mult2 <= w0_real;
                        M5_mult2 <= w2_real;
                        M6_mult2 <= w4_real;
                        M7_mult2 <= w6_real;
                    end
                    4'd6: begin
                        input_fir[read_count] <= fir_d;
                        
                        stage1_image[4] <= stage1_image[4] - M0[47:16];
                        stage1_image[5] <= stage1_image[5] - M1[47:16];
                        stage1_image[6] <= stage1_image[6] - M2[47:16];
                        stage1_image[7] <= stage1_image[7] - M3[47:16];
                        stage1_image[12] <= stage1_image[12] - M4[47:16];
                        stage1_image[13] <= stage1_image[13] - M5[47:16];
                        stage1_image[14] <= stage1_image[14] - M6[47:16];
                        stage1_image[15] <= stage1_image[15] - M7[47:16];
                        //stage1 finish

                        //stage2
                        stage2_real[0] <= stage1_real[0] + stage1_real[2];
                        stage2_real[1] <= stage1_real[1] + stage1_real[3];
                        stage2_real[4] <= stage1_real[4] + stage1_real[6];
                        stage2_real[5] <= stage1_real[5] + stage1_real[7];   
                        stage2_real[8] <= stage1_real[8] + stage1_real[10]; 
                        stage2_real[9] <= stage1_real[9] + stage1_real[11];
                        stage2_real[12] <= stage1_real[12] + stage1_real[14];
                        stage2_real[13] <= stage1_real[13] + stage1_real[15];

                        //stage2 (a-c) * real
                        M0_mult1 <= stage1_real[0] - stage1_real[2];                             
                        M1_mult1 <= stage1_real[1] - stage1_real[3];                
                        M2_mult1 <= stage1_real[4] - stage1_real[6];                 
                        M3_mult1 <= stage1_real[5] - stage1_real[7];                      
                        M4_mult1 <= stage1_real[8] - stage1_real[10];              
                        M5_mult1 <= stage1_real[9] - stage1_real[11];
                        M6_mult1 <= stage1_real[12] - stage1_real[14];
                        M7_mult1 <= stage1_real[13] - stage1_real[15];
                        M0_mult2 <= w0_real;
                        M1_mult2 <= w4_real;
                        M2_mult2 <= w0_real;
                        M3_mult2 <= w4_real;
                        M4_mult2 <= w0_real;
                        M5_mult2 <= w4_real;
                        M6_mult2 <= w0_real;
                        M7_mult2 <= w4_real;
                    end
                    4'd7: begin
                        input_fir[read_count] <= fir_d;

                        stage2_real[2] <= M0[47:16];
                        stage2_real[3] <= M1[47:16];
                        stage2_real[6] <= M2[47:16];
                        stage2_real[7] <= M3[47:16];
                        stage2_real[10] <= M4[47:16];
                        stage2_real[11] <= M5[47:16];
                        stage2_real[14] <= M6[47:16];
                        stage2_real[15] <= M7[47:16];

                        stage2_image[0] <= stage1_image[0] + stage1_image[2];
                        stage2_image[1] <= stage1_image[1] + stage1_image[3];
                        stage2_image[4] <= stage1_image[4] + stage1_image[6];
                        stage2_image[5] <= stage1_image[5] + stage1_image[7];   
                        stage2_image[8] <= stage1_image[8] + stage1_image[10]; 
                        stage2_image[9] <= stage1_image[9] + stage1_image[11];
                        stage2_image[12] <= stage1_image[12] + stage1_image[14];
                        stage2_image[13] <= stage1_image[13] + stage1_image[15];

                        //stage2 (a-c) * image
                        M0_mult2 <= w0_image;
                        M1_mult2 <= w4_image;
                        M2_mult2 <= w0_image;
                        M3_mult2 <= w4_image;
                        M4_mult2 <= w0_image;
                        M5_mult2 <= w4_image;
                        M6_mult2 <= w0_image;
                        M7_mult2 <= w4_image;
                    end
                    4'd8: begin
                        input_fir[read_count] <= fir_d;

                        stage2_image[2] <= M0[47:16];
                        stage2_image[3] <= M1[47:16];
                        stage2_image[6] <= M2[47:16];
                        stage2_image[7] <= M3[47:16];
                        stage2_image[10] <= M4[47:16];
                        stage2_image[11] <= M5[47:16];
                        stage2_image[14] <= M6[47:16];
                        stage2_image[15] <= M7[47:16];

                        //stage2 (d-b) * image
                        M0_mult1 <= stage1_image[2] - stage1_image[0];                             
                        M1_mult1 <= stage1_image[3] - stage1_image[1];                
                        M2_mult1 <= stage1_image[6] - stage1_image[4];                 
                        M3_mult1 <= stage1_image[7] - stage1_image[5];                      
                        M4_mult1 <= stage1_image[10] - stage1_image[8];              
                        M5_mult1 <= stage1_image[11] - stage1_image[9];
                        M6_mult1 <= stage1_image[14] - stage1_image[12];
                        M7_mult1 <= stage1_image[15] - stage1_image[13];
                    end
                    4'd9: begin
                        input_fir[read_count] <= fir_d;

                        stage2_real[2] <= stage2_real[2] + M0[47:16];
                        stage2_real[3] <= stage2_real[3] + M1[47:16];
                        stage2_real[6] <= stage2_real[6] + M2[47:16];
                        stage2_real[7] <= stage2_real[7] + M3[47:16];
                        stage2_real[10] <= stage2_real[10] + M4[47:16];
                        stage2_real[11] <= stage2_real[11] + M5[47:16];
                        stage2_real[14] <= stage2_real[14] + M6[47:16];
                        stage2_real[15] <= stage2_real[15] + M7[47:16];

                        //stage2 (d-b) * real
                        M0_mult2 <= w0_real;
                        M1_mult2 <= w4_real;
                        M2_mult2 <= w0_real;
                        M3_mult2 <= w4_real;
                        M4_mult2 <= w0_real;
                        M5_mult2 <= w4_real;
                        M6_mult2 <= w0_real;
                        M7_mult2 <= w4_real;
                    end
                    4'd10: begin
                        input_fir[read_count] <= fir_d;

                        stage2_image[2] <= stage2_image[2] - M0[47:16];
                        stage2_image[3] <= stage2_image[3] - M1[47:16];
                        stage2_image[6] <= stage2_image[6] - M2[47:16];
                        stage2_image[7] <= stage2_image[7] - M3[47:16];
                        stage2_image[10] <= stage2_image[10] - M4[47:16];
                        stage2_image[11] <= stage2_image[11] - M5[47:16];
                        stage2_image[14] <= stage2_image[14] - M6[47:16];
                        stage2_image[15] <= stage2_image[15] - M7[47:16];
                        //stage2 finish

                        //stage3
                        stage3_real[0] <= stage2_real[0] + stage2_real[1];
                        stage3_real[2] <= stage2_real[2] + stage2_real[3];
                        stage3_real[4] <= stage2_real[4] + stage2_real[5];
                        stage3_real[6] <= stage2_real[6] + stage2_real[7];   
                        stage3_real[8] <= stage2_real[8] + stage2_real[9]; 
                        stage3_real[10] <= stage2_real[10] + stage2_real[11];
                        stage3_real[12] <= stage2_real[12] + stage2_real[13];
                        stage3_real[14] <= stage2_real[14] + stage2_real[15];

                        //stage3 (a-c) * real
                        M0_mult1 <= stage2_real[0] - stage2_real[1];                             
                        M1_mult1 <= stage2_real[2] - stage2_real[3];                
                        M2_mult1 <= stage2_real[4] - stage2_real[5];                 
                        M3_mult1 <= stage2_real[6] - stage2_real[7];                      
                        M4_mult1 <= stage2_real[8] - stage2_real[9];              
                        M5_mult1 <= stage2_real[10] - stage2_real[11];
                        M6_mult1 <= stage2_real[12] - stage2_real[13];
                        M7_mult1 <= stage2_real[14] - stage2_real[15];
                        M0_mult2 <= w0_real;
                        M1_mult2 <= w0_real;
                        M2_mult2 <= w0_real;
                        M3_mult2 <= w0_real;
                        M4_mult2 <= w0_real;
                        M5_mult2 <= w0_real;
                        M6_mult2 <= w0_real;
                        M7_mult2 <= w0_real;
                    end
                    4'd11: begin
                        input_fir[read_count] <= fir_d;

                        stage3_real[1] <= M0[47:16];
                        stage3_real[3] <= M1[47:16];
                        stage3_real[5] <= M2[47:16];
                        stage3_real[7] <= M3[47:16];
                        stage3_real[9] <= M4[47:16];
                        stage3_real[11] <= M5[47:16];
                        stage3_real[13] <= M6[47:16];
                        stage3_real[15] <= M7[47:16];

                        stage3_image[0] <= stage2_image[0] + stage2_image[1];
                        stage3_image[2] <= stage2_image[2] + stage2_image[3];
                        stage3_image[4] <= stage2_image[4] + stage2_image[5];
                        stage3_image[6] <= stage2_image[6] + stage2_image[7];  
                        stage3_image[8] <= stage2_image[8] + stage2_image[9]; 
                        stage3_image[10] <= stage2_image[10]+ stage2_image[11];
                        stage3_image[12] <= stage2_image[12] + stage2_image[13];
                        stage3_image[14] <= stage2_image[14] + stage2_image[15];

                        //stage3 (a-c) * image
                        M0_mult2 <= w0_image;
                        M1_mult2 <= w0_image;
                        M2_mult2 <= w0_image;
                        M3_mult2 <= w0_image;
                        M4_mult2 <= w0_image;
                        M5_mult2 <= w0_image;
                        M6_mult2 <= w0_image;
                        M7_mult2 <= w0_image;
                    end
                    4'd12: begin
                        input_fir[read_count] <= fir_d;

                        stage3_image[1] <= M0[47:16];
                        stage3_image[3] <= M1[47:16];
                        stage3_image[5] <= M2[47:16];
                        stage3_image[7] <= M3[47:16];
                        stage3_image[9] <= M4[47:16];
                        stage3_image[11] <= M5[47:16];
                        stage3_image[13] <= M6[47:16];
                        stage3_image[15] <= M7[47:16];
                        
                        //stage3 (d-b) * image
                        M0_mult1 <= stage1_image[1] - stage1_image[0];                             
                        M1_mult1 <= stage1_image[3] - stage1_image[2];                
                        M2_mult1 <= stage1_image[5] - stage1_image[4];                 
                        M3_mult1 <= stage1_image[7] - stage1_image[6];                      
                        M4_mult1 <= stage1_image[9] - stage1_image[8];              
                        M5_mult1 <= stage1_image[11] - stage1_image[10];
                        M6_mult1 <= stage1_image[13] - stage1_image[12];
                        M7_mult1 <= stage1_image[15] - stage1_image[14];
                    end
                    4'd13: begin
                        input_fir[read_count] <= fir_d;

                        stage3_image[1] <= M0[47:16];
                        stage3_image[3] <= M1[47:16];
                        stage3_image[5] <= M2[47:16];
                        stage3_image[7] <= M3[47:16];
                        stage3_image[9] <= M4[47:16];
                        stage3_image[11] <= M5[47:16];
                        stage3_image[13] <= M6[47:16];
                        stage3_image[15] <= M7[47:16];

                        //stage2 (d-b) * image
                        M0_mult1 <= stage2_image[1] - stage2_image[0];                             
                        M1_mult1 <= stage2_image[3] - stage2_image[2];                
                        M2_mult1 <= stage2_image[5] - stage2_image[4];                 
                        M3_mult1 <= stage2_image[7] - stage2_image[6];                      
                        M4_mult1 <= stage2_image[9] - stage2_image[8];              
                        M5_mult1 <= stage2_image[11] - stage2_image[10];
                        M6_mult1 <= stage2_image[13] - stage2_image[12];
                        M7_mult1 <= stage2_image[15] - stage2_image[14];
                    end
                    4'd14: begin
                        input_fir[read_count] <= fir_d;

                        stage3_real[1] <= stage3_real[1] + M0[47:16];
                        stage3_real[3] <= stage3_real[3] + M1[47:16];
                        stage3_real[5] <= stage3_real[5] + M2[47:16];
                        stage3_real[7] <= stage3_real[7] + M3[47:16];
                        stage3_real[9] <= stage3_real[9] + M4[47:16];
                        stage3_real[11] <= stage3_real[11] + M5[47:16];
                        stage3_real[13] <= stage3_real[13] + M6[47:16];
                        stage3_real[15] <= stage3_real[15] + M7[47:16];

                        //stage3 (d-b) * real
                        M0_mult2 <= w0_real;
                        M1_mult2 <= w0_real;
                        M2_mult2 <= w0_real;
                        M3_mult2 <= w0_real;
                        M4_mult2 <= w0_real;
                        M5_mult2 <= w0_real;
                        M6_mult2 <= w0_real;
                        M7_mult2 <= w0_real;
                        
                    end
                    4'd15: begin
                        input_fir[read_count] <= fir_d;

                        stage3_image[1] <= stage3_image[1] - M0[47:16];
                        stage3_image[3] <= stage3_image[3] - M1[47:16];
                        stage3_image[5] <= stage3_image[5] - M2[47:16];
                        stage3_image[7] <= stage3_image[7] - M3[47:16];
                        stage3_image[9] <= stage3_image[9] - M4[47:16];
                        stage3_image[11] <= stage3_image[11] - M5[47:16];
                        stage3_image[13] <= stage3_image[13] - M6[47:16];
                        stage3_image[15] <= stage3_image[15] - M7[47:16];
                        //stage 3 finish

                        
                    end
                    default: begin
                        input_fir[read_count] <= fir_d;
                    end
                endcase 
            end
            TRANS: begin
                read_count <= read_count + 4'd1;
                case(read_count)
                    4'd0: begin
                        input_fir[read_count] <= fir_d;
                        proceed_fir[0] <= input_fir[0];
                        proceed_fir[1] <= input_fir[1];
                        proceed_fir[2] <= input_fir[2];
                        proceed_fir[3] <= input_fir[3];
                        proceed_fir[4] <= input_fir[4];
                        proceed_fir[5] <= input_fir[5];
                        proceed_fir[6] <= input_fir[6];
                        proceed_fir[7] <= input_fir[7];
                        proceed_fir[8] <= input_fir[8];
                        proceed_fir[9] <= input_fir[9];
                        proceed_fir[10] <= input_fir[10];
                        proceed_fir[11] <= input_fir[11];
                        proceed_fir[12] <= input_fir[12];
                        proceed_fir[13] <= input_fir[13];
                        proceed_fir[14] <= input_fir[14];
                        proceed_fir[15] <= input_fir[15];

                        //stage0 (a-c) * real
                        M0_mult1 <= {{8{input_fir[0][15]}}, input_fir[0], 8'd0} - {{8{input_fir[8][15]}}, input_fir[8], 8'd0};                                    
                        M1_mult1 <= {{8{input_fir[1][15]}}, input_fir[1], 8'd0} - {{8{input_fir[9][15]}}, input_fir[9], 8'd0};                       
                        M2_mult1 <= {{8{input_fir[2][15]}}, input_fir[2], 8'd0} - {{8{input_fir[10][15]}}, input_fir[10], 8'd0};                      
                        M3_mult1 <= {{8{input_fir[3][15]}}, input_fir[3], 8'd0} - {{8{input_fir[11][15]}}, input_fir[11], 8'd0};                        
                        M4_mult1 <= {{8{input_fir[4][15]}}, input_fir[4], 8'd0} - {{8{input_fir[12][15]}}, input_fir[12], 8'd0};                  
                        M5_mult1 <= {{8{input_fir[5][15]}}, input_fir[5], 8'd0} - {{8{input_fir[13][15]}}, input_fir[13], 8'd0};
                        M6_mult1 <= {{8{input_fir[6][15]}}, input_fir[6], 8'd0} - {{8{input_fir[14][15]}}, input_fir[14], 8'd0};
                        M7_mult1 <= {{8{input_fir[7][15]}}, input_fir[7], 8'd0} - {{8{input_fir[15][15]}}, input_fir[15], 8'd0};
                        M0_mult2 <= w0_real;
                        M1_mult2 <= w1_real;
                        M2_mult2 <= w2_real;
                        M3_mult2 <= w3_real;
                        M4_mult2 <= w4_real;
                        M5_mult2 <= w5_real;
                        M6_mult2 <= w6_real;
                        M7_mult2 <= w7_real;

                        //trans
                        fft_valid <= 1'b1;
                        fft_d0  <= stage3_real[0][23:8];
                        fft_d1  <= stage3_real[8][23:8];
                        fft_d2  <= stage3_real[4][23:8];
                        fft_d3  <= stage3_real[12][23:8];
                        fft_d4  <= stage3_real[2][23:8];
                        fft_d5  <= stage3_real[10][23:8];
                        fft_d6  <= stage3_real[6][23:8];
                        fft_d7  <= stage3_real[14][23:8];
                        fft_d8  <= stage3_real[1][23:8];
                        fft_d9  <= stage3_real[9][23:8];
                        fft_d10 <= stage3_real[5][23:8];
                        fft_d11 <= stage3_real[13][23:8];
                        fft_d12 <= stage3_real[3][23:8];
                        fft_d13 <= stage3_real[11][23:8];
                        fft_d14 <= stage3_real[7][23:8];
                        fft_d15 <= stage3_real[15][23:8];

                    end
                    //stage0 
                    4'd1: begin
                        input_fir[read_count] <= fir_d;
                        stage0_real[0] <= {{8{proceed_fir[0][15]}}, proceed_fir[0], 8'd0} + {{8{proceed_fir[8][15]}}, proceed_fir[8], 8'd0};
                        stage0_real[1] <= {{8{proceed_fir[1][15]}}, proceed_fir[1], 8'd0} + {{8{proceed_fir[9][15]}}, proceed_fir[9], 8'd0};
                        stage0_real[2] <= {{8{proceed_fir[2][15]}}, proceed_fir[2], 8'd0} + {{8{proceed_fir[10][15]}}, proceed_fir[10], 8'd0};
                        stage0_real[3] <= {{8{proceed_fir[3][15]}}, proceed_fir[3], 8'd0} + {{8{proceed_fir[11][15]}}, proceed_fir[11], 8'd0};
                        stage0_real[4] <= {{8{proceed_fir[4][15]}}, proceed_fir[4], 8'd0} + {{8{proceed_fir[12][15]}}, proceed_fir[12], 8'd0};
                        stage0_real[5] <= {{8{proceed_fir[5][15]}}, proceed_fir[5], 8'd0} + {{8{proceed_fir[13][15]}}, proceed_fir[13], 8'd0};
                        stage0_real[6] <= {{8{proceed_fir[6][15]}}, proceed_fir[6], 8'd0} + {{8{proceed_fir[14][15]}}, proceed_fir[14], 8'd0};
                        stage0_real[7] <= {{8{proceed_fir[7][15]}}, proceed_fir[7], 8'd0} + {{8{proceed_fir[15][15]}}, proceed_fir[15], 8'd0};
                                                
                        stage0_real[8] <= M0[47:16];
                        stage0_real[9] <= M1[47:16];
                        stage0_real[10] <= M2[47:16];
                        stage0_real[11] <= M3[47:16];
                        stage0_real[12] <= M4[47:16];
                        stage0_real[13] <= M5[47:16];
                        stage0_real[14] <= M6[47:16];
                        stage0_real[15] <= M7[47:16];

                        stage0_image[0] <= 32'd0;
                        stage0_image[1] <= 32'd0;
                        stage0_image[2] <= 32'd0;
                        stage0_image[3] <= 32'd0;
                        stage0_image[4] <= 32'd0;
                        stage0_image[5] <= 32'd0;
                        stage0_image[6] <= 32'd0;
                        stage0_image[7] <= 32'd0;

                        //stage0 (a-c) * image
                        M0_mult1 <= {{8{proceed_fir[0][15]}}, proceed_fir[0], 8'd0} - {{8{proceed_fir[8][15]}}, proceed_fir[8], 8'd0};  
                        M1_mult1 <= {{8{proceed_fir[1][15]}}, proceed_fir[1], 8'd0} - {{8{proceed_fir[9][15]}}, proceed_fir[9], 8'd0};  
                        M2_mult1 <= {{8{proceed_fir[2][15]}}, proceed_fir[2], 8'd0} - {{8{proceed_fir[10][15]}}, proceed_fir[10], 8'd0};
                        M3_mult1 <= {{8{proceed_fir[3][15]}}, proceed_fir[3], 8'd0} - {{8{proceed_fir[11][15]}}, proceed_fir[11], 8'd0};
                        M4_mult1 <= {{8{proceed_fir[4][15]}}, proceed_fir[4], 8'd0} - {{8{proceed_fir[12][15]}}, proceed_fir[12], 8'd0};
                        M5_mult1 <= {{8{proceed_fir[5][15]}}, proceed_fir[5], 8'd0} - {{8{proceed_fir[13][15]}}, proceed_fir[13], 8'd0};
                        M6_mult1 <= {{8{proceed_fir[6][15]}}, proceed_fir[6], 8'd0} - {{8{proceed_fir[14][15]}}, proceed_fir[14], 8'd0};
                        M7_mult1 <= {{8{proceed_fir[7][15]}}, proceed_fir[7], 8'd0} - {{8{proceed_fir[15][15]}}, proceed_fir[15], 8'd0};
                        M0_mult2 <= w0_image;
                        M1_mult2 <= w1_image;
                        M2_mult2 <= w2_image;
                        M3_mult2 <= w3_image;
                        M4_mult2 <= w4_image;
                        M5_mult2 <= w5_image;
                        M6_mult2 <= w6_image;
                        M7_mult2 <= w7_image;

                        fft_d0 <= stage3_image[0][23:8];
                        fft_d1 <= stage3_image[8][23:8];
                        fft_d2 <= stage3_image[4][23:8];
                        fft_d3 <= stage3_image[12][23:8];
                        fft_d4 <= stage3_image[2][23:8];
                        fft_d5 <= stage3_image[10][23:8];
                        fft_d6 <= stage3_image[6][23:8];
                        fft_d7 <= stage3_image[14][23:8];
                        fft_d8 <= stage3_image[1][23:8];
                        fft_d9 <= stage3_image[9][23:8];
                        fft_d10 <= stage3_image[5][23:8];
                        fft_d11 <= stage3_image[13][23:8];
                        fft_d12 <= stage3_image[3][23:8];
                        fft_d13 <= stage3_image[11][23:8];
                        fft_d14 <= stage3_image[7][23:8];
                        fft_d15 <= stage3_image[15][23:8];
                    end
                    4'd2: begin
                        fft_valid <= 0;
                        input_fir[read_count] <= fir_d;
                        
                        stage0_image[8]  <= M0[47:16];
                        stage0_image[9]  <= M1[47:16];
                        stage0_image[10] <= M2[47:16];
                        stage0_image[11] <= M3[47:16];
                        stage0_image[12] <= M4[47:16];
                        stage0_image[13] <= M5[47:16];
                        stage0_image[14] <= M6[47:16];
                        stage0_image[15] <= M7[47:16];
                        //stage 0 finish

                        //stage 1 
                        stage1_real[0] <= stage0_real[0] + stage0_real[4];
                        stage1_real[1] <= stage0_real[1] + stage0_real[5];
                        stage1_real[2] <= stage0_real[2] + stage0_real[6];
                        stage1_real[3] <= stage0_real[3] + stage0_real[7];   
                        stage1_real[8] <= stage0_real[8] + stage0_real[12];
                        stage1_real[9] <= stage0_real[9] + stage0_real[13];
                        stage1_real[10] <= stage0_real[10] + stage0_real[14];
                        stage1_real[11] <= stage0_real[11] + stage0_real[15];

                        // stage 1 (a-c) * real
                        M0_mult1 <= stage0_real[0] - stage0_real[4];                                  
                        M1_mult1 <= stage0_real[1] - stage0_real[5];                     
                        M2_mult1 <= stage0_real[2] - stage0_real[6];                      
                        M3_mult1 <= stage0_real[3] - stage0_real[7];                        
                        M4_mult1 <= stage0_real[8] - stage0_real[12];                  
                        M5_mult1 <= stage0_real[9] - stage0_real[13];
                        M6_mult1 <= stage0_real[10] - stage0_real[14];
                        M7_mult1 <= stage0_real[11] - stage0_real[15];
                        M0_mult2 <= w0_real;
                        M1_mult2 <= w2_real;
                        M2_mult2 <= w4_real;
                        M3_mult2 <= w6_real;
                        M4_mult2 <= w0_real;
                        M5_mult2 <= w2_real;
                        M6_mult2 <= w4_real;
                        M7_mult2 <= w6_real;
                                                                                                                                                                                                                                                                                                          
                    end
                    4'd3: begin
                        input_fir[read_count] <= fir_d;
                        
                        stage1_real[4] <= M0[47:16];
                        stage1_real[5] <= M1[47:16];
                        stage1_real[6] <= M2[47:16];
                        stage1_real[7] <= M3[47:16];
                        stage1_real[12] <= M4[47:16];
                        stage1_real[13] <= M5[47:16];
                        stage1_real[14] <= M6[47:16];
                        stage1_real[15] <= M7[47:16];

                        stage1_image[0] <= stage0_image[0] + stage0_image[4];
                        stage1_image[1] <= stage0_image[1] + stage0_image[5];
                        stage1_image[2] <= stage0_image[2] + stage0_image[6];                
                        stage1_image[3] <= stage0_image[3] + stage0_image[7];
                        stage1_image[8] <= stage0_image[8] + stage0_image[12];                       
                        stage1_image[9] <= stage0_image[9] + stage0_image[13];                      
                        stage1_image[10] <= stage0_image[10] + stage0_image[14];
                        stage1_image[11] <= stage0_image[11] + stage0_image[15];

                        //stage 1 (a-c) * image
                        M0_mult2 <= w0_image;
                        M1_mult2 <= w2_image;
                        M2_mult2 <= w4_image;
                        M3_mult2 <= w6_image;
                        M4_mult2 <= w0_image;
                        M5_mult2 <= w2_image;
                        M6_mult2 <= w4_image;
                        M7_mult2 <= w6_image;

                    end
                    4'd4: begin
                        input_fir[read_count] <= fir_d;

                        stage1_image[4] <= M0[47:16];
                        stage1_image[5] <= M1[47:16];
                        stage1_image[6] <= M2[47:16];
                        stage1_image[7] <= M3[47:16];
                        stage1_image[12] <= M4[47:16];
                        stage1_image[13] <= M5[47:16];
                        stage1_image[14] <= M6[47:16];
                        stage1_image[15] <= M7[47:16];

                        //stage 1 (d-b) * image
                        M0_mult1 <= stage0_image[4] - stage0_image[0];    
                        M1_mult1 <= stage0_image[5] - stage0_image[1];    
                        M2_mult1 <= stage0_image[6] - stage0_image[2];    
                        M3_mult1 <= stage0_image[7] - stage0_image[3];    
                        M4_mult1 <= stage0_image[12] - stage0_image[8];   
                        M5_mult1 <= stage0_image[13] - stage0_image[9];
                        M6_mult1 <= stage0_image[14] - stage0_image[10];
                        M7_mult1 <= stage0_image[15] - stage0_image[11];
                   
                    end
                    4'd5: begin
                        input_fir[read_count] <= fir_d;

                        stage1_real[4] <=  stage1_real[4] + M0[47:16];
                        stage1_real[5] <=  stage1_real[5] + M1[47:16];
                        stage1_real[6] <=  stage1_real[6] + M2[47:16];
                        stage1_real[7] <=  stage1_real[7] + M3[47:16];
                        stage1_real[12] <= stage1_real[12] + M4[47:16];
                        stage1_real[13] <= stage1_real[13] + M5[47:16];
                        stage1_real[14] <= stage1_real[14] + M6[47:16];
                        stage1_real[15] <= stage1_real[15] + M7[47:16];

                        //stage 1 (d-b) * real
                        M0_mult2 <= w0_real;
                        M1_mult2 <= w2_real;
                        M2_mult2 <= w4_real;
                        M3_mult2 <= w6_real;
                        M4_mult2 <= w0_real;
                        M5_mult2 <= w2_real;
                        M6_mult2 <= w4_real;
                        M7_mult2 <= w6_real;
                    end
                    4'd6: begin
                        input_fir[read_count] <= fir_d;
                        
                        stage1_image[4] <= stage1_image[4] - M0[47:16];
                        stage1_image[5] <= stage1_image[5] - M1[47:16];
                        stage1_image[6] <= stage1_image[6] - M2[47:16];
                        stage1_image[7] <= stage1_image[7] - M3[47:16];
                        stage1_image[12] <= stage1_image[12] - M4[47:16];
                        stage1_image[13] <= stage1_image[13] - M5[47:16];
                        stage1_image[14] <= stage1_image[14] - M6[47:16];
                        stage1_image[15] <= stage1_image[15] - M7[47:16];
                        //stage1 finish

                        //stage2
                        stage2_real[0] <= stage1_real[0] + stage1_real[2];
                        stage2_real[1] <= stage1_real[1] + stage1_real[3];
                        stage2_real[4] <= stage1_real[4] + stage1_real[6];
                        stage2_real[5] <= stage1_real[5] + stage1_real[7];   
                        stage2_real[8] <= stage1_real[8] + stage1_real[10]; 
                        stage2_real[9] <= stage1_real[9] + stage1_real[11];
                        stage2_real[12] <= stage1_real[12] + stage1_real[14];
                        stage2_real[13] <= stage1_real[13] + stage1_real[15];

                        //stage2 (a-c) * real
                        M0_mult1 <= stage1_real[0] - stage1_real[2];                             
                        M1_mult1 <= stage1_real[1] - stage1_real[3];                
                        M2_mult1 <= stage1_real[4] - stage1_real[6];                 
                        M3_mult1 <= stage1_real[5] - stage1_real[7];                      
                        M4_mult1 <= stage1_real[8] - stage1_real[10];              
                        M5_mult1 <= stage1_real[9] - stage1_real[11];
                        M6_mult1 <= stage1_real[12] - stage1_real[14];
                        M7_mult1 <= stage1_real[13] - stage1_real[15];
                        M0_mult2 <= w0_real;
                        M1_mult2 <= w4_real;
                        M2_mult2 <= w0_real;
                        M3_mult2 <= w4_real;
                        M4_mult2 <= w0_real;
                        M5_mult2 <= w4_real;
                        M6_mult2 <= w0_real;
                        M7_mult2 <= w4_real;
                    end
                    4'd7: begin
                        input_fir[read_count] <= fir_d;

                        stage2_real[2] <= M0[47:16];
                        stage2_real[3] <= M1[47:16];
                        stage2_real[6] <= M2[47:16];
                        stage2_real[7] <= M3[47:16];
                        stage2_real[10] <= M4[47:16];
                        stage2_real[11] <= M5[47:16];
                        stage2_real[14] <= M6[47:16];
                        stage2_real[15] <= M7[47:16];

                        stage2_image[0] <= stage1_image[0] + stage1_image[2];
                        stage2_image[1] <= stage1_image[1] + stage1_image[3];
                        stage2_image[4] <= stage1_image[4] + stage1_image[6];
                        stage2_image[5] <= stage1_image[5] + stage1_image[7];   
                        stage2_image[8] <= stage1_image[8] + stage1_image[10]; 
                        stage2_image[9] <= stage1_image[9] + stage1_image[11];
                        stage2_image[12] <= stage1_image[12] + stage1_image[14];
                        stage2_image[13] <= stage1_image[13] + stage1_image[15];

                        //stage2 (a-c) * image
                        M0_mult2 <= w0_image;
                        M1_mult2 <= w4_image;
                        M2_mult2 <= w0_image;
                        M3_mult2 <= w4_image;
                        M4_mult2 <= w0_image;
                        M5_mult2 <= w4_image;
                        M6_mult2 <= w0_image;
                        M7_mult2 <= w4_image;
                    end
                    4'd8: begin
                        input_fir[read_count] <= fir_d;

                        stage2_image[2] <= M0[47:16];
                        stage2_image[3] <= M1[47:16];
                        stage2_image[6] <= M2[47:16];
                        stage2_image[7] <= M3[47:16];
                        stage2_image[10] <= M4[47:16];
                        stage2_image[11] <= M5[47:16];
                        stage2_image[14] <= M6[47:16];
                        stage2_image[15] <= M7[47:16];

                        //stage2 (d-b) * image
                        M0_mult1 <= stage1_image[2] - stage1_image[0];                             
                        M1_mult1 <= stage1_image[3] - stage1_image[1];                
                        M2_mult1 <= stage1_image[6] - stage1_image[4];                 
                        M3_mult1 <= stage1_image[7] - stage1_image[5];                      
                        M4_mult1 <= stage1_image[10] - stage1_image[8];              
                        M5_mult1 <= stage1_image[11] - stage1_image[9];
                        M6_mult1 <= stage1_image[14] - stage1_image[12];
                        M7_mult1 <= stage1_image[15] - stage1_image[13];
                    end
                    4'd9: begin
                        input_fir[read_count] <= fir_d;

                        stage2_real[2] <= stage2_real[2] + M0[47:16];
                        stage2_real[3] <= stage2_real[3] + M1[47:16];
                        stage2_real[6] <= stage2_real[6] + M2[47:16];
                        stage2_real[7] <= stage2_real[7] + M3[47:16];
                        stage2_real[10] <= stage2_real[10] + M4[47:16];
                        stage2_real[11] <= stage2_real[11] + M5[47:16];
                        stage2_real[14] <= stage2_real[14] + M6[47:16];
                        stage2_real[15] <= stage2_real[15] + M7[47:16];

                        //stage2 (d-b) * real
                        M0_mult2 <= w0_real;
                        M1_mult2 <= w4_real;
                        M2_mult2 <= w0_real;
                        M3_mult2 <= w4_real;
                        M4_mult2 <= w0_real;
                        M5_mult2 <= w4_real;
                        M6_mult2 <= w0_real;
                        M7_mult2 <= w4_real;
                    end
                    4'd10: begin
                        input_fir[read_count] <= fir_d;

                        stage2_image[2] <= stage2_image[2] - M0[47:16];
                        stage2_image[3] <= stage2_image[3] - M1[47:16];
                        stage2_image[6] <= stage2_image[6] - M2[47:16];
                        stage2_image[7] <= stage2_image[7] - M3[47:16];
                        stage2_image[10] <= stage2_image[10] - M4[47:16];
                        stage2_image[11] <= stage2_image[11] - M5[47:16];
                        stage2_image[14] <= stage2_image[14] - M6[47:16];
                        stage2_image[15] <= stage2_image[15] - M7[47:16];
                        //stage2 finish

                        //stage3
                        stage3_real[0] <= stage2_real[0] + stage2_real[1];
                        stage3_real[2] <= stage2_real[2] + stage2_real[3];
                        stage3_real[4] <= stage2_real[4] + stage2_real[5];
                        stage3_real[6] <= stage2_real[6] + stage2_real[7];   
                        stage3_real[8] <= stage2_real[8] + stage2_real[9]; 
                        stage3_real[10] <= stage2_real[10] + stage2_real[11];
                        stage3_real[12] <= stage2_real[12] + stage2_real[13];
                        stage3_real[14] <= stage2_real[14] + stage2_real[15];

                        //stage3 (a-c) * real
                        M0_mult1 <= stage2_real[0] - stage2_real[1];                             
                        M1_mult1 <= stage2_real[2] - stage2_real[3];                
                        M2_mult1 <= stage2_real[4] - stage2_real[5];                 
                        M3_mult1 <= stage2_real[6] - stage2_real[7];                      
                        M4_mult1 <= stage2_real[8] - stage2_real[9];              
                        M5_mult1 <= stage2_real[10] - stage2_real[11];
                        M6_mult1 <= stage2_real[12] - stage2_real[13];
                        M7_mult1 <= stage2_real[14] - stage2_real[15];
                        M0_mult2 <= w0_real;
                        M1_mult2 <= w0_real;
                        M2_mult2 <= w0_real;
                        M3_mult2 <= w0_real;
                        M4_mult2 <= w0_real;
                        M5_mult2 <= w0_real;
                        M6_mult2 <= w0_real;
                        M7_mult2 <= w0_real;
                    end
                    4'd11: begin
                        input_fir[read_count] <= fir_d;

                        stage3_real[1] <= M0[47:16];
                        stage3_real[3] <= M1[47:16];
                        stage3_real[5] <= M2[47:16];
                        stage3_real[7] <= M3[47:16];
                        stage3_real[9] <= M4[47:16];
                        stage3_real[11] <= M5[47:16];
                        stage3_real[13] <= M6[47:16];
                        stage3_real[15] <= M7[47:16];

                        stage3_image[0] <= stage2_image[0] + stage2_image[1];
                        stage3_image[2] <= stage2_image[2] + stage2_image[3];
                        stage3_image[4] <= stage2_image[4] + stage2_image[5];
                        stage3_image[6] <= stage2_image[6] + stage2_image[7];  
                        stage3_image[8] <= stage2_image[8] + stage2_image[9]; 
                        stage3_image[10] <= stage2_image[10]+ stage2_image[11];
                        stage3_image[12] <= stage2_image[12] + stage2_image[13];
                        stage3_image[14] <= stage2_image[14] + stage2_image[15];

                        //stage3 (a-c) * image
                        M0_mult2 <= w0_image;
                        M1_mult2 <= w0_image;
                        M2_mult2 <= w0_image;
                        M3_mult2 <= w0_image;
                        M4_mult2 <= w0_image;
                        M5_mult2 <= w0_image;
                        M6_mult2 <= w0_image;
                        M7_mult2 <= w0_image;
                    end
                    4'd12: begin
                        input_fir[read_count] <= fir_d;

                        stage3_image[1] <= M0[47:16];
                        stage3_image[3] <= M1[47:16];
                        stage3_image[5] <= M2[47:16];
                        stage3_image[7] <= M3[47:16];
                        stage3_image[9] <= M4[47:16];
                        stage3_image[11] <= M5[47:16];
                        stage3_image[13] <= M6[47:16];
                        stage3_image[15] <= M7[47:16];
                        
                        //stage3 (d-b) * image
                        M0_mult1 <= stage1_image[1] - stage1_image[0];                             
                        M1_mult1 <= stage1_image[3] - stage1_image[2];                
                        M2_mult1 <= stage1_image[5] - stage1_image[4];                 
                        M3_mult1 <= stage1_image[7] - stage1_image[6];                      
                        M4_mult1 <= stage1_image[9] - stage1_image[8];              
                        M5_mult1 <= stage1_image[11] - stage1_image[10];
                        M6_mult1 <= stage1_image[13] - stage1_image[12];
                        M7_mult1 <= stage1_image[15] - stage1_image[14];
                    end
                    4'd13: begin
                        input_fir[read_count] <= fir_d;

                        stage3_image[1] <= M0[47:16];
                        stage3_image[3] <= M1[47:16];
                        stage3_image[5] <= M2[47:16];
                        stage3_image[7] <= M3[47:16];
                        stage3_image[9] <= M4[47:16];
                        stage3_image[11] <= M5[47:16];
                        stage3_image[13] <= M6[47:16];
                        stage3_image[15] <= M7[47:16];

                        //stage2 (d-b) * image
                        M0_mult1 <= stage2_image[1] - stage2_image[0];                             
                        M1_mult1 <= stage2_image[3] - stage2_image[2];                
                        M2_mult1 <= stage2_image[5] - stage2_image[4];                 
                        M3_mult1 <= stage2_image[7] - stage2_image[6];                      
                        M4_mult1 <= stage2_image[9] - stage2_image[8];              
                        M5_mult1 <= stage2_image[11] - stage2_image[10];
                        M6_mult1 <= stage2_image[13] - stage2_image[12];
                        M7_mult1 <= stage2_image[15] - stage2_image[14];
                    end
                    4'd14: begin
                        input_fir[read_count] <= fir_d;

                        stage3_real[1] <= stage3_real[1] + M0[47:16];
                        stage3_real[3] <= stage3_real[3] + M1[47:16];
                        stage3_real[5] <= stage3_real[5] + M2[47:16];
                        stage3_real[7] <= stage3_real[7] + M3[47:16];
                        stage3_real[9] <= stage3_real[9] + M4[47:16];
                        stage3_real[11] <= stage3_real[11] + M5[47:16];
                        stage3_real[13] <= stage3_real[13] + M6[47:16];
                        stage3_real[15] <= stage3_real[15] + M7[47:16];

                        //stage3 (d-b) * real
                        M0_mult2 <= w0_real;
                        M1_mult2 <= w0_real;
                        M2_mult2 <= w0_real;
                        M3_mult2 <= w0_real;
                        M4_mult2 <= w0_real;
                        M5_mult2 <= w0_real;
                        M6_mult2 <= w0_real;
                        M7_mult2 <= w0_real;
                        
                    end
                    4'd15: begin
                        input_fir[read_count] <= fir_d;

                        stage3_image[1] <= stage3_image[1] - M0[47:16];
                        stage3_image[3] <= stage3_image[3] - M1[47:16];
                        stage3_image[5] <= stage3_image[5] - M2[47:16];
                        stage3_image[7] <= stage3_image[7] - M3[47:16];
                        stage3_image[9] <= stage3_image[9] - M4[47:16];
                        stage3_image[11] <= stage3_image[11] - M5[47:16];
                        stage3_image[13] <= stage3_image[13] - M6[47:16];
                        stage3_image[15] <= stage3_image[15] - M7[47:16];
                        //stage 3 finish

                        
                    end
                    default: begin
                        input_fir[read_count] <= fir_d;
                    end
                endcase 
            end
            FINAL: begin
                read_count <= read_count + 4'd1;
                case(read_count)
                    4'd0: begin
                        input_fir[read_count] <= fir_d;
                        proceed_fir[0] <= input_fir[0];
                        proceed_fir[1] <= input_fir[1];
                        proceed_fir[2] <= input_fir[2];
                        proceed_fir[3] <= input_fir[3];
                        proceed_fir[4] <= input_fir[4];
                        proceed_fir[5] <= input_fir[5];
                        proceed_fir[6] <= input_fir[6];
                        proceed_fir[7] <= input_fir[7];
                        proceed_fir[8] <= input_fir[8];
                        proceed_fir[9] <= input_fir[9];
                        proceed_fir[10] <= input_fir[10];
                        proceed_fir[11] <= input_fir[11];
                        proceed_fir[12] <= input_fir[12];
                        proceed_fir[13] <= input_fir[13];
                        proceed_fir[14] <= input_fir[14];
                        proceed_fir[15] <= input_fir[15];

                        //stage0 (a-c) * real
                        M0_mult1 <= {{8{input_fir[0][15]}}, input_fir[0], 8'd0} - {{8{input_fir[8][15]}}, input_fir[8], 8'd0};                                    
                        M1_mult1 <= {{8{input_fir[1][15]}}, input_fir[1], 8'd0} - {{8{input_fir[9][15]}}, input_fir[9], 8'd0};                       
                        M2_mult1 <= {{8{input_fir[2][15]}}, input_fir[2], 8'd0} - {{8{input_fir[10][15]}}, input_fir[10], 8'd0};                      
                        M3_mult1 <= {{8{input_fir[3][15]}}, input_fir[3], 8'd0} - {{8{input_fir[11][15]}}, input_fir[11], 8'd0};                        
                        M4_mult1 <= {{8{input_fir[4][15]}}, input_fir[4], 8'd0} - {{8{input_fir[12][15]}}, input_fir[12], 8'd0};                  
                        M5_mult1 <= {{8{input_fir[5][15]}}, input_fir[5], 8'd0} - {{8{input_fir[13][15]}}, input_fir[13], 8'd0};
                        M6_mult1 <= {{8{input_fir[6][15]}}, input_fir[6], 8'd0} - {{8{input_fir[14][15]}}, input_fir[14], 8'd0};
                        M7_mult1 <= {{8{input_fir[7][15]}}, input_fir[7], 8'd0} - {{8{input_fir[15][15]}}, input_fir[15], 8'd0};
                        M0_mult2 <= w0_real;
                        M1_mult2 <= w1_real;
                        M2_mult2 <= w2_real;
                        M3_mult2 <= w3_real;
                        M4_mult2 <= w4_real;
                        M5_mult2 <= w5_real;
                        M6_mult2 <= w6_real;
                        M7_mult2 <= w7_real;

                        //trans
                        fft_valid <= 1'b1;
                        fft_d0  <= stage3_real[0][23:8];
                        fft_d1  <= stage3_real[8][23:8];
                        fft_d2  <= stage3_real[4][23:8];
                        fft_d3  <= stage3_real[12][23:8];
                        fft_d4  <= stage3_real[2][23:8];
                        fft_d5  <= stage3_real[10][23:8];
                        fft_d6  <= stage3_real[6][23:8];
                        fft_d7  <= stage3_real[14][23:8];
                        fft_d8  <= stage3_real[1][23:8];
                        fft_d9  <= stage3_real[9][23:8];
                        fft_d10 <= stage3_real[5][23:8];
                        fft_d11 <= stage3_real[13][23:8];
                        fft_d12 <= stage3_real[3][23:8];
                        fft_d13 <= stage3_real[11][23:8];
                        fft_d14 <= stage3_real[7][23:8];
                        fft_d15 <= stage3_real[15][23:8];

                    end
                    //stage0 
                    4'd1: begin
                        input_fir[read_count] <= fir_d;
                        stage0_real[0] <= {{8{proceed_fir[0][15]}}, proceed_fir[0], 8'd0} + {{8{proceed_fir[8][15]}}, proceed_fir[8], 8'd0};
                        stage0_real[1] <= {{8{proceed_fir[1][15]}}, proceed_fir[1], 8'd0} + {{8{proceed_fir[9][15]}}, proceed_fir[9], 8'd0};
                        stage0_real[2] <= {{8{proceed_fir[2][15]}}, proceed_fir[2], 8'd0} + {{8{proceed_fir[10][15]}}, proceed_fir[10], 8'd0};
                        stage0_real[3] <= {{8{proceed_fir[3][15]}}, proceed_fir[3], 8'd0} + {{8{proceed_fir[11][15]}}, proceed_fir[11], 8'd0};
                        stage0_real[4] <= {{8{proceed_fir[4][15]}}, proceed_fir[4], 8'd0} + {{8{proceed_fir[12][15]}}, proceed_fir[12], 8'd0};
                        stage0_real[5] <= {{8{proceed_fir[5][15]}}, proceed_fir[5], 8'd0} + {{8{proceed_fir[13][15]}}, proceed_fir[13], 8'd0};
                        stage0_real[6] <= {{8{proceed_fir[6][15]}}, proceed_fir[6], 8'd0} + {{8{proceed_fir[14][15]}}, proceed_fir[14], 8'd0};
                        stage0_real[7] <= {{8{proceed_fir[7][15]}}, proceed_fir[7], 8'd0} + {{8{proceed_fir[15][15]}}, proceed_fir[15], 8'd0};
                                                
                        stage0_real[8] <= M0[47:16];
                        stage0_real[9] <= M1[47:16];
                        stage0_real[10] <= M2[47:16];
                        stage0_real[11] <= M3[47:16];
                        stage0_real[12] <= M4[47:16];
                        stage0_real[13] <= M5[47:16];
                        stage0_real[14] <= M6[47:16];
                        stage0_real[15] <= M7[47:16];

                        stage0_image[0] <= 32'd0;
                        stage0_image[1] <= 32'd0;
                        stage0_image[2] <= 32'd0;
                        stage0_image[3] <= 32'd0;
                        stage0_image[4] <= 32'd0;
                        stage0_image[5] <= 32'd0;
                        stage0_image[6] <= 32'd0;
                        stage0_image[7] <= 32'd0;

                        //stage0 (a-c) * image
                        M0_mult1 <= {{8{proceed_fir[0][15]}}, proceed_fir[0], 8'd0} - {{8{proceed_fir[8][15]}}, proceed_fir[8], 8'd0};  
                        M1_mult1 <= {{8{proceed_fir[1][15]}}, proceed_fir[1], 8'd0} - {{8{proceed_fir[9][15]}}, proceed_fir[9], 8'd0};  
                        M2_mult1 <= {{8{proceed_fir[2][15]}}, proceed_fir[2], 8'd0} - {{8{proceed_fir[10][15]}}, proceed_fir[10], 8'd0};
                        M3_mult1 <= {{8{proceed_fir[3][15]}}, proceed_fir[3], 8'd0} - {{8{proceed_fir[11][15]}}, proceed_fir[11], 8'd0};
                        M4_mult1 <= {{8{proceed_fir[4][15]}}, proceed_fir[4], 8'd0} - {{8{proceed_fir[12][15]}}, proceed_fir[12], 8'd0};
                        M5_mult1 <= {{8{proceed_fir[5][15]}}, proceed_fir[5], 8'd0} - {{8{proceed_fir[13][15]}}, proceed_fir[13], 8'd0};
                        M6_mult1 <= {{8{proceed_fir[6][15]}}, proceed_fir[6], 8'd0} - {{8{proceed_fir[14][15]}}, proceed_fir[14], 8'd0};
                        M7_mult1 <= {{8{proceed_fir[7][15]}}, proceed_fir[7], 8'd0} - {{8{proceed_fir[15][15]}}, proceed_fir[15], 8'd0};
                        M0_mult2 <= w0_image;
                        M1_mult2 <= w1_image;
                        M2_mult2 <= w2_image;
                        M3_mult2 <= w3_image;
                        M4_mult2 <= w4_image;
                        M5_mult2 <= w5_image;
                        M6_mult2 <= w6_image;
                        M7_mult2 <= w7_image;

                        fft_d0 <= stage3_image[0][23:8];
                        fft_d1 <= stage3_image[8][23:8];
                        fft_d2 <= stage3_image[4][23:8];
                        fft_d3 <= stage3_image[12][23:8];
                        fft_d4 <= stage3_image[2][23:8];
                        fft_d5 <= stage3_image[10][23:8];
                        fft_d6 <= stage3_image[6][23:8];
                        fft_d7 <= stage3_image[14][23:8];
                        fft_d8 <= stage3_image[1][23:8];
                        fft_d9 <= stage3_image[9][23:8];
                        fft_d10 <= stage3_image[5][23:8];
                        fft_d11 <= stage3_image[13][23:8];
                        fft_d12 <= stage3_image[3][23:8];
                        fft_d13 <= stage3_image[11][23:8];
                        fft_d14 <= stage3_image[7][23:8];
                        fft_d15 <= stage3_image[15][23:8];
                    end
                    4'd2: begin
                        fft_valid <= 0;
                        input_fir[read_count] <= fir_d;
                        
                        stage0_image[8]  <= M0[47:16];
                        stage0_image[9]  <= M1[47:16];
                        stage0_image[10] <= M2[47:16];
                        stage0_image[11] <= M3[47:16];
                        stage0_image[12] <= M4[47:16];
                        stage0_image[13] <= M5[47:16];
                        stage0_image[14] <= M6[47:16];
                        stage0_image[15] <= M7[47:16];
                        //stage 0 finish

                        //stage 1 
                        stage1_real[0] <= stage0_real[0] + stage0_real[4];
                        stage1_real[1] <= stage0_real[1] + stage0_real[5];
                        stage1_real[2] <= stage0_real[2] + stage0_real[6];
                        stage1_real[3] <= stage0_real[3] + stage0_real[7];   
                        stage1_real[8] <= stage0_real[8] + stage0_real[12];
                        stage1_real[9] <= stage0_real[9] + stage0_real[13];
                        stage1_real[10] <= stage0_real[10] + stage0_real[14];
                        stage1_real[11] <= stage0_real[11] + stage0_real[15];

                        // stage 1 (a-c) * real
                        M0_mult1 <= stage0_real[0] - stage0_real[4];                                  
                        M1_mult1 <= stage0_real[1] - stage0_real[5];                     
                        M2_mult1 <= stage0_real[2] - stage0_real[6];                      
                        M3_mult1 <= stage0_real[3] - stage0_real[7];                        
                        M4_mult1 <= stage0_real[8] - stage0_real[12];                  
                        M5_mult1 <= stage0_real[9] - stage0_real[13];
                        M6_mult1 <= stage0_real[10] - stage0_real[14];
                        M7_mult1 <= stage0_real[11] - stage0_real[15];
                        M0_mult2 <= w0_real;
                        M1_mult2 <= w2_real;
                        M2_mult2 <= w4_real;
                        M3_mult2 <= w6_real;
                        M4_mult2 <= w0_real;
                        M5_mult2 <= w2_real;
                        M6_mult2 <= w4_real;
                        M7_mult2 <= w6_real;
                                                                                                                                                                                                                                                                                                          
                    end
                    4'd3: begin
                        input_fir[read_count] <= fir_d;
                        
                        stage1_real[4] <= M0[47:16];
                        stage1_real[5] <= M1[47:16];
                        stage1_real[6] <= M2[47:16];
                        stage1_real[7] <= M3[47:16];
                        stage1_real[12] <= M4[47:16];
                        stage1_real[13] <= M5[47:16];
                        stage1_real[14] <= M6[47:16];
                        stage1_real[15] <= M7[47:16];

                        stage1_image[0] <= stage0_image[0] + stage0_image[4];
                        stage1_image[1] <= stage0_image[1] + stage0_image[5];
                        stage1_image[2] <= stage0_image[2] + stage0_image[6];                
                        stage1_image[3] <= stage0_image[3] + stage0_image[7];
                        stage1_image[8] <= stage0_image[8] + stage0_image[12];                       
                        stage1_image[9] <= stage0_image[9] + stage0_image[13];                      
                        stage1_image[10] <= stage0_image[10] + stage0_image[14];
                        stage1_image[11] <= stage0_image[11] + stage0_image[15];

                        //stage 1 (a-c) * image
                        M0_mult2 <= w0_image;
                        M1_mult2 <= w2_image;
                        M2_mult2 <= w4_image;
                        M3_mult2 <= w6_image;
                        M4_mult2 <= w0_image;
                        M5_mult2 <= w2_image;
                        M6_mult2 <= w4_image;
                        M7_mult2 <= w6_image;

                    end
                    4'd4: begin
                        input_fir[read_count] <= fir_d;

                        stage1_image[4] <= M0[47:16];
                        stage1_image[5] <= M1[47:16];
                        stage1_image[6] <= M2[47:16];
                        stage1_image[7] <= M3[47:16];
                        stage1_image[12] <= M4[47:16];
                        stage1_image[13] <= M5[47:16];
                        stage1_image[14] <= M6[47:16];
                        stage1_image[15] <= M7[47:16];

                        //stage 1 (d-b) * image
                        M0_mult1 <= stage0_image[4] - stage0_image[0];    
                        M1_mult1 <= stage0_image[5] - stage0_image[1];    
                        M2_mult1 <= stage0_image[6] - stage0_image[2];    
                        M3_mult1 <= stage0_image[7] - stage0_image[3];    
                        M4_mult1 <= stage0_image[12] - stage0_image[8];   
                        M5_mult1 <= stage0_image[13] - stage0_image[9];
                        M6_mult1 <= stage0_image[14] - stage0_image[10];
                        M7_mult1 <= stage0_image[15] - stage0_image[11];
                   
                    end
                    4'd5: begin
                        input_fir[read_count] <= fir_d;

                        stage1_real[4] <=  stage1_real[4] + M0[47:16];
                        stage1_real[5] <=  stage1_real[5] + M1[47:16];
                        stage1_real[6] <=  stage1_real[6] + M2[47:16];
                        stage1_real[7] <=  stage1_real[7] + M3[47:16];
                        stage1_real[12] <= stage1_real[12] + M4[47:16];
                        stage1_real[13] <= stage1_real[13] + M5[47:16];
                        stage1_real[14] <= stage1_real[14] + M6[47:16];
                        stage1_real[15] <= stage1_real[15] + M7[47:16];

                        //stage 1 (d-b) * real
                        M0_mult2 <= w0_real;
                        M1_mult2 <= w2_real;
                        M2_mult2 <= w4_real;
                        M3_mult2 <= w6_real;
                        M4_mult2 <= w0_real;
                        M5_mult2 <= w2_real;
                        M6_mult2 <= w4_real;
                        M7_mult2 <= w6_real;
                    end
                    4'd6: begin
                        input_fir[read_count] <= fir_d;
                        
                        stage1_image[4] <= stage1_image[4] - M0[47:16];
                        stage1_image[5] <= stage1_image[5] - M1[47:16];
                        stage1_image[6] <= stage1_image[6] - M2[47:16];
                        stage1_image[7] <= stage1_image[7] - M3[47:16];
                        stage1_image[12] <= stage1_image[12] - M4[47:16];
                        stage1_image[13] <= stage1_image[13] - M5[47:16];
                        stage1_image[14] <= stage1_image[14] - M6[47:16];
                        stage1_image[15] <= stage1_image[15] - M7[47:16];
                        //stage1 finish

                        //stage2
                        stage2_real[0] <= stage1_real[0] + stage1_real[2];
                        stage2_real[1] <= stage1_real[1] + stage1_real[3];
                        stage2_real[4] <= stage1_real[4] + stage1_real[6];
                        stage2_real[5] <= stage1_real[5] + stage1_real[7];   
                        stage2_real[8] <= stage1_real[8] + stage1_real[10]; 
                        stage2_real[9] <= stage1_real[9] + stage1_real[11];
                        stage2_real[12] <= stage1_real[12] + stage1_real[14];
                        stage2_real[13] <= stage1_real[13] + stage1_real[15];

                        //stage2 (a-c) * real
                        M0_mult1 <= stage1_real[0] - stage1_real[2];                             
                        M1_mult1 <= stage1_real[1] - stage1_real[3];                
                        M2_mult1 <= stage1_real[4] - stage1_real[6];                 
                        M3_mult1 <= stage1_real[5] - stage1_real[7];                      
                        M4_mult1 <= stage1_real[8] - stage1_real[10];              
                        M5_mult1 <= stage1_real[9] - stage1_real[11];
                        M6_mult1 <= stage1_real[12] - stage1_real[14];
                        M7_mult1 <= stage1_real[13] - stage1_real[15];
                        M0_mult2 <= w0_real;
                        M1_mult2 <= w4_real;
                        M2_mult2 <= w0_real;
                        M3_mult2 <= w4_real;
                        M4_mult2 <= w0_real;
                        M5_mult2 <= w4_real;
                        M6_mult2 <= w0_real;
                        M7_mult2 <= w4_real;
                    end
                    4'd7: begin
                        input_fir[read_count] <= fir_d;

                        stage2_real[2] <= M0[47:16];
                        stage2_real[3] <= M1[47:16];
                        stage2_real[6] <= M2[47:16];
                        stage2_real[7] <= M3[47:16];
                        stage2_real[10] <= M4[47:16];
                        stage2_real[11] <= M5[47:16];
                        stage2_real[14] <= M6[47:16];
                        stage2_real[15] <= M7[47:16];

                        stage2_image[0] <= stage1_image[0] + stage1_image[2];
                        stage2_image[1] <= stage1_image[1] + stage1_image[3];
                        stage2_image[4] <= stage1_image[4] + stage1_image[6];
                        stage2_image[5] <= stage1_image[5] + stage1_image[7];   
                        stage2_image[8] <= stage1_image[8] + stage1_image[10]; 
                        stage2_image[9] <= stage1_image[9] + stage1_image[11];
                        stage2_image[12] <= stage1_image[12] + stage1_image[14];
                        stage2_image[13] <= stage1_image[13] + stage1_image[15];

                        //stage2 (a-c) * image
                        M0_mult2 <= w0_image;
                        M1_mult2 <= w4_image;
                        M2_mult2 <= w0_image;
                        M3_mult2 <= w4_image;
                        M4_mult2 <= w0_image;
                        M5_mult2 <= w4_image;
                        M6_mult2 <= w0_image;
                        M7_mult2 <= w4_image;
                    end
                    4'd8: begin
                        input_fir[read_count] <= fir_d;

                        stage2_image[2] <= M0[47:16];
                        stage2_image[3] <= M1[47:16];
                        stage2_image[6] <= M2[47:16];
                        stage2_image[7] <= M3[47:16];
                        stage2_image[10] <= M4[47:16];
                        stage2_image[11] <= M5[47:16];
                        stage2_image[14] <= M6[47:16];
                        stage2_image[15] <= M7[47:16];

                        //stage2 (d-b) * image
                        M0_mult1 <= stage1_image[2] - stage1_image[0];                             
                        M1_mult1 <= stage1_image[3] - stage1_image[1];                
                        M2_mult1 <= stage1_image[6] - stage1_image[4];                 
                        M3_mult1 <= stage1_image[7] - stage1_image[5];                      
                        M4_mult1 <= stage1_image[10] - stage1_image[8];              
                        M5_mult1 <= stage1_image[11] - stage1_image[9];
                        M6_mult1 <= stage1_image[14] - stage1_image[12];
                        M7_mult1 <= stage1_image[15] - stage1_image[13];
                    end
                    4'd9: begin
                        input_fir[read_count] <= fir_d;

                        stage2_real[2] <= stage2_real[2] + M0[47:16];
                        stage2_real[3] <= stage2_real[3] + M1[47:16];
                        stage2_real[6] <= stage2_real[6] + M2[47:16];
                        stage2_real[7] <= stage2_real[7] + M3[47:16];
                        stage2_real[10] <= stage2_real[10] + M4[47:16];
                        stage2_real[11] <= stage2_real[11] + M5[47:16];
                        stage2_real[14] <= stage2_real[14] + M6[47:16];
                        stage2_real[15] <= stage2_real[15] + M7[47:16];

                        //stage2 (d-b) * real
                        M0_mult2 <= w0_real;
                        M1_mult2 <= w4_real;
                        M2_mult2 <= w0_real;
                        M3_mult2 <= w4_real;
                        M4_mult2 <= w0_real;
                        M5_mult2 <= w4_real;
                        M6_mult2 <= w0_real;
                        M7_mult2 <= w4_real;
                    end
                    4'd10: begin
                        input_fir[read_count] <= fir_d;

                        stage2_image[2] <= stage2_image[2] - M0[47:16];
                        stage2_image[3] <= stage2_image[3] - M1[47:16];
                        stage2_image[6] <= stage2_image[6] - M2[47:16];
                        stage2_image[7] <= stage2_image[7] - M3[47:16];
                        stage2_image[10] <= stage2_image[10] - M4[47:16];
                        stage2_image[11] <= stage2_image[11] - M5[47:16];
                        stage2_image[14] <= stage2_image[14] - M6[47:16];
                        stage2_image[15] <= stage2_image[15] - M7[47:16];
                        //stage2 finish

                        //stage3
                        stage3_real[0] <= stage2_real[0] + stage2_real[1];
                        stage3_real[2] <= stage2_real[2] + stage2_real[3];
                        stage3_real[4] <= stage2_real[4] + stage2_real[5];
                        stage3_real[6] <= stage2_real[6] + stage2_real[7];   
                        stage3_real[8] <= stage2_real[8] + stage2_real[9]; 
                        stage3_real[10] <= stage2_real[10] + stage2_real[11];
                        stage3_real[12] <= stage2_real[12] + stage2_real[13];
                        stage3_real[14] <= stage2_real[14] + stage2_real[15];

                        //stage3 (a-c) * real
                        M0_mult1 <= stage2_real[0] - stage2_real[1];                             
                        M1_mult1 <= stage2_real[2] - stage2_real[3];                
                        M2_mult1 <= stage2_real[4] - stage2_real[5];                 
                        M3_mult1 <= stage2_real[6] - stage2_real[7];                      
                        M4_mult1 <= stage2_real[8] - stage2_real[9];              
                        M5_mult1 <= stage2_real[10] - stage2_real[11];
                        M6_mult1 <= stage2_real[12] - stage2_real[13];
                        M7_mult1 <= stage2_real[14] - stage2_real[15];
                        M0_mult2 <= w0_real;
                        M1_mult2 <= w0_real;
                        M2_mult2 <= w0_real;
                        M3_mult2 <= w0_real;
                        M4_mult2 <= w0_real;
                        M5_mult2 <= w0_real;
                        M6_mult2 <= w0_real;
                        M7_mult2 <= w0_real;
                    end
                    4'd11: begin
                        input_fir[read_count] <= fir_d;

                        stage3_real[1] <= M0[47:16];
                        stage3_real[3] <= M1[47:16];
                        stage3_real[5] <= M2[47:16];
                        stage3_real[7] <= M3[47:16];
                        stage3_real[9] <= M4[47:16];
                        stage3_real[11] <= M5[47:16];
                        stage3_real[13] <= M6[47:16];
                        stage3_real[15] <= M7[47:16];

                        stage3_image[0] <= stage2_image[0] + stage2_image[1];
                        stage3_image[2] <= stage2_image[2] + stage2_image[3];
                        stage3_image[4] <= stage2_image[4] + stage2_image[5];
                        stage3_image[6] <= stage2_image[6] + stage2_image[7];  
                        stage3_image[8] <= stage2_image[8] + stage2_image[9]; 
                        stage3_image[10] <= stage2_image[10]+ stage2_image[11];
                        stage3_image[12] <= stage2_image[12] + stage2_image[13];
                        stage3_image[14] <= stage2_image[14] + stage2_image[15];

                        //stage3 (a-c) * image
                        M0_mult2 <= w0_image;
                        M1_mult2 <= w0_image;
                        M2_mult2 <= w0_image;
                        M3_mult2 <= w0_image;
                        M4_mult2 <= w0_image;
                        M5_mult2 <= w0_image;
                        M6_mult2 <= w0_image;
                        M7_mult2 <= w0_image;
                    end
                    4'd12: begin
                        input_fir[read_count] <= fir_d;

                        stage3_image[1] <= M0[47:16];
                        stage3_image[3] <= M1[47:16];
                        stage3_image[5] <= M2[47:16];
                        stage3_image[7] <= M3[47:16];
                        stage3_image[9] <= M4[47:16];
                        stage3_image[11] <= M5[47:16];
                        stage3_image[13] <= M6[47:16];
                        stage3_image[15] <= M7[47:16];
                        
                        //stage3 (d-b) * image
                        M0_mult1 <= stage1_image[1] - stage1_image[0];                             
                        M1_mult1 <= stage1_image[3] - stage1_image[2];                
                        M2_mult1 <= stage1_image[5] - stage1_image[4];                 
                        M3_mult1 <= stage1_image[7] - stage1_image[6];                      
                        M4_mult1 <= stage1_image[9] - stage1_image[8];              
                        M5_mult1 <= stage1_image[11] - stage1_image[10];
                        M6_mult1 <= stage1_image[13] - stage1_image[12];
                        M7_mult1 <= stage1_image[15] - stage1_image[14];
                    end
                    4'd13: begin
                        input_fir[read_count] <= fir_d;

                        stage3_image[1] <= M0[47:16];
                        stage3_image[3] <= M1[47:16];
                        stage3_image[5] <= M2[47:16];
                        stage3_image[7] <= M3[47:16];
                        stage3_image[9] <= M4[47:16];
                        stage3_image[11] <= M5[47:16];
                        stage3_image[13] <= M6[47:16];
                        stage3_image[15] <= M7[47:16];

                        //stage2 (d-b) * image
                        M0_mult1 <= stage2_image[1] - stage2_image[0];                             
                        M1_mult1 <= stage2_image[3] - stage2_image[2];                
                        M2_mult1 <= stage2_image[5] - stage2_image[4];                 
                        M3_mult1 <= stage2_image[7] - stage2_image[6];                      
                        M4_mult1 <= stage2_image[9] - stage2_image[8];              
                        M5_mult1 <= stage2_image[11] - stage2_image[10];
                        M6_mult1 <= stage2_image[13] - stage2_image[12];
                        M7_mult1 <= stage2_image[15] - stage2_image[14];
                    end
                    4'd14: begin
                        input_fir[read_count] <= fir_d;

                        stage3_real[1] <= stage3_real[1] + M0[47:16];
                        stage3_real[3] <= stage3_real[3] + M1[47:16];
                        stage3_real[5] <= stage3_real[5] + M2[47:16];
                        stage3_real[7] <= stage3_real[7] + M3[47:16];
                        stage3_real[9] <= stage3_real[9] + M4[47:16];
                        stage3_real[11] <= stage3_real[11] + M5[47:16];
                        stage3_real[13] <= stage3_real[13] + M6[47:16];
                        stage3_real[15] <= stage3_real[15] + M7[47:16];

                        //stage3 (d-b) * real
                        M0_mult2 <= w0_real;
                        M1_mult2 <= w0_real;
                        M2_mult2 <= w0_real;
                        M3_mult2 <= w0_real;
                        M4_mult2 <= w0_real;
                        M5_mult2 <= w0_real;
                        M6_mult2 <= w0_real;
                        M7_mult2 <= w0_real;
                        
                    end
                    4'd15: begin
                        input_fir[read_count] <= fir_d;

                        stage3_image[1] <= stage3_image[1] - M0[47:16];
                        stage3_image[3] <= stage3_image[3] - M1[47:16];
                        stage3_image[5] <= stage3_image[5] - M2[47:16];
                        stage3_image[7] <= stage3_image[7] - M3[47:16];
                        stage3_image[9] <= stage3_image[9] - M4[47:16];
                        stage3_image[11] <= stage3_image[11] - M5[47:16];
                        stage3_image[13] <= stage3_image[13] - M6[47:16];
                        stage3_image[15] <= stage3_image[15] - M7[47:16];
                        //stage 3 finish

                        
                    end
                    default: begin
                        input_fir[read_count] <= fir_d;
                    end
                endcase
                read_count <= read_count + 4'd1;
            end
            FINAL_TRANS: begin
                case(read_count)
                    4'd0: begin
                        //trans
                        fft_valid <= 1'b1;
                        fft_d0  <= stage3_real[0][23:8];
                        fft_d1  <= stage3_real[8][23:8];
                        fft_d2  <= stage3_real[4][23:8];
                        fft_d3  <= stage3_real[12][23:8];
                        fft_d4  <= stage3_real[2][23:8];
                        fft_d5  <= stage3_real[10][23:8];
                        fft_d6  <= stage3_real[6][23:8];
                        fft_d7  <= stage3_real[14][23:8];
                        fft_d8  <= stage3_real[1][23:8];
                        fft_d9  <= stage3_real[9][23:8];
                        fft_d10 <= stage3_real[5][23:8];
                        fft_d11 <= stage3_real[13][23:8];
                        fft_d12 <= stage3_real[3][23:8];
                        fft_d13 <= stage3_real[11][23:8];
                        fft_d14 <= stage3_real[7][23:8];
                        fft_d15 <= stage3_real[15][23:8];
                    end
                    4'd1: begin
                        fft_d0 <= stage3_image[0][23:8];
                        fft_d1 <= stage3_image[8][23:8];
                        fft_d2 <= stage3_image[4][23:8];
                        fft_d3 <= stage3_image[12][23:8];
                        fft_d4 <= stage3_image[2][23:8];
                        fft_d5 <= stage3_image[10][23:8];
                        fft_d6 <= stage3_image[6][23:8];
                        fft_d7 <= stage3_image[14][23:8];
                        fft_d8 <= stage3_image[1][23:8];
                        fft_d9 <= stage3_image[9][23:8];
                        fft_d10 <= stage3_image[5][23:8];
                        fft_d11 <= stage3_image[13][23:8];
                        fft_d12 <= stage3_image[3][23:8];
                        fft_d13 <= stage3_image[11][23:8];
                        fft_d14 <= stage3_image[7][23:8];
                        fft_d15 <= stage3_image[15][23:8];
                    end
                    4'd2: begin
                        fft_valid <= 0;
                    end
                endcase
                read_count <= read_count + 4'd1;
            end
        endcase
    end

endmodule