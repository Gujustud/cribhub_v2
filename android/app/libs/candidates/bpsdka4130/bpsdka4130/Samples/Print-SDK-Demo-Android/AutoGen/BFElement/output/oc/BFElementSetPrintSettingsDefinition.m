

#import "BFElementSetPrintSettingsDefinition.h"

NSString * __nonnull const BFElementSetPrintSettingsStringMediaSize = @"MediaSize";
NSString * __nonnull const BFElementSetPrintSettingsStringImageOrientation = @"ImageOrientation";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintScalingMode = @"PrintScalingMode";
NSString * __nonnull const BFElementSetPrintSettingsStringImageHalftone = @"ImageHalftone";
NSString * __nonnull const BFElementSetPrintSettingsStringImageBrightness = @"ImageBrightness";
NSString * __nonnull const BFElementSetPrintSettingsStringImageContrast = @"ImageContrast";
NSString * __nonnull const BFElementSetPrintSettingsStringImageRedEnhancement = @"ImageRedEnhancement";
NSString * __nonnull const BFElementSetPrintSettingsStringImageGreenEnhancement = @"ImageGreenEnhancement";
NSString * __nonnull const BFElementSetPrintSettingsStringImageBlueEnhancement = @"ImageBlueEnhancement";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintHorizontalAlign = @"PrintHorizontalAlign";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintVerticalAlign = @"PrintVerticalAlign";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintTopMargin = @"PrintTopMargin";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintLeftMargin = @"PrintLeftMargin";
NSString * __nonnull const BFElementSetPrintSettingsStringMediaTextColor = @"MediaTextColor";
NSString * __nonnull const BFElementSetPrintSettingsStringMediaBackgroundColor = @"MediaBackgroundColor";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintScalingValue = @"PrintScalingValue";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintAutoCutLast = @"PrintAutoCutLast";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintAutoCutEvery = @"PrintAutoCutEvery";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintAutoCutEveryCyclePerPage = @"PrintAutoCutEveryCyclePerPage";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintAutoCutDisableForSpecialTape = @"PrintAutoCutDisableForSpecialTape";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintAutoHalfCut = @"PrintAutoHalfCut";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintDensity = @"PrintDensity";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintSpeed = @"PrintSpeed";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintDashLine = @"PrintDashLine";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintUsingCarbonCopyPaper = @"PrintUsingCarbonCopyPaper";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintFeedMode = @"PrintFeedMode";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintQuality = @"PrintQuality";
NSString * __nonnull const BFElementSetPrintSettingsStringMediaPJRollCase = @"MediaPJRollCase";
NSString * __nonnull const BFElementSetPrintSettingsStringMediaPaperInsertionPosition = @"MediaPaperInsertionPosition";
NSString * __nonnull const BFElementSetPrintSettingsStringMediaPJPaperType = @"MediaPJPaperType";
NSString * __nonnull const BFElementSetPrintSettingsStringMediaPJCustomSize = @"MediaPJCustomSize";
NSString * __nonnull const BFElementSetPrintSettingsStringMediaPJForceStretchPrintableArea = @"MediaPJForceStretchPrintableArea";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintExtraFeedDots = @"PrintExtraFeedDots";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintCopies = @"PrintCopies";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintBidirectionalCommunication = @"PrintBidirectionalCommunication";
NSString * __nonnull const BFElementSetPrintSettingsStringImageTrimBlankDataFromTail = @"ImageTrimBlankDataFromTail";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintPolicyOfProcessingPrintData = @"PrintPolicyOfProcessingPrintData";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintCollate = @"PrintCollate";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintCheckMediaTextColor = @"PrintCheckMediaTextColor";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintCheckMediaBackgroundColor = @"PrintCheckMediaBackgroundColor";
NSString * __nonnull const BFElementSetPrintSettingsStringPrintCutPause = @"PrintCutPause";
NSString * __nonnull const BFElementSetPrintSettingsString__Null = @"__Null";
@implementation BFElementSetPrintSettings
+ (nonnull NSString*)convertToString:(BFElementSetPrintSettingsNumber)num {
  switch(num) {
  case BFElementSetPrintSettingsNumberMediaSize: return BFElementSetPrintSettingsStringMediaSize;
  case BFElementSetPrintSettingsNumberImageOrientation: return BFElementSetPrintSettingsStringImageOrientation;
  case BFElementSetPrintSettingsNumberPrintScalingMode: return BFElementSetPrintSettingsStringPrintScalingMode;
  case BFElementSetPrintSettingsNumberImageHalftone: return BFElementSetPrintSettingsStringImageHalftone;
  case BFElementSetPrintSettingsNumberImageBrightness: return BFElementSetPrintSettingsStringImageBrightness;
  case BFElementSetPrintSettingsNumberImageContrast: return BFElementSetPrintSettingsStringImageContrast;
  case BFElementSetPrintSettingsNumberImageRedEnhancement: return BFElementSetPrintSettingsStringImageRedEnhancement;
  case BFElementSetPrintSettingsNumberImageGreenEnhancement: return BFElementSetPrintSettingsStringImageGreenEnhancement;
  case BFElementSetPrintSettingsNumberImageBlueEnhancement: return BFElementSetPrintSettingsStringImageBlueEnhancement;
  case BFElementSetPrintSettingsNumberPrintHorizontalAlign: return BFElementSetPrintSettingsStringPrintHorizontalAlign;
  case BFElementSetPrintSettingsNumberPrintVerticalAlign: return BFElementSetPrintSettingsStringPrintVerticalAlign;
  case BFElementSetPrintSettingsNumberPrintTopMargin: return BFElementSetPrintSettingsStringPrintTopMargin;
  case BFElementSetPrintSettingsNumberPrintLeftMargin: return BFElementSetPrintSettingsStringPrintLeftMargin;
  case BFElementSetPrintSettingsNumberMediaTextColor: return BFElementSetPrintSettingsStringMediaTextColor;
  case BFElementSetPrintSettingsNumberMediaBackgroundColor: return BFElementSetPrintSettingsStringMediaBackgroundColor;
  case BFElementSetPrintSettingsNumberPrintScalingValue: return BFElementSetPrintSettingsStringPrintScalingValue;
  case BFElementSetPrintSettingsNumberPrintAutoCutLast: return BFElementSetPrintSettingsStringPrintAutoCutLast;
  case BFElementSetPrintSettingsNumberPrintAutoCutEvery: return BFElementSetPrintSettingsStringPrintAutoCutEvery;
  case BFElementSetPrintSettingsNumberPrintAutoCutEveryCyclePerPage: return BFElementSetPrintSettingsStringPrintAutoCutEveryCyclePerPage;
  case BFElementSetPrintSettingsNumberPrintAutoCutDisableForSpecialTape: return BFElementSetPrintSettingsStringPrintAutoCutDisableForSpecialTape;
  case BFElementSetPrintSettingsNumberPrintAutoHalfCut: return BFElementSetPrintSettingsStringPrintAutoHalfCut;
  case BFElementSetPrintSettingsNumberPrintDensity: return BFElementSetPrintSettingsStringPrintDensity;
  case BFElementSetPrintSettingsNumberPrintSpeed: return BFElementSetPrintSettingsStringPrintSpeed;
  case BFElementSetPrintSettingsNumberPrintDashLine: return BFElementSetPrintSettingsStringPrintDashLine;
  case BFElementSetPrintSettingsNumberPrintUsingCarbonCopyPaper: return BFElementSetPrintSettingsStringPrintUsingCarbonCopyPaper;
  case BFElementSetPrintSettingsNumberPrintFeedMode: return BFElementSetPrintSettingsStringPrintFeedMode;
  case BFElementSetPrintSettingsNumberPrintQuality: return BFElementSetPrintSettingsStringPrintQuality;
  case BFElementSetPrintSettingsNumberMediaPJRollCase: return BFElementSetPrintSettingsStringMediaPJRollCase;
  case BFElementSetPrintSettingsNumberMediaPaperInsertionPosition: return BFElementSetPrintSettingsStringMediaPaperInsertionPosition;
  case BFElementSetPrintSettingsNumberMediaPJPaperType: return BFElementSetPrintSettingsStringMediaPJPaperType;
  case BFElementSetPrintSettingsNumberMediaPJCustomSize: return BFElementSetPrintSettingsStringMediaPJCustomSize;
  case BFElementSetPrintSettingsNumberMediaPJForceStretchPrintableArea: return BFElementSetPrintSettingsStringMediaPJForceStretchPrintableArea;
  case BFElementSetPrintSettingsNumberPrintExtraFeedDots: return BFElementSetPrintSettingsStringPrintExtraFeedDots;
  case BFElementSetPrintSettingsNumberPrintCopies: return BFElementSetPrintSettingsStringPrintCopies;
  case BFElementSetPrintSettingsNumberPrintBidirectionalCommunication: return BFElementSetPrintSettingsStringPrintBidirectionalCommunication;
  case BFElementSetPrintSettingsNumberImageTrimBlankDataFromTail: return BFElementSetPrintSettingsStringImageTrimBlankDataFromTail;
  case BFElementSetPrintSettingsNumberPrintPolicyOfProcessingPrintData: return BFElementSetPrintSettingsStringPrintPolicyOfProcessingPrintData;
  case BFElementSetPrintSettingsNumberPrintCollate: return BFElementSetPrintSettingsStringPrintCollate;
  case BFElementSetPrintSettingsNumberPrintCheckMediaTextColor: return BFElementSetPrintSettingsStringPrintCheckMediaTextColor;
  case BFElementSetPrintSettingsNumberPrintCheckMediaBackgroundColor: return BFElementSetPrintSettingsStringPrintCheckMediaBackgroundColor;
  case BFElementSetPrintSettingsNumberPrintCutPause: return BFElementSetPrintSettingsStringPrintCutPause;
  case BFElementSetPrintSettingsNumber__Null: return BFElementSetPrintSettingsString__Null;
  }
  return BFElementSetPrintSettingsString__Null;
}
+ (BFElementSetPrintSettingsNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementSetPrintSettingsStringMediaSize]) {
    return BFElementSetPrintSettingsNumberMediaSize;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringImageOrientation]) {
    return BFElementSetPrintSettingsNumberImageOrientation;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintScalingMode]) {
    return BFElementSetPrintSettingsNumberPrintScalingMode;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringImageHalftone]) {
    return BFElementSetPrintSettingsNumberImageHalftone;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringImageBrightness]) {
    return BFElementSetPrintSettingsNumberImageBrightness;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringImageContrast]) {
    return BFElementSetPrintSettingsNumberImageContrast;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringImageRedEnhancement]) {
    return BFElementSetPrintSettingsNumberImageRedEnhancement;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringImageGreenEnhancement]) {
    return BFElementSetPrintSettingsNumberImageGreenEnhancement;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringImageBlueEnhancement]) {
    return BFElementSetPrintSettingsNumberImageBlueEnhancement;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintHorizontalAlign]) {
    return BFElementSetPrintSettingsNumberPrintHorizontalAlign;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintVerticalAlign]) {
    return BFElementSetPrintSettingsNumberPrintVerticalAlign;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintTopMargin]) {
    return BFElementSetPrintSettingsNumberPrintTopMargin;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintLeftMargin]) {
    return BFElementSetPrintSettingsNumberPrintLeftMargin;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringMediaTextColor]) {
    return BFElementSetPrintSettingsNumberMediaTextColor;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringMediaBackgroundColor]) {
    return BFElementSetPrintSettingsNumberMediaBackgroundColor;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintScalingValue]) {
    return BFElementSetPrintSettingsNumberPrintScalingValue;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintAutoCutLast]) {
    return BFElementSetPrintSettingsNumberPrintAutoCutLast;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintAutoCutEvery]) {
    return BFElementSetPrintSettingsNumberPrintAutoCutEvery;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintAutoCutEveryCyclePerPage]) {
    return BFElementSetPrintSettingsNumberPrintAutoCutEveryCyclePerPage;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintAutoCutDisableForSpecialTape]) {
    return BFElementSetPrintSettingsNumberPrintAutoCutDisableForSpecialTape;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintAutoHalfCut]) {
    return BFElementSetPrintSettingsNumberPrintAutoHalfCut;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintDensity]) {
    return BFElementSetPrintSettingsNumberPrintDensity;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintSpeed]) {
    return BFElementSetPrintSettingsNumberPrintSpeed;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintDashLine]) {
    return BFElementSetPrintSettingsNumberPrintDashLine;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintUsingCarbonCopyPaper]) {
    return BFElementSetPrintSettingsNumberPrintUsingCarbonCopyPaper;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintFeedMode]) {
    return BFElementSetPrintSettingsNumberPrintFeedMode;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintQuality]) {
    return BFElementSetPrintSettingsNumberPrintQuality;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringMediaPJRollCase]) {
    return BFElementSetPrintSettingsNumberMediaPJRollCase;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringMediaPaperInsertionPosition]) {
    return BFElementSetPrintSettingsNumberMediaPaperInsertionPosition;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringMediaPJPaperType]) {
    return BFElementSetPrintSettingsNumberMediaPJPaperType;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringMediaPJCustomSize]) {
    return BFElementSetPrintSettingsNumberMediaPJCustomSize;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringMediaPJForceStretchPrintableArea]) {
    return BFElementSetPrintSettingsNumberMediaPJForceStretchPrintableArea;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintExtraFeedDots]) {
    return BFElementSetPrintSettingsNumberPrintExtraFeedDots;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintCopies]) {
    return BFElementSetPrintSettingsNumberPrintCopies;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintBidirectionalCommunication]) {
    return BFElementSetPrintSettingsNumberPrintBidirectionalCommunication;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringImageTrimBlankDataFromTail]) {
    return BFElementSetPrintSettingsNumberImageTrimBlankDataFromTail;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintPolicyOfProcessingPrintData]) {
    return BFElementSetPrintSettingsNumberPrintPolicyOfProcessingPrintData;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintCollate]) {
    return BFElementSetPrintSettingsNumberPrintCollate;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintCheckMediaTextColor]) {
    return BFElementSetPrintSettingsNumberPrintCheckMediaTextColor;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintCheckMediaBackgroundColor]) {
    return BFElementSetPrintSettingsNumberPrintCheckMediaBackgroundColor;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsStringPrintCutPause]) {
    return BFElementSetPrintSettingsNumberPrintCutPause;
  }
  if ([str isEqualToString:BFElementSetPrintSettingsString__Null]) {
    return BFElementSetPrintSettingsNumber__Null;
  }
  return BFElementSetPrintSettingsNumber__Null;
}
+ (nonnull NSString*)key {
  return @"PrintSettings";
}
@end

