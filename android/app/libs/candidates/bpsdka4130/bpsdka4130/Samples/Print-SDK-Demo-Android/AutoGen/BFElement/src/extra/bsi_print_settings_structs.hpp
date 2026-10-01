//
//  bsi_print_settings_structs.hpp
//  MacPrintSDK
//
//  Created by Yu Matsuo on 26/10/21.
//  Copyright © 2021 Brother Industries, Ltd. All rights reserved.
//

#pragma once

namespace bf {
namespace element {

struct MediaPJCustomSize{
    using DotCount = int;
    MediaPJCustomSize(const DotCount height, const DotCount width):height(height),width(width){};
    
    DotCount height;
    DotCount width;
    
    constexpr static const char * key = "MediaPJCustomSize";
};

}
}
