

#import "BFElementMediaDefinition.h"

NSString * __nonnull const BFElementMediaBackgroundColorStringStandard = @"Standard";
NSString * __nonnull const BFElementMediaBackgroundColorStringWhite = @"White";
NSString * __nonnull const BFElementMediaBackgroundColorStringOthers = @"Others";
NSString * __nonnull const BFElementMediaBackgroundColorStringClear = @"Clear";
NSString * __nonnull const BFElementMediaBackgroundColorStringRed = @"Red";
NSString * __nonnull const BFElementMediaBackgroundColorStringBlue = @"Blue";
NSString * __nonnull const BFElementMediaBackgroundColorStringYellow = @"Yellow";
NSString * __nonnull const BFElementMediaBackgroundColorStringGreen = @"Green";
NSString * __nonnull const BFElementMediaBackgroundColorStringBlack = @"Black";
NSString * __nonnull const BFElementMediaBackgroundColorStringClearWithWhiteInk = @"ClearWithWhiteInk";
NSString * __nonnull const BFElementMediaBackgroundColorStringPremiumGold = @"PremiumGold";
NSString * __nonnull const BFElementMediaBackgroundColorStringPremiumSilver = @"PremiumSilver";
NSString * __nonnull const BFElementMediaBackgroundColorStringPremiumOthers = @"PremiumOthers";
NSString * __nonnull const BFElementMediaBackgroundColorStringMaskingOthers = @"MaskingOthers";
NSString * __nonnull const BFElementMediaBackgroundColorStringMatteWhite = @"MatteWhite";
NSString * __nonnull const BFElementMediaBackgroundColorStringMatteClear = @"MatteClear";
NSString * __nonnull const BFElementMediaBackgroundColorStringMatteSilver = @"MatteSilver";
NSString * __nonnull const BFElementMediaBackgroundColorStringSatinGold = @"SatinGold";
NSString * __nonnull const BFElementMediaBackgroundColorStringSatinSilver = @"SatinSilver";
NSString * __nonnull const BFElementMediaBackgroundColorStringPastelPurple = @"PastelPurple";
NSString * __nonnull const BFElementMediaBackgroundColorStringBlueWithWhiteInk = @"BlueWithWhiteInk";
NSString * __nonnull const BFElementMediaBackgroundColorStringRedWithWhiteInk = @"RedWithWhiteInk";
NSString * __nonnull const BFElementMediaBackgroundColorStringFluorescentOrange = @"FluorescentOrange";
NSString * __nonnull const BFElementMediaBackgroundColorStringFluorescentYellow = @"FluorescentYellow";
NSString * __nonnull const BFElementMediaBackgroundColorStringBerryPink = @"BerryPink";
NSString * __nonnull const BFElementMediaBackgroundColorStringLightGray = @"LightGray";
NSString * __nonnull const BFElementMediaBackgroundColorStringLimeGreen = @"LimeGreen";
NSString * __nonnull const BFElementMediaBackgroundColorStringSatinNavyBlue = @"SatinNavyBlue";
NSString * __nonnull const BFElementMediaBackgroundColorStringSatinWineRed = @"SatinWineRed";
NSString * __nonnull const BFElementMediaBackgroundColorStringFabricYellow = @"FabricYellow";
NSString * __nonnull const BFElementMediaBackgroundColorStringFabricPink = @"FabricPink";
NSString * __nonnull const BFElementMediaBackgroundColorStringFabricBlue = @"FabricBlue";
NSString * __nonnull const BFElementMediaBackgroundColorStringTubeWhite = @"TubeWhite";
NSString * __nonnull const BFElementMediaBackgroundColorStringSelfLaminatedWhite = @"SelfLaminatedWhite";
NSString * __nonnull const BFElementMediaBackgroundColorStringFlexibleWhite = @"FlexibleWhite";
NSString * __nonnull const BFElementMediaBackgroundColorStringFlexibleYellow = @"FlexibleYellow";
NSString * __nonnull const BFElementMediaBackgroundColorStringCleaningWhite = @"CleaningWhite";
NSString * __nonnull const BFElementMediaBackgroundColorStringStencilWhite = @"StencilWhite";
NSString * __nonnull const BFElementMediaBackgroundColorStringLightBlue_Satin = @"LightBlue_Satin";
NSString * __nonnull const BFElementMediaBackgroundColorStringMint_Satin = @"Mint_Satin";
NSString * __nonnull const BFElementMediaBackgroundColorStringSilver_Satin = @"Silver_Satin";
NSString * __nonnull const BFElementMediaBackgroundColorStringIncompatible = @"Incompatible";
NSString * __nonnull const BFElementMediaBackgroundColorString__Null = @"__Null";
@implementation BFElementMediaBackgroundColor
+ (nonnull NSString*)convertToString:(BFElementMediaBackgroundColorNumber)num {
  switch(num) {
  case BFElementMediaBackgroundColorNumberStandard: return BFElementMediaBackgroundColorStringStandard;
  case BFElementMediaBackgroundColorNumberWhite: return BFElementMediaBackgroundColorStringWhite;
  case BFElementMediaBackgroundColorNumberOthers: return BFElementMediaBackgroundColorStringOthers;
  case BFElementMediaBackgroundColorNumberClear: return BFElementMediaBackgroundColorStringClear;
  case BFElementMediaBackgroundColorNumberRed: return BFElementMediaBackgroundColorStringRed;
  case BFElementMediaBackgroundColorNumberBlue: return BFElementMediaBackgroundColorStringBlue;
  case BFElementMediaBackgroundColorNumberYellow: return BFElementMediaBackgroundColorStringYellow;
  case BFElementMediaBackgroundColorNumberGreen: return BFElementMediaBackgroundColorStringGreen;
  case BFElementMediaBackgroundColorNumberBlack: return BFElementMediaBackgroundColorStringBlack;
  case BFElementMediaBackgroundColorNumberClearWithWhiteInk: return BFElementMediaBackgroundColorStringClearWithWhiteInk;
  case BFElementMediaBackgroundColorNumberPremiumGold: return BFElementMediaBackgroundColorStringPremiumGold;
  case BFElementMediaBackgroundColorNumberPremiumSilver: return BFElementMediaBackgroundColorStringPremiumSilver;
  case BFElementMediaBackgroundColorNumberPremiumOthers: return BFElementMediaBackgroundColorStringPremiumOthers;
  case BFElementMediaBackgroundColorNumberMaskingOthers: return BFElementMediaBackgroundColorStringMaskingOthers;
  case BFElementMediaBackgroundColorNumberMatteWhite: return BFElementMediaBackgroundColorStringMatteWhite;
  case BFElementMediaBackgroundColorNumberMatteClear: return BFElementMediaBackgroundColorStringMatteClear;
  case BFElementMediaBackgroundColorNumberMatteSilver: return BFElementMediaBackgroundColorStringMatteSilver;
  case BFElementMediaBackgroundColorNumberSatinGold: return BFElementMediaBackgroundColorStringSatinGold;
  case BFElementMediaBackgroundColorNumberSatinSilver: return BFElementMediaBackgroundColorStringSatinSilver;
  case BFElementMediaBackgroundColorNumberPastelPurple: return BFElementMediaBackgroundColorStringPastelPurple;
  case BFElementMediaBackgroundColorNumberBlueWithWhiteInk: return BFElementMediaBackgroundColorStringBlueWithWhiteInk;
  case BFElementMediaBackgroundColorNumberRedWithWhiteInk: return BFElementMediaBackgroundColorStringRedWithWhiteInk;
  case BFElementMediaBackgroundColorNumberFluorescentOrange: return BFElementMediaBackgroundColorStringFluorescentOrange;
  case BFElementMediaBackgroundColorNumberFluorescentYellow: return BFElementMediaBackgroundColorStringFluorescentYellow;
  case BFElementMediaBackgroundColorNumberBerryPink: return BFElementMediaBackgroundColorStringBerryPink;
  case BFElementMediaBackgroundColorNumberLightGray: return BFElementMediaBackgroundColorStringLightGray;
  case BFElementMediaBackgroundColorNumberLimeGreen: return BFElementMediaBackgroundColorStringLimeGreen;
  case BFElementMediaBackgroundColorNumberSatinNavyBlue: return BFElementMediaBackgroundColorStringSatinNavyBlue;
  case BFElementMediaBackgroundColorNumberSatinWineRed: return BFElementMediaBackgroundColorStringSatinWineRed;
  case BFElementMediaBackgroundColorNumberFabricYellow: return BFElementMediaBackgroundColorStringFabricYellow;
  case BFElementMediaBackgroundColorNumberFabricPink: return BFElementMediaBackgroundColorStringFabricPink;
  case BFElementMediaBackgroundColorNumberFabricBlue: return BFElementMediaBackgroundColorStringFabricBlue;
  case BFElementMediaBackgroundColorNumberTubeWhite: return BFElementMediaBackgroundColorStringTubeWhite;
  case BFElementMediaBackgroundColorNumberSelfLaminatedWhite: return BFElementMediaBackgroundColorStringSelfLaminatedWhite;
  case BFElementMediaBackgroundColorNumberFlexibleWhite: return BFElementMediaBackgroundColorStringFlexibleWhite;
  case BFElementMediaBackgroundColorNumberFlexibleYellow: return BFElementMediaBackgroundColorStringFlexibleYellow;
  case BFElementMediaBackgroundColorNumberCleaningWhite: return BFElementMediaBackgroundColorStringCleaningWhite;
  case BFElementMediaBackgroundColorNumberStencilWhite: return BFElementMediaBackgroundColorStringStencilWhite;
  case BFElementMediaBackgroundColorNumberLightBlue_Satin: return BFElementMediaBackgroundColorStringLightBlue_Satin;
  case BFElementMediaBackgroundColorNumberMint_Satin: return BFElementMediaBackgroundColorStringMint_Satin;
  case BFElementMediaBackgroundColorNumberSilver_Satin: return BFElementMediaBackgroundColorStringSilver_Satin;
  case BFElementMediaBackgroundColorNumberIncompatible: return BFElementMediaBackgroundColorStringIncompatible;
  case BFElementMediaBackgroundColorNumber__Null: return BFElementMediaBackgroundColorString__Null;
  }
  return BFElementMediaBackgroundColorString__Null;
}
+ (BFElementMediaBackgroundColorNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementMediaBackgroundColorStringStandard]) {
    return BFElementMediaBackgroundColorNumberStandard;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringWhite]) {
    return BFElementMediaBackgroundColorNumberWhite;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringOthers]) {
    return BFElementMediaBackgroundColorNumberOthers;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringClear]) {
    return BFElementMediaBackgroundColorNumberClear;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringRed]) {
    return BFElementMediaBackgroundColorNumberRed;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringBlue]) {
    return BFElementMediaBackgroundColorNumberBlue;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringYellow]) {
    return BFElementMediaBackgroundColorNumberYellow;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringGreen]) {
    return BFElementMediaBackgroundColorNumberGreen;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringBlack]) {
    return BFElementMediaBackgroundColorNumberBlack;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringClearWithWhiteInk]) {
    return BFElementMediaBackgroundColorNumberClearWithWhiteInk;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringPremiumGold]) {
    return BFElementMediaBackgroundColorNumberPremiumGold;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringPremiumSilver]) {
    return BFElementMediaBackgroundColorNumberPremiumSilver;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringPremiumOthers]) {
    return BFElementMediaBackgroundColorNumberPremiumOthers;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringMaskingOthers]) {
    return BFElementMediaBackgroundColorNumberMaskingOthers;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringMatteWhite]) {
    return BFElementMediaBackgroundColorNumberMatteWhite;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringMatteClear]) {
    return BFElementMediaBackgroundColorNumberMatteClear;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringMatteSilver]) {
    return BFElementMediaBackgroundColorNumberMatteSilver;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringSatinGold]) {
    return BFElementMediaBackgroundColorNumberSatinGold;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringSatinSilver]) {
    return BFElementMediaBackgroundColorNumberSatinSilver;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringPastelPurple]) {
    return BFElementMediaBackgroundColorNumberPastelPurple;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringBlueWithWhiteInk]) {
    return BFElementMediaBackgroundColorNumberBlueWithWhiteInk;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringRedWithWhiteInk]) {
    return BFElementMediaBackgroundColorNumberRedWithWhiteInk;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringFluorescentOrange]) {
    return BFElementMediaBackgroundColorNumberFluorescentOrange;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringFluorescentYellow]) {
    return BFElementMediaBackgroundColorNumberFluorescentYellow;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringBerryPink]) {
    return BFElementMediaBackgroundColorNumberBerryPink;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringLightGray]) {
    return BFElementMediaBackgroundColorNumberLightGray;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringLimeGreen]) {
    return BFElementMediaBackgroundColorNumberLimeGreen;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringSatinNavyBlue]) {
    return BFElementMediaBackgroundColorNumberSatinNavyBlue;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringSatinWineRed]) {
    return BFElementMediaBackgroundColorNumberSatinWineRed;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringFabricYellow]) {
    return BFElementMediaBackgroundColorNumberFabricYellow;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringFabricPink]) {
    return BFElementMediaBackgroundColorNumberFabricPink;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringFabricBlue]) {
    return BFElementMediaBackgroundColorNumberFabricBlue;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringTubeWhite]) {
    return BFElementMediaBackgroundColorNumberTubeWhite;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringSelfLaminatedWhite]) {
    return BFElementMediaBackgroundColorNumberSelfLaminatedWhite;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringFlexibleWhite]) {
    return BFElementMediaBackgroundColorNumberFlexibleWhite;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringFlexibleYellow]) {
    return BFElementMediaBackgroundColorNumberFlexibleYellow;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringCleaningWhite]) {
    return BFElementMediaBackgroundColorNumberCleaningWhite;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringStencilWhite]) {
    return BFElementMediaBackgroundColorNumberStencilWhite;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringLightBlue_Satin]) {
    return BFElementMediaBackgroundColorNumberLightBlue_Satin;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringMint_Satin]) {
    return BFElementMediaBackgroundColorNumberMint_Satin;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringSilver_Satin]) {
    return BFElementMediaBackgroundColorNumberSilver_Satin;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorStringIncompatible]) {
    return BFElementMediaBackgroundColorNumberIncompatible;
  }
  if ([str isEqualToString:BFElementMediaBackgroundColorString__Null]) {
    return BFElementMediaBackgroundColorNumber__Null;
  }
  return BFElementMediaBackgroundColorNumber__Null;
}
+ (nonnull NSString*)key {
  return @"MediaBackgroundColor";
}
@end

NSString * __nonnull const BFElementMediaPaperInsertionPositionStringLeft = @"Left";
NSString * __nonnull const BFElementMediaPaperInsertionPositionStringCenter = @"Center";
NSString * __nonnull const BFElementMediaPaperInsertionPositionStringRight = @"Right";
NSString * __nonnull const BFElementMediaPaperInsertionPositionString__Null = @"__Null";
@implementation BFElementMediaPaperInsertionPosition
+ (nonnull NSString*)convertToString:(BFElementMediaPaperInsertionPositionNumber)num {
  switch(num) {
  case BFElementMediaPaperInsertionPositionNumberLeft: return BFElementMediaPaperInsertionPositionStringLeft;
  case BFElementMediaPaperInsertionPositionNumberCenter: return BFElementMediaPaperInsertionPositionStringCenter;
  case BFElementMediaPaperInsertionPositionNumberRight: return BFElementMediaPaperInsertionPositionStringRight;
  case BFElementMediaPaperInsertionPositionNumber__Null: return BFElementMediaPaperInsertionPositionString__Null;
  }
  return BFElementMediaPaperInsertionPositionString__Null;
}
+ (BFElementMediaPaperInsertionPositionNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementMediaPaperInsertionPositionStringLeft]) {
    return BFElementMediaPaperInsertionPositionNumberLeft;
  }
  if ([str isEqualToString:BFElementMediaPaperInsertionPositionStringCenter]) {
    return BFElementMediaPaperInsertionPositionNumberCenter;
  }
  if ([str isEqualToString:BFElementMediaPaperInsertionPositionStringRight]) {
    return BFElementMediaPaperInsertionPositionNumberRight;
  }
  if ([str isEqualToString:BFElementMediaPaperInsertionPositionString__Null]) {
    return BFElementMediaPaperInsertionPositionNumber__Null;
  }
  return BFElementMediaPaperInsertionPositionNumber__Null;
}
+ (nonnull NSString*)key {
  return @"MediaPaperInsertionPosition";
}
@end

@implementation BFElementMediaPJForceStretchPrintableArea
+ (nonnull NSString*)key {
  return @"MediaPJForceStretchPrintableArea";
}
@end

NSString * __nonnull const BFElementMediaPJPaperTypeStringRoll = @"Roll";
NSString * __nonnull const BFElementMediaPJPaperTypeStringCutSheet = @"CutSheet";
NSString * __nonnull const BFElementMediaPJPaperTypeStringPerforatedRoll = @"PerforatedRoll";
NSString * __nonnull const BFElementMediaPJPaperTypeString__Null = @"__Null";
@implementation BFElementMediaPJPaperType
+ (nonnull NSString*)convertToString:(BFElementMediaPJPaperTypeNumber)num {
  switch(num) {
  case BFElementMediaPJPaperTypeNumberRoll: return BFElementMediaPJPaperTypeStringRoll;
  case BFElementMediaPJPaperTypeNumberCutSheet: return BFElementMediaPJPaperTypeStringCutSheet;
  case BFElementMediaPJPaperTypeNumberPerforatedRoll: return BFElementMediaPJPaperTypeStringPerforatedRoll;
  case BFElementMediaPJPaperTypeNumber__Null: return BFElementMediaPJPaperTypeString__Null;
  }
  return BFElementMediaPJPaperTypeString__Null;
}
+ (BFElementMediaPJPaperTypeNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementMediaPJPaperTypeStringRoll]) {
    return BFElementMediaPJPaperTypeNumberRoll;
  }
  if ([str isEqualToString:BFElementMediaPJPaperTypeStringCutSheet]) {
    return BFElementMediaPJPaperTypeNumberCutSheet;
  }
  if ([str isEqualToString:BFElementMediaPJPaperTypeStringPerforatedRoll]) {
    return BFElementMediaPJPaperTypeNumberPerforatedRoll;
  }
  if ([str isEqualToString:BFElementMediaPJPaperTypeString__Null]) {
    return BFElementMediaPJPaperTypeNumber__Null;
  }
  return BFElementMediaPJPaperTypeNumber__Null;
}
+ (nonnull NSString*)key {
  return @"MediaPJPaperType";
}
@end

NSString * __nonnull const BFElementMediaPJRollCaseStringNone = @"None";
NSString * __nonnull const BFElementMediaPJRollCaseStringPARC001_NoAntiCurl = @"PARC001_NoAntiCurl";
NSString * __nonnull const BFElementMediaPJRollCaseStringPARC001 = @"PARC001";
NSString * __nonnull const BFElementMediaPJRollCaseStringPARC001_ShortFeed = @"PARC001_ShortFeed";
NSString * __nonnull const BFElementMediaPJRollCaseStringKeepPrinterSetting = @"KeepPrinterSetting";
NSString * __nonnull const BFElementMediaPJRollCaseString__Null = @"__Null";
@implementation BFElementMediaPJRollCase
+ (nonnull NSString*)convertToString:(BFElementMediaPJRollCaseNumber)num {
  switch(num) {
  case BFElementMediaPJRollCaseNumberNone: return BFElementMediaPJRollCaseStringNone;
  case BFElementMediaPJRollCaseNumberPARC001_NoAntiCurl: return BFElementMediaPJRollCaseStringPARC001_NoAntiCurl;
  case BFElementMediaPJRollCaseNumberPARC001: return BFElementMediaPJRollCaseStringPARC001;
  case BFElementMediaPJRollCaseNumberPARC001_ShortFeed: return BFElementMediaPJRollCaseStringPARC001_ShortFeed;
  case BFElementMediaPJRollCaseNumberKeepPrinterSetting: return BFElementMediaPJRollCaseStringKeepPrinterSetting;
  case BFElementMediaPJRollCaseNumber__Null: return BFElementMediaPJRollCaseString__Null;
  }
  return BFElementMediaPJRollCaseString__Null;
}
+ (BFElementMediaPJRollCaseNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementMediaPJRollCaseStringNone]) {
    return BFElementMediaPJRollCaseNumberNone;
  }
  if ([str isEqualToString:BFElementMediaPJRollCaseStringPARC001_NoAntiCurl]) {
    return BFElementMediaPJRollCaseNumberPARC001_NoAntiCurl;
  }
  if ([str isEqualToString:BFElementMediaPJRollCaseStringPARC001]) {
    return BFElementMediaPJRollCaseNumberPARC001;
  }
  if ([str isEqualToString:BFElementMediaPJRollCaseStringPARC001_ShortFeed]) {
    return BFElementMediaPJRollCaseNumberPARC001_ShortFeed;
  }
  if ([str isEqualToString:BFElementMediaPJRollCaseStringKeepPrinterSetting]) {
    return BFElementMediaPJRollCaseNumberKeepPrinterSetting;
  }
  if ([str isEqualToString:BFElementMediaPJRollCaseString__Null]) {
    return BFElementMediaPJRollCaseNumber__Null;
  }
  return BFElementMediaPJRollCaseNumber__Null;
}
+ (nonnull NSString*)key {
  return @"MediaPJRollCase";
}
@end

NSString * __nonnull const BFElementMediaSizeStringL3_5mm = @"L3.5mm";
NSString * __nonnull const BFElementMediaSizeStringL6mm = @"L6mm";
NSString * __nonnull const BFElementMediaSizeStringL9mm = @"L9mm";
NSString * __nonnull const BFElementMediaSizeStringL12mm = @"L12mm";
NSString * __nonnull const BFElementMediaSizeStringL18mm = @"L18mm";
NSString * __nonnull const BFElementMediaSizeStringL24mm = @"L24mm";
NSString * __nonnull const BFElementMediaSizeStringL29mm = @"L29mm";
NSString * __nonnull const BFElementMediaSizeStringL36mm = @"L36mm";
NSString * __nonnull const BFElementMediaSizeStringL38mm = @"L38mm";
NSString * __nonnull const BFElementMediaSizeStringL50mm = @"L50mm";
NSString * __nonnull const BFElementMediaSizeStringL54mm = @"L54mm";
NSString * __nonnull const BFElementMediaSizeStringL62mm = @"L62mm";
NSString * __nonnull const BFElementMediaSizeStringL102mm = @"L102mm";
NSString * __nonnull const BFElementMediaSizeStringL103mm = @"L103mm";
NSString * __nonnull const BFElementMediaSizeStringL17mmx54mm = @"L17mmx54mm";
NSString * __nonnull const BFElementMediaSizeStringL17mmx87mm = @"L17mmx87mm";
NSString * __nonnull const BFElementMediaSizeStringL23mmx23mm = @"L23mmx23mm";
NSString * __nonnull const BFElementMediaSizeStringL29mmx42mm = @"L29mmx42mm";
NSString * __nonnull const BFElementMediaSizeStringL29mmx90mm = @"L29mmx90mm";
NSString * __nonnull const BFElementMediaSizeStringL38mmx90mm = @"L38mmx90mm";
NSString * __nonnull const BFElementMediaSizeStringL39mmx48mm = @"L39mmx48mm";
NSString * __nonnull const BFElementMediaSizeStringL52mmx29mm = @"L52mmx29mm";
NSString * __nonnull const BFElementMediaSizeStringL54mmx29mm = @"L54mmx29mm";
NSString * __nonnull const BFElementMediaSizeStringL60mmx86mm = @"L60mmx86mm";
NSString * __nonnull const BFElementMediaSizeStringL62mmx29mm = @"L62mmx29mm";
NSString * __nonnull const BFElementMediaSizeStringL62mmx60mm = @"L62mmx60mm";
NSString * __nonnull const BFElementMediaSizeStringL62mmx75mm = @"L62mmx75mm";
NSString * __nonnull const BFElementMediaSizeStringL62mmx100mm = @"L62mmx100mm";
NSString * __nonnull const BFElementMediaSizeStringL102mmx51mm = @"L102mmx51mm";
NSString * __nonnull const BFElementMediaSizeStringL102mmx152mm = @"L102mmx152mm";
NSString * __nonnull const BFElementMediaSizeStringL103mmx164mm = @"L103mmx164mm";
NSString * __nonnull const BFElementMediaSizeStringL12mmDia = @"L12mmDia";
NSString * __nonnull const BFElementMediaSizeStringL24mmDia = @"L24mmDia";
NSString * __nonnull const BFElementMediaSizeStringL58mmDia = @"L58mmDia";
NSString * __nonnull const BFElementMediaSizeStringHS5_8mm = @"HS5.8mm";
NSString * __nonnull const BFElementMediaSizeStringHS8_8mm = @"HS8.8mm";
NSString * __nonnull const BFElementMediaSizeStringHS11_7mm = @"HS11.7mm";
NSString * __nonnull const BFElementMediaSizeStringHS17_7mm = @"HS17.7mm";
NSString * __nonnull const BFElementMediaSizeStringHS23_6mm = @"HS23.6mm";
NSString * __nonnull const BFElementMediaSizeStringHS5_2mm = @"HS5.2mm";
NSString * __nonnull const BFElementMediaSizeStringHS9_0mm = @"HS9.0mm";
NSString * __nonnull const BFElementMediaSizeStringHS11_2mm = @"HS11.2mm";
NSString * __nonnull const BFElementMediaSizeStringHS21_0mm = @"HS21.0mm";
NSString * __nonnull const BFElementMediaSizeStringHS31_0mm = @"HS31.0mm";
NSString * __nonnull const BFElementMediaSizeStringFL21mmx45mm = @"FL21mmx45mm";
NSString * __nonnull const BFElementMediaSizeStringA4 = @"A4";
NSString * __nonnull const BFElementMediaSizeStringA5 = @"A5";
NSString * __nonnull const BFElementMediaSizeStringLetter = @"Letter";
NSString * __nonnull const BFElementMediaSizeStringLegal = @"Legal";
NSString * __nonnull const BFElementMediaSizeStringCustom = @"Custom";
NSString * __nonnull const BFElementMediaSizeString__Null = @"__Null";
@implementation BFElementMediaSize
+ (nonnull NSString*)convertToString:(BFElementMediaSizeNumber)num {
  switch(num) {
  case BFElementMediaSizeNumberL3_5mm: return BFElementMediaSizeStringL3_5mm;
  case BFElementMediaSizeNumberL6mm: return BFElementMediaSizeStringL6mm;
  case BFElementMediaSizeNumberL9mm: return BFElementMediaSizeStringL9mm;
  case BFElementMediaSizeNumberL12mm: return BFElementMediaSizeStringL12mm;
  case BFElementMediaSizeNumberL18mm: return BFElementMediaSizeStringL18mm;
  case BFElementMediaSizeNumberL24mm: return BFElementMediaSizeStringL24mm;
  case BFElementMediaSizeNumberL29mm: return BFElementMediaSizeStringL29mm;
  case BFElementMediaSizeNumberL36mm: return BFElementMediaSizeStringL36mm;
  case BFElementMediaSizeNumberL38mm: return BFElementMediaSizeStringL38mm;
  case BFElementMediaSizeNumberL50mm: return BFElementMediaSizeStringL50mm;
  case BFElementMediaSizeNumberL54mm: return BFElementMediaSizeStringL54mm;
  case BFElementMediaSizeNumberL62mm: return BFElementMediaSizeStringL62mm;
  case BFElementMediaSizeNumberL102mm: return BFElementMediaSizeStringL102mm;
  case BFElementMediaSizeNumberL103mm: return BFElementMediaSizeStringL103mm;
  case BFElementMediaSizeNumberL17mmx54mm: return BFElementMediaSizeStringL17mmx54mm;
  case BFElementMediaSizeNumberL17mmx87mm: return BFElementMediaSizeStringL17mmx87mm;
  case BFElementMediaSizeNumberL23mmx23mm: return BFElementMediaSizeStringL23mmx23mm;
  case BFElementMediaSizeNumberL29mmx42mm: return BFElementMediaSizeStringL29mmx42mm;
  case BFElementMediaSizeNumberL29mmx90mm: return BFElementMediaSizeStringL29mmx90mm;
  case BFElementMediaSizeNumberL38mmx90mm: return BFElementMediaSizeStringL38mmx90mm;
  case BFElementMediaSizeNumberL39mmx48mm: return BFElementMediaSizeStringL39mmx48mm;
  case BFElementMediaSizeNumberL52mmx29mm: return BFElementMediaSizeStringL52mmx29mm;
  case BFElementMediaSizeNumberL54mmx29mm: return BFElementMediaSizeStringL54mmx29mm;
  case BFElementMediaSizeNumberL60mmx86mm: return BFElementMediaSizeStringL60mmx86mm;
  case BFElementMediaSizeNumberL62mmx29mm: return BFElementMediaSizeStringL62mmx29mm;
  case BFElementMediaSizeNumberL62mmx60mm: return BFElementMediaSizeStringL62mmx60mm;
  case BFElementMediaSizeNumberL62mmx75mm: return BFElementMediaSizeStringL62mmx75mm;
  case BFElementMediaSizeNumberL62mmx100mm: return BFElementMediaSizeStringL62mmx100mm;
  case BFElementMediaSizeNumberL102mmx51mm: return BFElementMediaSizeStringL102mmx51mm;
  case BFElementMediaSizeNumberL102mmx152mm: return BFElementMediaSizeStringL102mmx152mm;
  case BFElementMediaSizeNumberL103mmx164mm: return BFElementMediaSizeStringL103mmx164mm;
  case BFElementMediaSizeNumberL12mmDia: return BFElementMediaSizeStringL12mmDia;
  case BFElementMediaSizeNumberL24mmDia: return BFElementMediaSizeStringL24mmDia;
  case BFElementMediaSizeNumberL58mmDia: return BFElementMediaSizeStringL58mmDia;
  case BFElementMediaSizeNumberHS5_8mm: return BFElementMediaSizeStringHS5_8mm;
  case BFElementMediaSizeNumberHS8_8mm: return BFElementMediaSizeStringHS8_8mm;
  case BFElementMediaSizeNumberHS11_7mm: return BFElementMediaSizeStringHS11_7mm;
  case BFElementMediaSizeNumberHS17_7mm: return BFElementMediaSizeStringHS17_7mm;
  case BFElementMediaSizeNumberHS23_6mm: return BFElementMediaSizeStringHS23_6mm;
  case BFElementMediaSizeNumberHS5_2mm: return BFElementMediaSizeStringHS5_2mm;
  case BFElementMediaSizeNumberHS9_0mm: return BFElementMediaSizeStringHS9_0mm;
  case BFElementMediaSizeNumberHS11_2mm: return BFElementMediaSizeStringHS11_2mm;
  case BFElementMediaSizeNumberHS21_0mm: return BFElementMediaSizeStringHS21_0mm;
  case BFElementMediaSizeNumberHS31_0mm: return BFElementMediaSizeStringHS31_0mm;
  case BFElementMediaSizeNumberFL21mmx45mm: return BFElementMediaSizeStringFL21mmx45mm;
  case BFElementMediaSizeNumberA4: return BFElementMediaSizeStringA4;
  case BFElementMediaSizeNumberA5: return BFElementMediaSizeStringA5;
  case BFElementMediaSizeNumberLetter: return BFElementMediaSizeStringLetter;
  case BFElementMediaSizeNumberLegal: return BFElementMediaSizeStringLegal;
  case BFElementMediaSizeNumberCustom: return BFElementMediaSizeStringCustom;
  case BFElementMediaSizeNumber__Null: return BFElementMediaSizeString__Null;
  }
  return BFElementMediaSizeString__Null;
}
+ (BFElementMediaSizeNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementMediaSizeStringL3_5mm]) {
    return BFElementMediaSizeNumberL3_5mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL6mm]) {
    return BFElementMediaSizeNumberL6mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL9mm]) {
    return BFElementMediaSizeNumberL9mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL12mm]) {
    return BFElementMediaSizeNumberL12mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL18mm]) {
    return BFElementMediaSizeNumberL18mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL24mm]) {
    return BFElementMediaSizeNumberL24mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL29mm]) {
    return BFElementMediaSizeNumberL29mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL36mm]) {
    return BFElementMediaSizeNumberL36mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL38mm]) {
    return BFElementMediaSizeNumberL38mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL50mm]) {
    return BFElementMediaSizeNumberL50mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL54mm]) {
    return BFElementMediaSizeNumberL54mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL62mm]) {
    return BFElementMediaSizeNumberL62mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL102mm]) {
    return BFElementMediaSizeNumberL102mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL103mm]) {
    return BFElementMediaSizeNumberL103mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL17mmx54mm]) {
    return BFElementMediaSizeNumberL17mmx54mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL17mmx87mm]) {
    return BFElementMediaSizeNumberL17mmx87mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL23mmx23mm]) {
    return BFElementMediaSizeNumberL23mmx23mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL29mmx42mm]) {
    return BFElementMediaSizeNumberL29mmx42mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL29mmx90mm]) {
    return BFElementMediaSizeNumberL29mmx90mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL38mmx90mm]) {
    return BFElementMediaSizeNumberL38mmx90mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL39mmx48mm]) {
    return BFElementMediaSizeNumberL39mmx48mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL52mmx29mm]) {
    return BFElementMediaSizeNumberL52mmx29mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL54mmx29mm]) {
    return BFElementMediaSizeNumberL54mmx29mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL60mmx86mm]) {
    return BFElementMediaSizeNumberL60mmx86mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL62mmx29mm]) {
    return BFElementMediaSizeNumberL62mmx29mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL62mmx60mm]) {
    return BFElementMediaSizeNumberL62mmx60mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL62mmx75mm]) {
    return BFElementMediaSizeNumberL62mmx75mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL62mmx100mm]) {
    return BFElementMediaSizeNumberL62mmx100mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL102mmx51mm]) {
    return BFElementMediaSizeNumberL102mmx51mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL102mmx152mm]) {
    return BFElementMediaSizeNumberL102mmx152mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL103mmx164mm]) {
    return BFElementMediaSizeNumberL103mmx164mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL12mmDia]) {
    return BFElementMediaSizeNumberL12mmDia;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL24mmDia]) {
    return BFElementMediaSizeNumberL24mmDia;
  }
  if ([str isEqualToString:BFElementMediaSizeStringL58mmDia]) {
    return BFElementMediaSizeNumberL58mmDia;
  }
  if ([str isEqualToString:BFElementMediaSizeStringHS5_8mm]) {
    return BFElementMediaSizeNumberHS5_8mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringHS8_8mm]) {
    return BFElementMediaSizeNumberHS8_8mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringHS11_7mm]) {
    return BFElementMediaSizeNumberHS11_7mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringHS17_7mm]) {
    return BFElementMediaSizeNumberHS17_7mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringHS23_6mm]) {
    return BFElementMediaSizeNumberHS23_6mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringHS5_2mm]) {
    return BFElementMediaSizeNumberHS5_2mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringHS9_0mm]) {
    return BFElementMediaSizeNumberHS9_0mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringHS11_2mm]) {
    return BFElementMediaSizeNumberHS11_2mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringHS21_0mm]) {
    return BFElementMediaSizeNumberHS21_0mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringHS31_0mm]) {
    return BFElementMediaSizeNumberHS31_0mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringFL21mmx45mm]) {
    return BFElementMediaSizeNumberFL21mmx45mm;
  }
  if ([str isEqualToString:BFElementMediaSizeStringA4]) {
    return BFElementMediaSizeNumberA4;
  }
  if ([str isEqualToString:BFElementMediaSizeStringA5]) {
    return BFElementMediaSizeNumberA5;
  }
  if ([str isEqualToString:BFElementMediaSizeStringLetter]) {
    return BFElementMediaSizeNumberLetter;
  }
  if ([str isEqualToString:BFElementMediaSizeStringLegal]) {
    return BFElementMediaSizeNumberLegal;
  }
  if ([str isEqualToString:BFElementMediaSizeStringCustom]) {
    return BFElementMediaSizeNumberCustom;
  }
  if ([str isEqualToString:BFElementMediaSizeString__Null]) {
    return BFElementMediaSizeNumber__Null;
  }
  return BFElementMediaSizeNumber__Null;
}
+ (nonnull NSString*)key {
  return @"MediaSize";
}
@end

NSString * __nonnull const BFElementMediaTextColorStringStandard = @"Standard";
NSString * __nonnull const BFElementMediaTextColorStringWhite = @"White";
NSString * __nonnull const BFElementMediaTextColorStringOthers = @"Others";
NSString * __nonnull const BFElementMediaTextColorStringRed = @"Red";
NSString * __nonnull const BFElementMediaTextColorStringBlue = @"Blue";
NSString * __nonnull const BFElementMediaTextColorStringBlack = @"Black";
NSString * __nonnull const BFElementMediaTextColorStringGold = @"Gold";
NSString * __nonnull const BFElementMediaTextColorStringRedAndBlack = @"RedAndBlack";
NSString * __nonnull const BFElementMediaTextColorStringFabricBlue = @"FabricBlue";
NSString * __nonnull const BFElementMediaTextColorStringCleaningBlack = @"CleaningBlack";
NSString * __nonnull const BFElementMediaTextColorStringStencilBlack = @"StencilBlack";
NSString * __nonnull const BFElementMediaTextColorStringIncompatible = @"Incompatible";
NSString * __nonnull const BFElementMediaTextColorString__Null = @"__Null";
@implementation BFElementMediaTextColor
+ (nonnull NSString*)convertToString:(BFElementMediaTextColorNumber)num {
  switch(num) {
  case BFElementMediaTextColorNumberStandard: return BFElementMediaTextColorStringStandard;
  case BFElementMediaTextColorNumberWhite: return BFElementMediaTextColorStringWhite;
  case BFElementMediaTextColorNumberOthers: return BFElementMediaTextColorStringOthers;
  case BFElementMediaTextColorNumberRed: return BFElementMediaTextColorStringRed;
  case BFElementMediaTextColorNumberBlue: return BFElementMediaTextColorStringBlue;
  case BFElementMediaTextColorNumberBlack: return BFElementMediaTextColorStringBlack;
  case BFElementMediaTextColorNumberGold: return BFElementMediaTextColorStringGold;
  case BFElementMediaTextColorNumberRedAndBlack: return BFElementMediaTextColorStringRedAndBlack;
  case BFElementMediaTextColorNumberFabricBlue: return BFElementMediaTextColorStringFabricBlue;
  case BFElementMediaTextColorNumberCleaningBlack: return BFElementMediaTextColorStringCleaningBlack;
  case BFElementMediaTextColorNumberStencilBlack: return BFElementMediaTextColorStringStencilBlack;
  case BFElementMediaTextColorNumberIncompatible: return BFElementMediaTextColorStringIncompatible;
  case BFElementMediaTextColorNumber__Null: return BFElementMediaTextColorString__Null;
  }
  return BFElementMediaTextColorString__Null;
}
+ (BFElementMediaTextColorNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementMediaTextColorStringStandard]) {
    return BFElementMediaTextColorNumberStandard;
  }
  if ([str isEqualToString:BFElementMediaTextColorStringWhite]) {
    return BFElementMediaTextColorNumberWhite;
  }
  if ([str isEqualToString:BFElementMediaTextColorStringOthers]) {
    return BFElementMediaTextColorNumberOthers;
  }
  if ([str isEqualToString:BFElementMediaTextColorStringRed]) {
    return BFElementMediaTextColorNumberRed;
  }
  if ([str isEqualToString:BFElementMediaTextColorStringBlue]) {
    return BFElementMediaTextColorNumberBlue;
  }
  if ([str isEqualToString:BFElementMediaTextColorStringBlack]) {
    return BFElementMediaTextColorNumberBlack;
  }
  if ([str isEqualToString:BFElementMediaTextColorStringGold]) {
    return BFElementMediaTextColorNumberGold;
  }
  if ([str isEqualToString:BFElementMediaTextColorStringRedAndBlack]) {
    return BFElementMediaTextColorNumberRedAndBlack;
  }
  if ([str isEqualToString:BFElementMediaTextColorStringFabricBlue]) {
    return BFElementMediaTextColorNumberFabricBlue;
  }
  if ([str isEqualToString:BFElementMediaTextColorStringCleaningBlack]) {
    return BFElementMediaTextColorNumberCleaningBlack;
  }
  if ([str isEqualToString:BFElementMediaTextColorStringStencilBlack]) {
    return BFElementMediaTextColorNumberStencilBlack;
  }
  if ([str isEqualToString:BFElementMediaTextColorStringIncompatible]) {
    return BFElementMediaTextColorNumberIncompatible;
  }
  if ([str isEqualToString:BFElementMediaTextColorString__Null]) {
    return BFElementMediaTextColorNumber__Null;
  }
  return BFElementMediaTextColorNumber__Null;
}
+ (nonnull NSString*)key {
  return @"MediaTextColor";
}
@end

NSString * __nonnull const BFElementMediaTypeStringUnknown = @"Unknown";
NSString * __nonnull const BFElementMediaTypeStringPTLaminate = @"PTLaminate";
NSString * __nonnull const BFElementMediaTypeStringPTNonLaminate = @"PTNonLaminate";
NSString * __nonnull const BFElementMediaTypeStringPTFabric = @"PTFabric";
NSString * __nonnull const BFElementMediaTypeStringQLInfiniteLable = @"QLInfiniteLable";
NSString * __nonnull const BFElementMediaTypeStringQLDieCutLable = @"QLDieCutLable";
NSString * __nonnull const BFElementMediaTypeStringPTHeatShrink = @"PTHeatShrink";
NSString * __nonnull const BFElementMediaTypeStringPTFLe = @"PTFLe";
NSString * __nonnull const BFElementMediaTypeStringPTFlexibleID = @"PTFlexibleID";
NSString * __nonnull const BFElementMediaTypeStringPTSatin = @"PTSatin";
NSString * __nonnull const BFElementMediaTypeStringPTSelfLaminate = @"PTSelfLaminate";
NSString * __nonnull const BFElementMediaTypeStringIncompatible = @"Incompatible";
NSString * __nonnull const BFElementMediaTypeString__Null = @"__Null";
@implementation BFElementMediaType
+ (nonnull NSString*)convertToString:(BFElementMediaTypeNumber)num {
  switch(num) {
  case BFElementMediaTypeNumberUnknown: return BFElementMediaTypeStringUnknown;
  case BFElementMediaTypeNumberPTLaminate: return BFElementMediaTypeStringPTLaminate;
  case BFElementMediaTypeNumberPTNonLaminate: return BFElementMediaTypeStringPTNonLaminate;
  case BFElementMediaTypeNumberPTFabric: return BFElementMediaTypeStringPTFabric;
  case BFElementMediaTypeNumberQLInfiniteLable: return BFElementMediaTypeStringQLInfiniteLable;
  case BFElementMediaTypeNumberQLDieCutLable: return BFElementMediaTypeStringQLDieCutLable;
  case BFElementMediaTypeNumberPTHeatShrink: return BFElementMediaTypeStringPTHeatShrink;
  case BFElementMediaTypeNumberPTFLe: return BFElementMediaTypeStringPTFLe;
  case BFElementMediaTypeNumberPTFlexibleID: return BFElementMediaTypeStringPTFlexibleID;
  case BFElementMediaTypeNumberPTSatin: return BFElementMediaTypeStringPTSatin;
  case BFElementMediaTypeNumberPTSelfLaminate: return BFElementMediaTypeStringPTSelfLaminate;
  case BFElementMediaTypeNumberIncompatible: return BFElementMediaTypeStringIncompatible;
  case BFElementMediaTypeNumber__Null: return BFElementMediaTypeString__Null;
  }
  return BFElementMediaTypeString__Null;
}
+ (BFElementMediaTypeNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementMediaTypeStringUnknown]) {
    return BFElementMediaTypeNumberUnknown;
  }
  if ([str isEqualToString:BFElementMediaTypeStringPTLaminate]) {
    return BFElementMediaTypeNumberPTLaminate;
  }
  if ([str isEqualToString:BFElementMediaTypeStringPTNonLaminate]) {
    return BFElementMediaTypeNumberPTNonLaminate;
  }
  if ([str isEqualToString:BFElementMediaTypeStringPTFabric]) {
    return BFElementMediaTypeNumberPTFabric;
  }
  if ([str isEqualToString:BFElementMediaTypeStringQLInfiniteLable]) {
    return BFElementMediaTypeNumberQLInfiniteLable;
  }
  if ([str isEqualToString:BFElementMediaTypeStringQLDieCutLable]) {
    return BFElementMediaTypeNumberQLDieCutLable;
  }
  if ([str isEqualToString:BFElementMediaTypeStringPTHeatShrink]) {
    return BFElementMediaTypeNumberPTHeatShrink;
  }
  if ([str isEqualToString:BFElementMediaTypeStringPTFLe]) {
    return BFElementMediaTypeNumberPTFLe;
  }
  if ([str isEqualToString:BFElementMediaTypeStringPTFlexibleID]) {
    return BFElementMediaTypeNumberPTFlexibleID;
  }
  if ([str isEqualToString:BFElementMediaTypeStringPTSatin]) {
    return BFElementMediaTypeNumberPTSatin;
  }
  if ([str isEqualToString:BFElementMediaTypeStringPTSelfLaminate]) {
    return BFElementMediaTypeNumberPTSelfLaminate;
  }
  if ([str isEqualToString:BFElementMediaTypeStringIncompatible]) {
    return BFElementMediaTypeNumberIncompatible;
  }
  if ([str isEqualToString:BFElementMediaTypeString__Null]) {
    return BFElementMediaTypeNumber__Null;
  }
  return BFElementMediaTypeNumber__Null;
}
+ (nonnull NSString*)key {
  return @"MediaType";
}
@end

