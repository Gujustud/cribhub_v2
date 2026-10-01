

#pragma once
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BFElementMediaBackgroundColorNumber) {
  BFElementMediaBackgroundColorNumberStandard,
  BFElementMediaBackgroundColorNumberWhite,
  BFElementMediaBackgroundColorNumberOthers,
  BFElementMediaBackgroundColorNumberClear,
  BFElementMediaBackgroundColorNumberRed,
  BFElementMediaBackgroundColorNumberBlue,
  BFElementMediaBackgroundColorNumberYellow,
  BFElementMediaBackgroundColorNumberGreen,
  BFElementMediaBackgroundColorNumberBlack,
  BFElementMediaBackgroundColorNumberClearWithWhiteInk,
  BFElementMediaBackgroundColorNumberPremiumGold,
  BFElementMediaBackgroundColorNumberPremiumSilver,
  BFElementMediaBackgroundColorNumberPremiumOthers,
  BFElementMediaBackgroundColorNumberMaskingOthers,
  BFElementMediaBackgroundColorNumberMatteWhite,
  BFElementMediaBackgroundColorNumberMatteClear,
  BFElementMediaBackgroundColorNumberMatteSilver,
  BFElementMediaBackgroundColorNumberSatinGold,
  BFElementMediaBackgroundColorNumberSatinSilver,
  BFElementMediaBackgroundColorNumberPastelPurple,
  BFElementMediaBackgroundColorNumberBlueWithWhiteInk,
  BFElementMediaBackgroundColorNumberRedWithWhiteInk,
  BFElementMediaBackgroundColorNumberFluorescentOrange,
  BFElementMediaBackgroundColorNumberFluorescentYellow,
  BFElementMediaBackgroundColorNumberBerryPink,
  BFElementMediaBackgroundColorNumberLightGray,
  BFElementMediaBackgroundColorNumberLimeGreen,
  BFElementMediaBackgroundColorNumberSatinNavyBlue,
  BFElementMediaBackgroundColorNumberSatinWineRed,
  BFElementMediaBackgroundColorNumberFabricYellow,
  BFElementMediaBackgroundColorNumberFabricPink,
  BFElementMediaBackgroundColorNumberFabricBlue,
  BFElementMediaBackgroundColorNumberTubeWhite,
  BFElementMediaBackgroundColorNumberSelfLaminatedWhite,
  BFElementMediaBackgroundColorNumberFlexibleWhite,
  BFElementMediaBackgroundColorNumberFlexibleYellow,
  BFElementMediaBackgroundColorNumberCleaningWhite,
  BFElementMediaBackgroundColorNumberStencilWhite,
  BFElementMediaBackgroundColorNumberLightBlue_Satin,
  BFElementMediaBackgroundColorNumberMint_Satin,
  BFElementMediaBackgroundColorNumberSilver_Satin,
  BFElementMediaBackgroundColorNumberIncompatible,
  BFElementMediaBackgroundColorNumber__Null,
};
extern NSString * __nonnull const BFElementMediaBackgroundColorStringStandard;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringWhite;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringOthers;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringClear;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringRed;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringBlue;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringYellow;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringGreen;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringBlack;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringClearWithWhiteInk;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringPremiumGold;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringPremiumSilver;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringPremiumOthers;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringMaskingOthers;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringMatteWhite;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringMatteClear;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringMatteSilver;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringSatinGold;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringSatinSilver;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringPastelPurple;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringBlueWithWhiteInk;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringRedWithWhiteInk;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringFluorescentOrange;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringFluorescentYellow;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringBerryPink;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringLightGray;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringLimeGreen;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringSatinNavyBlue;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringSatinWineRed;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringFabricYellow;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringFabricPink;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringFabricBlue;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringTubeWhite;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringSelfLaminatedWhite;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringFlexibleWhite;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringFlexibleYellow;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringCleaningWhite;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringStencilWhite;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringLightBlue_Satin;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringMint_Satin;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringSilver_Satin;
extern NSString * __nonnull const BFElementMediaBackgroundColorStringIncompatible;
extern NSString * __nonnull const BFElementMediaBackgroundColorString__Null;
@interface BFElementMediaBackgroundColor : NSObject
+ (nonnull NSString*)convertToString:(BFElementMediaBackgroundColorNumber)num;
+ (BFElementMediaBackgroundColorNumber)convertToNumber:(nonnull NSString*)str;
+ (nonnull NSString*)key;
@end

typedef NS_ENUM(NSUInteger, BFElementMediaPaperInsertionPositionNumber) {
  BFElementMediaPaperInsertionPositionNumberLeft,
  BFElementMediaPaperInsertionPositionNumberCenter,
  BFElementMediaPaperInsertionPositionNumberRight,
  BFElementMediaPaperInsertionPositionNumber__Null,
};
extern NSString * __nonnull const BFElementMediaPaperInsertionPositionStringLeft;
extern NSString * __nonnull const BFElementMediaPaperInsertionPositionStringCenter;
extern NSString * __nonnull const BFElementMediaPaperInsertionPositionStringRight;
extern NSString * __nonnull const BFElementMediaPaperInsertionPositionString__Null;
@interface BFElementMediaPaperInsertionPosition : NSObject
+ (nonnull NSString*)convertToString:(BFElementMediaPaperInsertionPositionNumber)num;
+ (BFElementMediaPaperInsertionPositionNumber)convertToNumber:(nonnull NSString*)str;
+ (nonnull NSString*)key;
@end

typedef int BFElementMediaPJForceStretchPrintableAreaNumber;
@interface BFElementMediaPJForceStretchPrintableArea : NSObject
+ (nonnull NSString*)key;
@end

typedef NS_ENUM(NSUInteger, BFElementMediaPJPaperTypeNumber) {
  BFElementMediaPJPaperTypeNumberRoll,
  BFElementMediaPJPaperTypeNumberCutSheet,
  BFElementMediaPJPaperTypeNumberPerforatedRoll,
  BFElementMediaPJPaperTypeNumber__Null,
};
extern NSString * __nonnull const BFElementMediaPJPaperTypeStringRoll;
extern NSString * __nonnull const BFElementMediaPJPaperTypeStringCutSheet;
extern NSString * __nonnull const BFElementMediaPJPaperTypeStringPerforatedRoll;
extern NSString * __nonnull const BFElementMediaPJPaperTypeString__Null;
@interface BFElementMediaPJPaperType : NSObject
+ (nonnull NSString*)convertToString:(BFElementMediaPJPaperTypeNumber)num;
+ (BFElementMediaPJPaperTypeNumber)convertToNumber:(nonnull NSString*)str;
+ (nonnull NSString*)key;
@end

typedef NS_ENUM(NSUInteger, BFElementMediaPJRollCaseNumber) {
  BFElementMediaPJRollCaseNumberNone,
  BFElementMediaPJRollCaseNumberPARC001_NoAntiCurl,
  BFElementMediaPJRollCaseNumberPARC001,
  BFElementMediaPJRollCaseNumberPARC001_ShortFeed,
  BFElementMediaPJRollCaseNumberKeepPrinterSetting,
  BFElementMediaPJRollCaseNumber__Null,
};
extern NSString * __nonnull const BFElementMediaPJRollCaseStringNone;
extern NSString * __nonnull const BFElementMediaPJRollCaseStringPARC001_NoAntiCurl;
extern NSString * __nonnull const BFElementMediaPJRollCaseStringPARC001;
extern NSString * __nonnull const BFElementMediaPJRollCaseStringPARC001_ShortFeed;
extern NSString * __nonnull const BFElementMediaPJRollCaseStringKeepPrinterSetting;
extern NSString * __nonnull const BFElementMediaPJRollCaseString__Null;
@interface BFElementMediaPJRollCase : NSObject
+ (nonnull NSString*)convertToString:(BFElementMediaPJRollCaseNumber)num;
+ (BFElementMediaPJRollCaseNumber)convertToNumber:(nonnull NSString*)str;
+ (nonnull NSString*)key;
@end

typedef NS_ENUM(NSUInteger, BFElementMediaSizeNumber) {
  BFElementMediaSizeNumberL3_5mm,
  BFElementMediaSizeNumberL6mm,
  BFElementMediaSizeNumberL9mm,
  BFElementMediaSizeNumberL12mm,
  BFElementMediaSizeNumberL18mm,
  BFElementMediaSizeNumberL24mm,
  BFElementMediaSizeNumberL29mm,
  BFElementMediaSizeNumberL36mm,
  BFElementMediaSizeNumberL38mm,
  BFElementMediaSizeNumberL50mm,
  BFElementMediaSizeNumberL54mm,
  BFElementMediaSizeNumberL62mm,
  BFElementMediaSizeNumberL102mm,
  BFElementMediaSizeNumberL103mm,
  BFElementMediaSizeNumberL17mmx54mm,
  BFElementMediaSizeNumberL17mmx87mm,
  BFElementMediaSizeNumberL23mmx23mm,
  BFElementMediaSizeNumberL29mmx42mm,
  BFElementMediaSizeNumberL29mmx90mm,
  BFElementMediaSizeNumberL38mmx90mm,
  BFElementMediaSizeNumberL39mmx48mm,
  BFElementMediaSizeNumberL52mmx29mm,
  BFElementMediaSizeNumberL54mmx29mm,
  BFElementMediaSizeNumberL60mmx86mm,
  BFElementMediaSizeNumberL62mmx29mm,
  BFElementMediaSizeNumberL62mmx60mm,
  BFElementMediaSizeNumberL62mmx75mm,
  BFElementMediaSizeNumberL62mmx100mm,
  BFElementMediaSizeNumberL102mmx51mm,
  BFElementMediaSizeNumberL102mmx152mm,
  BFElementMediaSizeNumberL103mmx164mm,
  BFElementMediaSizeNumberL12mmDia,
  BFElementMediaSizeNumberL24mmDia,
  BFElementMediaSizeNumberL58mmDia,
  BFElementMediaSizeNumberHS5_8mm,
  BFElementMediaSizeNumberHS8_8mm,
  BFElementMediaSizeNumberHS11_7mm,
  BFElementMediaSizeNumberHS17_7mm,
  BFElementMediaSizeNumberHS23_6mm,
  BFElementMediaSizeNumberHS5_2mm,
  BFElementMediaSizeNumberHS9_0mm,
  BFElementMediaSizeNumberHS11_2mm,
  BFElementMediaSizeNumberHS21_0mm,
  BFElementMediaSizeNumberHS31_0mm,
  BFElementMediaSizeNumberFL21mmx45mm,
  BFElementMediaSizeNumberA4,
  BFElementMediaSizeNumberA5,
  BFElementMediaSizeNumberLetter,
  BFElementMediaSizeNumberLegal,
  BFElementMediaSizeNumberCustom,
  BFElementMediaSizeNumber__Null,
};
extern NSString * __nonnull const BFElementMediaSizeStringL3_5mm;
extern NSString * __nonnull const BFElementMediaSizeStringL6mm;
extern NSString * __nonnull const BFElementMediaSizeStringL9mm;
extern NSString * __nonnull const BFElementMediaSizeStringL12mm;
extern NSString * __nonnull const BFElementMediaSizeStringL18mm;
extern NSString * __nonnull const BFElementMediaSizeStringL24mm;
extern NSString * __nonnull const BFElementMediaSizeStringL29mm;
extern NSString * __nonnull const BFElementMediaSizeStringL36mm;
extern NSString * __nonnull const BFElementMediaSizeStringL38mm;
extern NSString * __nonnull const BFElementMediaSizeStringL50mm;
extern NSString * __nonnull const BFElementMediaSizeStringL54mm;
extern NSString * __nonnull const BFElementMediaSizeStringL62mm;
extern NSString * __nonnull const BFElementMediaSizeStringL102mm;
extern NSString * __nonnull const BFElementMediaSizeStringL103mm;
extern NSString * __nonnull const BFElementMediaSizeStringL17mmx54mm;
extern NSString * __nonnull const BFElementMediaSizeStringL17mmx87mm;
extern NSString * __nonnull const BFElementMediaSizeStringL23mmx23mm;
extern NSString * __nonnull const BFElementMediaSizeStringL29mmx42mm;
extern NSString * __nonnull const BFElementMediaSizeStringL29mmx90mm;
extern NSString * __nonnull const BFElementMediaSizeStringL38mmx90mm;
extern NSString * __nonnull const BFElementMediaSizeStringL39mmx48mm;
extern NSString * __nonnull const BFElementMediaSizeStringL52mmx29mm;
extern NSString * __nonnull const BFElementMediaSizeStringL54mmx29mm;
extern NSString * __nonnull const BFElementMediaSizeStringL60mmx86mm;
extern NSString * __nonnull const BFElementMediaSizeStringL62mmx29mm;
extern NSString * __nonnull const BFElementMediaSizeStringL62mmx60mm;
extern NSString * __nonnull const BFElementMediaSizeStringL62mmx75mm;
extern NSString * __nonnull const BFElementMediaSizeStringL62mmx100mm;
extern NSString * __nonnull const BFElementMediaSizeStringL102mmx51mm;
extern NSString * __nonnull const BFElementMediaSizeStringL102mmx152mm;
extern NSString * __nonnull const BFElementMediaSizeStringL103mmx164mm;
extern NSString * __nonnull const BFElementMediaSizeStringL12mmDia;
extern NSString * __nonnull const BFElementMediaSizeStringL24mmDia;
extern NSString * __nonnull const BFElementMediaSizeStringL58mmDia;
extern NSString * __nonnull const BFElementMediaSizeStringHS5_8mm;
extern NSString * __nonnull const BFElementMediaSizeStringHS8_8mm;
extern NSString * __nonnull const BFElementMediaSizeStringHS11_7mm;
extern NSString * __nonnull const BFElementMediaSizeStringHS17_7mm;
extern NSString * __nonnull const BFElementMediaSizeStringHS23_6mm;
extern NSString * __nonnull const BFElementMediaSizeStringHS5_2mm;
extern NSString * __nonnull const BFElementMediaSizeStringHS9_0mm;
extern NSString * __nonnull const BFElementMediaSizeStringHS11_2mm;
extern NSString * __nonnull const BFElementMediaSizeStringHS21_0mm;
extern NSString * __nonnull const BFElementMediaSizeStringHS31_0mm;
extern NSString * __nonnull const BFElementMediaSizeStringFL21mmx45mm;
extern NSString * __nonnull const BFElementMediaSizeStringA4;
extern NSString * __nonnull const BFElementMediaSizeStringA5;
extern NSString * __nonnull const BFElementMediaSizeStringLetter;
extern NSString * __nonnull const BFElementMediaSizeStringLegal;
extern NSString * __nonnull const BFElementMediaSizeStringCustom;
extern NSString * __nonnull const BFElementMediaSizeString__Null;
@interface BFElementMediaSize : NSObject
+ (nonnull NSString*)convertToString:(BFElementMediaSizeNumber)num;
+ (BFElementMediaSizeNumber)convertToNumber:(nonnull NSString*)str;
+ (nonnull NSString*)key;
@end

typedef NS_ENUM(NSUInteger, BFElementMediaTextColorNumber) {
  BFElementMediaTextColorNumberStandard,
  BFElementMediaTextColorNumberWhite,
  BFElementMediaTextColorNumberOthers,
  BFElementMediaTextColorNumberRed,
  BFElementMediaTextColorNumberBlue,
  BFElementMediaTextColorNumberBlack,
  BFElementMediaTextColorNumberGold,
  BFElementMediaTextColorNumberRedAndBlack,
  BFElementMediaTextColorNumberFabricBlue,
  BFElementMediaTextColorNumberCleaningBlack,
  BFElementMediaTextColorNumberStencilBlack,
  BFElementMediaTextColorNumberIncompatible,
  BFElementMediaTextColorNumber__Null,
};
extern NSString * __nonnull const BFElementMediaTextColorStringStandard;
extern NSString * __nonnull const BFElementMediaTextColorStringWhite;
extern NSString * __nonnull const BFElementMediaTextColorStringOthers;
extern NSString * __nonnull const BFElementMediaTextColorStringRed;
extern NSString * __nonnull const BFElementMediaTextColorStringBlue;
extern NSString * __nonnull const BFElementMediaTextColorStringBlack;
extern NSString * __nonnull const BFElementMediaTextColorStringGold;
extern NSString * __nonnull const BFElementMediaTextColorStringRedAndBlack;
extern NSString * __nonnull const BFElementMediaTextColorStringFabricBlue;
extern NSString * __nonnull const BFElementMediaTextColorStringCleaningBlack;
extern NSString * __nonnull const BFElementMediaTextColorStringStencilBlack;
extern NSString * __nonnull const BFElementMediaTextColorStringIncompatible;
extern NSString * __nonnull const BFElementMediaTextColorString__Null;
@interface BFElementMediaTextColor : NSObject
+ (nonnull NSString*)convertToString:(BFElementMediaTextColorNumber)num;
+ (BFElementMediaTextColorNumber)convertToNumber:(nonnull NSString*)str;
+ (nonnull NSString*)key;
@end

typedef NS_ENUM(NSUInteger, BFElementMediaTypeNumber) {
  BFElementMediaTypeNumberUnknown,
  BFElementMediaTypeNumberPTLaminate,
  BFElementMediaTypeNumberPTNonLaminate,
  BFElementMediaTypeNumberPTFabric,
  BFElementMediaTypeNumberQLInfiniteLable,
  BFElementMediaTypeNumberQLDieCutLable,
  BFElementMediaTypeNumberPTHeatShrink,
  BFElementMediaTypeNumberPTFLe,
  BFElementMediaTypeNumberPTFlexibleID,
  BFElementMediaTypeNumberPTSatin,
  BFElementMediaTypeNumberPTSelfLaminate,
  BFElementMediaTypeNumberIncompatible,
  BFElementMediaTypeNumber__Null,
};
extern NSString * __nonnull const BFElementMediaTypeStringUnknown;
extern NSString * __nonnull const BFElementMediaTypeStringPTLaminate;
extern NSString * __nonnull const BFElementMediaTypeStringPTNonLaminate;
extern NSString * __nonnull const BFElementMediaTypeStringPTFabric;
extern NSString * __nonnull const BFElementMediaTypeStringQLInfiniteLable;
extern NSString * __nonnull const BFElementMediaTypeStringQLDieCutLable;
extern NSString * __nonnull const BFElementMediaTypeStringPTHeatShrink;
extern NSString * __nonnull const BFElementMediaTypeStringPTFLe;
extern NSString * __nonnull const BFElementMediaTypeStringPTFlexibleID;
extern NSString * __nonnull const BFElementMediaTypeStringPTSatin;
extern NSString * __nonnull const BFElementMediaTypeStringPTSelfLaminate;
extern NSString * __nonnull const BFElementMediaTypeStringIncompatible;
extern NSString * __nonnull const BFElementMediaTypeString__Null;
@interface BFElementMediaType : NSObject
+ (nonnull NSString*)convertToString:(BFElementMediaTypeNumber)num;
+ (BFElementMediaTypeNumber)convertToNumber:(nonnull NSString*)str;
+ (nonnull NSString*)key;
@end

