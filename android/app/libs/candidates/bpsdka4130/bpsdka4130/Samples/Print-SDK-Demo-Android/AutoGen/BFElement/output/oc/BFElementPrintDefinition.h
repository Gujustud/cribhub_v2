

#pragma once
#import <Foundation/Foundation.h>

typedef bool BFElementPrintAutoCutDisableForSpecialTapeNumber;
@interface BFElementPrintAutoCutDisableForSpecialTape : NSObject
+ (nonnull NSString*)key;
@end

typedef bool BFElementPrintAutoCutEveryNumber;
@interface BFElementPrintAutoCutEvery : NSObject
+ (nonnull NSString*)key;
@end

typedef int BFElementPrintAutoCutEveryCyclePerPageNumber;
@interface BFElementPrintAutoCutEveryCyclePerPage : NSObject
+ (nonnull NSString*)key;
@end

typedef bool BFElementPrintAutoCutLastNumber;
@interface BFElementPrintAutoCutLast : NSObject
+ (nonnull NSString*)key;
@end

typedef bool BFElementPrintAutoHalfCutNumber;
@interface BFElementPrintAutoHalfCut : NSObject
+ (nonnull NSString*)key;
@end

typedef bool BFElementPrintBidirectionalCommunicationNumber;
@interface BFElementPrintBidirectionalCommunication : NSObject
+ (nonnull NSString*)key;
@end

typedef bool BFElementPrintCheckMediaBackgroundColorNumber;
@interface BFElementPrintCheckMediaBackgroundColor : NSObject
+ (nonnull NSString*)key;
@end

typedef bool BFElementPrintCheckMediaTextColorNumber;
@interface BFElementPrintCheckMediaTextColor : NSObject
+ (nonnull NSString*)key;
@end

typedef bool BFElementPrintCollateNumber;
@interface BFElementPrintCollate : NSObject
+ (nonnull NSString*)key;
@end

typedef int BFElementPrintCopiesNumber;
@interface BFElementPrintCopies : NSObject
+ (nonnull NSString*)key;
@end

typedef bool BFElementPrintCutPauseNumber;
@interface BFElementPrintCutPause : NSObject
+ (nonnull NSString*)key;
@end

typedef bool BFElementPrintDashLineNumber;
@interface BFElementPrintDashLine : NSObject
+ (nonnull NSString*)key;
@end

typedef NS_ENUM(NSUInteger, BFElementPrintDensityNumber) {
  BFElementPrintDensityNumberWeakLevel5,
  BFElementPrintDensityNumberWeakLevel4,
  BFElementPrintDensityNumberWeakLevel3,
  BFElementPrintDensityNumberWeakLevel2,
  BFElementPrintDensityNumberWeakLevel1,
  BFElementPrintDensityNumberNeutral,
  BFElementPrintDensityNumberStrongLevel1,
  BFElementPrintDensityNumberStrongLevel2,
  BFElementPrintDensityNumberStrongLevel3,
  BFElementPrintDensityNumberStrongLevel4,
  BFElementPrintDensityNumberStrongLevel5,
  BFElementPrintDensityNumberUsePrinterSetting,
  BFElementPrintDensityNumber__Null,
};
extern NSString * __nonnull const BFElementPrintDensityStringWeakLevel5;
extern NSString * __nonnull const BFElementPrintDensityStringWeakLevel4;
extern NSString * __nonnull const BFElementPrintDensityStringWeakLevel3;
extern NSString * __nonnull const BFElementPrintDensityStringWeakLevel2;
extern NSString * __nonnull const BFElementPrintDensityStringWeakLevel1;
extern NSString * __nonnull const BFElementPrintDensityStringNeutral;
extern NSString * __nonnull const BFElementPrintDensityStringStrongLevel1;
extern NSString * __nonnull const BFElementPrintDensityStringStrongLevel2;
extern NSString * __nonnull const BFElementPrintDensityStringStrongLevel3;
extern NSString * __nonnull const BFElementPrintDensityStringStrongLevel4;
extern NSString * __nonnull const BFElementPrintDensityStringStrongLevel5;
extern NSString * __nonnull const BFElementPrintDensityStringUsePrinterSetting;
extern NSString * __nonnull const BFElementPrintDensityString__Null;
@interface BFElementPrintDensity : NSObject
+ (nonnull NSString*)convertToString:(BFElementPrintDensityNumber)num;
+ (BFElementPrintDensityNumber)convertToNumber:(nonnull NSString*)str;
+ (nonnull NSString*)key;
@end

typedef int BFElementPrintExtraFeedDotsNumber;
@interface BFElementPrintExtraFeedDots : NSObject
+ (nonnull NSString*)key;
@end

typedef NS_ENUM(NSUInteger, BFElementPrintFeedModeNumber) {
  BFElementPrintFeedModeNumberNoFeed,
  BFElementPrintFeedModeNumberFixedPage,
  BFElementPrintFeedModeNumberEndOfPage,
  BFElementPrintFeedModeNumberEndOfPageRetract,
  BFElementPrintFeedModeNumber__Null,
};
extern NSString * __nonnull const BFElementPrintFeedModeStringNoFeed;
extern NSString * __nonnull const BFElementPrintFeedModeStringFixedPage;
extern NSString * __nonnull const BFElementPrintFeedModeStringEndOfPage;
extern NSString * __nonnull const BFElementPrintFeedModeStringEndOfPageRetract;
extern NSString * __nonnull const BFElementPrintFeedModeString__Null;
@interface BFElementPrintFeedMode : NSObject
+ (nonnull NSString*)convertToString:(BFElementPrintFeedModeNumber)num;
+ (BFElementPrintFeedModeNumber)convertToNumber:(nonnull NSString*)str;
+ (nonnull NSString*)key;
@end

typedef NS_ENUM(NSUInteger, BFElementPrintHorizontalAlignNumber) {
  BFElementPrintHorizontalAlignNumberLeft,
  BFElementPrintHorizontalAlignNumberCenter,
  BFElementPrintHorizontalAlignNumberRight,
  BFElementPrintHorizontalAlignNumber__Null,
};
extern NSString * __nonnull const BFElementPrintHorizontalAlignStringLeft;
extern NSString * __nonnull const BFElementPrintHorizontalAlignStringCenter;
extern NSString * __nonnull const BFElementPrintHorizontalAlignStringRight;
extern NSString * __nonnull const BFElementPrintHorizontalAlignString__Null;
@interface BFElementPrintHorizontalAlign : NSObject
+ (nonnull NSString*)convertToString:(BFElementPrintHorizontalAlignNumber)num;
+ (BFElementPrintHorizontalAlignNumber)convertToNumber:(nonnull NSString*)str;
+ (nonnull NSString*)key;
@end

typedef double BFElementPrintLeftMarginNumber;
@interface BFElementPrintLeftMargin : NSObject
+ (nonnull NSString*)key;
@end

typedef NS_ENUM(NSUInteger, BFElementPrintPolicyOfProcessingPrintDataNumber) {
  BFElementPrintPolicyOfProcessingPrintDataNumberBatchPrint,
  BFElementPrintPolicyOfProcessingPrintDataNumberRealTimePrint,
  BFElementPrintPolicyOfProcessingPrintDataNumber__Null,
};
extern NSString * __nonnull const BFElementPrintPolicyOfProcessingPrintDataStringBatchPrint;
extern NSString * __nonnull const BFElementPrintPolicyOfProcessingPrintDataStringRealTimePrint;
extern NSString * __nonnull const BFElementPrintPolicyOfProcessingPrintDataString__Null;
@interface BFElementPrintPolicyOfProcessingPrintData : NSObject
+ (nonnull NSString*)convertToString:(BFElementPrintPolicyOfProcessingPrintDataNumber)num;
+ (BFElementPrintPolicyOfProcessingPrintDataNumber)convertToNumber:(nonnull NSString*)str;
+ (nonnull NSString*)key;
@end

typedef NS_ENUM(NSUInteger, BFElementPrintQualityNumber) {
  BFElementPrintQualityNumberLowResolutionHighSpeed,
  BFElementPrintQualityNumberNormalResolutionNormalSpeed,
  BFElementPrintQualityNumberNormalResolutionDoubleSpeed,
  BFElementPrintQualityNumberHighResolutionLowSpeed,
  BFElementPrintQualityNumberHighResolutionUsingHRImageLowSpeed,
  BFElementPrintQualityNumber__Null,
};
extern NSString * __nonnull const BFElementPrintQualityStringLowResolutionHighSpeed;
extern NSString * __nonnull const BFElementPrintQualityStringNormalResolutionNormalSpeed;
extern NSString * __nonnull const BFElementPrintQualityStringNormalResolutionDoubleSpeed;
extern NSString * __nonnull const BFElementPrintQualityStringHighResolutionLowSpeed;
extern NSString * __nonnull const BFElementPrintQualityStringHighResolutionUsingHRImageLowSpeed;
extern NSString * __nonnull const BFElementPrintQualityString__Null;
@interface BFElementPrintQuality : NSObject
+ (nonnull NSString*)convertToString:(BFElementPrintQualityNumber)num;
+ (BFElementPrintQualityNumber)convertToNumber:(nonnull NSString*)str;
+ (nonnull NSString*)key;
@end

typedef NS_ENUM(NSUInteger, BFElementPrintScalingModeNumber) {
  BFElementPrintScalingModeNumberOriginal,
  BFElementPrintScalingModeNumberFitToPrintArea,
  BFElementPrintScalingModeNumberFitToPaper,
  BFElementPrintScalingModeNumberCustom,
  BFElementPrintScalingModeNumber__Null,
};
extern NSString * __nonnull const BFElementPrintScalingModeStringOriginal;
extern NSString * __nonnull const BFElementPrintScalingModeStringFitToPrintArea;
extern NSString * __nonnull const BFElementPrintScalingModeStringFitToPaper;
extern NSString * __nonnull const BFElementPrintScalingModeStringCustom;
extern NSString * __nonnull const BFElementPrintScalingModeString__Null;
@interface BFElementPrintScalingMode : NSObject
+ (nonnull NSString*)convertToString:(BFElementPrintScalingModeNumber)num;
+ (BFElementPrintScalingModeNumber)convertToNumber:(nonnull NSString*)str;
+ (nonnull NSString*)key;
@end

typedef double BFElementPrintScalingValueNumber;
@interface BFElementPrintScalingValue : NSObject
+ (nonnull NSString*)key;
@end

typedef NS_ENUM(NSUInteger, BFElementPrintSpeedNumber) {
  BFElementPrintSpeedNumberHighSpeed,
  BFElementPrintSpeedNumberMediumHighSpeed,
  BFElementPrintSpeedNumberMediumLowSpeed,
  BFElementPrintSpeedNumberLowSpeed,
  BFElementPrintSpeedNumberFast_DraftQuality,
  BFElementPrintSpeedNumberFast_LineConversion,
  BFElementPrintSpeedNumberUsePrinterSetting,
  BFElementPrintSpeedNumber__Null,
};
extern NSString * __nonnull const BFElementPrintSpeedStringHighSpeed;
extern NSString * __nonnull const BFElementPrintSpeedStringMediumHighSpeed;
extern NSString * __nonnull const BFElementPrintSpeedStringMediumLowSpeed;
extern NSString * __nonnull const BFElementPrintSpeedStringLowSpeed;
extern NSString * __nonnull const BFElementPrintSpeedStringFast_DraftQuality;
extern NSString * __nonnull const BFElementPrintSpeedStringFast_LineConversion;
extern NSString * __nonnull const BFElementPrintSpeedStringUsePrinterSetting;
extern NSString * __nonnull const BFElementPrintSpeedString__Null;
@interface BFElementPrintSpeed : NSObject
+ (nonnull NSString*)convertToString:(BFElementPrintSpeedNumber)num;
+ (BFElementPrintSpeedNumber)convertToNumber:(nonnull NSString*)str;
+ (nonnull NSString*)key;
@end

typedef double BFElementPrintTopMarginNumber;
@interface BFElementPrintTopMargin : NSObject
+ (nonnull NSString*)key;
@end

typedef bool BFElementPrintUsingCarbonCopyPaperNumber;
@interface BFElementPrintUsingCarbonCopyPaper : NSObject
+ (nonnull NSString*)key;
@end

typedef NS_ENUM(NSUInteger, BFElementPrintVerticalAlignNumber) {
  BFElementPrintVerticalAlignNumberTop,
  BFElementPrintVerticalAlignNumberMiddle,
  BFElementPrintVerticalAlignNumberBottom,
  BFElementPrintVerticalAlignNumber__Null,
};
extern NSString * __nonnull const BFElementPrintVerticalAlignStringTop;
extern NSString * __nonnull const BFElementPrintVerticalAlignStringMiddle;
extern NSString * __nonnull const BFElementPrintVerticalAlignStringBottom;
extern NSString * __nonnull const BFElementPrintVerticalAlignString__Null;
@interface BFElementPrintVerticalAlign : NSObject
+ (nonnull NSString*)convertToString:(BFElementPrintVerticalAlignNumber)num;
+ (BFElementPrintVerticalAlignNumber)convertToNumber:(nonnull NSString*)str;
+ (nonnull NSString*)key;
@end

