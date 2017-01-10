module project2(clk, f, sw1, sw2, sw3, sw4, rst);
	input clk;
	input sw1;
	input sw2;
	input sw3;
	input sw4;
	input rst;
	
	//output shown on LEDs
	output [7:0] f;
	
	reg [2:0] switches;
	reg [7:0] f;
	wire genclk;
	
	//clock generator module to generate clock depending on which switches are active
	clockgenerator clock(.clk(clk), .sw3(sw3), .sw4(sw4), .clkout(genclk));
	
	always @(posedge genclk)
	begin
		//3 bit register switches controls cases
		switches = {~rst, sw2, sw1};
		case (switches)
			0: f = f;
			1: f = f + 1;	//if sw1 is on and sw2 is off count up
			2: f = f - 1;	//vice versa count down
			3: f = f;
			4: f = 0;	//in the case that reset switch is pressed down
			5: f = 0;	//reset the output to 0
			6: f = 0;
			7: f = 0;
		endcase
	end
endmodule
		

module clockgenerator(clk, sw3, sw4, clkout);
	input clk;
	input sw3;
	input sw4;
	
	output clkout;
	
	reg clkout = 0;		//initialize clock output at 0
	reg [27:0] counter;	//register to hold counter value
	
	always @(posedge clk)
	begin
		counter <= counter + 1;	//increment counter at every internal clock edge (50 MHz)
		if (sw3) begin
			if (sw4) begin
				if (counter >= 5_000_000) begin	//sw3 + sw4 trigger 10 Hz clock
					clkout <= ~clkout;
					counter <= 0;
				end
			end else if (~sw4) begin
				if (counter >= 10_000_000) begin	//sw3 by itself triggers 5 Hz clock
					clkout <= ~clkout;
					counter <= 0;
				end
			end
		end else if (sw4) begin
			if (counter >= 2_500_000) begin //sw4 by itself triggers 20 Hz clock
				clkout <= ~clkout;
				counter <= 0;
			end
		end else if (~sw3) begin
			if (~sw4) begin
				if (counter >= 20_000_000) begin //no switches high triggers 2.5 Hz clock
					clkout <= ~clkout;
					counter <= 0;
				end
			end
		end
	end
	
endmodule
