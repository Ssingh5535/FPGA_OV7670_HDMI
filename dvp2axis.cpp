// dvp2axis.cpp
#include "dvp2axis.h"

void dvp2axis(
    bool                  vsync,
    bool                  href,
    bool                  pclk,
    ap_uint<8>            data_in,
    volatile Config      *cfg,
    hls::stream<AxisData> &m_axis
) {
    // ----------------------------
    // HLS INTERFACE PRAGMAS
    // (must be inside function)
    // ----------------------------
    #pragma HLS INTERFACE ap_none        port=vsync
    #pragma HLS INTERFACE ap_none        port=href
    #pragma HLS INTERFACE ap_none        port=pclk
    #pragma HLS INTERFACE ap_none        port=data_in

    #pragma HLS INTERFACE s_axilite      port=cfg      bundle=CTRL
    #pragma HLS INTERFACE axis           port=m_axis
    #pragma HLS INTERFACE ap_ctrl_none   port=return

    // (Optional: if you want to specify a separate clock port,
    //  you can add:  #pragma HLS INTERFACE ap_clk port=pclk )
    // By default HLS will use the top-level 'clk' port.

    // --------------------------------------
    // Begin your actual pixel-capture logic
    // --------------------------------------

    // Read config into locals (non-volatile)
    ap_uint<16> frame_width  = cfg->width;
    ap_uint<16> frame_height = cfg->height;

    static bool        in_frame = false;
    static ap_uint<16> x = 0, y = 0;

    AxisData out;
    out.data = 0;
    out.user = 0;
    out.last = 0;

    // On rising edge of pclk
    if (pclk) {
        if (vsync) {
            // New frame: reset
            in_frame = false;
            x = 0; y = 0;
        } else {
            // Detect start-of-frame
            if (!in_frame && href) {
                in_frame = true;
                out.user = 1;  // TUSER pulse
            }
            // During active video
            if (in_frame && href) {
                out.data = data_in;
                // End-of-line?
                if (x == frame_width - 1) {
                    out.last = 1;  // TLAST pulse
                    x = 0; y++;
                } else {
                    x++;
                }
                m_axis.write(out);
            }
            // End-of-frame?
            if (in_frame && (y == frame_height)) {
                in_frame = false;
            }
        }
    }
}
