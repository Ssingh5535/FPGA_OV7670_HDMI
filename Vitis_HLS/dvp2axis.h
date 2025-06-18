// dvp2axis.h
#ifndef DVP2AXIS_H
#define DVP2AXIS_H

#include <ap_int.h>
#include <hls_stream.h>

// Control registers — exposed over AXI-Lite
struct Config {
    ap_uint<1>  enable;  // 1→start streaming
    ap_uint<16> width;   // pixels per line
    ap_uint<16> height;  // lines per frame
};

// AXI-Stream pixel struct
struct AxisData {
    ap_uint<16> data;  // pixel value (e.g. RGB565)
    ap_uint<1>  last;  // TLAST: end of line
    ap_uint<1>  user;  // TUSER: start of frame
};

// Top-level HLS function
void dvp2axis(
    bool                  vsync,      // frame sync
    bool                  href,       // line active
    bool                  pclk,       // pixel clock
    ap_uint<8>            data_in,    // camera D[7:0]
    volatile Config      *cfg,        // control regs
    hls::stream<AxisData> &m_axis     // AXI-Stream output
);

#endif // DVP2AXIS_H
