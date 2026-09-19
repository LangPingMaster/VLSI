module binarization (clk,
    pix_out,
    rst_n,
    pix_in,
    threshold);
 input clk;
 output pix_out;
 input rst_n;
 input [7:0] pix_in;
 input [7:0] threshold;

 wire _00_;
 wire _01_;
 wire _02_;
 wire _03_;
 wire _04_;
 wire _05_;
 wire _06_;
 wire _07_;
 wire _08_;
 wire _09_;
 wire _10_;
 wire _11_;
 wire _12_;
 wire _13_;
 wire _14_;
 wire _15_;
 wire _16_;
 wire _17_;
 wire _18_;
 wire _19_;
 wire _20_;
 wire _21_;
 wire _22_;
 wire _23_;
 wire _24_;
 wire _25_;
 wire _26_;
 wire _27_;
 wire _28_;
 wire _29_;
 wire _30_;
 wire _31_;
 wire _32_;
 wire _33_;
 wire _34_;
 wire _35_;

 INV_X1 _36_ (.A(pix_in[0]),
    .ZN(_04_));
 INV_X1 _37_ (.A(threshold[2]),
    .ZN(_22_));
 INV_X1 _38_ (.A(threshold[7]),
    .ZN(_13_));
 INV_X1 _39_ (.A(threshold[1]),
    .ZN(_10_));
 INV_X1 _40_ (.A(threshold[6]),
    .ZN(_07_));
 INV_X1 _41_ (.A(threshold[5]),
    .ZN(_01_));
 INV_X1 _42_ (.A(threshold[4]),
    .ZN(_16_));
 INV_X1 _43_ (.A(threshold[3]),
    .ZN(_19_));
 AOI21_X1 _44_ (.A(_14_),
    .B1(_15_),
    .B2(_08_),
    .ZN(_25_));
 AND2_X1 _45_ (.A1(_24_),
    .A2(_11_),
    .ZN(_26_));
 NAND2_X1 _46_ (.A1(_24_),
    .A2(_12_),
    .ZN(_27_));
 INV_X1 _47_ (.A(_06_),
    .ZN(_28_));
 AOI21_X1 _48_ (.A(_27_),
    .B1(_28_),
    .B2(_05_),
    .ZN(_29_));
 NOR4_X2 _49_ (.A1(_23_),
    .A2(_20_),
    .A3(_26_),
    .A4(_29_),
    .ZN(_30_));
 AND4_X2 _50_ (.A1(_15_),
    .A2(_03_),
    .A3(_18_),
    .A4(_09_),
    .ZN(_31_));
 OAI21_X1 _51_ (.A(_31_),
    .B1(_20_),
    .B2(_21_),
    .ZN(_32_));
 NAND2_X1 _52_ (.A1(_15_),
    .A2(_09_),
    .ZN(_33_));
 AOI21_X1 _53_ (.A(_02_),
    .B1(_03_),
    .B2(_17_),
    .ZN(_34_));
 OAI221_X1 _54_ (.A(_25_),
    .B1(_30_),
    .B2(_32_),
    .C1(_33_),
    .C2(_34_),
    .ZN(_00_));
 HA_X1 _55_ (.A(pix_in[5]),
    .B(_01_),
    .CO(_02_),
    .S(_03_));
 HA_X1 _56_ (.A(_04_),
    .B(threshold[0]),
    .CO(_05_),
    .S(_06_));
 HA_X1 _57_ (.A(pix_in[6]),
    .B(_07_),
    .CO(_08_),
    .S(_09_));
 HA_X1 _58_ (.A(pix_in[1]),
    .B(_10_),
    .CO(_11_),
    .S(_12_));
 HA_X1 _59_ (.A(pix_in[7]),
    .B(_13_),
    .CO(_14_),
    .S(_15_));
 HA_X1 _60_ (.A(pix_in[4]),
    .B(_16_),
    .CO(_17_),
    .S(_18_));
 HA_X1 _61_ (.A(pix_in[3]),
    .B(_19_),
    .CO(_20_),
    .S(_21_));
 HA_X1 _62_ (.A(pix_in[2]),
    .B(_22_),
    .CO(_23_),
    .S(_24_));
 DFFR_X1 \pix_out$_DFF_PN0_  (.D(_00_),
    .RN(rst_n),
    .CK(clk),
    .Q(pix_out),
    .QN(_35_));
endmodule
