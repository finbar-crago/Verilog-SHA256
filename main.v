module top(input CLK, output LED0, LED1, LED2, LED3, LED4);

   reg  [0:511] data = 512'h61626380;
   wire [0:255] hash;

   sha256 _sha256(.clk(CLK), .reset(1'b1), .in(data), .out(hash));

   assign LED0 = 1;
   assign LED1 = hash[0];
   assign LED2 = hash[1];
   assign LED3 = hash[2];
   assign LED4 = hash[3];
endmodule


module sha256(input clk, reset, input wire [0:511] in, output wire [0:255] out);
   genvar i;

   wire [0:31] h [0:7];  
   wire [0:31] k [0:63];  
   wire [0:31] w [0:63];
   wire [0:31] r [0:63][0:7];

   generate
      for(i = 0; i < 16; i = i+1)
	assign w[i] = in[ (i*32) +: 32 ];

      for(i = 16; i < 64; i = i+1)
	assign w[i] =  w[i-16] + w[i-7] +
		       (({w[i-15], w[i-15]} >> 7 ) ^
			({w[i-15],w[i-15]} >> 18) ^
			({w[i-15],w[i-15]} >> 3 )) +
		       (({w[i-2],w[i-2]} >> 17) ^
			({w[i-2],w[i-2]} >> 19) ^
			({w[i-2],w[i-2]} >> 10));

      for(i = 0; i < 8; i = i+1)
	assign r[0][i] = h[i];

      for(i = 1; i < 64; i = i+1)
	begin
	   /* a */ assign r[i][0] = r[i-1][7] + k[i] + w[i] +
				    (({r[i-1][4],r[i-1][4]} >> 6) ^
				     ({r[i-1][4],r[i-1][4]} >> 11)^
				     ({r[i-1][4],r[i-1][4]} >> 25))+
				    (r[i-1][4] & r[i-1][5]) ^ ((~r[i-1][4]) & r[i-1][6]) +

				    ({r[i-1][0],r[i-1][0]} >> 2) ^
				    ({r[i-1][0],r[i-1][0]} >> 13)^
				    ({r[i-1][0],r[i-1][0]} >> 22)+

				    (r[i-1][0] & r[i-1][1]) ^
				    (r[i-1][0] & r[i-1][2]) ^
				    (r[i-1][1] & r[i-1][2]);

	   /* b */ assign r[i][1] = r[i-1][0];
	   /* c */ assign r[i][2] = r[i-1][1];
	   /* d */ assign r[i][3] = r[i-1][2];

	   /* e */ assign r[i][4] = r[i-1][3] + r[i-1][7] + k[i] + w[i] + 
				    (({r[i-1][4],r[i-1][4]} >> 6) ^
				     ({r[i-1][4],r[i-1][4]} >> 11)^
				     ({r[i-1][4],r[i-1][4]} >> 25))+
				    (r[i-1][4] & r[i-1][5]) ^ ((~r[i-1][4]) & r[i-1][6]);

	   /* f */ assign r[i][5] = r[i-1][4];
	   /* g */ assign r[i][6] = r[i-1][5];
	   /* h */ assign r[i][7] = r[i-1][6];
	end

      for(i = 0; i < 8; i = i+1)
	assign out[ (i*32) +: 32 ] = h[i] + r[63][0];

   endgenerate
  

   assign h[0] = 32'h6a09e667;
   assign h[1] = 32'hbb67ae85;
   assign h[2] = 32'h3c6ef372;
   assign h[3] = 32'ha54ff53a;
   assign h[4] = 32'h510e527f;
   assign h[5] = 32'h9b05688c;
   assign h[6] = 32'h1f83d9ab;
   assign h[7] = 32'h5be0cd19;


   assign k[ 0] = 32'h428a2f98;
   assign k[ 1] = 32'h71374491;
   assign k[ 2] = 32'hb5c0fbcf;
   assign k[ 3] = 32'he9b5dba5;
   assign k[ 4] = 32'h3956c25b;
   assign k[ 5] = 32'h59f111f1;
   assign k[ 6] = 32'h923f82a4;
   assign k[ 7] = 32'hab1c5ed5;
   assign k[ 8] = 32'hd807aa98;
   assign k[ 9] = 32'h12835b01;
   assign k[10] = 32'h243185be;
   assign k[11] = 32'h550c7dc3;
   assign k[12] = 32'h72be5d74;
   assign k[13] = 32'h80deb1fe;
   assign k[14] = 32'h9bdc06a7;
   assign k[15] = 32'hc19bf174;
   assign k[16] = 32'he49b69c1;
   assign k[17] = 32'hefbe4786;
   assign k[18] = 32'h0fc19dc6;
   assign k[19] = 32'h240ca1cc;
   assign k[20] = 32'h2de92c6f;
   assign k[21] = 32'h4a7484aa;
   assign k[22] = 32'h5cb0a9dc;
   assign k[23] = 32'h76f988da;
   assign k[24] = 32'h983e5152;
   assign k[25] = 32'ha831c66d;
   assign k[26] = 32'hb00327c8;
   assign k[27] = 32'hbf597fc7;
   assign k[28] = 32'hc6e00bf3;
   assign k[29] = 32'hd5a79147;
   assign k[30] = 32'h06ca6351;
   assign k[31] = 32'h14292967;
   assign k[32] = 32'h27b70a85;
   assign k[33] = 32'h2e1b2138;
   assign k[34] = 32'h4d2c6dfc;
   assign k[35] = 32'h53380d13;
   assign k[36] = 32'h650a7354;
   assign k[37] = 32'h766a0abb;
   assign k[38] = 32'h81c2c92e;
   assign k[39] = 32'h92722c85;
   assign k[40] = 32'ha2bfe8a1;
   assign k[41] = 32'ha81a664b;
   assign k[42] = 32'hc24b8b70;
   assign k[43] = 32'hc76c51a3;
   assign k[44] = 32'hd192e819;
   assign k[45] = 32'hd6990624;
   assign k[46] = 32'hf40e3585;
   assign k[47] = 32'h106aa070;
   assign k[48] = 32'h19a4c116;
   assign k[49] = 32'h1e376c08;
   assign k[50] = 32'h2748774c;
   assign k[51] = 32'h34b0bcb5;
   assign k[52] = 32'h391c0cb3;
   assign k[53] = 32'h4ed8aa4a;
   assign k[54] = 32'h5b9cca4f;
   assign k[55] = 32'h682e6ff3;
   assign k[56] = 32'h748f82ee;
   assign k[57] = 32'h78a5636f;
   assign k[58] = 32'h84c87814;
   assign k[59] = 32'h8cc70208;
   assign k[60] = 32'h90befffa;
   assign k[61] = 32'ha4506ceb;
   assign k[62] = 32'hbef9a3f7;
   assign k[63] = 32'hc67178f2;

endmodule