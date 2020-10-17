`define ENABLE                0        // : std_ulogic;               -- global enable
`define VSYNC_POLARITY        1        // : std_ulogic;               -- active high or low vertical sync
`define HSYNC_POLARITY        2        // : std_ulogic;               -- active high or low horizontal sync
`define DATA_ENABLE_POLARITY  3        // : std_ulogic;               -- active high or low data enable
`define VSYNC_WIDTH           4  +:14   // : unsigned (8 downto 0);    -- vertical sync pulse width in lines
`define HSYNC_WIDTH           18 +:14   // : unsigned (8 downto 0);    -- horizontal sync pulse width in clocks
`define VRES                  32 +:14  // : unsigned (10 downto 0);   -- 2k max vres (0 to vres - 1)
`define HRES                  46 +:14  // : unsigned (10 downto 0);   -- 2k max hres (0 to hres - 1)
`define VERT_BACK_PORCH       60 +:14   // : unsigned (8 downto 0);    -- vertical sync back porch in lines
`define VERT_FRONT_PORCH      74 +:14   //  : unsigned (8 downto 0);    -- vertical sync front porch in lines
`define HORIZ_BACK_PORCH      88 +:14   //  : unsigned (8 downto 0);    -- horizontal sync back porch in clocks
`define HORIZ_FRONT_PORCH     102 +:14   //  : unsigned (8 downto 0);    -- horizontal sync front porch in clocks
`define FRAMELOCK_ENABLE      116      //  : std_ulogic;               -- enable framelocking
`define FRAMELOCK_DELAY       117 +:14  //  : unsigned (21 downto 0);   -- delay for framelock vertical sync
`define FRAMELOCK_ALIGN_HSYNC 131      //  : std_ulogic;               -- align the hsync and vsync in framelock mode
`define FRAMELOCK_LINE_FRAC   132 +:14 //  : unsigned (10 downto 0);   -- fractional line increment in framelock mode

`define TC_HSBLNK             146 +:14 // : unsigned (10 downto 0); -- h starts blank
`define TC_HSSYNC             160 +:14 // : unsigned (10 downto 0); -- h starts sync pulse
`define TC_HESYNC             174 +:14 // : unsigned (10 downto 0); -- h ends sync pulse
`define TC_HEBLNK             188 +:14 // : unsigned (10 downto 0); -- h ends blank 
`define TC_VSBLNK             202 +:14 // : unsigned (10 downto 0); -- v starts blank
`define TC_VSSYNC             216 +:14 // : unsigned (10 downto 0); -- v starts sync pulse
`define TC_VESYNC             230 +:14 // : unsigned (10 downto 0); -- v ends sync pulse
`define TC_VEBLNK             244 +:14 // : unsigned (10 downto 0); -- v ends blank 

`define DISP_DTC_REGS_SIZE    258
