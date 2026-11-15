module booth_multiplier_tb();

reg clk;
reg rst;
reg start;

reg signed [3:0] M;
reg signed [3:0] Q_in;

wire signed [7:0] product;
wire done;
wire busy;

// DUT instantiation

booth_multiplier DUT (
    .clk(clk),
    .rst(rst),
    .start(start),
    .M(M),
    .Q_in(Q_in),
    .product(product),
    .done(done),
    .busy(busy)
);

// Clock generation

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus

initial begin

    rst = 1;
    start = 0;

    M = 4'b0011;       // Multiplicand = 3
    Q_in = 4'b0111;    // Multiplier = 7

    #12;
    rst = 0;

    #10;
    start = 1;

    #10;
    start = 0;

    wait(done);

    #1;
    $display("Multiplicand = %d", M);
    $display("Multiplier   = %d", Q_in);
    $display("Product      = %d", $signed(product));
    $display("Product Binary = %b", product);
    #10;
    $finish;
end
endmodule
