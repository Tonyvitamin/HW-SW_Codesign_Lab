
`timescale 1 ns / 1 ps

	module compute_sad_v1_0_S00_AXI #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 7
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
	localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
	localparam integer OPT_MEM_ADDR_BITS = 4;
	//----------------------------------------------
	//-- Signals for user logic register space example
	//------------------------------------------------
	//-- Number of Slave Registers 18
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
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg11;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg12;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg13;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg14;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg15;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg16;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg17;
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
	      slv_reg11 <= 0;
	      slv_reg12 <= 0;
	      slv_reg13 <= 0;
	      slv_reg14 <= 0;
	      slv_reg15 <= 0;
	      slv_reg16 <= 0;
	      slv_reg17 <= 0;
	    end 
	  else begin
	    if (slv_reg_wren)
	      begin
	        case ( axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	          5'h00:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 0
	                slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          5'h01:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 1
	                slv_reg1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          5'h02:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 2
	                slv_reg2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          5'h03:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 3
	                slv_reg3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          5'h04:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 4
	                slv_reg4[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          5'h05:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 5
	                slv_reg5[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          5'h06:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg6[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          5'h07:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 7
	                slv_reg7[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          5'h08:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 8
	                slv_reg8[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          5'h09:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 9
	                slv_reg9[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          5'h0A:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 10
	                slv_reg10[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          5'h0B:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 11
	                slv_reg11[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          5'h0C:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 12
	                slv_reg12[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          5'h0D:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 13
	                slv_reg13[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          5'h0E:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 14
	                slv_reg14[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          5'h0F:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 15
	                slv_reg15[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          5'h10:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 16
	                slv_reg16[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          5'h11:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 17
	                slv_reg17[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
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
	                      slv_reg11 <= slv_reg11;
	                      slv_reg12 <= slv_reg12;
	                      slv_reg13 <= slv_reg13;
	                      slv_reg14 <= slv_reg14;
	                      slv_reg15 <= slv_reg15;
	                      slv_reg16 <= slv_reg16;
	                      slv_reg17 <= slv_reg17;
	                    end
	        endcase
	      end
      else 
        begin
          if(check == 1)
            begin
              slv_reg16 <= 0;
              slv_reg17 <= sad_result;
            end
          else
            begin
              slv_reg16 <= slv_reg16;
              slv_reg17 <= slv_reg17;
             end
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
	        5'h00   : reg_data_out <= slv_reg0;
	        5'h01   : reg_data_out <= slv_reg1;
	        5'h02   : reg_data_out <= slv_reg2;
	        5'h03   : reg_data_out <= slv_reg3;
	        5'h04   : reg_data_out <= slv_reg4;
	        5'h05   : reg_data_out <= slv_reg5;
	        5'h06   : reg_data_out <= slv_reg6;
	        5'h07   : reg_data_out <= slv_reg7;
	        5'h08   : reg_data_out <= slv_reg8;
	        5'h09   : reg_data_out <= slv_reg9;
	        5'h0A   : reg_data_out <= slv_reg10;
	        5'h0B   : reg_data_out <= slv_reg11;
	        5'h0C   : reg_data_out <= slv_reg12;
	        5'h0D   : reg_data_out <= slv_reg13;
	        5'h0E   : reg_data_out <= slv_reg14;
	        5'h0F   : reg_data_out <= slv_reg15;
	        5'h10   : reg_data_out <= slv_reg16;
	        5'h11   : reg_data_out <= slv_reg17;
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
	      if (slv_reg_rden == 1)
	        begin
	          axi_rdata <= reg_data_out;     // register read data
	        end   
	    end
	end    

	// Add user logic here
  reg [8:0] abs_diff[0:31];
  wire [8:0] f_pixel[0:31]; // face pixels
  wire [8:0] g_pixel[0:31]; // group pixels
  wire [8:0] diff[0:31];
  
  assign f_pixel[0] = {1'b0, slv_reg0[31:24]};
  assign g_pixel[0] = {1'b0, slv_reg8[31:24]};
  assign diff[0] = f_pixel[0] - g_pixel[0];
  
  assign f_pixel[1] = {1'b0, slv_reg0[23:16]};
  assign g_pixel[1] = {1'b0, slv_reg8[23:16]};
  assign diff[1] = f_pixel[1] - g_pixel[1]; 

  assign f_pixel[2] = {1'b0, slv_reg0[15:8]};
  assign g_pixel[2] = {1'b0, slv_reg8[15:8]};
  assign diff[2] = f_pixel[2] - g_pixel[2];
  
  assign f_pixel[3] = {1'b0, slv_reg0[7:0]};
  assign g_pixel[3] = {1'b0, slv_reg8[7:0]};
  assign diff[3] = f_pixel[3] - g_pixel[3];

  assign f_pixel[4] = {1'b0, slv_reg1[31:24]};
  assign g_pixel[4] = {1'b0, slv_reg9[31:24]};
  assign diff[4] = f_pixel[4] - g_pixel[4];

  assign f_pixel[5] = {1'b0, slv_reg1[23:16]};
  assign g_pixel[5] = {1'b0, slv_reg9[23:16]};
  assign diff[5] = f_pixel[5] - g_pixel[5];
  
  assign f_pixel[6] = {1'b0, slv_reg1[15:8]};
  assign g_pixel[6] = {1'b0, slv_reg9[15:8]};
  assign diff[6] = f_pixel[6] - g_pixel[6];
  
  assign f_pixel[7] = {1'b0, slv_reg1[7:0]};
  assign g_pixel[7] = {1'b0, slv_reg9[7:0]};
  assign diff[7] = f_pixel[7] - g_pixel[7];
  
  assign f_pixel[8] = {1'b0, slv_reg2[31:24]};
  assign g_pixel[8] = {1'b0, slv_reg10[31:24]};
  assign diff[8] = f_pixel[8] - g_pixel[8];
  
  assign f_pixel[9] = {1'b0, slv_reg2[23:16]};
  assign g_pixel[9] = {1'b0, slv_reg10[23:16]};
  assign diff[9] = f_pixel[9] - g_pixel[9];
  
  assign f_pixel[10] = {1'b0, slv_reg2[15:8]};
  assign g_pixel[10] = {1'b0, slv_reg10[15:8]};
  assign diff[10] = f_pixel[10] - g_pixel[10];
  
  assign f_pixel[11] = {1'b0, slv_reg2[7:0]};
  assign g_pixel[11] = {1'b0, slv_reg10[7:0]};
  assign diff[11] = f_pixel[11] - g_pixel[11];
  
  assign f_pixel[12] = {1'b0, slv_reg3[31:24]};
  assign g_pixel[12] = {1'b0, slv_reg11[31:24]};
  assign diff[12] = f_pixel[12] - g_pixel[12];

  assign f_pixel[13] = {1'b0, slv_reg3[23:16]};
  assign g_pixel[13] = {1'b0, slv_reg11[23:16]};
  assign diff[13] = f_pixel[13] - g_pixel[13];
  
  assign f_pixel[14] = {1'b0, slv_reg3[15:8]};
  assign g_pixel[14] = {1'b0, slv_reg11[15:8]};
  assign diff[14] = f_pixel[14] - g_pixel[14];

  assign f_pixel[15] = {1'b0, slv_reg3[7:0]};
  assign g_pixel[15] = {1'b0, slv_reg11[7:0]};
  assign diff[15] = f_pixel[15] - g_pixel[15];
  
  assign f_pixel[16] = {1'b0, slv_reg4[31:24]};
  assign g_pixel[16] = {1'b0, slv_reg12[31:24]};
  assign diff[16] = f_pixel[16] - g_pixel[16];
  
  assign f_pixel[17] = {1'b0, slv_reg4[23:16]};
  assign g_pixel[17] = {1'b0, slv_reg12[23:16]};
  assign diff[17] = f_pixel[17] - g_pixel[17];

  assign f_pixel[18] = {1'b0, slv_reg4[15:8]};
  assign g_pixel[18] = {1'b0, slv_reg12[15:8]};
  assign diff[18] = f_pixel[18] - g_pixel[18];
  
  assign f_pixel[19] = {1'b0, slv_reg4[7:0]};
  assign g_pixel[19] = {1'b0, slv_reg12[7:0]};
  assign diff[19] = f_pixel[19] - g_pixel[19];
  
  assign f_pixel[20] = {1'b0, slv_reg5[31:24]};
  assign g_pixel[20] = {1'b0, slv_reg13[31:24]};
  assign diff[20] = f_pixel[20] - g_pixel[20];
  
  assign f_pixel[21] = {1'b0, slv_reg5[23:16]};
  assign g_pixel[21] = {1'b0, slv_reg13[23:16]};
  assign diff[21] = f_pixel[21] - g_pixel[21];
  
  assign f_pixel[22] = {1'b0, slv_reg5[15:8]};
  assign g_pixel[22] = {1'b0, slv_reg13[15:8]};
  assign diff[22] = f_pixel[22] - g_pixel[22];
  
  assign f_pixel[23] = {1'b0, slv_reg5[7:0]};
  assign g_pixel[23] = {1'b0, slv_reg13[7:0]};
  assign diff[23] = f_pixel[23] - g_pixel[23];
  
  assign f_pixel[24] = {1'b0, slv_reg6[31:24]};
  assign g_pixel[24] = {1'b0, slv_reg14[31:24]};
  assign diff[24] = f_pixel[24] - g_pixel[24];
  
  assign f_pixel[25] = {1'b0, slv_reg6[23:16]};
  assign g_pixel[25] = {1'b0, slv_reg14[23:16]};
  assign diff[25] = f_pixel[25] - g_pixel[25];
  
  assign f_pixel[26] = {1'b0, slv_reg6[15:8]};
  assign g_pixel[26] = {1'b0, slv_reg14[15:8]};
  assign diff[26] = f_pixel[26] - g_pixel[26];

  assign f_pixel[27] = {1'b0, slv_reg6[7:0]};
  assign g_pixel[27] = {1'b0, slv_reg14[7:0]};
  assign diff[27] = f_pixel[27] - g_pixel[27];
  
  assign f_pixel[28] = {1'b0, slv_reg7[31:24]};
  assign g_pixel[28] = {1'b0, slv_reg15[31:24]};
  assign diff[28] = f_pixel[28] - g_pixel[28];
  
  assign f_pixel[29] = {1'b0, slv_reg7[23:16]};
  assign g_pixel[29] = {1'b0, slv_reg15[23:16]};
  assign diff[29] = f_pixel[29] - g_pixel[29];
  
  assign f_pixel[30] = {1'b0, slv_reg7[15:8]};
  assign g_pixel[30] = {1'b0, slv_reg15[15:8]};
  assign diff[30] = f_pixel[30] - g_pixel[30];

  assign f_pixel[31] = {1'b0, slv_reg7[7:0]};
  assign g_pixel[31] = {1'b0, slv_reg15[7:0]};
  assign diff[31] = f_pixel[31] - g_pixel[31];


  
  always @(posedge S_AXI_ACLK)
  begin
    if (S_AXI_ARESETN == 1'b0)
    begin
      abs_diff[0] <= 0;
      abs_diff[1] <= 0;
      abs_diff[2] <= 0;
      abs_diff[3] <= 0;
      abs_diff[4] <= 0;
      abs_diff[5] <= 0;
      abs_diff[6] <= 0;
      abs_diff[7] <= 0;
      abs_diff[8] <= 0;
      abs_diff[9] <= 0;
      abs_diff[10] <= 0;
      abs_diff[11] <= 0;
      abs_diff[12] <= 0;
      abs_diff[13] <= 0;
      abs_diff[14] <= 0;
      abs_diff[15] <= 0;
      abs_diff[16] <= 0;
      abs_diff[17] <= 0;
      abs_diff[18] <= 0;
      abs_diff[19] <= 0;
      abs_diff[20] <= 0;
      abs_diff[21] <= 0;
      abs_diff[22] <= 0;
      abs_diff[23] <= 0;
      abs_diff[24] <= 0;
      abs_diff[25] <= 0;
      abs_diff[26] <= 0;
      abs_diff[27] <= 0;
      abs_diff[28] <= 0;
      abs_diff[29] <= 0;
      abs_diff[30] <= 0;
      abs_diff[31] <= 0;
    end
    else 
    begin
      abs_diff[0] <= (diff[0][8] == 1'b1)? -diff[0] : diff[0];
      abs_diff[1] <= (diff[1][8] == 1'b1)? -diff[1] : diff[1];
      abs_diff[2] <= (diff[2][8] == 1'b1)? -diff[2] : diff[2];
      abs_diff[3] <= (diff[3][8] == 1'b1)? -diff[3] : diff[3];
      abs_diff[4] <= (diff[4][8] == 1'b1)? -diff[4] : diff[4];
      abs_diff[5] <= (diff[5][8] == 1'b1)? -diff[5] : diff[5];
      abs_diff[6] <= (diff[6][8] == 1'b1)? -diff[6] : diff[6];
      abs_diff[7] <= (diff[7][8] == 1'b1)? -diff[7] : diff[7];
      abs_diff[8] <= (diff[8][8] == 1'b1)? -diff[8] : diff[8];
      abs_diff[9] <= (diff[9][8] == 1'b1)? -diff[9] : diff[9];
      abs_diff[10] <= (diff[10][8] == 1'b1)? -diff[10] : diff[10];
      abs_diff[11] <= (diff[11][8] == 1'b1)? -diff[11] : diff[11];
      abs_diff[12] <= (diff[12][8] == 1'b1)? -diff[12] : diff[12];
      abs_diff[13] <= (diff[13][8] == 1'b1)? -diff[13] : diff[13];
      abs_diff[14] <= (diff[14][8] == 1'b1)? -diff[14] : diff[14];
      abs_diff[15] <= (diff[15][8] == 1'b1)? -diff[15] : diff[15];
      abs_diff[16] <= (diff[16][8] == 1'b1)? -diff[16] : diff[16];
      abs_diff[17] <= (diff[17][8] == 1'b1)? -diff[17] : diff[17];
      abs_diff[18] <= (diff[18][8] == 1'b1)? -diff[18] : diff[18];
      abs_diff[19] <= (diff[19][8] == 1'b1)? -diff[19] : diff[19];
      abs_diff[20] <= (diff[20][8] == 1'b1)? -diff[20] : diff[20];
      abs_diff[21] <= (diff[21][8] == 1'b1)? -diff[21] : diff[21];
      abs_diff[22] <= (diff[22][8] == 1'b1)? -diff[22] : diff[22];
      abs_diff[23] <= (diff[23][8] == 1'b1)? -diff[23] : diff[23];
      abs_diff[24] <= (diff[24][8] == 1'b1)? -diff[24] : diff[24];
      abs_diff[25] <= (diff[25][8] == 1'b1)? -diff[25] : diff[25];
      abs_diff[26] <= (diff[26][8] == 1'b1)? -diff[26] : diff[26];
      abs_diff[27] <= (diff[27][8] == 1'b1)? -diff[27] : diff[27];
      abs_diff[28] <= (diff[28][8] == 1'b1)? -diff[28] : diff[28];
      abs_diff[29] <= (diff[29][8] == 1'b1)? -diff[29] : diff[29];
      abs_diff[30] <= (diff[30][8] == 1'b1)? -diff[30] : diff[30];
      abs_diff[31] <= (diff[31][8] == 1'b1)? -diff[31] : diff[31];
    end
  end
  
   /****************************
  
        LEVEL TWO
      first layer of adder 
  
  
  *****************************/
  reg [31:0] temp_sum_1[0:7];
  wire [9:0] partial_sum_1[0:15];
  assign partial_sum_1[0] = abs_diff[0] + abs_diff[1];
  assign partial_sum_1[1] = abs_diff[2] + abs_diff[3];
  assign partial_sum_1[2] = abs_diff[4] + abs_diff[5];
  assign partial_sum_1[3] = abs_diff[6] + abs_diff[7];
  assign partial_sum_1[4] = abs_diff[8] + abs_diff[9];
  assign partial_sum_1[5] = abs_diff[10] + abs_diff[11];
  assign partial_sum_1[6] = abs_diff[12] + abs_diff[13];
  assign partial_sum_1[7] = abs_diff[14] + abs_diff[15];
  assign partial_sum_1[8] = abs_diff[16] + abs_diff[17];
  assign partial_sum_1[9] = abs_diff[18] + abs_diff[19];
  assign partial_sum_1[10] = abs_diff[20] + abs_diff[21];
  assign partial_sum_1[11] = abs_diff[22] + abs_diff[23];
  assign partial_sum_1[12] = abs_diff[24] + abs_diff[25];
  assign partial_sum_1[13] = abs_diff[26] + abs_diff[27];
  assign partial_sum_1[14] = abs_diff[28] + abs_diff[29];
  assign partial_sum_1[15] = abs_diff[30] + abs_diff[31];
  
  always @(posedge S_AXI_ACLK)
    begin
    if (S_AXI_ARESETN == 1'b0)
      begin 
        temp_sum_1[0] <= 0;
        temp_sum_1[1] <= 0;
        temp_sum_1[2] <= 0;
        temp_sum_1[3] <= 0;
        temp_sum_1[4] <= 0;
        temp_sum_1[5] <= 0;
        temp_sum_1[6] <= 0;
        temp_sum_1[7] <= 0;
      end
    else
      begin
        temp_sum_1[0] <= partial_sum_1[0] + partial_sum_1[1];
        temp_sum_1[1] <= partial_sum_1[2] + partial_sum_1[3];
        temp_sum_1[2] <= partial_sum_1[4] + partial_sum_1[5];
        temp_sum_1[3] <= partial_sum_1[6] + partial_sum_1[7];
        temp_sum_1[4] <= partial_sum_1[8] + partial_sum_1[9];
        temp_sum_1[5] <= partial_sum_1[10] + partial_sum_1[11];
        temp_sum_1[6] <= partial_sum_1[12] + partial_sum_1[13];
        temp_sum_1[7] <= partial_sum_1[14] + partial_sum_1[15];
      end
 end
 /****************************** 
   
           LEVEL THREE
         The second layer of adder
   
   *******************************/
   reg [31:0] temp_sum_2[0:1];
   wire [10:0] partial_sum_2[0:3];
   assign partial_sum_2[0] = temp_sum_1[0] + temp_sum_1[1];
   assign partial_sum_2[1] = temp_sum_1[2] + temp_sum_1[3];
   assign partial_sum_2[2] = temp_sum_1[4] + temp_sum_1[5];
   assign partial_sum_2[3] = temp_sum_1[6] + temp_sum_1[7];
 
   
   always @(posedge S_AXI_ACLK)
     begin
     if (S_AXI_ARESETN == 1'b0)
       begin 
         temp_sum_2[0] <= 0;
         temp_sum_2[1] <= 0;
       end
     else
       begin
         temp_sum_2[0] <= partial_sum_2[0] + partial_sum_2[1];
         temp_sum_2[1] <= partial_sum_2[2] + partial_sum_2[3];
       end
   end
  
   /***************************
   
           LEVEL Four
       The sad result output layer 
   
   ****************************/
  
   reg check;
   reg [31:0] sad_result;
   wire [11:0] partial_sum_3;
   assign partial_sum_3 = temp_sum_2[0] + temp_sum_2[1];
  
   always @(posedge S_AXI_ACLK)
     begin
     if (S_AXI_ARESETN == 1'b0)
       begin 
         sad_result <= 0;
         check <= 0;
       end
     else
       begin
        if(partial_sum_3 !=0 )
          begin
            sad_result <= partial_sum_3;
            check <= 1;
          end
        else 
          begin
            check <= check;
            sad_result <= sad_result;
          end
       end
   end
	// User logic ends

	endmodule
