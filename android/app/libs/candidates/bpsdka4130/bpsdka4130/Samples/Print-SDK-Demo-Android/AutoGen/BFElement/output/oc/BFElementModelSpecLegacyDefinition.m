

#import "BFElementModelSpecLegacyDefinition.h"

NSString * __nonnull const BFElementModelSpecLegacyBatteryCommandTypeStringPS_BAT_NON = @"PS_BAT_NON";
NSString * __nonnull const BFElementModelSpecLegacyBatteryCommandTypeStringPS_BAT_PJCOMMAND = @"PS_BAT_PJCOMMAND";
NSString * __nonnull const BFElementModelSpecLegacyBatteryCommandTypeStringPS_BAT_MW145COMMAND = @"PS_BAT_MW145COMMAND";
NSString * __nonnull const BFElementModelSpecLegacyBatteryCommandTypeStringPS_BAT_MW260COMMAND = @"PS_BAT_MW260COMMAND";
NSString * __nonnull const BFElementModelSpecLegacyBatteryCommandTypeStringPS_BAT_FROMSTATUS = @"PS_BAT_FROMSTATUS";
NSString * __nonnull const BFElementModelSpecLegacyBatteryCommandTypeString__Null = @"__Null";
@implementation BFElementModelSpecLegacyBatteryCommandType
+ (nonnull NSString*)convertToString:(BFElementModelSpecLegacyBatteryCommandTypeNumber)num {
  switch(num) {
  case BFElementModelSpecLegacyBatteryCommandTypeNumberPS_BAT_NON: return BFElementModelSpecLegacyBatteryCommandTypeStringPS_BAT_NON;
  case BFElementModelSpecLegacyBatteryCommandTypeNumberPS_BAT_PJCOMMAND: return BFElementModelSpecLegacyBatteryCommandTypeStringPS_BAT_PJCOMMAND;
  case BFElementModelSpecLegacyBatteryCommandTypeNumberPS_BAT_MW145COMMAND: return BFElementModelSpecLegacyBatteryCommandTypeStringPS_BAT_MW145COMMAND;
  case BFElementModelSpecLegacyBatteryCommandTypeNumberPS_BAT_MW260COMMAND: return BFElementModelSpecLegacyBatteryCommandTypeStringPS_BAT_MW260COMMAND;
  case BFElementModelSpecLegacyBatteryCommandTypeNumberPS_BAT_FROMSTATUS: return BFElementModelSpecLegacyBatteryCommandTypeStringPS_BAT_FROMSTATUS;
  case BFElementModelSpecLegacyBatteryCommandTypeNumber__Null: return BFElementModelSpecLegacyBatteryCommandTypeString__Null;
  }
  return BFElementModelSpecLegacyBatteryCommandTypeString__Null;
}
+ (BFElementModelSpecLegacyBatteryCommandTypeNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementModelSpecLegacyBatteryCommandTypeStringPS_BAT_NON]) {
    return BFElementModelSpecLegacyBatteryCommandTypeNumberPS_BAT_NON;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyBatteryCommandTypeStringPS_BAT_PJCOMMAND]) {
    return BFElementModelSpecLegacyBatteryCommandTypeNumberPS_BAT_PJCOMMAND;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyBatteryCommandTypeStringPS_BAT_MW145COMMAND]) {
    return BFElementModelSpecLegacyBatteryCommandTypeNumberPS_BAT_MW145COMMAND;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyBatteryCommandTypeStringPS_BAT_MW260COMMAND]) {
    return BFElementModelSpecLegacyBatteryCommandTypeNumberPS_BAT_MW260COMMAND;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyBatteryCommandTypeStringPS_BAT_FROMSTATUS]) {
    return BFElementModelSpecLegacyBatteryCommandTypeNumberPS_BAT_FROMSTATUS;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyBatteryCommandTypeString__Null]) {
    return BFElementModelSpecLegacyBatteryCommandTypeNumber__Null;
  }
  return BFElementModelSpecLegacyBatteryCommandTypeNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyBatteryCommandType";
}
@end

@implementation BFElementModelSpecLegacyBitOrderOfBitmapIsLittle
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyBitOrderOfBitmapIsLittle";
}
@end

@implementation BFElementModelSpecLegacyChangeStatusMode
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyChangeStatusMode";
}
@end

@implementation BFElementModelSpecLegacyFirmUpdateShouldChangeCommandMode
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyFirmUpdateShouldChangeCommandMode";
}
@end

NSString * __nonnull const BFElementModelSpecLegacyGraphicCommandTypeStringG_COMMAND_g = @"G_COMMAND_g";
NSString * __nonnull const BFElementModelSpecLegacyGraphicCommandTypeStringG_COMMAND_G = @"G_COMMAND_G";
NSString * __nonnull const BFElementModelSpecLegacyGraphicCommandTypeStringG_COMMAND_PJ = @"G_COMMAND_PJ";
NSString * __nonnull const BFElementModelSpecLegacyGraphicCommandTypeString__Null = @"__Null";
@implementation BFElementModelSpecLegacyGraphicCommandType
+ (nonnull NSString*)convertToString:(BFElementModelSpecLegacyGraphicCommandTypeNumber)num {
  switch(num) {
  case BFElementModelSpecLegacyGraphicCommandTypeNumberG_COMMAND_g: return BFElementModelSpecLegacyGraphicCommandTypeStringG_COMMAND_g;
  case BFElementModelSpecLegacyGraphicCommandTypeNumberG_COMMAND_G: return BFElementModelSpecLegacyGraphicCommandTypeStringG_COMMAND_G;
  case BFElementModelSpecLegacyGraphicCommandTypeNumberG_COMMAND_PJ: return BFElementModelSpecLegacyGraphicCommandTypeStringG_COMMAND_PJ;
  case BFElementModelSpecLegacyGraphicCommandTypeNumber__Null: return BFElementModelSpecLegacyGraphicCommandTypeString__Null;
  }
  return BFElementModelSpecLegacyGraphicCommandTypeString__Null;
}
+ (BFElementModelSpecLegacyGraphicCommandTypeNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementModelSpecLegacyGraphicCommandTypeStringG_COMMAND_g]) {
    return BFElementModelSpecLegacyGraphicCommandTypeNumberG_COMMAND_g;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyGraphicCommandTypeStringG_COMMAND_G]) {
    return BFElementModelSpecLegacyGraphicCommandTypeNumberG_COMMAND_G;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyGraphicCommandTypeStringG_COMMAND_PJ]) {
    return BFElementModelSpecLegacyGraphicCommandTypeNumberG_COMMAND_PJ;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyGraphicCommandTypeString__Null]) {
    return BFElementModelSpecLegacyGraphicCommandTypeNumber__Null;
  }
  return BFElementModelSpecLegacyGraphicCommandTypeNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyGraphicCommandType";
}
@end

@implementation BFElementModelSpecLegacyHeadPin
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyHeadPin";
}
@end

@implementation BFElementModelSpecLegacyHeadPinWhenPrintTube
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyHeadPinWhenPrintTube";
}
@end

@implementation BFElementModelSpecLegacyIgnorePaperEmptyWhenPrintEnd
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyIgnorePaperEmptyWhenPrintEnd";
}
@end

@implementation BFElementModelSpecLegacyImageHalftoneShouldGammaAdjust
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyImageHalftoneShouldGammaAdjust";
}
@end

NSString * __nonnull const BFElementModelSpecLegacyMainVersionCommandTypeStringMV_U0FH01H01H = @"MV_U0FH01H01H";
NSString * __nonnull const BFElementModelSpecLegacyMainVersionCommandTypeStringMV_U0EH01H = @"MV_U0EH01H";
NSString * __nonnull const BFElementModelSpecLegacyMainVersionCommandTypeStringMV_U0FH02H01H = @"MV_U0FH02H01H";
NSString * __nonnull const BFElementModelSpecLegacyMainVersionCommandTypeStringMV_UNKWOUN = @"MV_UNKWOUN";
NSString * __nonnull const BFElementModelSpecLegacyMainVersionCommandTypeString__Null = @"__Null";
@implementation BFElementModelSpecLegacyMainVersionCommandType
+ (nonnull NSString*)convertToString:(BFElementModelSpecLegacyMainVersionCommandTypeNumber)num {
  switch(num) {
  case BFElementModelSpecLegacyMainVersionCommandTypeNumberMV_U0FH01H01H: return BFElementModelSpecLegacyMainVersionCommandTypeStringMV_U0FH01H01H;
  case BFElementModelSpecLegacyMainVersionCommandTypeNumberMV_U0EH01H: return BFElementModelSpecLegacyMainVersionCommandTypeStringMV_U0EH01H;
  case BFElementModelSpecLegacyMainVersionCommandTypeNumberMV_U0FH02H01H: return BFElementModelSpecLegacyMainVersionCommandTypeStringMV_U0FH02H01H;
  case BFElementModelSpecLegacyMainVersionCommandTypeNumberMV_UNKWOUN: return BFElementModelSpecLegacyMainVersionCommandTypeStringMV_UNKWOUN;
  case BFElementModelSpecLegacyMainVersionCommandTypeNumber__Null: return BFElementModelSpecLegacyMainVersionCommandTypeString__Null;
  }
  return BFElementModelSpecLegacyMainVersionCommandTypeString__Null;
}
+ (BFElementModelSpecLegacyMainVersionCommandTypeNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementModelSpecLegacyMainVersionCommandTypeStringMV_U0FH01H01H]) {
    return BFElementModelSpecLegacyMainVersionCommandTypeNumberMV_U0FH01H01H;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyMainVersionCommandTypeStringMV_U0EH01H]) {
    return BFElementModelSpecLegacyMainVersionCommandTypeNumberMV_U0EH01H;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyMainVersionCommandTypeStringMV_U0FH02H01H]) {
    return BFElementModelSpecLegacyMainVersionCommandTypeNumberMV_U0FH02H01H;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyMainVersionCommandTypeStringMV_UNKWOUN]) {
    return BFElementModelSpecLegacyMainVersionCommandTypeNumberMV_UNKWOUN;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyMainVersionCommandTypeString__Null]) {
    return BFElementModelSpecLegacyMainVersionCommandTypeNumber__Null;
  }
  return BFElementModelSpecLegacyMainVersionCommandTypeNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyMainVersionCommandType";
}
@end

@implementation BFElementModelSpecLegacyMediaSizeShouldCheck
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyMediaSizeShouldCheck";
}
@end

@implementation BFElementModelSpecLegacyMinPrintMerginPerTenthMM
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyMinPrintMerginPerTenthMM";
}
@end

@implementation BFElementModelSpecLegacyMinPrintPaperLengthPerTenthMM
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyMinPrintPaperLengthPerTenthMM";
}
@end

@implementation BFElementModelSpecLegacyMode9CompressionMaxByteSize
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyMode9CompressionMaxByteSize";
}
@end

@implementation BFElementModelSpecLegacyMode9ShouldFlipHorizontal
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyMode9ShouldFlipHorizontal";
}
@end

@implementation BFElementModelSpecLegacyModelCode
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyModelCode";
}
@end

@implementation BFElementModelSpecLegacyModelName
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyModelName";
}
@end

@implementation BFElementModelSpecLegacyNullCommandLength
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyNullCommandLength";
}
@end

NSString * __nonnull const BFElementModelSpecLegacyPageEndCommandTypeStringEND_PJCODE = @"END_PJCODE";
NSString * __nonnull const BFElementModelSpecLegacyPageEndCommandTypeStringEND_NORMAL = @"END_NORMAL";
NSString * __nonnull const BFElementModelSpecLegacyPageEndCommandTypeString__Null = @"__Null";
@implementation BFElementModelSpecLegacyPageEndCommandType
+ (nonnull NSString*)convertToString:(BFElementModelSpecLegacyPageEndCommandTypeNumber)num {
  switch(num) {
  case BFElementModelSpecLegacyPageEndCommandTypeNumberEND_PJCODE: return BFElementModelSpecLegacyPageEndCommandTypeStringEND_PJCODE;
  case BFElementModelSpecLegacyPageEndCommandTypeNumberEND_NORMAL: return BFElementModelSpecLegacyPageEndCommandTypeStringEND_NORMAL;
  case BFElementModelSpecLegacyPageEndCommandTypeNumber__Null: return BFElementModelSpecLegacyPageEndCommandTypeString__Null;
  }
  return BFElementModelSpecLegacyPageEndCommandTypeString__Null;
}
+ (BFElementModelSpecLegacyPageEndCommandTypeNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementModelSpecLegacyPageEndCommandTypeStringEND_PJCODE]) {
    return BFElementModelSpecLegacyPageEndCommandTypeNumberEND_PJCODE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPageEndCommandTypeStringEND_NORMAL]) {
    return BFElementModelSpecLegacyPageEndCommandTypeNumberEND_NORMAL;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPageEndCommandTypeString__Null]) {
    return BFElementModelSpecLegacyPageEndCommandTypeNumber__Null;
  }
  return BFElementModelSpecLegacyPageEndCommandTypeNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyPageEndCommandType";
}
@end

NSString * __nonnull const BFElementModelSpecLegacyPaperListKindStringPS_A7 = @"PS_A7";
NSString * __nonnull const BFElementModelSpecLegacyPaperListKindStringPS_A6 = @"PS_A6";
NSString * __nonnull const BFElementModelSpecLegacyPaperListKindStringPS_PJ = @"PS_PJ";
NSString * __nonnull const BFElementModelSpecLegacyPaperListKindStringPS_BIN = @"PS_BIN";
NSString * __nonnull const BFElementModelSpecLegacyPaperListKindStringPS_QL = @"PS_QL";
NSString * __nonnull const BFElementModelSpecLegacyPaperListKindStringPS_PT = @"PS_PT";
NSString * __nonnull const BFElementModelSpecLegacyPaperListKindStringPS_PT_36mm = @"PS_PT_36mm";
NSString * __nonnull const BFElementModelSpecLegacyPaperListKindStringPS_PT_18mm = @"PS_PT_18mm";
NSString * __nonnull const BFElementModelSpecLegacyPaperListKindStringPS_TUBE = @"PS_TUBE";
NSString * __nonnull const BFElementModelSpecLegacyPaperListKindStringPS_FLE = @"PS_FLE";
NSString * __nonnull const BFElementModelSpecLegacyPaperListKindStringPS_PT3 = @"PS_PT3";
NSString * __nonnull const BFElementModelSpecLegacyPaperListKindStringPS_QL1000 = @"PS_QL1000";
NSString * __nonnull const BFElementModelSpecLegacyPaperListKindStringPS_PT_CUBE3 = @"PS_PT_CUBE3";
NSString * __nonnull const BFElementModelSpecLegacyPaperListKindStringPS_PT9000 = @"PS_PT9000";
NSString * __nonnull const BFElementModelSpecLegacyPaperListKindStringPS_PT_3_5mmUNSUPPORT = @"PS_PT_3_5mmUNSUPPORT";
NSString * __nonnull const BFElementModelSpecLegacyPaperListKindStringPS_PT_HS3 = @"PS_PT_HS3";
NSString * __nonnull const BFElementModelSpecLegacyPaperListKindStringPS_PT_36mm_HS3 = @"PS_PT_36mm_HS3";
NSString * __nonnull const BFElementModelSpecLegacyPaperListKindStringPAPER_UNSUPPORT = @"PAPER_UNSUPPORT";
NSString * __nonnull const BFElementModelSpecLegacyPaperListKindString__Null = @"__Null";
@implementation BFElementModelSpecLegacyPaperListKind
+ (nonnull NSString*)convertToString:(BFElementModelSpecLegacyPaperListKindNumber)num {
  switch(num) {
  case BFElementModelSpecLegacyPaperListKindNumberPS_A7: return BFElementModelSpecLegacyPaperListKindStringPS_A7;
  case BFElementModelSpecLegacyPaperListKindNumberPS_A6: return BFElementModelSpecLegacyPaperListKindStringPS_A6;
  case BFElementModelSpecLegacyPaperListKindNumberPS_PJ: return BFElementModelSpecLegacyPaperListKindStringPS_PJ;
  case BFElementModelSpecLegacyPaperListKindNumberPS_BIN: return BFElementModelSpecLegacyPaperListKindStringPS_BIN;
  case BFElementModelSpecLegacyPaperListKindNumberPS_QL: return BFElementModelSpecLegacyPaperListKindStringPS_QL;
  case BFElementModelSpecLegacyPaperListKindNumberPS_PT: return BFElementModelSpecLegacyPaperListKindStringPS_PT;
  case BFElementModelSpecLegacyPaperListKindNumberPS_PT_36mm: return BFElementModelSpecLegacyPaperListKindStringPS_PT_36mm;
  case BFElementModelSpecLegacyPaperListKindNumberPS_PT_18mm: return BFElementModelSpecLegacyPaperListKindStringPS_PT_18mm;
  case BFElementModelSpecLegacyPaperListKindNumberPS_TUBE: return BFElementModelSpecLegacyPaperListKindStringPS_TUBE;
  case BFElementModelSpecLegacyPaperListKindNumberPS_FLE: return BFElementModelSpecLegacyPaperListKindStringPS_FLE;
  case BFElementModelSpecLegacyPaperListKindNumberPS_PT3: return BFElementModelSpecLegacyPaperListKindStringPS_PT3;
  case BFElementModelSpecLegacyPaperListKindNumberPS_QL1000: return BFElementModelSpecLegacyPaperListKindStringPS_QL1000;
  case BFElementModelSpecLegacyPaperListKindNumberPS_PT_CUBE3: return BFElementModelSpecLegacyPaperListKindStringPS_PT_CUBE3;
  case BFElementModelSpecLegacyPaperListKindNumberPS_PT9000: return BFElementModelSpecLegacyPaperListKindStringPS_PT9000;
  case BFElementModelSpecLegacyPaperListKindNumberPS_PT_3_5mmUNSUPPORT: return BFElementModelSpecLegacyPaperListKindStringPS_PT_3_5mmUNSUPPORT;
  case BFElementModelSpecLegacyPaperListKindNumberPS_PT_HS3: return BFElementModelSpecLegacyPaperListKindStringPS_PT_HS3;
  case BFElementModelSpecLegacyPaperListKindNumberPS_PT_36mm_HS3: return BFElementModelSpecLegacyPaperListKindStringPS_PT_36mm_HS3;
  case BFElementModelSpecLegacyPaperListKindNumberPAPER_UNSUPPORT: return BFElementModelSpecLegacyPaperListKindStringPAPER_UNSUPPORT;
  case BFElementModelSpecLegacyPaperListKindNumber__Null: return BFElementModelSpecLegacyPaperListKindString__Null;
  }
  return BFElementModelSpecLegacyPaperListKindString__Null;
}
+ (BFElementModelSpecLegacyPaperListKindNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementModelSpecLegacyPaperListKindStringPS_A7]) {
    return BFElementModelSpecLegacyPaperListKindNumberPS_A7;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPaperListKindStringPS_A6]) {
    return BFElementModelSpecLegacyPaperListKindNumberPS_A6;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPaperListKindStringPS_PJ]) {
    return BFElementModelSpecLegacyPaperListKindNumberPS_PJ;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPaperListKindStringPS_BIN]) {
    return BFElementModelSpecLegacyPaperListKindNumberPS_BIN;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPaperListKindStringPS_QL]) {
    return BFElementModelSpecLegacyPaperListKindNumberPS_QL;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPaperListKindStringPS_PT]) {
    return BFElementModelSpecLegacyPaperListKindNumberPS_PT;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPaperListKindStringPS_PT_36mm]) {
    return BFElementModelSpecLegacyPaperListKindNumberPS_PT_36mm;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPaperListKindStringPS_PT_18mm]) {
    return BFElementModelSpecLegacyPaperListKindNumberPS_PT_18mm;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPaperListKindStringPS_TUBE]) {
    return BFElementModelSpecLegacyPaperListKindNumberPS_TUBE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPaperListKindStringPS_FLE]) {
    return BFElementModelSpecLegacyPaperListKindNumberPS_FLE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPaperListKindStringPS_PT3]) {
    return BFElementModelSpecLegacyPaperListKindNumberPS_PT3;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPaperListKindStringPS_QL1000]) {
    return BFElementModelSpecLegacyPaperListKindNumberPS_QL1000;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPaperListKindStringPS_PT_CUBE3]) {
    return BFElementModelSpecLegacyPaperListKindNumberPS_PT_CUBE3;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPaperListKindStringPS_PT9000]) {
    return BFElementModelSpecLegacyPaperListKindNumberPS_PT9000;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPaperListKindStringPS_PT_3_5mmUNSUPPORT]) {
    return BFElementModelSpecLegacyPaperListKindNumberPS_PT_3_5mmUNSUPPORT;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPaperListKindStringPS_PT_HS3]) {
    return BFElementModelSpecLegacyPaperListKindNumberPS_PT_HS3;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPaperListKindStringPS_PT_36mm_HS3]) {
    return BFElementModelSpecLegacyPaperListKindNumberPS_PT_36mm_HS3;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPaperListKindStringPAPER_UNSUPPORT]) {
    return BFElementModelSpecLegacyPaperListKindNumberPAPER_UNSUPPORT;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPaperListKindString__Null]) {
    return BFElementModelSpecLegacyPaperListKindNumber__Null;
  }
  return BFElementModelSpecLegacyPaperListKindNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyPaperListKind";
}
@end

NSString * __nonnull const BFElementModelSpecLegacyPrintCompressTypeStringCOM_RAW = @"COM_RAW";
NSString * __nonnull const BFElementModelSpecLegacyPrintCompressTypeStringCOM_RAW_TIFF = @"COM_RAW_TIFF";
NSString * __nonnull const BFElementModelSpecLegacyPrintCompressTypeStringCOM_TIFF = @"COM_TIFF";
NSString * __nonnull const BFElementModelSpecLegacyPrintCompressTypeString__Null = @"__Null";
@implementation BFElementModelSpecLegacyPrintCompressType
+ (nonnull NSString*)convertToString:(BFElementModelSpecLegacyPrintCompressTypeNumber)num {
  switch(num) {
  case BFElementModelSpecLegacyPrintCompressTypeNumberCOM_RAW: return BFElementModelSpecLegacyPrintCompressTypeStringCOM_RAW;
  case BFElementModelSpecLegacyPrintCompressTypeNumberCOM_RAW_TIFF: return BFElementModelSpecLegacyPrintCompressTypeStringCOM_RAW_TIFF;
  case BFElementModelSpecLegacyPrintCompressTypeNumberCOM_TIFF: return BFElementModelSpecLegacyPrintCompressTypeStringCOM_TIFF;
  case BFElementModelSpecLegacyPrintCompressTypeNumber__Null: return BFElementModelSpecLegacyPrintCompressTypeString__Null;
  }
  return BFElementModelSpecLegacyPrintCompressTypeString__Null;
}
+ (BFElementModelSpecLegacyPrintCompressTypeNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementModelSpecLegacyPrintCompressTypeStringCOM_RAW]) {
    return BFElementModelSpecLegacyPrintCompressTypeNumberCOM_RAW;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrintCompressTypeStringCOM_RAW_TIFF]) {
    return BFElementModelSpecLegacyPrintCompressTypeNumberCOM_RAW_TIFF;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrintCompressTypeStringCOM_TIFF]) {
    return BFElementModelSpecLegacyPrintCompressTypeNumberCOM_TIFF;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrintCompressTypeString__Null]) {
    return BFElementModelSpecLegacyPrintCompressTypeNumber__Null;
  }
  return BFElementModelSpecLegacyPrintCompressTypeNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyPrintCompressType";
}
@end

NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_NET_IPV6 = @"PS_NET_IPV6";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIFI_IPV6 = @"PS_WIFI_IPV6";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIFI_BOOTMODE = @"PS_WIFI_BOOTMODE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIFI_INTERFACE = @"PS_WIFI_INTERFACE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIFI_WIRELESSDIRECT_BOOTMODE = @"PS_WIFI_WIRELESSDIRECT_BOOTMODE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIFI_SETTINGS = @"PS_WIFI_SETTINGS";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIFI_NODENAME = @"PS_WIFI_NODENAME";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_LAN_SETTINGS = @"PS_LAN_SETTINGS";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_LAN_NODENAME = @"PS_LAN_NODENAME";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_LAN_IPV6 = @"PS_LAN_IPV6";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIRELESSDIRECT_CREATE_KRY = @"PS_WIRELESSDIRECT_CREATE_KRY";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIRELESSDIRECT_SETTINGS = @"PS_WIRELESSDIRECT_SETTINGS";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_AUTOPOWEROFFTIME = @"PS_BT_AUTOPOWEROFFTIME";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_AUTOSLEEPTIME = @"PS_BT_AUTOSLEEPTIME";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_AUTOSLEEPTOPOWEROFFTIME = @"PS_BT_AUTOSLEEPTOPOWEROFFTIME";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_POWERSAVEMODE = @"PS_BT_POWERSAVEMODE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_ISDISCOVERABLE = @"PS_BT_ISDISCOVERABLE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_DEVICENAME = @"PS_BT_DEVICENAME";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_PINCODE = @"PS_BT_PINCODE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_SSP = @"PS_BT_SSP";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_PINCODE_ENABLE = @"PS_BT_PINCODE_ENABLE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_SECURITYMODE = @"PS_BT_SECURITYMODE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_BOOTMODE = @"PS_BT_BOOTMODE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_BLUETOOTH_TO_IRDA = @"PS_BT_BLUETOOTH_TO_IRDA";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_BLUETOOTH_TO_NET = @"PS_BT_BLUETOOTH_TO_NET";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_KEY = @"PS_BT_KEY";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_AUTO_CONNECTION = @"PS_BT_AUTO_CONNECTION";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_BOOTMODE_PJ = @"PS_BT_BOOTMODE_PJ";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_PRINT_JPEG_HALFTONE = @"PS_PRINT_JPEG_HALFTONE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_PRINT_JPEG_SCALE = @"PS_PRINT_JPEG_SCALE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_PRINT_DENSITY = @"PS_PRINT_DENSITY";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_PRINT_SPEED = @"PS_PRINT_SPEED";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME = @"PS_POWER_POWEROFFTIME";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_BATTERY = @"PS_POWER_POWEROFFTIME_BATTERY";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_RJ2 = @"PS_POWER_POWEROFFTIME_RJ2";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_QL8 = @"PS_POWER_POWEROFFTIME_QL8";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_BATTERY_QL8 = @"PS_POWER_POWEROFFTIME_BATTERY_QL8";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_QL1100 = @"PS_POWER_POWEROFFTIME_QL1100";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_RJ4000a = @"PS_POWER_POWEROFFTIME_RJ4000a";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_ModelFilter = @"PS_POWER_POWEROFFTIME_ModelFilter";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_PowerSupplyFilter = @"PS_POWER_POWEROFFTIME_PowerSupplyFilter";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryString__Null = @"__Null";
@implementation BFElementModelSpecLegacyPrinterSettingCategory
+ (nonnull NSString*)convertToString:(BFElementModelSpecLegacyPrinterSettingCategoryNumber)num {
  switch(num) {
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_NET_IPV6: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_NET_IPV6;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_IPV6: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIFI_IPV6;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_BOOTMODE: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIFI_BOOTMODE;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_INTERFACE: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIFI_INTERFACE;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_WIRELESSDIRECT_BOOTMODE: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIFI_WIRELESSDIRECT_BOOTMODE;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_SETTINGS: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIFI_SETTINGS;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_NODENAME: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIFI_NODENAME;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_LAN_SETTINGS: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_LAN_SETTINGS;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_LAN_NODENAME: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_LAN_NODENAME;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_LAN_IPV6: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_LAN_IPV6;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIRELESSDIRECT_CREATE_KRY: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIRELESSDIRECT_CREATE_KRY;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIRELESSDIRECT_SETTINGS: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIRELESSDIRECT_SETTINGS;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_AUTOPOWEROFFTIME: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_AUTOPOWEROFFTIME;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_AUTOSLEEPTIME: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_AUTOSLEEPTIME;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_AUTOSLEEPTOPOWEROFFTIME: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_AUTOSLEEPTOPOWEROFFTIME;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_POWERSAVEMODE: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_POWERSAVEMODE;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_ISDISCOVERABLE: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_ISDISCOVERABLE;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_DEVICENAME: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_DEVICENAME;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_PINCODE: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_PINCODE;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_SSP: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_SSP;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_PINCODE_ENABLE: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_PINCODE_ENABLE;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_SECURITYMODE: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_SECURITYMODE;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_BOOTMODE: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_BOOTMODE;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_BLUETOOTH_TO_IRDA: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_BLUETOOTH_TO_IRDA;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_BLUETOOTH_TO_NET: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_BLUETOOTH_TO_NET;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_KEY: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_KEY;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_AUTO_CONNECTION: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_AUTO_CONNECTION;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_BOOTMODE_PJ: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_BOOTMODE_PJ;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_PRINT_JPEG_HALFTONE: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_PRINT_JPEG_HALFTONE;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_PRINT_JPEG_SCALE: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_PRINT_JPEG_SCALE;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_PRINT_DENSITY: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_PRINT_DENSITY;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_PRINT_SPEED: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_PRINT_SPEED;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_BATTERY: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_BATTERY;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_RJ2: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_RJ2;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_QL8: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_QL8;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_BATTERY_QL8: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_BATTERY_QL8;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_QL1100: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_QL1100;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_RJ4000a: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_RJ4000a;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_ModelFilter: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_ModelFilter;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_PowerSupplyFilter: return BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_PowerSupplyFilter;
  case BFElementModelSpecLegacyPrinterSettingCategoryNumber__Null: return BFElementModelSpecLegacyPrinterSettingCategoryString__Null;
  }
  return BFElementModelSpecLegacyPrinterSettingCategoryString__Null;
}
+ (BFElementModelSpecLegacyPrinterSettingCategoryNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_NET_IPV6]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_NET_IPV6;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIFI_IPV6]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_IPV6;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIFI_BOOTMODE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_BOOTMODE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIFI_INTERFACE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_INTERFACE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIFI_WIRELESSDIRECT_BOOTMODE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_WIRELESSDIRECT_BOOTMODE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIFI_SETTINGS]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_SETTINGS;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIFI_NODENAME]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_NODENAME;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_LAN_SETTINGS]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_LAN_SETTINGS;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_LAN_NODENAME]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_LAN_NODENAME;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_LAN_IPV6]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_LAN_IPV6;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIRELESSDIRECT_CREATE_KRY]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIRELESSDIRECT_CREATE_KRY;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_WIRELESSDIRECT_SETTINGS]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIRELESSDIRECT_SETTINGS;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_AUTOPOWEROFFTIME]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_AUTOPOWEROFFTIME;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_AUTOSLEEPTIME]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_AUTOSLEEPTIME;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_AUTOSLEEPTOPOWEROFFTIME]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_AUTOSLEEPTOPOWEROFFTIME;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_POWERSAVEMODE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_POWERSAVEMODE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_ISDISCOVERABLE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_ISDISCOVERABLE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_DEVICENAME]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_DEVICENAME;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_PINCODE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_PINCODE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_SSP]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_SSP;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_PINCODE_ENABLE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_PINCODE_ENABLE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_SECURITYMODE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_SECURITYMODE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_BOOTMODE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_BOOTMODE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_BLUETOOTH_TO_IRDA]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_BLUETOOTH_TO_IRDA;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_BLUETOOTH_TO_NET]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_BLUETOOTH_TO_NET;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_KEY]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_KEY;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_AUTO_CONNECTION]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_AUTO_CONNECTION;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_BT_BOOTMODE_PJ]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_BOOTMODE_PJ;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_PRINT_JPEG_HALFTONE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_PRINT_JPEG_HALFTONE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_PRINT_JPEG_SCALE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_PRINT_JPEG_SCALE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_PRINT_DENSITY]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_PRINT_DENSITY;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_PRINT_SPEED]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_PRINT_SPEED;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_BATTERY]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_BATTERY;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_RJ2]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_RJ2;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_QL8]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_QL8;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_BATTERY_QL8]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_BATTERY_QL8;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_QL1100]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_QL1100;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_RJ4000a]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_RJ4000a;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_ModelFilter]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_ModelFilter;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryStringPS_POWER_POWEROFFTIME_PowerSupplyFilter]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_PowerSupplyFilter;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryString__Null]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNumber__Null;
  }
  return BFElementModelSpecLegacyPrinterSettingCategoryNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyPrinterSettingCategory";
}
@end

NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_AUTOPOWEROFFTIME = @"PS_BT_AUTOPOWEROFFTIME";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_AUTOSLEEPTIME = @"PS_BT_AUTOSLEEPTIME";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_AUTOSLEEPTOPOWEROFFTIME = @"PS_BT_AUTOSLEEPTOPOWEROFFTIME";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_POWERSAVEMODE = @"PS_BT_POWERSAVEMODE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_ISDISCOVERABLE = @"PS_BT_ISDISCOVERABLE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_DEVICENAME = @"PS_BT_DEVICENAME";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_PINCODE = @"PS_BT_PINCODE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_SSP = @"PS_BT_SSP";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_PINCODE_ENABLE = @"PS_BT_PINCODE_ENABLE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_SECURITYMODE = @"PS_BT_SECURITYMODE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_BOOTMODE = @"PS_BT_BOOTMODE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_BLUETOOTH_TO_IRDA = @"PS_BT_BLUETOOTH_TO_IRDA";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_BLUETOOTH_TO_NET = @"PS_BT_BLUETOOTH_TO_NET";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_KEY = @"PS_BT_KEY";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_AUTO_CONNECTION = @"PS_BT_AUTO_CONNECTION";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_BOOTMODE_PJ = @"PS_BT_BOOTMODE_PJ";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryBluetoothString__Null = @"__Null";
@implementation BFElementModelSpecLegacyPrinterSettingCategoryBluetooth
+ (nonnull NSString*)convertToString:(BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumber)num {
  switch(num) {
  case BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_AUTOPOWEROFFTIME: return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_AUTOPOWEROFFTIME;
  case BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_AUTOSLEEPTIME: return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_AUTOSLEEPTIME;
  case BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_AUTOSLEEPTOPOWEROFFTIME: return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_AUTOSLEEPTOPOWEROFFTIME;
  case BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_POWERSAVEMODE: return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_POWERSAVEMODE;
  case BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_ISDISCOVERABLE: return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_ISDISCOVERABLE;
  case BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_DEVICENAME: return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_DEVICENAME;
  case BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_PINCODE: return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_PINCODE;
  case BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_SSP: return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_SSP;
  case BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_PINCODE_ENABLE: return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_PINCODE_ENABLE;
  case BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_SECURITYMODE: return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_SECURITYMODE;
  case BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_BOOTMODE: return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_BOOTMODE;
  case BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_BLUETOOTH_TO_IRDA: return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_BLUETOOTH_TO_IRDA;
  case BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_BLUETOOTH_TO_NET: return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_BLUETOOTH_TO_NET;
  case BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_KEY: return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_KEY;
  case BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_AUTO_CONNECTION: return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_AUTO_CONNECTION;
  case BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_BOOTMODE_PJ: return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_BOOTMODE_PJ;
  case BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumber__Null: return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothString__Null;
  }
  return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothString__Null;
}
+ (BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_AUTOPOWEROFFTIME]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_AUTOPOWEROFFTIME;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_AUTOSLEEPTIME]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_AUTOSLEEPTIME;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_AUTOSLEEPTOPOWEROFFTIME]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_AUTOSLEEPTOPOWEROFFTIME;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_POWERSAVEMODE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_POWERSAVEMODE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_ISDISCOVERABLE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_ISDISCOVERABLE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_DEVICENAME]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_DEVICENAME;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_PINCODE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_PINCODE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_SSP]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_SSP;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_PINCODE_ENABLE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_PINCODE_ENABLE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_SECURITYMODE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_SECURITYMODE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_BOOTMODE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_BOOTMODE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_BLUETOOTH_TO_IRDA]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_BLUETOOTH_TO_IRDA;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_BLUETOOTH_TO_NET]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_BLUETOOTH_TO_NET;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_KEY]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_KEY;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_AUTO_CONNECTION]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_AUTO_CONNECTION;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothStringPS_BT_BOOTMODE_PJ]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_BOOTMODE_PJ;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothString__Null]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumber__Null;
  }
  return BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyPrinterSettingCategoryBluetooth";
}
@end

NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_NET_IPV6 = @"PS_NET_IPV6";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIFI_IPV6 = @"PS_WIFI_IPV6";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIFI_BOOTMODE = @"PS_WIFI_BOOTMODE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIFI_INTERFACE = @"PS_WIFI_INTERFACE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIFI_WIRELESSDIRECT_BOOTMODE = @"PS_WIFI_WIRELESSDIRECT_BOOTMODE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIFI_SETTINGS = @"PS_WIFI_SETTINGS";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIFI_NODENAME = @"PS_WIFI_NODENAME";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_LAN_SETTINGS = @"PS_LAN_SETTINGS";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_LAN_NODENAME = @"PS_LAN_NODENAME";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_LAN_IPV6 = @"PS_LAN_IPV6";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIRELESSDIRECT_CREATE_KRY = @"PS_WIRELESSDIRECT_CREATE_KRY";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIRELESSDIRECT_SETTINGS = @"PS_WIRELESSDIRECT_SETTINGS";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryNetworkString__Null = @"__Null";
@implementation BFElementModelSpecLegacyPrinterSettingCategoryNetwork
+ (nonnull NSString*)convertToString:(BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumber)num {
  switch(num) {
  case BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_NET_IPV6: return BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_NET_IPV6;
  case BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_IPV6: return BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIFI_IPV6;
  case BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_BOOTMODE: return BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIFI_BOOTMODE;
  case BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_INTERFACE: return BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIFI_INTERFACE;
  case BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_WIRELESSDIRECT_BOOTMODE: return BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIFI_WIRELESSDIRECT_BOOTMODE;
  case BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_SETTINGS: return BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIFI_SETTINGS;
  case BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_NODENAME: return BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIFI_NODENAME;
  case BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_LAN_SETTINGS: return BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_LAN_SETTINGS;
  case BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_LAN_NODENAME: return BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_LAN_NODENAME;
  case BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_LAN_IPV6: return BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_LAN_IPV6;
  case BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIRELESSDIRECT_CREATE_KRY: return BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIRELESSDIRECT_CREATE_KRY;
  case BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIRELESSDIRECT_SETTINGS: return BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIRELESSDIRECT_SETTINGS;
  case BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumber__Null: return BFElementModelSpecLegacyPrinterSettingCategoryNetworkString__Null;
  }
  return BFElementModelSpecLegacyPrinterSettingCategoryNetworkString__Null;
}
+ (BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_NET_IPV6]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_NET_IPV6;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIFI_IPV6]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_IPV6;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIFI_BOOTMODE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_BOOTMODE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIFI_INTERFACE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_INTERFACE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIFI_WIRELESSDIRECT_BOOTMODE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_WIRELESSDIRECT_BOOTMODE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIFI_SETTINGS]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_SETTINGS;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIFI_NODENAME]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_NODENAME;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_LAN_SETTINGS]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_LAN_SETTINGS;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_LAN_NODENAME]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_LAN_NODENAME;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_LAN_IPV6]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_LAN_IPV6;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIRELESSDIRECT_CREATE_KRY]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIRELESSDIRECT_CREATE_KRY;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryNetworkStringPS_WIRELESSDIRECT_SETTINGS]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIRELESSDIRECT_SETTINGS;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryNetworkString__Null]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumber__Null;
  }
  return BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyPrinterSettingCategoryNetwork";
}
@end

NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME = @"PS_POWER_POWEROFFTIME";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_BATTERY = @"PS_POWER_POWEROFFTIME_BATTERY";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_RJ2 = @"PS_POWER_POWEROFFTIME_RJ2";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_QL8 = @"PS_POWER_POWEROFFTIME_QL8";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_BATTERY_QL8 = @"PS_POWER_POWEROFFTIME_BATTERY_QL8";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_QL1100 = @"PS_POWER_POWEROFFTIME_QL1100";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_RJ4000a = @"PS_POWER_POWEROFFTIME_RJ4000a";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_BATTERY_PJ8 = @"PS_POWER_POWEROFFTIME_BATTERY_PJ8";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_ModelFilter = @"PS_POWER_POWEROFFTIME_ModelFilter";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_PowerSupplyFilter = @"PS_POWER_POWEROFFTIME_PowerSupplyFilter";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryPowerString__Null = @"__Null";
@implementation BFElementModelSpecLegacyPrinterSettingCategoryPower
+ (nonnull NSString*)convertToString:(BFElementModelSpecLegacyPrinterSettingCategoryPowerNumber)num {
  switch(num) {
  case BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME: return BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME;
  case BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_BATTERY: return BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_BATTERY;
  case BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_RJ2: return BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_RJ2;
  case BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_QL8: return BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_QL8;
  case BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_BATTERY_QL8: return BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_BATTERY_QL8;
  case BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_QL1100: return BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_QL1100;
  case BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_RJ4000a: return BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_RJ4000a;
  case BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_BATTERY_PJ8: return BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_BATTERY_PJ8;
  case BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_ModelFilter: return BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_ModelFilter;
  case BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_PowerSupplyFilter: return BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_PowerSupplyFilter;
  case BFElementModelSpecLegacyPrinterSettingCategoryPowerNumber__Null: return BFElementModelSpecLegacyPrinterSettingCategoryPowerString__Null;
  }
  return BFElementModelSpecLegacyPrinterSettingCategoryPowerString__Null;
}
+ (BFElementModelSpecLegacyPrinterSettingCategoryPowerNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_BATTERY]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_BATTERY;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_RJ2]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_RJ2;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_QL8]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_QL8;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_BATTERY_QL8]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_BATTERY_QL8;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_QL1100]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_QL1100;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_RJ4000a]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_RJ4000a;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_BATTERY_PJ8]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_BATTERY_PJ8;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_ModelFilter]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_ModelFilter;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryPowerStringPS_POWER_POWEROFFTIME_PowerSupplyFilter]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_PowerSupplyFilter;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryPowerString__Null]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryPowerNumber__Null;
  }
  return BFElementModelSpecLegacyPrinterSettingCategoryPowerNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyPrinterSettingCategoryPower";
}
@end

NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryPrintStringPS_PRINT_JPEG_HALFTONE = @"PS_PRINT_JPEG_HALFTONE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryPrintStringPS_PRINT_JPEG_SCALE = @"PS_PRINT_JPEG_SCALE";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryPrintStringPS_PRINT_DENSITY = @"PS_PRINT_DENSITY";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryPrintStringPS_PRINT_SPEED = @"PS_PRINT_SPEED";
NSString * __nonnull const BFElementModelSpecLegacyPrinterSettingCategoryPrintString__Null = @"__Null";
@implementation BFElementModelSpecLegacyPrinterSettingCategoryPrint
+ (nonnull NSString*)convertToString:(BFElementModelSpecLegacyPrinterSettingCategoryPrintNumber)num {
  switch(num) {
  case BFElementModelSpecLegacyPrinterSettingCategoryPrintNumberPS_PRINT_JPEG_HALFTONE: return BFElementModelSpecLegacyPrinterSettingCategoryPrintStringPS_PRINT_JPEG_HALFTONE;
  case BFElementModelSpecLegacyPrinterSettingCategoryPrintNumberPS_PRINT_JPEG_SCALE: return BFElementModelSpecLegacyPrinterSettingCategoryPrintStringPS_PRINT_JPEG_SCALE;
  case BFElementModelSpecLegacyPrinterSettingCategoryPrintNumberPS_PRINT_DENSITY: return BFElementModelSpecLegacyPrinterSettingCategoryPrintStringPS_PRINT_DENSITY;
  case BFElementModelSpecLegacyPrinterSettingCategoryPrintNumberPS_PRINT_SPEED: return BFElementModelSpecLegacyPrinterSettingCategoryPrintStringPS_PRINT_SPEED;
  case BFElementModelSpecLegacyPrinterSettingCategoryPrintNumber__Null: return BFElementModelSpecLegacyPrinterSettingCategoryPrintString__Null;
  }
  return BFElementModelSpecLegacyPrinterSettingCategoryPrintString__Null;
}
+ (BFElementModelSpecLegacyPrinterSettingCategoryPrintNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryPrintStringPS_PRINT_JPEG_HALFTONE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryPrintNumberPS_PRINT_JPEG_HALFTONE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryPrintStringPS_PRINT_JPEG_SCALE]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryPrintNumberPS_PRINT_JPEG_SCALE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryPrintStringPS_PRINT_DENSITY]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryPrintNumberPS_PRINT_DENSITY;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryPrintStringPS_PRINT_SPEED]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryPrintNumberPS_PRINT_SPEED;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrinterSettingCategoryPrintString__Null]) {
    return BFElementModelSpecLegacyPrinterSettingCategoryPrintNumber__Null;
  }
  return BFElementModelSpecLegacyPrinterSettingCategoryPrintNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyPrinterSettingCategoryPrint";
}
@end

NSString * __nonnull const BFElementModelSpecLegacyPrintPageCommandTypeStringPAGE_START_END = @"PAGE_START_END";
NSString * __nonnull const BFElementModelSpecLegacyPrintPageCommandTypeStringPAGE_START_NEXT_END = @"PAGE_START_NEXT_END";
NSString * __nonnull const BFElementModelSpecLegacyPrintPageCommandTypeString__Null = @"__Null";
@implementation BFElementModelSpecLegacyPrintPageCommandType
+ (nonnull NSString*)convertToString:(BFElementModelSpecLegacyPrintPageCommandTypeNumber)num {
  switch(num) {
  case BFElementModelSpecLegacyPrintPageCommandTypeNumberPAGE_START_END: return BFElementModelSpecLegacyPrintPageCommandTypeStringPAGE_START_END;
  case BFElementModelSpecLegacyPrintPageCommandTypeNumberPAGE_START_NEXT_END: return BFElementModelSpecLegacyPrintPageCommandTypeStringPAGE_START_NEXT_END;
  case BFElementModelSpecLegacyPrintPageCommandTypeNumber__Null: return BFElementModelSpecLegacyPrintPageCommandTypeString__Null;
  }
  return BFElementModelSpecLegacyPrintPageCommandTypeString__Null;
}
+ (BFElementModelSpecLegacyPrintPageCommandTypeNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementModelSpecLegacyPrintPageCommandTypeStringPAGE_START_END]) {
    return BFElementModelSpecLegacyPrintPageCommandTypeNumberPAGE_START_END;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrintPageCommandTypeStringPAGE_START_NEXT_END]) {
    return BFElementModelSpecLegacyPrintPageCommandTypeNumberPAGE_START_NEXT_END;
  }
  if ([str isEqualToString:BFElementModelSpecLegacyPrintPageCommandTypeString__Null]) {
    return BFElementModelSpecLegacyPrintPageCommandTypeNumber__Null;
  }
  return BFElementModelSpecLegacyPrintPageCommandTypeNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyPrintPageCommandType";
}
@end

@implementation BFElementModelSpecLegacyPrintShouldDensityCommand
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyPrintShouldDensityCommand";
}
@end

@implementation BFElementModelSpecLegacyPrintShouldPrinterInfoCommand
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyPrintShouldPrinterInfoCommand";
}
@end

@implementation BFElementModelSpecLegacyPrintShouldSpaceCommand
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyPrintShouldSpaceCommand";
}
@end

@implementation BFElementModelSpecLegacySeriesCode
+ (nonnull NSString*)key {
  return @"ModelSpecLegacySeriesCode";
}
@end

@implementation BFElementModelSpecLegacyStatusIndexOfPaperBackgroundColor
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyStatusIndexOfPaperBackgroundColor";
}
@end

@implementation BFElementModelSpecLegacyStatusIndexOfPaperTextColor
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyStatusIndexOfPaperTextColor";
}
@end

@implementation BFElementModelSpecLegacyStatusIndexOfTubeRibbon
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyStatusIndexOfTubeRibbon";
}
@end

@implementation BFElementModelSpecLegacySupportAdjustPaperPosition
+ (nonnull NSString*)key {
  return @"ModelSpecLegacySupportAdjustPaperPosition";
}
@end

NSString * __nonnull const BFElementModelSpecLegacySupportAdvanceModeCommandStringPS_AM_HALFCUT = @"PS_AM_HALFCUT";
NSString * __nonnull const BFElementModelSpecLegacySupportAdvanceModeCommandStringPS_AM_CUTEND = @"PS_AM_CUTEND";
NSString * __nonnull const BFElementModelSpecLegacySupportAdvanceModeCommandStringPS_AM_SPECIALTAPE = @"PS_AM_SPECIALTAPE";
NSString * __nonnull const BFElementModelSpecLegacySupportAdvanceModeCommandStringPS_AM_HIGH_RESOLUTION = @"PS_AM_HIGH_RESOLUTION";
NSString * __nonnull const BFElementModelSpecLegacySupportAdvanceModeCommandStringPS_AM_LABEL_CUTEND = @"PS_AM_LABEL_CUTEND";
NSString * __nonnull const BFElementModelSpecLegacySupportAdvanceModeCommandStringPS_AM_NOBUFFER = @"PS_AM_NOBUFFER";
NSString * __nonnull const BFElementModelSpecLegacySupportAdvanceModeCommandStringPS_AM_LOW_RESOLUTION = @"PS_AM_LOW_RESOLUTION";
NSString * __nonnull const BFElementModelSpecLegacySupportAdvanceModeCommandString__Null = @"__Null";
@implementation BFElementModelSpecLegacySupportAdvanceModeCommand
+ (nonnull NSString*)convertToString:(BFElementModelSpecLegacySupportAdvanceModeCommandNumber)num {
  switch(num) {
  case BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_HALFCUT: return BFElementModelSpecLegacySupportAdvanceModeCommandStringPS_AM_HALFCUT;
  case BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_CUTEND: return BFElementModelSpecLegacySupportAdvanceModeCommandStringPS_AM_CUTEND;
  case BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_SPECIALTAPE: return BFElementModelSpecLegacySupportAdvanceModeCommandStringPS_AM_SPECIALTAPE;
  case BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_HIGH_RESOLUTION: return BFElementModelSpecLegacySupportAdvanceModeCommandStringPS_AM_HIGH_RESOLUTION;
  case BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_LABEL_CUTEND: return BFElementModelSpecLegacySupportAdvanceModeCommandStringPS_AM_LABEL_CUTEND;
  case BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_NOBUFFER: return BFElementModelSpecLegacySupportAdvanceModeCommandStringPS_AM_NOBUFFER;
  case BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_LOW_RESOLUTION: return BFElementModelSpecLegacySupportAdvanceModeCommandStringPS_AM_LOW_RESOLUTION;
  case BFElementModelSpecLegacySupportAdvanceModeCommandNumber__Null: return BFElementModelSpecLegacySupportAdvanceModeCommandString__Null;
  }
  return BFElementModelSpecLegacySupportAdvanceModeCommandString__Null;
}
+ (BFElementModelSpecLegacySupportAdvanceModeCommandNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementModelSpecLegacySupportAdvanceModeCommandStringPS_AM_HALFCUT]) {
    return BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_HALFCUT;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportAdvanceModeCommandStringPS_AM_CUTEND]) {
    return BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_CUTEND;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportAdvanceModeCommandStringPS_AM_SPECIALTAPE]) {
    return BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_SPECIALTAPE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportAdvanceModeCommandStringPS_AM_HIGH_RESOLUTION]) {
    return BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_HIGH_RESOLUTION;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportAdvanceModeCommandStringPS_AM_LABEL_CUTEND]) {
    return BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_LABEL_CUTEND;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportAdvanceModeCommandStringPS_AM_NOBUFFER]) {
    return BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_NOBUFFER;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportAdvanceModeCommandStringPS_AM_LOW_RESOLUTION]) {
    return BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_LOW_RESOLUTION;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportAdvanceModeCommandString__Null]) {
    return BFElementModelSpecLegacySupportAdvanceModeCommandNumber__Null;
  }
  return BFElementModelSpecLegacySupportAdvanceModeCommandNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ModelSpecLegacySupportAdvanceModeCommand";
}
@end

@implementation BFElementModelSpecLegacySupportChangeDpi
+ (nonnull NSString*)key {
  return @"ModelSpecLegacySupportChangeDpi";
}
@end

@implementation BFElementModelSpecLegacySupportCommandProtocolVersion
+ (nonnull NSString*)key {
  return @"ModelSpecLegacySupportCommandProtocolVersion";
}
@end

NSString * __nonnull const BFElementModelSpecLegacySupportFuncStringSP_FUC_RASTER_PRINT = @"SP_FUC_RASTER_PRINT";
NSString * __nonnull const BFElementModelSpecLegacySupportFuncStringSP_FUC_TEMPLATE_PRINT = @"SP_FUC_TEMPLATE_PRINT";
NSString * __nonnull const BFElementModelSpecLegacySupportFuncStringSP_FUC_TEMPLATE_TRANS = @"SP_FUC_TEMPLATE_TRANS";
NSString * __nonnull const BFElementModelSpecLegacySupportFuncStringSP_FUC_TEMPLATE_REMOVE = @"SP_FUC_TEMPLATE_REMOVE";
NSString * __nonnull const BFElementModelSpecLegacySupportFuncStringSP_FUC_PRINTER_SETTINGS = @"SP_FUC_PRINTER_SETTINGS";
NSString * __nonnull const BFElementModelSpecLegacySupportFuncStringSP_FUC_FIRM_UPDATE = @"SP_FUC_FIRM_UPDATE";
NSString * __nonnull const BFElementModelSpecLegacySupportFuncString__Null = @"__Null";
@implementation BFElementModelSpecLegacySupportFunc
+ (nonnull NSString*)convertToString:(BFElementModelSpecLegacySupportFuncNumber)num {
  switch(num) {
  case BFElementModelSpecLegacySupportFuncNumberSP_FUC_RASTER_PRINT: return BFElementModelSpecLegacySupportFuncStringSP_FUC_RASTER_PRINT;
  case BFElementModelSpecLegacySupportFuncNumberSP_FUC_TEMPLATE_PRINT: return BFElementModelSpecLegacySupportFuncStringSP_FUC_TEMPLATE_PRINT;
  case BFElementModelSpecLegacySupportFuncNumberSP_FUC_TEMPLATE_TRANS: return BFElementModelSpecLegacySupportFuncStringSP_FUC_TEMPLATE_TRANS;
  case BFElementModelSpecLegacySupportFuncNumberSP_FUC_TEMPLATE_REMOVE: return BFElementModelSpecLegacySupportFuncStringSP_FUC_TEMPLATE_REMOVE;
  case BFElementModelSpecLegacySupportFuncNumberSP_FUC_PRINTER_SETTINGS: return BFElementModelSpecLegacySupportFuncStringSP_FUC_PRINTER_SETTINGS;
  case BFElementModelSpecLegacySupportFuncNumberSP_FUC_FIRM_UPDATE: return BFElementModelSpecLegacySupportFuncStringSP_FUC_FIRM_UPDATE;
  case BFElementModelSpecLegacySupportFuncNumber__Null: return BFElementModelSpecLegacySupportFuncString__Null;
  }
  return BFElementModelSpecLegacySupportFuncString__Null;
}
+ (BFElementModelSpecLegacySupportFuncNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementModelSpecLegacySupportFuncStringSP_FUC_RASTER_PRINT]) {
    return BFElementModelSpecLegacySupportFuncNumberSP_FUC_RASTER_PRINT;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportFuncStringSP_FUC_TEMPLATE_PRINT]) {
    return BFElementModelSpecLegacySupportFuncNumberSP_FUC_TEMPLATE_PRINT;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportFuncStringSP_FUC_TEMPLATE_TRANS]) {
    return BFElementModelSpecLegacySupportFuncNumberSP_FUC_TEMPLATE_TRANS;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportFuncStringSP_FUC_TEMPLATE_REMOVE]) {
    return BFElementModelSpecLegacySupportFuncNumberSP_FUC_TEMPLATE_REMOVE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportFuncStringSP_FUC_PRINTER_SETTINGS]) {
    return BFElementModelSpecLegacySupportFuncNumberSP_FUC_PRINTER_SETTINGS;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportFuncStringSP_FUC_FIRM_UPDATE]) {
    return BFElementModelSpecLegacySupportFuncNumberSP_FUC_FIRM_UPDATE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportFuncString__Null]) {
    return BFElementModelSpecLegacySupportFuncNumber__Null;
  }
  return BFElementModelSpecLegacySupportFuncNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ModelSpecLegacySupportFunc";
}
@end

@implementation BFElementModelSpecLegacySupportGetBatteryWeak
+ (nonnull NSString*)key {
  return @"ModelSpecLegacySupportGetBatteryWeak";
}
@end

@implementation BFElementModelSpecLegacySupportGetMediaInfoVersion
+ (nonnull NSString*)key {
  return @"ModelSpecLegacySupportGetMediaInfoVersion";
}
@end

@implementation BFElementModelSpecLegacySupportGetSerialNumber
+ (nonnull NSString*)key {
  return @"ModelSpecLegacySupportGetSerialNumber";
}
@end

@implementation BFElementModelSpecLegacySupportMode9Compression
+ (nonnull NSString*)key {
  return @"ModelSpecLegacySupportMode9Compression";
}
@end

NSString * __nonnull const BFElementModelSpecLegacySupportMultiColorLabelStringMONO_COLOR = @"MONO_COLOR";
NSString * __nonnull const BFElementModelSpecLegacySupportMultiColorLabelStringBI_COLOR = @"BI_COLOR";
NSString * __nonnull const BFElementModelSpecLegacySupportMultiColorLabelStringUNSUPPORTED_COLOR = @"UNSUPPORTED_COLOR";
NSString * __nonnull const BFElementModelSpecLegacySupportMultiColorLabelString__Null = @"__Null";
@implementation BFElementModelSpecLegacySupportMultiColorLabel
+ (nonnull NSString*)convertToString:(BFElementModelSpecLegacySupportMultiColorLabelNumber)num {
  switch(num) {
  case BFElementModelSpecLegacySupportMultiColorLabelNumberMONO_COLOR: return BFElementModelSpecLegacySupportMultiColorLabelStringMONO_COLOR;
  case BFElementModelSpecLegacySupportMultiColorLabelNumberBI_COLOR: return BFElementModelSpecLegacySupportMultiColorLabelStringBI_COLOR;
  case BFElementModelSpecLegacySupportMultiColorLabelNumberUNSUPPORTED_COLOR: return BFElementModelSpecLegacySupportMultiColorLabelStringUNSUPPORTED_COLOR;
  case BFElementModelSpecLegacySupportMultiColorLabelNumber__Null: return BFElementModelSpecLegacySupportMultiColorLabelString__Null;
  }
  return BFElementModelSpecLegacySupportMultiColorLabelString__Null;
}
+ (BFElementModelSpecLegacySupportMultiColorLabelNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementModelSpecLegacySupportMultiColorLabelStringMONO_COLOR]) {
    return BFElementModelSpecLegacySupportMultiColorLabelNumberMONO_COLOR;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportMultiColorLabelStringBI_COLOR]) {
    return BFElementModelSpecLegacySupportMultiColorLabelNumberBI_COLOR;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportMultiColorLabelStringUNSUPPORTED_COLOR]) {
    return BFElementModelSpecLegacySupportMultiColorLabelNumberUNSUPPORTED_COLOR;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportMultiColorLabelString__Null]) {
    return BFElementModelSpecLegacySupportMultiColorLabelNumber__Null;
  }
  return BFElementModelSpecLegacySupportMultiColorLabelNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ModelSpecLegacySupportMultiColorLabel";
}
@end

NSString * __nonnull const BFElementModelSpecLegacySupportPJFeedModeStringFEED_MODE_FREE = @"FEED_MODE_FREE";
NSString * __nonnull const BFElementModelSpecLegacySupportPJFeedModeStringFEED_MODE_FIXEDPAGE = @"FEED_MODE_FIXEDPAGE";
NSString * __nonnull const BFElementModelSpecLegacySupportPJFeedModeStringFEED_MODE_ENDOFPAGE = @"FEED_MODE_ENDOFPAGE";
NSString * __nonnull const BFElementModelSpecLegacySupportPJFeedModeStringFEED_MODE_ENDOFPAGERETRACT = @"FEED_MODE_ENDOFPAGERETRACT";
NSString * __nonnull const BFElementModelSpecLegacySupportPJFeedModeString__Null = @"__Null";
@implementation BFElementModelSpecLegacySupportPJFeedMode
+ (nonnull NSString*)convertToString:(BFElementModelSpecLegacySupportPJFeedModeNumber)num {
  switch(num) {
  case BFElementModelSpecLegacySupportPJFeedModeNumberFEED_MODE_FREE: return BFElementModelSpecLegacySupportPJFeedModeStringFEED_MODE_FREE;
  case BFElementModelSpecLegacySupportPJFeedModeNumberFEED_MODE_FIXEDPAGE: return BFElementModelSpecLegacySupportPJFeedModeStringFEED_MODE_FIXEDPAGE;
  case BFElementModelSpecLegacySupportPJFeedModeNumberFEED_MODE_ENDOFPAGE: return BFElementModelSpecLegacySupportPJFeedModeStringFEED_MODE_ENDOFPAGE;
  case BFElementModelSpecLegacySupportPJFeedModeNumberFEED_MODE_ENDOFPAGERETRACT: return BFElementModelSpecLegacySupportPJFeedModeStringFEED_MODE_ENDOFPAGERETRACT;
  case BFElementModelSpecLegacySupportPJFeedModeNumber__Null: return BFElementModelSpecLegacySupportPJFeedModeString__Null;
  }
  return BFElementModelSpecLegacySupportPJFeedModeString__Null;
}
+ (BFElementModelSpecLegacySupportPJFeedModeNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementModelSpecLegacySupportPJFeedModeStringFEED_MODE_FREE]) {
    return BFElementModelSpecLegacySupportPJFeedModeNumberFEED_MODE_FREE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportPJFeedModeStringFEED_MODE_FIXEDPAGE]) {
    return BFElementModelSpecLegacySupportPJFeedModeNumberFEED_MODE_FIXEDPAGE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportPJFeedModeStringFEED_MODE_ENDOFPAGE]) {
    return BFElementModelSpecLegacySupportPJFeedModeNumberFEED_MODE_ENDOFPAGE;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportPJFeedModeStringFEED_MODE_ENDOFPAGERETRACT]) {
    return BFElementModelSpecLegacySupportPJFeedModeNumberFEED_MODE_ENDOFPAGERETRACT;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportPJFeedModeString__Null]) {
    return BFElementModelSpecLegacySupportPJFeedModeNumber__Null;
  }
  return BFElementModelSpecLegacySupportPJFeedModeNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ModelSpecLegacySupportPJFeedMode";
}
@end

@implementation BFElementModelSpecLegacySupportPJRollCase
+ (nonnull NSString*)key {
  return @"ModelSpecLegacySupportPJRollCase";
}
@end

@implementation BFElementModelSpecLegacySupportPJSpeedCommand
+ (nonnull NSString*)key {
  return @"ModelSpecLegacySupportPJSpeedCommand";
}
@end

@implementation BFElementModelSpecLegacySupportTube
+ (nonnull NSString*)key {
  return @"ModelSpecLegacySupportTube";
}
@end

NSString * __nonnull const BFElementModelSpecLegacySupportVariousModeCommandStringPS_VM_AUTOCUT = @"PS_VM_AUTOCUT";
NSString * __nonnull const BFElementModelSpecLegacySupportVariousModeCommandStringPS_VM_MIRROR = @"PS_VM_MIRROR";
NSString * __nonnull const BFElementModelSpecLegacySupportVariousModeCommandStringPS_VM_PEEL = @"PS_VM_PEEL";
NSString * __nonnull const BFElementModelSpecLegacySupportVariousModeCommandStringPS_VM_ROTATE180 = @"PS_VM_ROTATE180";
NSString * __nonnull const BFElementModelSpecLegacySupportVariousModeCommandStringPS_VM_CUTMARK = @"PS_VM_CUTMARK";
NSString * __nonnull const BFElementModelSpecLegacySupportVariousModeCommandStringPS_FEEDVOL = @"PS_FEEDVOL";
NSString * __nonnull const BFElementModelSpecLegacySupportVariousModeCommandString__Null = @"__Null";
@implementation BFElementModelSpecLegacySupportVariousModeCommand
+ (nonnull NSString*)convertToString:(BFElementModelSpecLegacySupportVariousModeCommandNumber)num {
  switch(num) {
  case BFElementModelSpecLegacySupportVariousModeCommandNumberPS_VM_AUTOCUT: return BFElementModelSpecLegacySupportVariousModeCommandStringPS_VM_AUTOCUT;
  case BFElementModelSpecLegacySupportVariousModeCommandNumberPS_VM_MIRROR: return BFElementModelSpecLegacySupportVariousModeCommandStringPS_VM_MIRROR;
  case BFElementModelSpecLegacySupportVariousModeCommandNumberPS_VM_PEEL: return BFElementModelSpecLegacySupportVariousModeCommandStringPS_VM_PEEL;
  case BFElementModelSpecLegacySupportVariousModeCommandNumberPS_VM_ROTATE180: return BFElementModelSpecLegacySupportVariousModeCommandStringPS_VM_ROTATE180;
  case BFElementModelSpecLegacySupportVariousModeCommandNumberPS_VM_CUTMARK: return BFElementModelSpecLegacySupportVariousModeCommandStringPS_VM_CUTMARK;
  case BFElementModelSpecLegacySupportVariousModeCommandNumberPS_FEEDVOL: return BFElementModelSpecLegacySupportVariousModeCommandStringPS_FEEDVOL;
  case BFElementModelSpecLegacySupportVariousModeCommandNumber__Null: return BFElementModelSpecLegacySupportVariousModeCommandString__Null;
  }
  return BFElementModelSpecLegacySupportVariousModeCommandString__Null;
}
+ (BFElementModelSpecLegacySupportVariousModeCommandNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementModelSpecLegacySupportVariousModeCommandStringPS_VM_AUTOCUT]) {
    return BFElementModelSpecLegacySupportVariousModeCommandNumberPS_VM_AUTOCUT;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportVariousModeCommandStringPS_VM_MIRROR]) {
    return BFElementModelSpecLegacySupportVariousModeCommandNumberPS_VM_MIRROR;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportVariousModeCommandStringPS_VM_PEEL]) {
    return BFElementModelSpecLegacySupportVariousModeCommandNumberPS_VM_PEEL;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportVariousModeCommandStringPS_VM_ROTATE180]) {
    return BFElementModelSpecLegacySupportVariousModeCommandNumberPS_VM_ROTATE180;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportVariousModeCommandStringPS_VM_CUTMARK]) {
    return BFElementModelSpecLegacySupportVariousModeCommandNumberPS_VM_CUTMARK;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportVariousModeCommandStringPS_FEEDVOL]) {
    return BFElementModelSpecLegacySupportVariousModeCommandNumberPS_FEEDVOL;
  }
  if ([str isEqualToString:BFElementModelSpecLegacySupportVariousModeCommandString__Null]) {
    return BFElementModelSpecLegacySupportVariousModeCommandNumber__Null;
  }
  return BFElementModelSpecLegacySupportVariousModeCommandNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ModelSpecLegacySupportVariousModeCommand";
}
@end

@implementation BFElementModelSpecLegacyTemplateLimited
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyTemplateLimited";
}
@end

@implementation BFElementModelSpecLegacyTemplateLimitedFirmName
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyTemplateLimitedFirmName";
}
@end

@implementation BFElementModelSpecLegacyTemplateLimitedFirmType
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyTemplateLimitedFirmType";
}
@end

@implementation BFElementModelSpecLegacyTemplateMaxObjectSize
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyTemplateMaxObjectSize";
}
@end

@implementation BFElementModelSpecLegacyTemplateShouldChangeCommandMode
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyTemplateShouldChangeCommandMode";
}
@end

@implementation BFElementModelSpecLegacyUSBDeviceProductID
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyUSBDeviceProductID";
}
@end

@implementation BFElementModelSpecLegacyValidCommunicationBidirectional
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyValidCommunicationBidirectional";
}
@end

@implementation BFElementModelSpecLegacyValidResponseAfterFirmUpdate
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyValidResponseAfterFirmUpdate";
}
@end

@implementation BFElementModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty";
}
@end

@implementation BFElementModelSpecLegacyXdpi
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyXdpi";
}
@end

@implementation BFElementModelSpecLegacyYdpi
+ (nonnull NSString*)key {
  return @"ModelSpecLegacyYdpi";
}
@end

