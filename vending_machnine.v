
module vending_machine(
    input clk,
    input reset,
    input [1:0] product,
    input [4:0] coin,
    input cancel,

    output reg [5:0] price,
    output reg dispense,
    output reg [5:0] change
);
// input clk,reset;
// input  [4:0]coin;
// input [1:0]product;
// input cancel;
// // output disp;
// output reg [5:0]price;
// output reg dispense;
// output dispense;
// output reg [5:0]change;
reg [1:0]selected_product;
reg [2:0]state; //state code
reg [5:0]inserted_amount; //inserted coins 

parameter ONE=5'b00001,TWO=5'b00010,FIVE=5'b00101,TEN=5'b01010,TWENTY=5'b10100; //coins
parameter CAN=2'b01,CANDY=2'b10,COLD_DRINK=2'b11; //product
parameter IDLE=3'b000,SHOW_PRICE=3'b001,PAYMENT=3'b010,DISPENSE=3'b011,RETURN_CHANGE=3'b100;  //states



always@(posedge clk or posedge reset)
 begin 
 if(reset) begin 
                selected_product<=0;
                inserted_amount<=0;
                price<=0;
                dispense<=0;
                change<=0;
 state<=IDLE;
 end
else 
     begin  
 case (state)
 IDLE: begin   
                dispense<=0;
                change<=0;
        if(product>0) begin 
        selected_product<=product;
        state<=SHOW_PRICE;
        end
        else state<=IDLE;
       end

 SHOW_PRICE: 
 begin 
  case(selected_product)
 CAN:  price<=25;
 CANDY:  price<=30;
 COLD_DRINK:  price<=26;
 default:  price<=0;
 endcase 
 state<=PAYMENT;
 end 
PAYMENT:       begin
                     
                      if(cancel) begin state<=RETURN_CHANGE;
                      end 
                       else if(coin>0) 
                      begin
                      inserted_amount<=inserted_amount+coin;
                       if(inserted_amount+coin>=price)
                          state<=DISPENSE;
                           else state<=PAYMENT;
                      end
                      else state<=PAYMENT;

                      end 
DISPENSE:  begin
dispense<=1;

state<=RETURN_CHANGE;
end
RETURN_CHANGE: begin  
                 
                  if(inserted_amount<price)
                  begin change<=inserted_amount;
                  end 
                  else 
                      begin change<=inserted_amount-price;
                       end
                     
                selected_product <= 0;
                inserted_amount<=0;
                price<=0;
                dispense<=0;
                state<=IDLE;
               end 
default: 
state<=IDLE;
endcase
end     
end
  endmodule 


  module testbench;
  reg cancel,clk,reset;
  reg [4:0]coin;
  reg [1:0]product;

  wire [5:0] price;
  wire dispense;
  wire [5:0] change;
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

initial begin 
clk=0;
reset=1;
 product = 0;
    coin = 0;
    cancel = 0;
end 

always   #5 clk=~clk; 

initial begin 
#19 reset = 0;
#5 product=2'b01;
#10 product=0;
#10 coin=20;
#10 coin=20;
#10 coin=0;
end 
initial begin 
$dumpfile("vending_test.vcd");
$dumpvars(0,testbench);
$monitor(" T=%0t reset=%b product=%2b coin=%d change=%d cancel=%b price=%d dispense=%b",$time,reset,product,coin,change,cancel,price,dispense);
#100 $finish;
end 
endmodule 
        
              
          



