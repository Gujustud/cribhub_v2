//
//  BSIPrintSettingsStructs.m
//  MacPrintSDK
//
//  Created by Yu Matsuo on 12/10/21.
//  Copyright © 2021 Brother Industries, Ltd. All rights reserved.
//

#import "BSIPrintSettingsStructs.h"

@implementation BFElementMediaPJCustomSize
- (instancetype)initWithWidth:(DotCount)width height:(DotCount)height {
    self = [super init];
    if (self) {
        _height = height;
        _width = width;
    }
    return self;
}

+ (nonnull NSString*)key {
    return @"MediaPJCustomSize";
}
@end
