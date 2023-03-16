`default_nettype none

module yannickreiss_switch_diamond(
  input [0:7] io_in,
  output [0:7] io_out
);
  wire [0:7] I;
  wire [0:7] O;

  assign I = io_in[1:6] & "0";
  assign O = io_out;

  // signal control
  wire snw;
  wire ssw;
  wire sne;
  wire sse;

  assign snw = (!(I[4] | I[5]) & (I[0] & !I[2])) | ((I[4] & I[5]) & (I[0] & !I[3] & (I[2] ^ I[1]))) | ( (I[4] & !I[5]) & ( I[0] & (I[1] ^ I[2]) & (I[2] ^ I[3]) ) );
  assign ssw = (!(I[4] | I[5]) & (I[1] & !I[3])) | ((I[4] & I[5]) & (I[1] & !I[2] & (I[0] ^ I[3]))) | ( (I[4] & !I[5]) & ( I[1] & !I[3] ) )                        ;
  assign sne = (!(I[4] | I[5]) & (I[2] & !I[0])) | ((I[4] & I[5]) & (I[2] & !I[1] & (I[0] ^ I[3]))) | ( (I[4] & !I[5]) & ( I[2] & !I[0] ) )                        ;
  assign sse = (!(I[4] | I[5]) & (I[3] & !I[1])) | ((I[4] & I[5]) & (I[3] & !I[0] & (I[2] ^ I[1]))) | ( (I[4] & !I[5]) & ( I[3] & (I[1] ^ I[2]) & (I[2] ^ I[3]) ) );

  // switch control
  wire pw;
  wire pe;
  wire set_switch;

  // Modes
  //  keep tracks can be ignored, as switches are straight by default
  wire bind_track;
  wire as; // avoid stop
  wire co; // crossover 

  // Variables
  wire w1;
  wire w2;

  // western and eastern parity
  assign pw = I[0] ^ I[1];
  assign pe = I[2] ^ I[3];

  // calculate bind and avoid stop conditions
  assign w1 = !(pw | pe) & (I[0] | I[1]);
  assign w2 = !(pw | pe) & ((I[1] & !I[2]) | (I[2] & I[6]) | (I[0] & I[7]) | (I[3] | !I[6]));

  // signals per mode
  assign co = I[4] & I[5];
  assign as = I[4] & w1;
  assign bind_track = I[5] & w2;

  // finally set switch
  assign set_switch = co | as | bind_track;

  // set output
  assign O[0:3] = {snw, ssw, sne, sse};
  assign O[4:7] = {set_switch, set_switch, set_switch, set_switch};
endmodule
