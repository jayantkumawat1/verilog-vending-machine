module testbench;

// input signals for DUT
reg cancel,clk,reset;
reg [4:0]coin;
reg [1:0]product;

// output signals from DUT
wire [5:0] price;
wire dispense;
wire [5:0] change;

// instantiate vending machine
vending_machine DUT(
    .clk(clk),
    .reset(reset),
    .product(product),
    .coin(coin),
    .cancel(cancel),
    .price(price),
    .dispense(dispense),
    .change(change)
);

// initial values
initial begin
    clk=0;
    reset=1;
    product=0;
    coin=0;
    cancel=0;
end

// clock generation (10 ns time period)
always #5 clk=~clk;

// test sequence
initial begin

    // release reset
    #19 reset=0;

    // select CAN
    #5 product=2'b01;

    // remove selection signal
    #10 product=0;

    // insert first Rs.20 coin
    #10 coin=20;

    // insert second Rs.20 coin
    #10 coin=20;

    // no more coins
    #10 coin=0;

end

// waveform and simulation output
initial begin

    $dumpfile("vending_test.vcd");
    $dumpvars(0,testbench);

    // print values during simulation
    $monitor(" T=%0t reset=%b product=%2b coin=%d change=%d cancel=%b price=%d dispense=%b",
             $time,reset,product,coin,change,cancel,price,dispense);

    // stop simulation
    #100 $finish;

end

endmodule
