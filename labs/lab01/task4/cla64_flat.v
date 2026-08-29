module cla64_flat(
    input  [63:0] a,
    input  [63:0] b,
    input         cin,
    output [63:0] sum,
    output        cout
);

    wire [63:0] p;
    wire [63:0] g;
    wire [64:0] c;

    assign c[0] = cin;


    genvar i;

    generate
        for (i = 0; i < 64; i = i + 1) begin : gen_pg
            xor #(2) (p[i], a[i], b[i]);
            and #(2) (g[i], a[i], b[i]);
        end
    endgenerate

    assign c[1] = g[0] | (p[0] & c[0]);

    genvar j;

    generate
        for (j = 1; j < 64; j = j + 1) begin : gen_carry
            assign c[j+1] = g[j] | (p[j] & c[j]);
        end
    endgenerate

    generate
        for (i = 0; i < 64; i = i + 1) begin : gen_sum
            xor #(2) (sum[i], p[i], c[i]);
        end
    endgenerate

    assign cout = c[64];

endmodule