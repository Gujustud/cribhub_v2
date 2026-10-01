//
//  BSIPrintSettingsStructs.h
//  MacPrintSDK
//
//  Created by Yu Matsuo on 12/10/21.
//  Copyright © 2021 Brother Industries, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFElementMediaDefinition.h"

NS_ASSUME_NONNULL_BEGIN

typedef int DotCount;

@interface BFElementMediaPJCustomSize : NSObject
- (instancetype)initWithWidth:(DotCount)width height:(DotCount)height;
- (instancetype)init __attribute__((unavailable("init is not available")));
@property (nonatomic, readonly) DotCount height;
@property (nonatomic, readonly) DotCount width;
+ (nonnull NSString*)key;
@end

NS_ASSUME_NONNULL_END
