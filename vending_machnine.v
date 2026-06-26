
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

// stores which product is selected
reg [1:0]selected_product;

// current state of machine
reg [2:0]state;

// total money inserted by user
reg [5:0]inserted_amount;

// coin values
parameter ONE=5'b00001,TWO=5'b00010,FIVE=5'b00101,TEN=5'b01010,TWENTY=5'b10100;

// product codes
parameter CAN=2'b01,CANDY=2'b10,COLD_DRINK=2'b11;

// state codes
parameter IDLE=3'b000,SHOW_PRICE=3'b001,PAYMENT=3'b010,DISPENSE=3'b011,RETURN_CHANGE=3'b100;



// main logic
always@(posedge clk or posedge reset)
 begin

 // reset everything
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

 // waiting for product selection
 IDLE: begin
                dispense<=0;
                change<=0;

        if(product>0) begin
        selected_product<=product;
        state<=SHOW_PRICE;
        end

        else state<=IDLE;
       end


 // load the price of selected product
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


 // keep taking coins until enough money is inserted
 PAYMENT: begin

                      if(cancel) begin
                      state<=RETURN_CHANGE;
                      end

                      else if(coin>0)
                      begin

                      inserted_amount<=inserted_amount+coin;

                      // check if payment is complete
                       if(inserted_amount+coin>=price)
                          state<=DISPENSE;
                       else
                          state<=PAYMENT;

                      end

                      else
                          state<=PAYMENT;

                      end


 // give the product
 DISPENSE: begin

dispense<=1;

state<=RETURN_CHANGE;

end


 // return extra money if any and clear everything
 RETURN_CHANGE: begin

                  if(inserted_amount<price)
                  begin
                      change<=inserted_amount;
                  end

                  else
                  begin
                      change<=inserted_amount-price;
                  end

                selected_product <= 0;
                inserted_amount<=0;
                price<=0;
                dispense<=0;
                state<=IDLE;

               end

// safety case
default:
state<=IDLE;

endcase

end

end

endmodule

 
        
              
          



