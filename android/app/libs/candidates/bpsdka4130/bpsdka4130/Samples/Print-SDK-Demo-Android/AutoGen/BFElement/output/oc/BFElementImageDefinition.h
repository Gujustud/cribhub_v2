

#pragma once
#import <Foundation/Foundation.h>

typedef int BFElementImageBlueEnhancementNumber;
@interface BFElementImageBlueEnhancement : NSObject
+ (nonnull NSString*)key;
@end

typedef int BFElementImageBrightnessNumber;
@interface BFElementImageBrightness : NSObject
+ (nonnull NSString*)key;
@end

typedef int BFElementImageContrastNumber;
@interface BFElementImageContrast : NSObject
+ (nonnull NSString*)key;
@end

typedef int BFElementImageGreenEnhancementNumber;
@interface BFElementImageGreenEnhancement : NSObject
+ (nonnull NSString*)key;
@end

typedef NS_ENUM(NSUInteger, BFElementImageHalftoneNumber) {
  BFElementImageHalftoneNumberSimpleThreshold,
  BFElementImageHalftoneNumberDither,
  BFElementImageHalftoneNumberErrorDiffusion,
  BFElementImageHalftoneNumber__Null,
};
extern NSString * __nonnull const BFElementImageHalftoneStringSimpleThreshold;
extern NSString * __nonnull const BFElementImageHalftoneStringDither;
extern NSString * __nonnull const BFElementImageHalftoneStringErrorDiffusion;
extern NSString * __nonnull const BFElementImageHalftoneString__Null;
@interface BFElementImageHalftone : NSObject
+ (nonnull NSString*)convertToString:(BFElementImageHalftoneNumber)num;
+ (BFElementImageHalftoneNumber)convertToNumber:(nonnull NSString*)str;
+ (nonnull NSString*)key;
@end

typedef NS_ENUM(NSUInteger, BFElementImageOrientationNumber) {
  BFElementImageOrientationNumberPortrait,
  BFElementImageOrientationNumberLandscape,
  BFElementImageOrientationNumber__Null,
};
extern NSString * __nonnull const BFElementImageOrientationStringPortrait;
extern NSString * __nonnull const BFElementImageOrientationStringLandscape;
extern NSString * __nonnull const BFElementImageOrientationString__Null;
@interface BFElementImageOrientation : NSObject
+ (nonnull NSString*)convertToString:(BFElementImageOrientationNumber)num;
+ (BFElementImageOrientationNumber)convertToNumber:(nonnull NSString*)str;
+ (nonnull NSString*)key;
@end

typedef int BFElementImageRedEnhancementNumber;
@interface BFElementImageRedEnhancement : NSObject
+ (nonnull NSString*)key;
@end

typedef bool BFElementImageTrimBlankDataFromTailNumber;
@interface BFElementImageTrimBlankDataFromTail : NSObject
+ (nonnull NSString*)key;
@end

