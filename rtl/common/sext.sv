module sext#
(
    parameter DATA_WIDTH=1,
    parameter OUT_WIDTH=2
)
(
    input [DATA_WIDTH-1:0]data,
    output [OUT_WIDTH-1:0]sext_data
);

assign sext_data = {{(OUT_WIDTH-DATA_WIDTH){data[DATA_WIDTH-1]}},data};



endmodule

