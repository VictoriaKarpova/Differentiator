`timescale 1 ns / 1 ns

module Filter_test_24_tb;


  reg  clk;
  reg  reset;
  wire clk_enable;
  wire Output1_done;  // ufix1
  wire rdEnb;
  wire Output1_done_enb;  // ufix1
  reg [7:0] Output1_addr;  // ufix8
  wire Output1_active;  // ufix1
  reg [7:0] Signal_From_Workspace_out1_addr;  // ufix8
  wire Signal_From_Workspace_out1_active;  // ufix1
  reg  tb_enb_delay;
  wire Signal_From_Workspace_out1_enb;  // ufix1
  wire [7:0] Signal_From_Workspace_out1_addr_delay_1;  // ufix8
  reg signed [31:0] fp_Input1;  // sfix32
  reg signed [15:0] rawData_Input1;  // sfix16_En8
  reg signed [31:0] status_Input1;  // sfix32
  reg signed [15:0] holdData_Input1;  // sfix16_En8
  reg signed [15:0] Input1_offset;  // sfix16_En8
  wire signed [15:0] Input1;  // sfix16_En8
  reg  check1_done;  // ufix1
  wire snkDonen;
  wire resetn;
  wire tb_enb;
  //wire ce_out;
  wire signed [15:0] Output1;  // sfix16_En8
  wire Output1_enb;  // ufix1
  wire Output1_lastAddr;  // ufix1
  wire [7:0] Output1_addr_delay_1;  // ufix8
  reg signed [31:0] fp_Output1_expected;  // sfix32
  reg signed [15:0] Output1_expected;  // sfix16_En8
  reg signed [31:0] status_Output1_expected;  // sfix32
  reg signed [15:0] Output1_ref;  // sfix16_En8
  reg  Output1_testFailure;  // ufix1
  wire testFailure;  // ufix1


  assign Output1_done_enb = Output1_done & rdEnb;



  assign Output1_active = Output1_addr != 8'b11111010;



  assign Signal_From_Workspace_out1_active = Signal_From_Workspace_out1_addr != 8'b11111010;



  assign Signal_From_Workspace_out1_enb = Signal_From_Workspace_out1_active & (rdEnb & tb_enb_delay);



  // Count limited, Unsigned Counter
  //  initial value   = 0
  //  step value      = 1
  //  count to value  = 250
  always @(posedge clk)
    begin : SignalFromWorkspace_process
      if (reset == 1'b1) begin
        Signal_From_Workspace_out1_addr <= 8'b00000000;
      end
      else begin
        if (Signal_From_Workspace_out1_enb) begin
          if (Signal_From_Workspace_out1_addr >= 8'b11111010) begin
            Signal_From_Workspace_out1_addr <= 8'b00000000;
          end
          else begin
            Signal_From_Workspace_out1_addr <= Signal_From_Workspace_out1_addr + 8'b00000001;
          end
        end
      end
    end



  assign #1 Signal_From_Workspace_out1_addr_delay_1 = Signal_From_Workspace_out1_addr;

  // Data source for Input1
  initial
    begin : Input1_fileread
      fp_Input1 = $fopen("Input1.dat", "r");
      status_Input1 = $rewind(fp_Input1);
    end

  always @(Signal_From_Workspace_out1_addr_delay_1, rdEnb, tb_enb_delay)
    begin
      if (tb_enb_delay == 0) begin
        rawData_Input1 <= 16'bx;
      end
      else if (rdEnb == 1) begin
        status_Input1 = $fscanf(fp_Input1, "%h", rawData_Input1);
      end
    end

  // holdData reg for Signal_From_Workspace_out1
  always @(posedge clk)
    begin : stimuli_Signal_From_Workspace_out1
      if (reset) begin
        holdData_Input1 <= 16'bx;
      end
      else begin
        holdData_Input1 <= rawData_Input1;
      end
    end

  always @(rawData_Input1 or rdEnb)
    begin : stimuli_Signal_From_Workspace_out1_1
      if (rdEnb == 1'b0) begin
        Input1_offset <= holdData_Input1;
      end
      else begin
        Input1_offset <= rawData_Input1;
      end
    end

  assign #2 Input1 = Input1_offset;

  assign snkDonen =  ~ check1_done;



  assign resetn =  ~ reset;



  assign tb_enb = resetn & snkDonen;



  // Delay inside enable generation: register depth 1
  always @(posedge clk)
    begin : u_enable_delay
      if (reset) begin
        tb_enb_delay <= 0;
      end
      else begin
        tb_enb_delay <= tb_enb;
      end
    end

  assign rdEnb = (check1_done == 1'b0 ? tb_enb_delay :
              1'b0);



  assign #2 clk_enable = rdEnb;

  initial
    begin : reset_gen
      reset <= 1'b1;
      # (20);
      @ (posedge clk)
      # (2);
      reset <= 1'b0;
    end

  always 
    begin : clk_gen
      clk <= 1'b1;
      # (150);
      clk <= 1'b0;
      # (150);
      if (check1_done == 1'b1) begin
        clk <= 1'b1;
        # (150);
        clk <= 1'b0;
        # (150);
        $stop;
      end
    end
initial 
	$sdf_annotate("../Outputs/Encounter/Filter_test_24.sdf", u_filter);
  
Filter_test_24 u_Filter_test_24 (.clk(clk),
                                   .reset(reset),
                                   .clk_enable(clk_enable),
                                   .Input1(Input1),  // sfix16_En8
                                   .Output1(Output1)  // sfix16_En8
                                   );

  assign Output1_enb = clk_enable & Output1_active;



  // Count limited, Unsigned Counter
  //  initial value   = 0
  //  step value      = 1
  //  count to value  = 250
  always @(posedge clk)
    begin : c_2_process
      if (reset == 1'b1) begin
        Output1_addr <= 8'b00000000;
      end
      else begin
        if (Output1_enb) begin
          if (Output1_addr >= 8'b11111010) begin
            Output1_addr <= 8'b00000000;
          end
          else begin
            Output1_addr <= Output1_addr + 8'b00000001;
          end
        end
      end
    end



  assign Output1_lastAddr = Output1_addr >= 8'b11111010;



  assign Output1_done = Output1_lastAddr & resetn;



  // Delay to allow last sim cycle to complete
  always @(posedge clk)
    begin : checkDone_1
      if (reset) begin
        check1_done <= 0;
      end
      else begin
        if (Output1_done_enb) begin
          check1_done <= Output1_done;
        end
      end
    end

  assign #1 Output1_addr_delay_1 = Output1_addr;

  // Data source for Output1_expected
  initial
    begin : Output1_expected_fileread
      fp_Output1_expected = $fopen("Output1_expected.dat", "r");
      status_Output1_expected = $rewind(fp_Output1_expected);
    end

  always @(Output1_addr_delay_1, clk_enable, tb_enb_delay)
    begin
      if (tb_enb_delay == 0) begin
        Output1_expected <= 16'bx;
      end
      else if (clk_enable == 1) begin
        status_Output1_expected = $fscanf(fp_Output1_expected, "%h", Output1_expected);
      end
    end
   always@(posedge clk)
   Output1_ref <= Output1_expected;

  always @(posedge clk)
    begin : Output1_checker
      if (reset == 1'b1) begin
        Output1_testFailure <= 1'b0;
      end
      else begin
        if (clk_enable == 1'b1 && Output1 !== Output1_ref) begin
          Output1_testFailure <= 1'b1;
          $display("ERROR in Output1 at time %t : Expected '%h' Actual '%h'", $time, Output1_ref, Output1);
        end
      end
    end

  assign testFailure = Output1_testFailure;

  always @(posedge clk)
    begin : completed_msg
      if (check1_done == 1'b1) begin
        if (testFailure == 1'b0) begin
          $display("**************TEST COMPLETED (PASSED)**************");
        end
        else begin
          $display("**************TEST COMPLETED (FAILED)**************");
        end
      end
    end

endmodule  // Filter_test_24_tb