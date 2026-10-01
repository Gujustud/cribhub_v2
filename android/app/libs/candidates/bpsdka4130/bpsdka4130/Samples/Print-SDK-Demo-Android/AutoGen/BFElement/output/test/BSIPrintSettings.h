//
//  BSIPrintSettings.h
//  MacPrintSDK
//
//
//
//
#import <Foundation/Foundation.h>
#import "BSICommonDefinition.h"
#import "BFModelDefinition.h"
#import "BFElementSetPrintSettingsDefinition.h"

@interface BSIPrintSettings : NSObject<NSCopying>
+ (nonnull BSIPrintSettings*) generateDefaultWithModelNumber:(BFElementModelNameNumber)model;

- (nonnull instancetype) init __unavailable;

- (void) setValue:(nonnull NSNumber*)value forCategory:(BFElementSetPrintSettingsNumber)category;
- (void) setString:(nonnull NSString*)string forCategory:(BFElementSetPrintSettingsNumber)category;

- (nullable NSNumber*) getValueForCategory:(BFElementSetPrintSettingsNumber)category;
- (nullable NSString*) getStringForCategory:(BFElementSetPrintSettingsNumber)category;

- (void) setMediaSize:(BFElementMediaSizeNumber)value;
- (void) setImageOrientation:(BFElementImageOrientationNumber)value;
- (void) setPrintScalingMode:(BFElementPrintScalingModeNumber)value;
- (void) setImageHalftone:(BFElementImageHalftoneNumber)value;
- (void) setImageBrightness:(NSInteger)value;
- (void) setImageContrast:(NSInteger)value;
- (void) setImageRedEnhancement:(NSInteger)value;
- (void) setImageGreenEnhancement:(NSInteger)value;
- (void) setImageBlueEnhancement:(NSInteger)value;
- (void) setPrintHorizontalAlign:(BFElementPrintHorizontalAlignNumber)value;
- (void) setPrintVerticalAlign:(BFElementPrintVerticalAlignNumber)value;
- (void) setPrintTopMargin:(CGFloat)value;
- (void) setPrintLeftMargin:(CGFloat)value;
- (void) setMediaTextColor:(BFElementMediaTextColorNumber)value;
- (void) setMediaBackgroundColor:(BFElementMediaBackgroundColorNumber)value;
- (void) setPrintScalingValue:(CGFloat)value;
- (void) setPrintAutoCutLast:(BOOL)value;
- (void) setPrintAutoCutEvery:(BOOL)value;
- (void) setPrintAutoCutEveryCyclePerPage:(NSInteger)value;
- (void) setPrintAutoCutDisableForSpecialTape:(BOOL)value;
- (void) setPrintAutoHalfCut:(BOOL)value;
- (void) setPrintDensity:(BFElementPrintDensityNumber)value;
- (void) setPrintSpeed:(BFElementPrintSpeedNumber)value;
- (void) setPrintDashLine:(BOOL)value;
- (void) setPrintUsingCarbonCopyPaper:(BOOL)value;
- (void) setPrintFeedMode:(BFElementPrintFeedModeNumber)value;
- (void) setPrintQuality:(BFElementPrintQualityNumber)value;
- (void) setMediaPJRollCase:(BFElementMediaPJRollCaseNumber)value;
- (void) setMediaPaperInsertionPosition:(BFElementMediaPaperInsertionPositionNumber)value;
- (void) setMediaPJPaperType:(BFElementMediaPJPaperTypeNumber)value;
- (void) setMediaPJForceStretchPrintableArea:(NSInteger)value;
- (void) setPrintExtraFeedDots:(NSInteger)value;
- (void) setPrintCopies:(NSInteger)value;
- (void) setPrintBidirectionalCommunication:(BOOL)value;
- (void) setImageTrimBlankDataFromTail:(BOOL)value;
- (void) setPrintPolicyOfProcessingPrintData:(BFElementPrintPolicyOfProcessingPrintDataNumber)value;
- (void) setPrintCollate:(BOOL)value;
- (void) setPrintCheckMediaTextColor:(BOOL)value;
- (void) setPrintCheckMediaBackgroundColor:(BOOL)value;
- (void) setPrintCutPause:(BOOL)value;
- (BFElementMediaSizeNumber) getMediaSize;
- (BFElementImageOrientationNumber) getImageOrientation;
- (BFElementPrintScalingModeNumber) getPrintScalingMode;
- (BFElementImageHalftoneNumber) getImageHalftone;
- (nullable NSNumber/*NSInteger*/*) getImageBrightness;
- (nullable NSNumber/*NSInteger*/*) getImageContrast;
- (nullable NSNumber/*NSInteger*/*) getImageRedEnhancement;
- (nullable NSNumber/*NSInteger*/*) getImageGreenEnhancement;
- (nullable NSNumber/*NSInteger*/*) getImageBlueEnhancement;
- (BFElementPrintHorizontalAlignNumber) getPrintHorizontalAlign;
- (BFElementPrintVerticalAlignNumber) getPrintVerticalAlign;
- (nullable NSNumber/*CGFloat*/*) getPrintTopMargin;
- (nullable NSNumber/*CGFloat*/*) getPrintLeftMargin;
- (BFElementMediaTextColorNumber) getMediaTextColor;
- (BFElementMediaBackgroundColorNumber) getMediaBackgroundColor;
- (nullable NSNumber/*CGFloat*/*) getPrintScalingValue;
- (nullable NSNumber/*BOOL*/*) getPrintAutoCutLast;
- (nullable NSNumber/*BOOL*/*) getPrintAutoCutEvery;
- (nullable NSNumber/*NSInteger*/*) getPrintAutoCutEveryCyclePerPage;
- (nullable NSNumber/*BOOL*/*) getPrintAutoCutDisableForSpecialTape;
- (nullable NSNumber/*BOOL*/*) getPrintAutoHalfCut;
- (BFElementPrintDensityNumber) getPrintDensity;
- (BFElementPrintSpeedNumber) getPrintSpeed;
- (nullable NSNumber/*BOOL*/*) getPrintDashLine;
- (nullable NSNumber/*BOOL*/*) getPrintUsingCarbonCopyPaper;
- (BFElementPrintFeedModeNumber) getPrintFeedMode;
- (BFElementPrintQualityNumber) getPrintQuality;
- (BFElementMediaPJRollCaseNumber) getMediaPJRollCase;
- (BFElementMediaPaperInsertionPositionNumber) getMediaPaperInsertionPosition;
- (BFElementMediaPJPaperTypeNumber) getMediaPJPaperType;
- (nullable NSNumber/*NSInteger*/*) getMediaPJForceStretchPrintableArea;
- (nullable NSNumber/*NSInteger*/*) getPrintExtraFeedDots;
- (nullable NSNumber/*NSInteger*/*) getPrintCopies;
- (nullable NSNumber/*BOOL*/*) getPrintBidirectionalCommunication;
- (nullable NSNumber/*BOOL*/*) getImageTrimBlankDataFromTail;
- (BFElementPrintPolicyOfProcessingPrintDataNumber) getPrintPolicyOfProcessingPrintData;
- (nullable NSNumber/*BOOL*/*) getPrintCollate;
- (nullable NSNumber/*BOOL*/*) getPrintCheckMediaTextColor;
- (nullable NSNumber/*BOOL*/*) getPrintCheckMediaBackgroundColor;
- (nullable NSNumber/*BOOL*/*) getPrintCutPause;

@end
