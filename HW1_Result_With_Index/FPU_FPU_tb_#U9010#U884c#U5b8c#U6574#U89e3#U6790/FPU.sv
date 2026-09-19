module FPU(
    input  logic        clk,
    input  logic        rst,
    input  logic        enable,
    input  logic [1:0]  instruction,
    input  logic [31:0] ai,
    input  logic [31:0] bi,
    output logic [31:0] co,
    output logic        valid
);

function automatic [31:0] fp_minmax;
    input [31:0] a, b;
    input is_max;
    reg a_nan,b_nan;
    begin
        a_nan = (&a[30:23]) && (|a[22:0]);
        b_nan = (&b[30:23]) && (|b[22:0]);
        if (a_nan || b_nan) fp_minmax = 32'hFFC00000;
        else if ((a[30:0]==0) && (b[30:0]==0)) begin
            if (is_max) fp_minmax = (a[31] & b[31]) ? 32'h80000000 : 32'h00000000;
            else        fp_minmax = (a[31] | b[31]) ? 32'h80000000 : 32'h00000000;
        end else if (a == b) fp_minmax = a;
        else if (a[31] != b[31]) begin
            if (is_max) fp_minmax = a[31] ? b : a;
            else        fp_minmax = a[31] ? a : b;
        end else if (!a[31]) begin
            if (is_max) fp_minmax = (a[30:0] > b[30:0]) ? a : b;
            else        fp_minmax = (a[30:0] < b[30:0]) ? a : b;
        end else begin
            if (is_max) fp_minmax = (a[30:0] < b[30:0]) ? a : b;
            else        fp_minmax = (a[30:0] > b[30:0]) ? a : b;
        end
    end
endfunction

function automatic [31:0] fp_addsub;
    input [31:0] a_in, b_in;
    input sub;
    reg [31:0] a,b;
    reg sa,sb,sr;
    reg [7:0] ea,eb;
    reg [22:0] fa,fb;
    reg a_nan,b_nan,a_inf,b_inf,a_zero,b_zero;
    integer exa,exb,er,diff,k;
    reg [26:0] ma,mb;
    reg [27:0] sum;
    reg [26:0] mr;
    reg sticky;
    reg guardb,roundb,stickyb,lsb,round_up;
    reg [24:0] rounded;
    begin
        a = a_in;
        b = b_in;
        b[31] = b_in[31] ^ sub;
        sa=a[31]; sb=b[31]; ea=a[30:23]; eb=b[30:23]; fa=a[22:0]; fb=b[22:0];
        a_nan=(&ea)&&(|fa); b_nan=(&eb)&&(|fb);
        a_inf=(&ea)&&(~|fa); b_inf=(&eb)&&(~|fb);
        a_zero=(a[30:0]==0); b_zero=(b[30:0]==0);

        if (a_nan || b_nan) fp_addsub=32'hFFC00000;
        else if (a_inf && b_inf && (sa!=sb)) fp_addsub=32'hFFC00000;
        else if (a_inf) fp_addsub={sa,8'hff,23'b0};
        else if (b_inf) fp_addsub={sb,8'hff,23'b0};
        else if (a_zero && b_zero) fp_addsub={(sa & sb),31'b0};
        else if (a_zero) fp_addsub=b;
        else if (b_zero) fp_addsub=a;
        else begin
            exa = (ea==0) ? 1 : ea;
            exb = (eb==0) ? 1 : eb;
            ma = {(ea!=0),fa,3'b000};
            mb = {(eb!=0),fb,3'b000};
            er = exa;
            if (exa > exb) begin
                diff=exa-exb; er=exa;
                if (diff >= 27) mb = (mb!=0);
                else begin
                    sticky=0;
                    for(k=0;k<27;k=k+1) if(k<diff) sticky=sticky|mb[k];
                    mb=mb>>diff; mb[0]=mb[0]|sticky;
                end
            end else if (exb > exa) begin
                diff=exb-exa; er=exb;
                if (diff >= 27) ma = (ma!=0);
                else begin
                    sticky=0;
                    for(k=0;k<27;k=k+1) if(k<diff) sticky=sticky|ma[k];
                    ma=ma>>diff; ma[0]=ma[0]|sticky;
                end
            end

            if (sa==sb) begin
                sum={1'b0,ma}+{1'b0,mb}; sr=sa;
                if(sum[27]) begin
                    sticky=sum[0];
                    mr=sum[27:1]; mr[0]=mr[0]|sticky; er=er+1;
                end else mr=sum[26:0];
            end else begin
                if(ma>mb) begin mr=ma-mb; sr=sa; end
                else if(mb>ma) begin mr=mb-ma; sr=sb; end
                else begin mr=0; sr=0; end
                while((mr[26]==0) && (mr!=0) && (er>1)) begin mr=mr<<1; er=er-1; end
            end

            if(mr==0) fp_addsub=32'h00000000;
            else if(er>=255) fp_addsub={sr,8'hff,23'b0};
            else begin
                // If exponent is at the minimum, hidden bit may be zero (subnormal).
                guardb=mr[2]; roundb=mr[1]; stickyb=mr[0]; lsb=mr[3];
                round_up=guardb && (roundb || stickyb || lsb);
                rounded={1'b0,mr[26:3]} + round_up;
                if(rounded[24]) begin rounded=rounded>>1; er=er+1; end
                if(er>=255) fp_addsub={sr,8'hff,23'b0};
                else if((er==1) && (rounded[23]==0)) fp_addsub={sr,8'h00,rounded[22:0]};
                else fp_addsub={sr,er[7:0],rounded[22:0]};
            end
        end
    end
endfunction

reg [31:0] next_result;
always @* begin
    case(instruction)
        2'd0: next_result = fp_minmax(ai,bi,1'b0);
        2'd1: next_result = fp_minmax(ai,bi,1'b1);
        2'd2: next_result = fp_addsub(ai,bi,1'b0);
        2'd3: next_result = fp_addsub(ai,bi,1'b1);
        default: next_result = 32'b0;
    endcase
end

always @(posedge clk) begin
    if (rst) begin co<=0; valid<=0; end
    else begin
        valid <= enable;
        if(enable) co <= next_result;
    end
end
endmodule
