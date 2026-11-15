module booth_multiplier (
input clk,
input rst,
input start,

input signed [3:0] M,
input signed [3:0] Q_in,

output reg signed [7:0] product,
output reg done,
output reg busy
);

reg signed [3:0] A;
reg signed [3:0] Q;
reg Q_1;

reg [1:0] count;

reg signed [3:0] A_work;
reg signed [8:0] shift_temp;

always @(posedge clk or posedge rst)
begin

        if (rst) begin
            A       <= 4'b0000;
            Q       <= 4'b0000;
            Q_1     <= 1'b0;
            count   <= 2'b00;
            product <= 8'b00000000;
            done    <= 1'b0;
            busy    <= 1'b0;
        end

        else begin

            if (start && !busy) begin

                A       <= 4'b0000;
                Q       <= Q_in;
                Q_1     <= 1'b0;
                count   <= 2'b00;
                product <= 8'b00000000;

                done    <= 1'b0;
                busy    <= 1'b1;

            end

            else if (busy) begin

                A_work = A;

                // Booth operation

                case ({Q[0], Q_1})

                    2'b01: A_work = A + M;

                    2'b10: A_work = A - M;

                    default: A_work = A;

                endcase

                // Arithmetic right shift

                shift_temp = {A_work, Q, Q_1};

                shift_temp = $signed(shift_temp) >>> 1;

                A   <= shift_temp[8:5];
                Q   <= shift_temp[4:1];
                Q_1 <= shift_temp[0];
                // Four iterations completed
                if (count == 2'd3) begin
                    product <= {
                        shift_temp[8:5],
                        shift_temp[4:1]
                    };
                    done <= 1'b1;
                    busy <= 1'b0;
                end
                else begin
                    count <= count + 1'b1;
                end
            end
        end
    end
endmodule
