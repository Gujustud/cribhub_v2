

#import "BFElementPrintDefinition.h"

@implementation BFElementPrintAutoCutDisableForSpecialTape
+ (nonnull NSString*)key {
  return @"PrintAutoCutDisableForSpecialTape";
}
@end

@implementation BFElementPrintAutoCutEvery
+ (nonnull NSString*)key {
  return @"PrintAutoCutEvery";
}
@end

@implementation BFElementPrintAutoCutEveryCyclePerPage
+ (nonnull NSString*)key {
  return @"PrintAutoCutEveryCyclePerPage";
}
@end

@implementation BFElementPrintAutoCutLast
+ (nonnull NSString*)key {
  return @"PrintAutoCutLast";
}
@end

@implementation BFElementPrintAutoHalfCut
+ (nonnull NSString*)key {
  return @"PrintAutoHalfCut";
}
@end

@implementation BFElementPrintBidirectionalCommunication
+ (nonnull NSString*)key {
  return @"PrintBidirectionalCommunication";
}
@end

@implementation BFElementPrintCheckMediaBackgroundColor
+ (nonnull NSString*)key {
  return @"PrintCheckMediaBackgroundColor";
}
@end

@implementation BFElementPrintCheckMediaTextColor
+ (nonnull NSString*)key {
  return @"PrintCheckMediaTextColor";
}
@end

@implementation BFElementPrintCollate
+ (nonnull NSString*)key {
  return @"PrintCollate";
}
@end

@implementation BFElementPrintCopies
+ (nonnull NSString*)key {
  return @"PrintCopies";
}
@end

@implementation BFElementPrintCutPause
+ (nonnull NSString*)key {
  return @"PrintCutPause";
}
@end

@implementation BFElementPrintDashLine
+ (nonnull NSString*)key {
  return @"PrintDashLine";
}
@end

NSString * __nonnull const BFElementPrintDensityStringWeakLevel5 = @"WeakLevel5";
NSString * __nonnull const BFElementPrintDensityStringWeakLevel4 = @"WeakLevel4";
NSString * __nonnull const BFElementPrintDensityStringWeakLevel3 = @"WeakLevel3";
NSString * __nonnull const BFElementPrintDensityStringWeakLevel2 = @"WeakLevel2";
NSString * __nonnull const BFElementPrintDensityStringWeakLevel1 = @"WeakLevel1";
NSString * __nonnull const BFElementPrintDensityStringNeutral = @"Neutral";
NSString * __nonnull const BFElementPrintDensityStringStrongLevel1 = @"StrongLevel1";
NSString * __nonnull const BFElementPrintDensityStringStrongLevel2 = @"StrongLevel2";
NSString * __nonnull const BFElementPrintDensityStringStrongLevel3 = @"StrongLevel3";
NSString * __nonnull const BFElementPrintDensityStringStrongLevel4 = @"StrongLevel4";
NSString * __nonnull const BFElementPrintDensityStringStrongLevel5 = @"StrongLevel5";
NSString * __nonnull const BFElementPrintDensityStringUsePrinterSetting = @"UsePrinterSetting";
NSString * __nonnull const BFElementPrintDensityString__Null = @"__Null";
@implementation BFElementPrintDensity
+ (nonnull NSString*)convertToString:(BFElementPrintDensityNumber)num {
  switch(num) {
  case BFElementPrintDensityNumberWeakLevel5: return BFElementPrintDensityStringWeakLevel5;
  case BFElementPrintDensityNumberWeakLevel4: return BFElementPrintDensityStringWeakLevel4;
  case BFElementPrintDensityNumberWeakLevel3: return BFElementPrintDensityStringWeakLevel3;
  case BFElementPrintDensityNumberWeakLevel2: return BFElementPrintDensityStringWeakLevel2;
  case BFElementPrintDensityNumberWeakLevel1: return BFElementPrintDensityStringWeakLevel1;
  case BFElementPrintDensityNumberNeutral: return BFElementPrintDensityStringNeutral;
  case BFElementPrintDensityNumberStrongLevel1: return BFElementPrintDensityStringStrongLevel1;
  case BFElementPrintDensityNumberStrongLevel2: return BFElementPrintDensityStringStrongLevel2;
  case BFElementPrintDensityNumberStrongLevel3: return BFElementPrintDensityStringStrongLevel3;
  case BFElementPrintDensityNumberStrongLevel4: return BFElementPrintDensityStringStrongLevel4;
  case BFElementPrintDensityNumberStrongLevel5: return BFElementPrintDensityStringStrongLevel5;
  case BFElementPrintDensityNumberUsePrinterSetting: return BFElementPrintDensityStringUsePrinterSetting;
  case BFElementPrintDensityNumber__Null: return BFElementPrintDensityString__Null;
  }
  return BFElementPrintDensityString__Null;
}
+ (BFElementPrintDensityNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementPrintDensityStringWeakLevel5]) {
    return BFElementPrintDensityNumberWeakLevel5;
  }
  if ([str isEqualToString:BFElementPrintDensityStringWeakLevel4]) {
    return BFElementPrintDensityNumberWeakLevel4;
  }
  if ([str isEqualToString:BFElementPrintDensityStringWeakLevel3]) {
    return BFElementPrintDensityNumberWeakLevel3;
  }
  if ([str isEqualToString:BFElementPrintDensityStringWeakLevel2]) {
    return BFElementPrintDensityNumberWeakLevel2;
  }
  if ([str isEqualToString:BFElementPrintDensityStringWeakLevel1]) {
    return BFElementPrintDensityNumberWeakLevel1;
  }
  if ([str isEqualToString:BFElementPrintDensityStringNeutral]) {
    return BFElementPrintDensityNumberNeutral;
  }
  if ([str isEqualToString:BFElementPrintDensityStringStrongLevel1]) {
    return BFElementPrintDensityNumberStrongLevel1;
  }
  if ([str isEqualToString:BFElementPrintDensityStringStrongLevel2]) {
    return BFElementPrintDensityNumberStrongLevel2;
  }
  if ([str isEqualToString:BFElementPrintDensityStringStrongLevel3]) {
    return BFElementPrintDensityNumberStrongLevel3;
  }
  if ([str isEqualToString:BFElementPrintDensityStringStrongLevel4]) {
    return BFElementPrintDensityNumberStrongLevel4;
  }
  if ([str isEqualToString:BFElementPrintDensityStringStrongLevel5]) {
    return BFElementPrintDensityNumberStrongLevel5;
  }
  if ([str isEqualToString:BFElementPrintDensityStringUsePrinterSetting]) {
    return BFElementPrintDensityNumberUsePrinterSetting;
  }
  if ([str isEqualToString:BFElementPrintDensityString__Null]) {
    return BFElementPrintDensityNumber__Null;
  }
  return BFElementPrintDensityNumber__Null;
}
+ (nonnull NSString*)key {
  return @"PrintDensity";
}
@end

@implementation BFElementPrintExtraFeedDots
+ (nonnull NSString*)key {
  return @"PrintExtraFeedDots";
}
@end

NSString * __nonnull const BFElementPrintFeedModeStringNoFeed = @"NoFeed";
NSString * __nonnull const BFElementPrintFeedModeStringFixedPage = @"FixedPage";
NSString * __nonnull const BFElementPrintFeedModeStringEndOfPage = @"EndOfPage";
NSString * __nonnull const BFElementPrintFeedModeStringEndOfPageRetract = @"EndOfPageRetract";
NSString * __nonnull const BFElementPrintFeedModeString__Null = @"__Null";
@implementation BFElementPrintFeedMode
+ (nonnull NSString*)convertToString:(BFElementPrintFeedModeNumber)num {
  switch(num) {
  case BFElementPrintFeedModeNumberNoFeed: return BFElementPrintFeedModeStringNoFeed;
  case BFElementPrintFeedModeNumberFixedPage: return BFElementPrintFeedModeStringFixedPage;
  case BFElementPrintFeedModeNumberEndOfPage: return BFElementPrintFeedModeStringEndOfPage;
  case BFElementPrintFeedModeNumberEndOfPageRetract: return BFElementPrintFeedModeStringEndOfPageRetract;
  case BFElementPrintFeedModeNumber__Null: return BFElementPrintFeedModeString__Null;
  }
  return BFElementPrintFeedModeString__Null;
}
+ (BFElementPrintFeedModeNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementPrintFeedModeStringNoFeed]) {
    return BFElementPrintFeedModeNumberNoFeed;
  }
  if ([str isEqualToString:BFElementPrintFeedModeStringFixedPage]) {
    return BFElementPrintFeedModeNumberFixedPage;
  }
  if ([str isEqualToString:BFElementPrintFeedModeStringEndOfPage]) {
    return BFElementPrintFeedModeNumberEndOfPage;
  }
  if ([str isEqualToString:BFElementPrintFeedModeStringEndOfPageRetract]) {
    return BFElementPrintFeedModeNumberEndOfPageRetract;
  }
  if ([str isEqualToString:BFElementPrintFeedModeString__Null]) {
    return BFElementPrintFeedModeNumber__Null;
  }
  return BFElementPrintFeedModeNumber__Null;
}
+ (nonnull NSString*)key {
  return @"PrintFeedMode";
}
@end

NSString * __nonnull const BFElementPrintHorizontalAlignStringLeft = @"Left";
NSString * __nonnull const BFElementPrintHorizontalAlignStringCenter = @"Center";
NSString * __nonnull const BFElementPrintHorizontalAlignStringRight = @"Right";
NSString * __nonnull const BFElementPrintHorizontalAlignString__Null = @"__Null";
@implementation BFElementPrintHorizontalAlign
+ (nonnull NSString*)convertToString:(BFElementPrintHorizontalAlignNumber)num {
  switch(num) {
  case BFElementPrintHorizontalAlignNumberLeft: return BFElementPrintHorizontalAlignStringLeft;
  case BFElementPrintHorizontalAlignNumberCenter: return BFElementPrintHorizontalAlignStringCenter;
  case BFElementPrintHorizontalAlignNumberRight: return BFElementPrintHorizontalAlignStringRight;
  case BFElementPrintHorizontalAlignNumber__Null: return BFElementPrintHorizontalAlignString__Null;
  }
  return BFElementPrintHorizontalAlignString__Null;
}
+ (BFElementPrintHorizontalAlignNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementPrintHorizontalAlignStringLeft]) {
    return BFElementPrintHorizontalAlignNumberLeft;
  }
  if ([str isEqualToString:BFElementPrintHorizontalAlignStringCenter]) {
    return BFElementPrintHorizontalAlignNumberCenter;
  }
  if ([str isEqualToString:BFElementPrintHorizontalAlignStringRight]) {
    return BFElementPrintHorizontalAlignNumberRight;
  }
  if ([str isEqualToString:BFElementPrintHorizontalAlignString__Null]) {
    return BFElementPrintHorizontalAlignNumber__Null;
  }
  return BFElementPrintHorizontalAlignNumber__Null;
}
+ (nonnull NSString*)key {
  return @"PrintHorizontalAlign";
}
@end

@implementation BFElementPrintLeftMargin
+ (nonnull NSString*)key {
  return @"PrintLeftMargin";
}
@end

NSString * __nonnull const BFElementPrintPolicyOfProcessingPrintDataStringBatchPrint = @"BatchPrint";
NSString * __nonnull const BFElementPrintPolicyOfProcessingPrintDataStringRealTimePrint = @"RealTimePrint";
NSString * __nonnull const BFElementPrintPolicyOfProcessingPrintDataString__Null = @"__Null";
@implementation BFElementPrintPolicyOfProcessingPrintData
+ (nonnull NSString*)convertToString:(BFElementPrintPolicyOfProcessingPrintDataNumber)num {
  switch(num) {
  case BFElementPrintPolicyOfProcessingPrintDataNumberBatchPrint: return BFElementPrintPolicyOfProcessingPrintDataStringBatchPrint;
  case BFElementPrintPolicyOfProcessingPrintDataNumberRealTimePrint: return BFElementPrintPolicyOfProcessingPrintDataStringRealTimePrint;
  case BFElementPrintPolicyOfProcessingPrintDataNumber__Null: return BFElementPrintPolicyOfProcessingPrintDataString__Null;
  }
  return BFElementPrintPolicyOfProcessingPrintDataString__Null;
}
+ (BFElementPrintPolicyOfProcessingPrintDataNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementPrintPolicyOfProcessingPrintDataStringBatchPrint]) {
    return BFElementPrintPolicyOfProcessingPrintDataNumberBatchPrint;
  }
  if ([str isEqualToString:BFElementPrintPolicyOfProcessingPrintDataStringRealTimePrint]) {
    return BFElementPrintPolicyOfProcessingPrintDataNumberRealTimePrint;
  }
  if ([str isEqualToString:BFElementPrintPolicyOfProcessingPrintDataString__Null]) {
    return BFElementPrintPolicyOfProcessingPrintDataNumber__Null;
  }
  return BFElementPrintPolicyOfProcessingPrintDataNumber__Null;
}
+ (nonnull NSString*)key {
  return @"PrintPolicyOfProcessingPrintData";
}
@end

NSString * __nonnull const BFElementPrintQualityStringLowResolutionHighSpeed = @"LowResolutionHighSpeed";
NSString * __nonnull const BFElementPrintQualityStringNormalResolutionNormalSpeed = @"NormalResolutionNormalSpeed";
NSString * __nonnull const BFElementPrintQualityStringNormalResolutionDoubleSpeed = @"NormalResolutionDoubleSpeed";
NSString * __nonnull const BFElementPrintQualityStringHighResolutionLowSpeed = @"HighResolutionLowSpeed";
NSString * __nonnull const BFElementPrintQualityStringHighResolutionUsingHRImageLowSpeed = @"HighResolutionUsingHRImageLowSpeed";
NSString * __nonnull const BFElementPrintQualityString__Null = @"__Null";
@implementation BFElementPrintQuality
+ (nonnull NSString*)convertToString:(BFElementPrintQualityNumber)num {
  switch(num) {
  case BFElementPrintQualityNumberLowResolutionHighSpeed: return BFElementPrintQualityStringLowResolutionHighSpeed;
  case BFElementPrintQualityNumberNormalResolutionNormalSpeed: return BFElementPrintQualityStringNormalResolutionNormalSpeed;
  case BFElementPrintQualityNumberNormalResolutionDoubleSpeed: return BFElementPrintQualityStringNormalResolutionDoubleSpeed;
  case BFElementPrintQualityNumberHighResolutionLowSpeed: return BFElementPrintQualityStringHighResolutionLowSpeed;
  case BFElementPrintQualityNumberHighResolutionUsingHRImageLowSpeed: return BFElementPrintQualityStringHighResolutionUsingHRImageLowSpeed;
  case BFElementPrintQualityNumber__Null: return BFElementPrintQualityString__Null;
  }
  return BFElementPrintQualityString__Null;
}
+ (BFElementPrintQualityNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementPrintQualityStringLowResolutionHighSpeed]) {
    return BFElementPrintQualityNumberLowResolutionHighSpeed;
  }
  if ([str isEqualToString:BFElementPrintQualityStringNormalResolutionNormalSpeed]) {
    return BFElementPrintQualityNumberNormalResolutionNormalSpeed;
  }
  if ([str isEqualToString:BFElementPrintQualityStringNormalResolutionDoubleSpeed]) {
    return BFElementPrintQualityNumberNormalResolutionDoubleSpeed;
  }
  if ([str isEqualToString:BFElementPrintQualityStringHighResolutionLowSpeed]) {
    return BFElementPrintQualityNumberHighResolutionLowSpeed;
  }
  if ([str isEqualToString:BFElementPrintQualityStringHighResolutionUsingHRImageLowSpeed]) {
    return BFElementPrintQualityNumberHighResolutionUsingHRImageLowSpeed;
  }
  if ([str isEqualToString:BFElementPrintQualityString__Null]) {
    return BFElementPrintQualityNumber__Null;
  }
  return BFElementPrintQualityNumber__Null;
}
+ (nonnull NSString*)key {
  return @"PrintQuality";
}
@end

NSString * __nonnull const BFElementPrintScalingModeStringOriginal = @"Original";
NSString * __nonnull const BFElementPrintScalingModeStringFitToPrintArea = @"FitToPrintArea";
NSString * __nonnull const BFElementPrintScalingModeStringFitToPaper = @"FitToPaper";
NSString * __nonnull const BFElementPrintScalingModeStringCustom = @"Custom";
NSString * __nonnull const BFElementPrintScalingModeString__Null = @"__Null";
@implementation BFElementPrintScalingMode
+ (nonnull NSString*)convertToString:(BFElementPrintScalingModeNumber)num {
  switch(num) {
  case BFElementPrintScalingModeNumberOriginal: return BFElementPrintScalingModeStringOriginal;
  case BFElementPrintScalingModeNumberFitToPrintArea: return BFElementPrintScalingModeStringFitToPrintArea;
  case BFElementPrintScalingModeNumberFitToPaper: return BFElementPrintScalingModeStringFitToPaper;
  case BFElementPrintScalingModeNumberCustom: return BFElementPrintScalingModeStringCustom;
  case BFElementPrintScalingModeNumber__Null: return BFElementPrintScalingModeString__Null;
  }
  return BFElementPrintScalingModeString__Null;
}
+ (BFElementPrintScalingModeNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementPrintScalingModeStringOriginal]) {
    return BFElementPrintScalingModeNumberOriginal;
  }
  if ([str isEqualToString:BFElementPrintScalingModeStringFitToPrintArea]) {
    return BFElementPrintScalingModeNumberFitToPrintArea;
  }
  if ([str isEqualToString:BFElementPrintScalingModeStringFitToPaper]) {
    return BFElementPrintScalingModeNumberFitToPaper;
  }
  if ([str isEqualToString:BFElementPrintScalingModeStringCustom]) {
    return BFElementPrintScalingModeNumberCustom;
  }
  if ([str isEqualToString:BFElementPrintScalingModeString__Null]) {
    return BFElementPrintScalingModeNumber__Null;
  }
  return BFElementPrintScalingModeNumber__Null;
}
+ (nonnull NSString*)key {
  return @"PrintScalingMode";
}
@end

@implementation BFElementPrintScalingValue
+ (nonnull NSString*)key {
  return @"PrintScalingValue";
}
@end

NSString * __nonnull const BFElementPrintSpeedStringHighSpeed = @"HighSpeed";
NSString * __nonnull const BFElementPrintSpeedStringMediumHighSpeed = @"MediumHighSpeed";
NSString * __nonnull const BFElementPrintSpeedStringMediumLowSpeed = @"MediumLowSpeed";
NSString * __nonnull const BFElementPrintSpeedStringLowSpeed = @"LowSpeed";
NSString * __nonnull const BFElementPrintSpeedStringFast_DraftQuality = @"Fast_DraftQuality";
NSString * __nonnull const BFElementPrintSpeedStringFast_LineConversion = @"Fast_LineConversion";
NSString * __nonnull const BFElementPrintSpeedStringUsePrinterSetting = @"UsePrinterSetting";
NSString * __nonnull const BFElementPrintSpeedString__Null = @"__Null";
@implementation BFElementPrintSpeed
+ (nonnull NSString*)convertToString:(BFElementPrintSpeedNumber)num {
  switch(num) {
  case BFElementPrintSpeedNumberHighSpeed: return BFElementPrintSpeedStringHighSpeed;
  case BFElementPrintSpeedNumberMediumHighSpeed: return BFElementPrintSpeedStringMediumHighSpeed;
  case BFElementPrintSpeedNumberMediumLowSpeed: return BFElementPrintSpeedStringMediumLowSpeed;
  case BFElementPrintSpeedNumberLowSpeed: return BFElementPrintSpeedStringLowSpeed;
  case BFElementPrintSpeedNumberFast_DraftQuality: return BFElementPrintSpeedStringFast_DraftQuality;
  case BFElementPrintSpeedNumberFast_LineConversion: return BFElementPrintSpeedStringFast_LineConversion;
  case BFElementPrintSpeedNumberUsePrinterSetting: return BFElementPrintSpeedStringUsePrinterSetting;
  case BFElementPrintSpeedNumber__Null: return BFElementPrintSpeedString__Null;
  }
  return BFElementPrintSpeedString__Null;
}
+ (BFElementPrintSpeedNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementPrintSpeedStringHighSpeed]) {
    return BFElementPrintSpeedNumberHighSpeed;
  }
  if ([str isEqualToString:BFElementPrintSpeedStringMediumHighSpeed]) {
    return BFElementPrintSpeedNumberMediumHighSpeed;
  }
  if ([str isEqualToString:BFElementPrintSpeedStringMediumLowSpeed]) {
    return BFElementPrintSpeedNumberMediumLowSpeed;
  }
  if ([str isEqualToString:BFElementPrintSpeedStringLowSpeed]) {
    return BFElementPrintSpeedNumberLowSpeed;
  }
  if ([str isEqualToString:BFElementPrintSpeedStringFast_DraftQuality]) {
    return BFElementPrintSpeedNumberFast_DraftQuality;
  }
  if ([str isEqualToString:BFElementPrintSpeedStringFast_LineConversion]) {
    return BFElementPrintSpeedNumberFast_LineConversion;
  }
  if ([str isEqualToString:BFElementPrintSpeedStringUsePrinterSetting]) {
    return BFElementPrintSpeedNumberUsePrinterSetting;
  }
  if ([str isEqualToString:BFElementPrintSpeedString__Null]) {
    return BFElementPrintSpeedNumber__Null;
  }
  return BFElementPrintSpeedNumber__Null;
}
+ (nonnull NSString*)key {
  return @"PrintSpeed";
}
@end

@implementation BFElementPrintTopMargin
+ (nonnull NSString*)key {
  return @"PrintTopMargin";
}
@end

@implementation BFElementPrintUsingCarbonCopyPaper
+ (nonnull NSString*)key {
  return @"PrintUsingCarbonCopyPaper";
}
@end

NSString * __nonnull const BFElementPrintVerticalAlignStringTop = @"Top";
NSString * __nonnull const BFElementPrintVerticalAlignStringMiddle = @"Middle";
NSString * __nonnull const BFElementPrintVerticalAlignStringBottom = @"Bottom";
NSString * __nonnull const BFElementPrintVerticalAlignString__Null = @"__Null";
@implementation BFElementPrintVerticalAlign
+ (nonnull NSString*)convertToString:(BFElementPrintVerticalAlignNumber)num {
  switch(num) {
  case BFElementPrintVerticalAlignNumberTop: return BFElementPrintVerticalAlignStringTop;
  case BFElementPrintVerticalAlignNumberMiddle: return BFElementPrintVerticalAlignStringMiddle;
  case BFElementPrintVerticalAlignNumberBottom: return BFElementPrintVerticalAlignStringBottom;
  case BFElementPrintVerticalAlignNumber__Null: return BFElementPrintVerticalAlignString__Null;
  }
  return BFElementPrintVerticalAlignString__Null;
}
+ (BFElementPrintVerticalAlignNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementPrintVerticalAlignStringTop]) {
    return BFElementPrintVerticalAlignNumberTop;
  }
  if ([str isEqualToString:BFElementPrintVerticalAlignStringMiddle]) {
    return BFElementPrintVerticalAlignNumberMiddle;
  }
  if ([str isEqualToString:BFElementPrintVerticalAlignStringBottom]) {
    return BFElementPrintVerticalAlignNumberBottom;
  }
  if ([str isEqualToString:BFElementPrintVerticalAlignString__Null]) {
    return BFElementPrintVerticalAlignNumber__Null;
  }
  return BFElementPrintVerticalAlignNumber__Null;
}
+ (nonnull NSString*)key {
  return @"PrintVerticalAlign";
}
@end

