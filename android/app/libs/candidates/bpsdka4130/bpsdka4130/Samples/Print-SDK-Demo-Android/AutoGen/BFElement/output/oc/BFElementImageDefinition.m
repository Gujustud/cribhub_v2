

#import "BFElementImageDefinition.h"

@implementation BFElementImageBlueEnhancement
+ (nonnull NSString*)key {
  return @"ImageBlueEnhancement";
}
@end

@implementation BFElementImageBrightness
+ (nonnull NSString*)key {
  return @"ImageBrightness";
}
@end

@implementation BFElementImageContrast
+ (nonnull NSString*)key {
  return @"ImageContrast";
}
@end

@implementation BFElementImageGreenEnhancement
+ (nonnull NSString*)key {
  return @"ImageGreenEnhancement";
}
@end

NSString * __nonnull const BFElementImageHalftoneStringSimpleThreshold = @"SimpleThreshold";
NSString * __nonnull const BFElementImageHalftoneStringDither = @"Dither";
NSString * __nonnull const BFElementImageHalftoneStringErrorDiffusion = @"ErrorDiffusion";
NSString * __nonnull const BFElementImageHalftoneString__Null = @"__Null";
@implementation BFElementImageHalftone
+ (nonnull NSString*)convertToString:(BFElementImageHalftoneNumber)num {
  switch(num) {
  case BFElementImageHalftoneNumberSimpleThreshold: return BFElementImageHalftoneStringSimpleThreshold;
  case BFElementImageHalftoneNumberDither: return BFElementImageHalftoneStringDither;
  case BFElementImageHalftoneNumberErrorDiffusion: return BFElementImageHalftoneStringErrorDiffusion;
  case BFElementImageHalftoneNumber__Null: return BFElementImageHalftoneString__Null;
  }
  return BFElementImageHalftoneString__Null;
}
+ (BFElementImageHalftoneNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementImageHalftoneStringSimpleThreshold]) {
    return BFElementImageHalftoneNumberSimpleThreshold;
  }
  if ([str isEqualToString:BFElementImageHalftoneStringDither]) {
    return BFElementImageHalftoneNumberDither;
  }
  if ([str isEqualToString:BFElementImageHalftoneStringErrorDiffusion]) {
    return BFElementImageHalftoneNumberErrorDiffusion;
  }
  if ([str isEqualToString:BFElementImageHalftoneString__Null]) {
    return BFElementImageHalftoneNumber__Null;
  }
  return BFElementImageHalftoneNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ImageHalftone";
}
@end

NSString * __nonnull const BFElementImageOrientationStringPortrait = @"Portrait";
NSString * __nonnull const BFElementImageOrientationStringLandscape = @"Landscape";
NSString * __nonnull const BFElementImageOrientationString__Null = @"__Null";
@implementation BFElementImageOrientation
+ (nonnull NSString*)convertToString:(BFElementImageOrientationNumber)num {
  switch(num) {
  case BFElementImageOrientationNumberPortrait: return BFElementImageOrientationStringPortrait;
  case BFElementImageOrientationNumberLandscape: return BFElementImageOrientationStringLandscape;
  case BFElementImageOrientationNumber__Null: return BFElementImageOrientationString__Null;
  }
  return BFElementImageOrientationString__Null;
}
+ (BFElementImageOrientationNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementImageOrientationStringPortrait]) {
    return BFElementImageOrientationNumberPortrait;
  }
  if ([str isEqualToString:BFElementImageOrientationStringLandscape]) {
    return BFElementImageOrientationNumberLandscape;
  }
  if ([str isEqualToString:BFElementImageOrientationString__Null]) {
    return BFElementImageOrientationNumber__Null;
  }
  return BFElementImageOrientationNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ImageOrientation";
}
@end

@implementation BFElementImageRedEnhancement
+ (nonnull NSString*)key {
  return @"ImageRedEnhancement";
}
@end

@implementation BFElementImageTrimBlankDataFromTail
+ (nonnull NSString*)key {
  return @"ImageTrimBlankDataFromTail";
}
@end

