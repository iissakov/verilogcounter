module project2(clk, f, sw1, sw2, sw3, sw4, rst);
	input clk;
	input sw1;
	input sw2;
	input sw3;
	input sw4;
	input rst;
	
	output [7:0] f;
	
	reg [2:0] switches;
	reg [7:0] f;
	wire genclk;
	
	clockgenerator clock(.clk(clk), .sw3(sw3), .sw4(sw4), .clkout(genclk));
	
	always @(posedge genclk)
	begin
		switches = {~rst, sw2, sw1};
		case (switches)
			0: f = f;
			1: f = f + 1;
			2: f = f - 1;
			3: f = f;
			4: f = 0;
			5: f = 0;
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
	
	reg clkout = 0;
	reg [27:0] counter;
	
	always @(posedge clk)
	begin
		counter <= counter + 1;
		if (sw3) begin
			if (sw4) begin
				if (counter >= 5_000_000) begin
					clkout <= ~clkout;
					counter <= 0;
				end
			end else if (~sw4) begin
				if (counter >= 10_000_000) begin
					clkout <= ~clkout;
					counter <= 0;
				end
			end
		end else if (sw4) begin
			if (counter >= 2_500_000) begin
				clkout <= ~clkout;
				counter <= 0;
			end
		end else if (~sw3) begin
			if (~sw4) begin
				if (counter >= 20_000_000) begin
					clkout <= ~clkout;
					counter <= 0;
				end
			end
		end
	end
	
endmodule
