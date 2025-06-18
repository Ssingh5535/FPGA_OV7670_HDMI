// tb_dvp2axis.cpp
#include "dvp2axis.h"
#include <iostream>
#include <hls_stream.h>
#include <cstdint>

int main() {
    // 1) configure a tiny test frame
    Config cfg;
    cfg.enable = 1;
    cfg.width  = 4;  // 4 pixels per line
    cfg.height = 2;  // 2 lines

    hls::stream<AxisData> out_stream;

    // 2) pulse VSYNC once
    bool vsync = 1, href = 0, pclk = 1;
    dvp2axis(vsync, href, pclk, 0, &cfg, out_stream);

    // 3) stream two lines × four pixels
    vsync = 0;
    for (int row = 0; row < cfg.height; row++) {
        for (int col = 0; col < cfg.width; col++) {
            href = 1;
            ap_uint<8> px = col + row * cfg.width;  // test pattern

            // low→high pclk
            pclk = 0; dvp2axis(vsync, href, pclk, px, &cfg, out_stream);
            pclk = 1; dvp2axis(vsync, href, pclk, px, &cfg, out_stream);

            // read & print
            if (!out_stream.empty()) {
                AxisData d = out_stream.read();
                uint16_t data_val = d.data.to_uint();
                uint8_t  user_val = d.user.to_uint();
                uint8_t  last_val = d.last.to_uint();
                std::cout << "row=" << row
                          << " col=" << col
                          << " data=" << data_val
                          << " user=" << int(user_val)
                          << " last=" << int(last_val)
                          << std::endl;
            }
        }
        // end-of-line clean-up
        href = 0;
        pclk = 1; dvp2axis(vsync, href, pclk, 0, &cfg, out_stream);
    }

    std::cout << "Testbench complete." << std::endl;
    return 0;
}
