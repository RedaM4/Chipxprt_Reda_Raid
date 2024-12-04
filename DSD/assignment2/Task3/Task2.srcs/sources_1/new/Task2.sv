`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2024 02:48:21 PM
// Design Name: 
// Module Name: Task2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Task3#(parameter n=8)(
input logic clk,reset,b,
input logic [n-1:0]Xc,Yc,r,
output logic [7:0] Xo,output logic [6:0]Yo
    
    
    );
    logic [n-1:0]x,y,Count,d ; 
    logic F ; 
    typedef enum logic [3:0] {check,more,less,comp,plotting, clear,init, idle} state_t;
 
        state_t current_state, next_state;
always_ff @(posedge clk or negedge reset) begin
    if (!reset) 
        current_state <= idle; // Reset to locked state
  //      x<=0 ; y<=0 ; Count<=0; y<=r ; 
     else 
        current_state <= next_state; // Update to next state on positive edge of clk 
    end
    
    
    
     always_comb begin
       
        case (current_state)
            idle: 
            if(b)begin next_state = init; end
               
                    

            init: begin if (x<=y) 
                    next_state = plotting ; 
                    else next_state = init ; end 

            plotting:
    if (Count == 7) next_state = comp;
    else next_state = plotting;

            
            comp: 
            if(d>=0)next_state = more ; 
            else next_state = less ; 
            
            less: 
            next_state=check ; 
            
            more :
             next_state=check ; 
            check:
            if (F) next_state= idle;
            else next_state = plotting ;  
            
            
        endcase
    end
    
    

    
 //always @(current_state , Count) begin
  always @(posedge clk,negedge reset) begin
if (!reset) begin
        Count <= 0;x <= 0;y <= 0;F <= 0;
        
     end else begin
    if (current_state == plotting) 
        if (Count < 7)
            Count <= Count + 1;
        else
            Count <= 0;end
  
    
    if(current_state ==idle)
    F=0 ; 
    
    
    

  
  if(current_state == init)begin 
  x=0;
  y=r;
  d=3 - (r<<1) ; 
  end
  
  
 if (current_state == plotting) begin
        case (Count)
            0: begin Xo <= Xc + x; Yo <= Yc + y; end
            1: begin Xo <= Xc - x; Yo <= Yc + y; end
            2: begin Xo <= Xc + x; Yo <= Yc - y; end
            3: begin Xo <= Xc - x; Yo <= Yc - y; end
            4: begin Xo <= Xc + y; Yo <= Yc + x; end
            5: begin Xo <= Xc - y; Yo <= Yc + x; end
            6: begin Xo <= Xc + y; Yo <= Yc - x; end
            7: begin Xo <= Xc - y; Yo <= Yc - x; end
        endcase
end


  if(current_state == plotting)
  Count+=1 ; 
  else Count =0 ; 
  
  if(current_state ==comp)begin
  x+=1 ; end
    
    
    if(current_state == less)
    d=d+ (x <<2) + 6 ; 
        
    if(current_state == more)begin
    d= d + (  (x-y) <<2 ) + 10 ; 
    y -=1 ; end
    
    
    
        if(current_state == less || current_state ==more)begin
    F = x<=y ? 0:1 ; 
    end
    
    
    end
endmodule
