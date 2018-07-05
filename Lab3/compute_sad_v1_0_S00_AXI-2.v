
`timescale 1 ns / 1 ps

	module compute_sad_v1_0_S00_AXI #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 6
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line

		// Global Clock Signal
		input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Write channel Protection type. This signal indicates the
    		// privilege and security level of the transaction, and whether
    		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT,
		// Write address valid. This signal indicates that the master signaling
    		// valid write address and control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that the slave is ready
    		// to accept an address and associated control signals.
		output wire  S_AXI_AWREADY,
		// Write data (issued by master, acceped by Slave)
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		// Write strobes. This signal indicates which byte lanes hold
    		// valid data. There is one write strobe bit for each eight
    		// bits of the write data bus.
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		// Write valid. This signal indicates that valid write
    		// data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    		// can accept the write data.
		output wire  S_AXI_WREADY,
		// Write response. This signal indicates the status
    		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Write response valid. This signal indicates that the channel
    		// is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
    		// can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Protection type. This signal indicates the privilege
    		// and security level of the transaction, and whether the
    		// transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT,
		// Read address valid. This signal indicates that the channel
    		// is signaling valid read address and control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that the slave is
    		// ready to accept an address and associated control signals.
		output wire  S_AXI_ARREADY,
		// Read data (issued by slave)
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of the
    		// read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read valid. This signal indicates that the channel is
    		// signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    		// accept the read data and response information.
		input wire  S_AXI_RREADY
	);

	// AXI4LITE signals
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg  	axi_awready;
	reg  	axi_wready;
	reg [1 : 0] 	axi_bresp;
	reg  	axi_bvalid;
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	reg  	axi_arready;
	reg [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
	reg [1 : 0] 	axi_rresp;
	reg  	axi_rvalid;

	// Example-specific design signals
	// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	// ADDR_LSB is used for addressing 32/64 bit registers/memories
	// ADDR_LSB = 2 for 32 bits (n downto 2)
	// ADDR_LSB = 3 for 64 bits (n downto 3)
	localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32)+1;
	localparam integer OPT_MEM_ADDR_BITS = 3;
	//----------------------------------------------
	//-- Signals for user logic register space example
	//------------------------------------------------
	//-- Number of Slave Registers 11
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg0;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg2;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg3;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg4;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg5;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg6;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg7;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg8;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg9;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg10;
	wire	 slv_reg_rden;
	wire	 slv_reg_wren;
	reg [C_S_AXI_DATA_WIDTH-1:0]	 reg_data_out;
	integer	 byte_index;
	reg	 aw_en;

	// I/O Connections assignments

	assign S_AXI_AWREADY	= axi_awready;
	assign S_AXI_WREADY	= axi_wready;
	assign S_AXI_BRESP	= axi_bresp;
	assign S_AXI_BVALID	= axi_bvalid;
	assign S_AXI_ARREADY	= axi_arready;
	assign S_AXI_RDATA	= axi_rdata;
	assign S_AXI_RRESP	= axi_rresp;
	assign S_AXI_RVALID	= axi_rvalid;
	// Implement axi_awready generation
	// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	// de-asserted when reset is low.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awready <= 1'b0;
	      aw_en <= 1'b1;
	    end
	  else
	    begin
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // slave is ready to accept write address when
	          // there is a valid write address and write data
	          // on the write address and data bus. This design
	          // expects no outstanding transactions.
	          axi_awready <= 1'b1;
	          aw_en <= 1'b0;
	        end
	        else if (S_AXI_BREADY && axi_bvalid)
	            begin
	              aw_en <= 1'b1;
	              axi_awready <= 1'b0;
	            end
	      else
	        begin
	          axi_awready <= 1'b0;
	        end
	    end
	end

	// Implement axi_awaddr latching
	// This process is used to latch the address when both
	// S_AXI_AWVALID and S_AXI_WVALID are valid.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awaddr <= 0;
	    end
	  else
	    begin
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // Write Address latching
	          axi_awaddr <= S_AXI_AWADDR;
	        end
	    end
	end

	// Implement axi_wready generation
	// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is
	// de-asserted when reset is low.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_wready <= 1'b0;
	    end
	  else
	    begin
	      if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en )
	        begin
	          // slave is ready to accept write data when
	          // there is a valid write address and write data
	          // on the write address and data bus. This design
	          // expects no outstanding transactions.
	          axi_wready <= 1'b1;
	        end
	      else
	        begin
	          axi_wready <= 1'b0;
	        end
	    end
	end

	// Implement memory mapped register select and write logic generation
	// The write data is accepted and written to memory mapped registers when
	// axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	// select byte enables of slave registers while writing.
	// These registers are cleared when reset (active low) is applied.
	// Slave register write enable is asserted when valid address and data are available
	// and the slave is ready to accept the write address and write data.
	assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;
	

	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      slv_reg0 <= 0;
	      slv_reg1 <= 0;
	      slv_reg2 <= 0;
	      slv_reg3 <= 0;
	      slv_reg4 <= 0;
	      slv_reg5 <= 0;
	      slv_reg6 <= 0;
	      slv_reg7 <= 0;
	      slv_reg8 <= 0;
	      slv_reg9 <= 0;
	      slv_reg10 <= 0;
	    end
	  else begin
        if (slv_reg_wren)
          begin
            case ( axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
              4'h0:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
              4'h1:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 1
                    slv_reg1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
              4'h2:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 2
                    slv_reg2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
              4'h3:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 3
                    slv_reg3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
              4'h4:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 4
                    slv_reg4[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
              4'h5:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 5
                    slv_reg5[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
              4'h6:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 6
                    slv_reg6[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
              4'h7:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 7
                    slv_reg7[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
              4'h8:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 8
                    slv_reg8[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
              4'h9:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 9
                    slv_reg9[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
              4'hA:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 10
                    slv_reg10[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
              default : begin
                          slv_reg0 <= slv_reg0;
                          slv_reg1 <= slv_reg1;
                          slv_reg2 <= slv_reg2;
                          slv_reg3 <= slv_reg3;
                          slv_reg4 <= slv_reg4;
                          slv_reg5 <= slv_reg5;
                          slv_reg6 <= slv_reg6;
                          slv_reg7 <= slv_reg7;
                          slv_reg8 <= slv_reg8;
                          slv_reg9 <= slv_reg9;
                          slv_reg10 <= slv_reg10;
                        end
            endcase
          end
        else
            begin
               slv_reg9 <= (hw_done==1) ? 32'd0 : slv_reg9; 
               slv_reg10 <= (hw_done==1) ? sad_result : slv_reg10; 
            end
	  end
	end

	// Implement write response logic generation
	// The write response and response valid signals are asserted by the slave
	// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.
	// This marks the acceptance of address and indicates the status of
	// write transaction.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_bvalid  <= 0;
	      axi_bresp   <= 2'b0;
	    end
	  else
	    begin
	      if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
	        begin
	          // indicates a valid write response is available
	          axi_bvalid <= 1'b1;
	          axi_bresp  <= 2'b0; // 'OKAY' response
	        end                   // work error responses in future
	      else
	        begin
	          if (S_AXI_BREADY && axi_bvalid)
	            //check if bready is asserted while bvalid is high)
	            //(there is a possibility that bready is always asserted high)
	            begin
	              axi_bvalid <= 1'b0;
	            end
	        end
	    end
	end

	// Implement axi_arready generation
	// axi_arready is asserted for one S_AXI_ACLK clock cycle when
	// S_AXI_ARVALID is asserted. axi_awready is
	// de-asserted when reset (active low) is asserted.
	// The read address is also latched when S_AXI_ARVALID is
	// asserted. axi_araddr is reset to zero on reset assertion.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_arready <= 1'b0;
	      axi_araddr  <= 32'b0;
	    end
	  else
	    begin
	      if (~axi_arready && S_AXI_ARVALID)
	        begin
	          // indicates that the slave has acceped the valid read address
	          axi_arready <= 1'b1;
	          // Read address latching
	          axi_araddr  <= S_AXI_ARADDR;
	        end
	      else
	        begin
	          axi_arready <= 1'b0;
	        end
	    end
	end

	// Implement axi_arvalid generation
	// axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_ARVALID and axi_arready are asserted. The slave registers
	// data are available on the axi_rdata bus at this instance. The
	// assertion of axi_rvalid marks the validity of read data on the
	// bus and axi_rresp indicates the status of read transaction.axi_rvalid
	// is deasserted on reset (active low). axi_rresp and axi_rdata are
	// cleared to zero on reset (active low).
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rvalid <= 0;
	      axi_rresp  <= 0;
	    end
	  else
	    begin
	      if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
	        begin
	          // Valid read data is available at the read data bus
	          axi_rvalid <= 1'b1;
	          axi_rresp  <= 2'b0; // 'OKAY' response
	        end
	      else if (axi_rvalid && S_AXI_RREADY)
	        begin
	          // Read data is accepted by the master
	          axi_rvalid <= 1'b0;
	        end
	    end
	end

	// Implement memory mapped register select and read logic generation
	// Slave register read enable is asserted when valid address is available
	// and the slave is ready to accept the read address.
	assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
	always @(*)
	begin
	      // Address decoding for reading registers
	      case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	        4'h0   : reg_data_out <= slv_reg0;
	        4'h1   : reg_data_out <= slv_reg1;
	        4'h2   : reg_data_out <= slv_reg2;
	        4'h3   : reg_data_out <= slv_reg3;
	        4'h4   : reg_data_out <= slv_reg4;
	        4'h5   : reg_data_out <= slv_reg5;
	        4'h6   : reg_data_out <= slv_reg6;
	        4'h7   : reg_data_out <= slv_reg7;
	        4'h8   : reg_data_out <= slv_reg8;
	        4'h9   : reg_data_out <= slv_reg9;
	        4'hA   : reg_data_out <= slv_reg10;
	        default : reg_data_out <= 0;
	      endcase
	end

	// Output register or memory read data
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rdata  <= 0;
	    end
	  else
	    begin
	      // When there is a valid read address (S_AXI_ARVALID) with
	      // acceptance of read address by the slave (axi_arready),
	      // output the read dada
	      if (slv_reg_rden)
	        begin
	          axi_rdata <= reg_data_out;     // register read data
	        end
	    end
	end

	// Add user logic here
	wire [31:0] reg_bank;
    assign reg_bank = slv_reg8;
	reg hw_active;
	wire hw_done;

    //declare face and group bank buffer here 
    reg [8:0] f_pixel[0:31][0:31];
    reg [8:0] g_pixel[0:31][0:31];

	// write group pixel into the group part of bank buffer
	integer idx, jdx;
    always @ ( posedge S_AXI_ACLK ) 
	begin
		if (S_AXI_ARESETN == 1'b0) 
			begin
				for(idx=0;idx<32;idx=idx+1) 
					begin
						for(jdx=0;jdx<32;jdx=jdx+1)
							begin
								g_pixel[idx][jdx] <= 8'd0;
							end
					end
			end
		else 
			begin
				if(reg_bank < 32)
					begin
						g_pixel[reg_bank][31]  <={1'b0, slv_reg7[31:24]};
						g_pixel[reg_bank][30]  <={1'b0, slv_reg7[23:16]};
						g_pixel[reg_bank][29]  <={1'b0, slv_reg7[15:8]};
						g_pixel[reg_bank][28]  <={1'b0, slv_reg7[7:0]};
						
						g_pixel[reg_bank][27]  <={1'b0, slv_reg6[31:24]};
						g_pixel[reg_bank][26]  <={1'b0, slv_reg6[23:16]};
						g_pixel[reg_bank][25]  <={1'b0, slv_reg6[15:8]};
						g_pixel[reg_bank][24]  <={1'b0, slv_reg6[7:0]};
						
						g_pixel[reg_bank][23]  <={1'b0, slv_reg5[31:24]};
						g_pixel[reg_bank][22]  <={1'b0, slv_reg5[23:16]};
						g_pixel[reg_bank][21]  <={1'b0, slv_reg5[15:8]};
						g_pixel[reg_bank][20]  <={1'b0, slv_reg5[7:0]};
				
						g_pixel[reg_bank][19]  <={1'b0, slv_reg4[31:24]};
						g_pixel[reg_bank][18]  <={1'b0, slv_reg4[23:16]};
						g_pixel[reg_bank][17]  <={1'b0, slv_reg4[15:8]};
						g_pixel[reg_bank][16]  <={1'b0, slv_reg4[7:0]};
				
						g_pixel[reg_bank][15]  <={1'b0, slv_reg3[31:24]};
						g_pixel[reg_bank][14]  <={1'b0, slv_reg3[23:16]};
						g_pixel[reg_bank][13]  <={1'b0, slv_reg3[15:8]};
						g_pixel[reg_bank][12]  <={1'b0, slv_reg3[7:0]};
				
						g_pixel[reg_bank][11]  <={1'b0, slv_reg2[31:24]};
						g_pixel[reg_bank][10]  <={1'b0, slv_reg2[23:16]};
						g_pixel[reg_bank][9]   <={1'b0, slv_reg2[15:8]};
						g_pixel[reg_bank][8]   <={1'b0, slv_reg2[7:0]};
				
						g_pixel[reg_bank][7]   <={1'b0, slv_reg1[31:24]};
						g_pixel[reg_bank][6]   <={1'b0, slv_reg1[23:16]};
						g_pixel[reg_bank][5]   <={1'b0, slv_reg1[15:8]};
						g_pixel[reg_bank][4]   <={1'b0, slv_reg1[7:0]};
				
						g_pixel[reg_bank][3]   <={1'b0, slv_reg0[31:24]};
						g_pixel[reg_bank][2]   <={1'b0, slv_reg0[23:16]};
						g_pixel[reg_bank][1]   <={1'b0, slv_reg0[15:8]};
						g_pixel[reg_bank][0]   <={1'b0, slv_reg0[7:0]};
					end
            end
    end

	// write face pixel into the face part of bank buffer
    always @ (posedge S_AXI_ACLK) 
	begin
		if (S_AXI_ARESETN == 1'b0) 
			begin
				for(idx=0;idx<32;idx=idx+1) 
					begin
						for(jdx=0;jdx<32;jdx=jdx+1)
							begin
								f_pixel[idx][jdx] <= 8'd0;
							end
					end
			end
		else 
			begin
				if(reg_bank > 31)
						begin
						f_pixel[reg_bank-32][31]  <={1'b0, slv_reg7[31:24]};
						f_pixel[reg_bank-32][30]  <={1'b0, slv_reg7[23:16]};
						f_pixel[reg_bank-32][29]  <={1'b0, slv_reg7[15:8]};
						f_pixel[reg_bank-32][28]  <={1'b0, slv_reg7[7:0]};
						
						f_pixel[reg_bank-32][27]  <={1'b0, slv_reg6[31:24]};
						f_pixel[reg_bank-32][26]  <={1'b0, slv_reg6[23:16]};
						f_pixel[reg_bank-32][25]  <={1'b0, slv_reg6[15:8]};
						f_pixel[reg_bank-32][24]  <={1'b0, slv_reg6[7:0]};
				
						f_pixel[reg_bank-32][23]  <={1'b0, slv_reg5[31:24]};
						f_pixel[reg_bank-32][22]  <={1'b0, slv_reg5[23:16]};
						f_pixel[reg_bank-32][21]  <={1'b0, slv_reg5[15:8]};
						f_pixel[reg_bank-32][20]  <={1'b0, slv_reg5[7:0]};
				
						f_pixel[reg_bank-32][19]  <={1'b0, slv_reg4[31:24]};
						f_pixel[reg_bank-32][18]  <={1'b0, slv_reg4[23:16]};
						f_pixel[reg_bank-32][17]  <={1'b0, slv_reg4[15:8]};
						f_pixel[reg_bank-32][16]  <={1'b0, slv_reg4[7:0]};
				
						f_pixel[reg_bank-32][15]  <={1'b0, slv_reg3[31:24]};
						f_pixel[reg_bank-32][14]  <={1'b0, slv_reg3[23:16]};
						f_pixel[reg_bank-32][13]  <={1'b0, slv_reg3[15:8]};
						f_pixel[reg_bank-32][12]  <={1'b0, slv_reg3[7:0]};
				
						f_pixel[reg_bank-32][11]  <={1'b0, slv_reg2[31:24]};
						f_pixel[reg_bank-32][10]  <={1'b0, slv_reg2[23:16]};
						f_pixel[reg_bank-32][9]   <={1'b0, slv_reg2[15:8]};
						f_pixel[reg_bank-32][8]   <={1'b0, slv_reg2[7:0]};
				
						f_pixel[reg_bank-32][7]   <={1'b0, slv_reg1[31:24]};
						f_pixel[reg_bank-32][6]   <={1'b0, slv_reg1[23:16]};
						f_pixel[reg_bank-32][5]   <={1'b0, slv_reg1[15:8]};
						f_pixel[reg_bank-32][4]   <={1'b0, slv_reg1[7:0]};
				
						f_pixel[reg_bank-32][3]   <={1'b0, slv_reg0[31:24]};
						f_pixel[reg_bank-32][2]   <={1'b0, slv_reg0[23:16]};
						f_pixel[reg_bank-32][1]   <={1'b0, slv_reg0[15:8]};
						f_pixel[reg_bank-32][0]   <={1'b0, slv_reg0[7:0]};
					end
			end
    end
	// circular buffer handled here
	
	///////////////////////// fail log /////////////////////////////////////////
	// version 1 shift => failed, too much LUT and instances
	// version 2 address forward => failed, too much LUT and MUX , it takes too much to synethesis(2 hours)
	// version 3 direct subtract f - g in wire mode and finish it at a time => failed, too much LUT and MUX 
	// version 4 direct subtract f - g in reg mode and finish it at a time => failed, too much LUT and MUX 
	// version 5 address forward to a register and let be the index of the g_pixel not in order  => failed, too much LUT and MUX 
	// version 6 address forward to a register and let be the index of the g_pixel in order => failed, too much LUT and MUX 
	reg [8 : 0] diff[31:0][31:0];
    always @ ( * ) begin
        case (reg_bank)
            32'd0:  
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx+1) % 32 ][jdx];
                            end
                    end
            32'd1:  
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 2) % 32 ][jdx];
                            end
                    end
            32'd2: 
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 3) % 32 ][jdx];
                            end
                    end
            32'd3: 
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 4) % 32 ][jdx];
                            end
                    end
            32'd4:   
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 5) % 32 ][jdx];
                            end
                    end
            32'd5:  
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 6) % 32 ][jdx];
                            end
                    end
            32'd6:  
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 7) % 32 ][jdx];
                            end
                    end
            32'd7:  
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 8) % 32 ][jdx];
                            end
                    end
            32'd8: 
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 9) % 32 ][jdx];
                            end
                    end
            32'd9:   
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx+10) % 32 ][jdx];
                            end
                    end
            32'd10:  
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx+11) % 32 ][jdx];
                            end
                    end
            32'd11: 
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx+12) % 32 ][jdx];
                            end
                    end
            32'd12:  
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx+13) % 32 ][jdx];
                            end
                    end
            32'd13:  
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx+14) % 32 ][jdx];
                            end
                    end
            32'd14: 
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx+15) % 32 ][jdx];
                            end
                    end
            32'd15:   
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx+16) % 32 ][jdx];
                            end
                    end
            32'd16:    
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx+17) % 32 ][jdx];
                            end
                    end
            32'd17:   
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx+18) % 32 ][jdx];
                            end
                    end
            32'd18:   
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx+19) % 32 ][jdx];
                            end
                    end
            32'd19:  
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 20) % 32 ][jdx];
                            end
                    end
            32'd20:   
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 21) % 32 ][jdx];
                            end
                    end
            32'd21: 
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 22) % 32 ][jdx];
                            end
                    end
            32'd22:  
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 23) % 32 ][jdx];
                            end
                    end
            32'd23:  
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 24) % 32 ][jdx];
                            end
                    end
            32'd24:  
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 25) % 32 ][jdx];
                            end
                    end
            32'd25:   
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 26) % 32 ][jdx];
                            end
                    end
            32'd26:  
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 27) % 32 ][jdx];
                            end
                    end
            32'd27: 
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 28) % 32 ][jdx];
                            end
                    end
            32'd28:   
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 29) % 32 ][jdx];
                            end
                    end
            32'd29:    
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 30) % 32 ][jdx];
                            end
                    end
            32'd30:   
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 31) % 32 ][jdx];
                            end
                    end
            32'd31: 
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 32) % 32 ][jdx];
                            end
                    end
            default: 
                for(idx = 0; idx < 32; idx = idx+1)
                    begin
                        for(jdx = 0; jdx < 32; jdx = jdx+1)
                            begin
                                diff[idx][jdx] = f_pixel[idx][jdx] - g_pixel[ (idx + 32) % 32 ][jdx];
                            end
                    end
        endcase  
    end

	/// version 1 finish all row of pixel in one time in wire => failed, too much LUT
	/// version 2 finish all row of pixel in one time in always => failed, too much MUX
	/// version 3 finish all row of pixel in one time in above combined => failed, too much LUT and too much MUX
	reg [7:0] abs_diff_0[127:0];         
    reg [7:0] abs_diff_1[127:0];            
    reg [7:0] abs_diff_2[127:0]; 
    reg [7:0] abs_diff_3[127:0];            
    reg [7:0] abs_diff_4[127:0]; 
    reg [7:0] abs_diff_5[127:0];    
    reg [7:0] abs_diff_6[127:0]; 
    reg [7:0] abs_diff_7[127:0];               
    always @ (posedge S_AXI_ACLK) begin
        for(idx = 0; idx < 4; idx = idx+1)
            begin
                for(jdx = 0; jdx < 32; jdx = jdx+1)
                    begin
                        abs_diff_0[32*idx + jdx] <= (diff[idx][jdx][8] == 1'b1) ? -diff[idx][jdx] : diff[idx][jdx];

                        abs_diff_1[32*idx + jdx] <= (diff[idx+4][jdx][8] == 1'b1) ? -diff[idx+4][jdx] : diff[idx+4][jdx];

                        abs_diff_2[32*idx + jdx] <= (diff[idx+8][jdx][8] == 1'b1) ?  -diff[idx+8][jdx] : diff[idx+8][jdx];

                        abs_diff_3[32*idx + jdx] <= (diff[idx+12][jdx][8] == 1'b1) ?  -diff[idx+12][jdx] : diff[idx+12][jdx];

                        abs_diff_4[32*idx + jdx] <= (diff[idx+16][jdx][8] == 1'b1) ?  -diff[idx+16][jdx] : diff[idx+16][jdx];

                        abs_diff_5[32*idx + jdx] <= (diff[idx+20][jdx][8] == 1'b1) ?  -diff[idx+20][jdx] : diff[idx+20][jdx];

                        abs_diff_6[32*idx + jdx] <= (diff[idx+24][jdx][8] == 1'b1) ?  -diff[idx+24][jdx] : diff[idx+24][jdx];

                        abs_diff_7[32*idx + jdx] <= (diff[idx+28][jdx][8] == 1'b1) ?  -diff[idx+28][jdx] : diff[idx+28][jdx];
                    end
            end
    end
	
	//// select the corresponding rows(4 rows) to sum up first level 
    reg [31:0] sum_level_1[63:0];
	wire [2:0] choose_row;
	assign choose_row = tick_count[2:0];
    always @ (posedge S_AXI_ACLK) 
	begin
		for(idx = 0; idx < 64; idx = idx+1)
        begin
				case(choose_row)
				3'd0:
						sum_level_1[idx] <= abs_diff_7[2*idx] + abs_diff_7[2*idx+1];
				3'd1:
						sum_level_1[idx] <= abs_diff_0[2*idx] + abs_diff_0[2*idx+1];
				3'd2:
						sum_level_1[idx] <= abs_diff_1[2*idx] + abs_diff_1[2*idx+1];
				3'd3:
						sum_level_1[idx] <= abs_diff_2[2*idx] + abs_diff_2[2*idx+1];
				3'd4:
						sum_level_1[idx] <= abs_diff_3[2*idx] + abs_diff_3[2*idx+1];
				3'd5:
						sum_level_1[idx] <= abs_diff_4[2*idx] + abs_diff_4[2*idx+1];
				3'd6:
						sum_level_1[idx] <= abs_diff_5[2*idx] + abs_diff_5[2*idx+1];
				3'd7:
						sum_level_1[idx] <= abs_diff_6[2*idx] + abs_diff_6[2*idx+1];
				endcase
		end
    end
	
    reg [31:0] sum_level_2[31:0];
    always @ ( posedge S_AXI_ACLK ) begin
        for(idx = 0; idx < 32; idx = idx+1)
            sum_level_2[idx] <= sum_level_1[2*idx] + sum_level_1[2*idx+1];
    end
	
    reg [31:0] sum_level_3[15:0];
    always @ ( posedge S_AXI_ACLK ) begin
        for(idx = 0; idx < 16; idx = idx+1)
            sum_level_3[idx] <= sum_level_2[2*idx] + sum_level_2[2*idx+1];
    end
	
    reg [31:0] sum_level_4[7:0];
    always @ ( posedge S_AXI_ACLK ) begin
        for(idx = 0; idx < 8; idx = idx+1)
            sum_level_4[idx] <= sum_level_3[2*idx] + sum_level_3[2*idx+1];
    end
	
    reg [31:0] sum_level_5[3:0];
    always @ ( posedge S_AXI_ACLK ) begin
        for(idx = 0; idx < 4; idx = idx+1)
            sum_level_5[idx] <= sum_level_4[2*idx] + sum_level_4[2*idx+1];
    end
	
    reg [31:0] sum_level_6[1:0];
    always @ ( posedge S_AXI_ACLK ) begin
        for(idx = 0; idx < 2; idx = idx+1)
            sum_level_6[idx] <= sum_level_5[2*idx] + sum_level_5[2*idx+1];
    end
    
    wire [31:0] sum_level_7;
	assign sum_level_7 = sum_level_6[0] + sum_level_6[1];
	/// control and output singals 
	assign hw_done = (hw_active == 1 && tick_count == 8'd15);
	reg [31:0] sad_result;
    always @ ( posedge S_AXI_ACLK ) begin
		if(tick_count > 8'd6 && tick_count < 8'd15)
            sad_result <= sad_result + sum_level_7;
        else
            sad_result <= 0;
    end
	
    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
            hw_active   <=  0;
        end 
      else if(hw_done ==1)
        begin    
            hw_active  <=  0;
        end
      else 
        begin
            hw_active  <=  | slv_reg9;
        end
    end 
	reg [7: 0] tick_count;
    always @ (posedge S_AXI_ACLK) begin
		if(hw_active == 1'b1)
            tick_count <= tick_count + 8'd1;
        else
            tick_count <= 8'd0;
    end
	// User logic ends

	endmodule
