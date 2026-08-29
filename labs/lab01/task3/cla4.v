// cla4.v
// Gate-level 4-bit carry-lookahead adder

module cla4(
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout
);

    wire p0, p1, p2, p3;
    wire g0, g1, g2, g3;
    wire c1, c2, c3, c4;

    // ------------------------------------------------
    // Propagate signals
    // p[i] = a[i] ^ b[i]
    // ------------------------------------------------

    xor #(2) P0 (p0, a[0], b[0]);
    xor #(2) P1 (p1, a[1], b[1]);
    xor #(2) P2 (p2, a[2], b[2]);
    xor #(2) P3 (p3, a[3], b[3]);

    // ------------------------------------------------
    // Generate signals
    // g[i] = a[i] & b[i]
    // ------------------------------------------------

    and #(2) G0 (g0, a[0], b[0]);
    and #(2) G1 (g1, a[1], b[1]);
    and #(2) G2 (g2, a[2], b[2]);
    and #(2) G3 (g3, a[3], b[3]);

    // ------------------------------------------------
    // Carry-lookahead equations
    // ------------------------------------------------

    or #(2) C1 (
        c1,
        g0,
        p0 & cin
    );

    or #(2) C2 (
        c2,
        g1,
        p1 & g0,
        p1 & p0 & cin
    );

    or #(2) C3 (
        c3,
        g2,
        p2 & g1,
        p2 & p1 & g0,
        p2 & p1 & p0 & cin
    );

    or #(2) C4 (
        c4,
        g3,
        p3 & g2,
        p3 & p2 & g1,
        p3 & p2 & p1 & g0,
        p3 & p2 & p1 & p0 & cin
    );

    // ------------------------------------------------
    // Sum bits
    // c0 = cin
    // ------------------------------------------------

    xor #(2) S0 (sum[0], p0, cin);
    xor #(2) S1 (sum[1], p1, c1);
    xor #(2) S2 (sum[2], p2, c2);
    xor #(2) S3 (sum[3], p3, c3);

    // Final carry
    assign cout = c4;

endmodule