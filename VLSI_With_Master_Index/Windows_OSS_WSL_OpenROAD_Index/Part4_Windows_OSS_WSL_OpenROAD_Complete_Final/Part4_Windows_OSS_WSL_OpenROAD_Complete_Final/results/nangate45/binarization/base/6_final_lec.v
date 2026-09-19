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
 wire net1;
 wire net2;
 wire net3;
 wire net4;
 wire net5;
 wire net6;
 wire net7;
 wire net8;
 wire net18;
 wire net9;
 wire net10;
 wire net11;
 wire net12;
 wire net13;
 wire net14;
 wire net15;
 wire net16;
 wire net17;

 INV_X1 _36_ (.A(net1),
    .ZN(_04_));
 INV_X1 _37_ (.A(net12),
    .ZN(_22_));
 INV_X1 _38_ (.A(net17),
    .ZN(_13_));
 INV_X1 _39_ (.A(net11),
    .ZN(_10_));
 INV_X1 _40_ (.A(net16),
    .ZN(_07_));
 INV_X1 _41_ (.A(net15),
    .ZN(_01_));
 INV_X1 _42_ (.A(net14),
    .ZN(_16_));
 INV_X1 _43_ (.A(net13),
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
 HA_X1 _55_ (.A(net6),
    .B(_01_),
    .CO(_02_),
    .S(_03_));
 HA_X1 _56_ (.A(_04_),
    .B(net10),
    .CO(_05_),
    .S(_06_));
 HA_X1 _57_ (.A(net7),
    .B(_07_),
    .CO(_08_),
    .S(_09_));
 HA_X1 _58_ (.A(net2),
    .B(_10_),
    .CO(_11_),
    .S(_12_));
 HA_X1 _59_ (.A(net8),
    .B(_13_),
    .CO(_14_),
    .S(_15_));
 HA_X1 _60_ (.A(net5),
    .B(_16_),
    .CO(_17_),
    .S(_18_));
 HA_X1 _61_ (.A(net4),
    .B(_19_),
    .CO(_20_),
    .S(_21_));
 HA_X1 _62_ (.A(net3),
    .B(_22_),
    .CO(_23_),
    .S(_24_));
 BUF_X1 input1 (.A(pix_in[0]),
    .Z(net1));
 BUF_X1 input10 (.A(threshold[0]),
    .Z(net10));
 BUF_X1 input11 (.A(threshold[1]),
    .Z(net11));
 BUF_X1 input12 (.A(threshold[2]),
    .Z(net12));
 BUF_X1 input13 (.A(threshold[3]),
    .Z(net13));
 BUF_X1 input14 (.A(threshold[4]),
    .Z(net14));
 BUF_X1 input15 (.A(threshold[5]),
    .Z(net15));
 BUF_X1 input16 (.A(threshold[6]),
    .Z(net16));
 BUF_X1 input17 (.A(threshold[7]),
    .Z(net17));
 BUF_X1 input2 (.A(pix_in[1]),
    .Z(net2));
 BUF_X1 input3 (.A(pix_in[2]),
    .Z(net3));
 BUF_X1 input4 (.A(pix_in[3]),
    .Z(net4));
 BUF_X1 input5 (.A(pix_in[4]),
    .Z(net5));
 BUF_X1 input6 (.A(pix_in[5]),
    .Z(net6));
 BUF_X1 input7 (.A(pix_in[6]),
    .Z(net7));
 BUF_X1 input8 (.A(pix_in[7]),
    .Z(net8));
 BUF_X1 input9 (.A(rst_n),
    .Z(net9));
 BUF_X1 output18 (.A(net18),
    .Z(pix_out));
 DFFR_X1 \pix_out$_DFF_PN0_  (.D(_00_),
    .RN(net9),
    .CK(clk),
    .Q(net18),
    .QN(_35_));
endmodule
