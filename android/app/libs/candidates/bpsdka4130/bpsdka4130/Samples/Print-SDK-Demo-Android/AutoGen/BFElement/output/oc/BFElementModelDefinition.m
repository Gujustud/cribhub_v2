

#import "BFElementModelDefinition.h"

NSString * __nonnull const BFElementModelInterfaceStringUSB = @"USB";
NSString * __nonnull const BFElementModelInterfaceStringNetwork = @"Network";
NSString * __nonnull const BFElementModelInterfaceStringBluetooth = @"Bluetooth";
NSString * __nonnull const BFElementModelInterfaceStringBluetoothLowEnergy = @"BluetoothLowEnergy";
NSString * __nonnull const BFElementModelInterfaceString__Null = @"__Null";
@implementation BFElementModelInterface
+ (nonnull NSString*)convertToString:(BFElementModelInterfaceNumber)num {
  switch(num) {
  case BFElementModelInterfaceNumberUSB: return BFElementModelInterfaceStringUSB;
  case BFElementModelInterfaceNumberNetwork: return BFElementModelInterfaceStringNetwork;
  case BFElementModelInterfaceNumberBluetooth: return BFElementModelInterfaceStringBluetooth;
  case BFElementModelInterfaceNumberBluetoothLowEnergy: return BFElementModelInterfaceStringBluetoothLowEnergy;
  case BFElementModelInterfaceNumber__Null: return BFElementModelInterfaceString__Null;
  }
  return BFElementModelInterfaceString__Null;
}
+ (BFElementModelInterfaceNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementModelInterfaceStringUSB]) {
    return BFElementModelInterfaceNumberUSB;
  }
  if ([str isEqualToString:BFElementModelInterfaceStringNetwork]) {
    return BFElementModelInterfaceNumberNetwork;
  }
  if ([str isEqualToString:BFElementModelInterfaceStringBluetooth]) {
    return BFElementModelInterfaceNumberBluetooth;
  }
  if ([str isEqualToString:BFElementModelInterfaceStringBluetoothLowEnergy]) {
    return BFElementModelInterfaceNumberBluetoothLowEnergy;
  }
  if ([str isEqualToString:BFElementModelInterfaceString__Null]) {
    return BFElementModelInterfaceNumber__Null;
  }
  return BFElementModelInterfaceNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ModelInterface";
}
@end

NSString * __nonnull const BFElementModelMajorStringQL = @"QL";
NSString * __nonnull const BFElementModelMajorStringPT = @"PT";
NSString * __nonnull const BFElementModelMajorStringPJ = @"PJ";
NSString * __nonnull const BFElementModelMajorStringSC = @"SC";
NSString * __nonnull const BFElementModelMajorStringRJ = @"RJ";
NSString * __nonnull const BFElementModelMajorStringTD = @"TD";
NSString * __nonnull const BFElementModelMajorStringTP = @"TP";
NSString * __nonnull const BFElementModelMajorStringMW = @"MW";
NSString * __nonnull const BFElementModelMajorString__Null = @"__Null";
@implementation BFElementModelMajor
+ (nonnull NSString*)convertToString:(BFElementModelMajorNumber)num {
  switch(num) {
  case BFElementModelMajorNumberQL: return BFElementModelMajorStringQL;
  case BFElementModelMajorNumberPT: return BFElementModelMajorStringPT;
  case BFElementModelMajorNumberPJ: return BFElementModelMajorStringPJ;
  case BFElementModelMajorNumberSC: return BFElementModelMajorStringSC;
  case BFElementModelMajorNumberRJ: return BFElementModelMajorStringRJ;
  case BFElementModelMajorNumberTD: return BFElementModelMajorStringTD;
  case BFElementModelMajorNumberTP: return BFElementModelMajorStringTP;
  case BFElementModelMajorNumberMW: return BFElementModelMajorStringMW;
  case BFElementModelMajorNumber__Null: return BFElementModelMajorString__Null;
  }
  return BFElementModelMajorString__Null;
}
+ (BFElementModelMajorNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementModelMajorStringQL]) {
    return BFElementModelMajorNumberQL;
  }
  if ([str isEqualToString:BFElementModelMajorStringPT]) {
    return BFElementModelMajorNumberPT;
  }
  if ([str isEqualToString:BFElementModelMajorStringPJ]) {
    return BFElementModelMajorNumberPJ;
  }
  if ([str isEqualToString:BFElementModelMajorStringSC]) {
    return BFElementModelMajorNumberSC;
  }
  if ([str isEqualToString:BFElementModelMajorStringRJ]) {
    return BFElementModelMajorNumberRJ;
  }
  if ([str isEqualToString:BFElementModelMajorStringTD]) {
    return BFElementModelMajorNumberTD;
  }
  if ([str isEqualToString:BFElementModelMajorStringTP]) {
    return BFElementModelMajorNumberTP;
  }
  if ([str isEqualToString:BFElementModelMajorStringMW]) {
    return BFElementModelMajorNumberMW;
  }
  if ([str isEqualToString:BFElementModelMajorString__Null]) {
    return BFElementModelMajorNumber__Null;
  }
  return BFElementModelMajorNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ModelMajor";
}
@end

NSString * __nonnull const BFElementModelNameStringMW_140BT = @"MW-140BT";
NSString * __nonnull const BFElementModelNameStringMW_145BT = @"MW-145BT";
NSString * __nonnull const BFElementModelNameStringMW_260 = @"MW-260";
NSString * __nonnull const BFElementModelNameStringPJ_522 = @"PJ-522";
NSString * __nonnull const BFElementModelNameStringPJ_523 = @"PJ-523";
NSString * __nonnull const BFElementModelNameStringPJ_520 = @"PJ-520";
NSString * __nonnull const BFElementModelNameStringPJ_560 = @"PJ-560";
NSString * __nonnull const BFElementModelNameStringPJ_562 = @"PJ-562";
NSString * __nonnull const BFElementModelNameStringPJ_563 = @"PJ-563";
NSString * __nonnull const BFElementModelNameStringPJ_622 = @"PJ-622";
NSString * __nonnull const BFElementModelNameStringPJ_623 = @"PJ-623";
NSString * __nonnull const BFElementModelNameStringPJ_662 = @"PJ-662";
NSString * __nonnull const BFElementModelNameStringPJ_663 = @"PJ-663";
NSString * __nonnull const BFElementModelNameStringRJ_4030 = @"RJ-4030";
NSString * __nonnull const BFElementModelNameStringRJ_4040 = @"RJ-4040";
NSString * __nonnull const BFElementModelNameStringRJ_3150 = @"RJ-3150";
NSString * __nonnull const BFElementModelNameStringRJ_3050 = @"RJ-3050";
NSString * __nonnull const BFElementModelNameStringQL_580N = @"QL-580N";
NSString * __nonnull const BFElementModelNameStringQL_700 = @"QL-700";
NSString * __nonnull const BFElementModelNameStringQL_710W = @"QL-710W";
NSString * __nonnull const BFElementModelNameStringQL_720NW = @"QL-720NW";
NSString * __nonnull const BFElementModelNameStringTD_2020 = @"TD-2020";
NSString * __nonnull const BFElementModelNameStringTD_2120N = @"TD-2120N";
NSString * __nonnull const BFElementModelNameStringTD_2130N = @"TD-2130N";
NSString * __nonnull const BFElementModelNameStringPT_E550W = @"PT-E550W";
NSString * __nonnull const BFElementModelNameStringPT_P750W = @"PT-P750W";
NSString * __nonnull const BFElementModelNameStringTD_4100N = @"TD-4100N";
NSString * __nonnull const BFElementModelNameStringTD_4000 = @"TD-4000";
NSString * __nonnull const BFElementModelNameStringPJ_762 = @"PJ-762";
NSString * __nonnull const BFElementModelNameStringPJ_763 = @"PJ-763";
NSString * __nonnull const BFElementModelNameStringPJ_773 = @"PJ-773";
NSString * __nonnull const BFElementModelNameStringPJ_722 = @"PJ-722";
NSString * __nonnull const BFElementModelNameStringPJ_723 = @"PJ-723";
NSString * __nonnull const BFElementModelNameStringPJ_763MFi = @"PJ-763MFi";
NSString * __nonnull const BFElementModelNameStringPJ_673 = @"PJ-673";
NSString * __nonnull const BFElementModelNameStringMW_145MFi = @"MW-145MFi";
NSString * __nonnull const BFElementModelNameStringMW_260MFi = @"MW-260MFi";
NSString * __nonnull const BFElementModelNameStringPT_P300BT = @"PT-P300BT";
NSString * __nonnull const BFElementModelNameStringPT_E850TKW = @"PT-E850TKW";
NSString * __nonnull const BFElementModelNameStringPT_D800W = @"PT-D800W";
NSString * __nonnull const BFElementModelNameStringPT_P900W = @"PT-P900W";
NSString * __nonnull const BFElementModelNameStringPT_P950NW = @"PT-P950NW";
NSString * __nonnull const BFElementModelNameStringRJ_4030Ai = @"RJ-4030Ai";
NSString * __nonnull const BFElementModelNameStringPT_E800W = @"PT-E800W";
NSString * __nonnull const BFElementModelNameStringRJ_2030 = @"RJ-2030";
NSString * __nonnull const BFElementModelNameStringRJ_2050 = @"RJ-2050";
NSString * __nonnull const BFElementModelNameStringRJ_2140 = @"RJ-2140";
NSString * __nonnull const BFElementModelNameStringRJ_2150 = @"RJ-2150";
NSString * __nonnull const BFElementModelNameStringRJ_3050Ai = @"RJ-3050Ai";
NSString * __nonnull const BFElementModelNameStringRJ_3150Ai = @"RJ-3150Ai";
NSString * __nonnull const BFElementModelNameStringQL_800 = @"QL-800";
NSString * __nonnull const BFElementModelNameStringQL_810W = @"QL-810W";
NSString * __nonnull const BFElementModelNameStringQL_820NWB = @"QL-820NWB";
NSString * __nonnull const BFElementModelNameStringQL_1100 = @"QL-1100";
NSString * __nonnull const BFElementModelNameStringQL_1110NWB = @"QL-1110NWB";
NSString * __nonnull const BFElementModelNameStringQL_1115NWB = @"QL-1115NWB";
NSString * __nonnull const BFElementModelNameStringPT_P710BT = @"PT-P710BT";
NSString * __nonnull const BFElementModelNameStringPT_E500 = @"PT-E500";
NSString * __nonnull const BFElementModelNameStringRJ_4230B = @"RJ-4230B";
NSString * __nonnull const BFElementModelNameStringRJ_4250WB = @"RJ-4250WB";
NSString * __nonnull const BFElementModelNameStringTD_4410D = @"TD-4410D";
NSString * __nonnull const BFElementModelNameStringTD_4420DN = @"TD-4420DN";
NSString * __nonnull const BFElementModelNameStringTD_4510D = @"TD-4510D";
NSString * __nonnull const BFElementModelNameStringTD_4520DN = @"TD-4520DN";
NSString * __nonnull const BFElementModelNameStringTD_4550DNWB = @"TD-4550DNWB";
NSString * __nonnull const BFElementModelNameStringQL_600 = @"QL-600";
NSString * __nonnull const BFElementModelNameStringMW_170 = @"MW-170";
NSString * __nonnull const BFElementModelNameStringMW_270 = @"MW-270";
NSString * __nonnull const BFElementModelNameStringPT_P910BT = @"PT-P910BT";
NSString * __nonnull const BFElementModelNameStringPT_D450 = @"PT-D450";
NSString * __nonnull const BFElementModelNameStringPT_D600 = @"PT-D600";
NSString * __nonnull const BFElementModelNameStringPT_P700 = @"PT-P700";
NSString * __nonnull const BFElementModelNameStringPT_H500 = @"PT-H500";
NSString * __nonnull const BFElementModelNameStringPT_P715eBT = @"PT-P715eBT";
NSString * __nonnull const BFElementModelNameStringQL_500 = @"QL-500";
NSString * __nonnull const BFElementModelNameStringQL_550 = @"QL-550";
NSString * __nonnull const BFElementModelNameStringQL_560 = @"QL-560";
NSString * __nonnull const BFElementModelNameStringQL_570 = @"QL-570";
NSString * __nonnull const BFElementModelNameStringQL_650TD = @"QL-650TD";
NSString * __nonnull const BFElementModelNameStringQL_1050 = @"QL-1050";
NSString * __nonnull const BFElementModelNameStringQL_1060N = @"QL-1060N";
NSString * __nonnull const BFElementModelNameStringPT_9700PC = @"PT-9700PC";
NSString * __nonnull const BFElementModelNameStringPT_9800PCN = @"PT-9800PCN";
NSString * __nonnull const BFElementModelNameStringPT_3600 = @"PT-3600";
NSString * __nonnull const BFElementModelNameStringPT_9600 = @"PT-9600";
NSString * __nonnull const BFElementModelNameStringPT_9500PC = @"PT-9500PC";
NSString * __nonnull const BFElementModelNameStringPT_18NR = @"PT-18NR";
NSString * __nonnull const BFElementModelNameStringPT_18R = @"PT-18R";
NSString * __nonnull const BFElementModelNameStringPT_24 = @"PT-24";
NSString * __nonnull const BFElementModelNameStringPT_2700 = @"PT-2700";
NSString * __nonnull const BFElementModelNameStringPT_2430PC = @"PT-2430PC";
NSString * __nonnull const BFElementModelNameStringPT_2730 = @"PT-2730";
NSString * __nonnull const BFElementModelNameStringRJ_3230B = @"RJ-3230B";
NSString * __nonnull const BFElementModelNameStringRJ_3250WB = @"RJ-3250WB";
NSString * __nonnull const BFElementModelNameStringPT_D410 = @"PT-D410";
NSString * __nonnull const BFElementModelNameStringPT_D460BT = @"PT-D460BT";
NSString * __nonnull const BFElementModelNameStringPT_D610BT = @"PT-D610BT";
NSString * __nonnull const BFElementModelNameStringPJ_822 = @"PJ-822";
NSString * __nonnull const BFElementModelNameStringPJ_823 = @"PJ-823";
NSString * __nonnull const BFElementModelNameStringPJ_862 = @"PJ-862";
NSString * __nonnull const BFElementModelNameStringPJ_863 = @"PJ-863";
NSString * __nonnull const BFElementModelNameStringPJ_883 = @"PJ-883";
NSString * __nonnull const BFElementModelNameString__Null = @"__Null";
@implementation BFElementModelName
+ (nonnull NSString*)convertToString:(BFElementModelNameNumber)num {
  switch(num) {
  case BFElementModelNameNumberMW_140BT: return BFElementModelNameStringMW_140BT;
  case BFElementModelNameNumberMW_145BT: return BFElementModelNameStringMW_145BT;
  case BFElementModelNameNumberMW_260: return BFElementModelNameStringMW_260;
  case BFElementModelNameNumberPJ_522: return BFElementModelNameStringPJ_522;
  case BFElementModelNameNumberPJ_523: return BFElementModelNameStringPJ_523;
  case BFElementModelNameNumberPJ_520: return BFElementModelNameStringPJ_520;
  case BFElementModelNameNumberPJ_560: return BFElementModelNameStringPJ_560;
  case BFElementModelNameNumberPJ_562: return BFElementModelNameStringPJ_562;
  case BFElementModelNameNumberPJ_563: return BFElementModelNameStringPJ_563;
  case BFElementModelNameNumberPJ_622: return BFElementModelNameStringPJ_622;
  case BFElementModelNameNumberPJ_623: return BFElementModelNameStringPJ_623;
  case BFElementModelNameNumberPJ_662: return BFElementModelNameStringPJ_662;
  case BFElementModelNameNumberPJ_663: return BFElementModelNameStringPJ_663;
  case BFElementModelNameNumberRJ_4030: return BFElementModelNameStringRJ_4030;
  case BFElementModelNameNumberRJ_4040: return BFElementModelNameStringRJ_4040;
  case BFElementModelNameNumberRJ_3150: return BFElementModelNameStringRJ_3150;
  case BFElementModelNameNumberRJ_3050: return BFElementModelNameStringRJ_3050;
  case BFElementModelNameNumberQL_580N: return BFElementModelNameStringQL_580N;
  case BFElementModelNameNumberQL_700: return BFElementModelNameStringQL_700;
  case BFElementModelNameNumberQL_710W: return BFElementModelNameStringQL_710W;
  case BFElementModelNameNumberQL_720NW: return BFElementModelNameStringQL_720NW;
  case BFElementModelNameNumberTD_2020: return BFElementModelNameStringTD_2020;
  case BFElementModelNameNumberTD_2120N: return BFElementModelNameStringTD_2120N;
  case BFElementModelNameNumberTD_2130N: return BFElementModelNameStringTD_2130N;
  case BFElementModelNameNumberPT_E550W: return BFElementModelNameStringPT_E550W;
  case BFElementModelNameNumberPT_P750W: return BFElementModelNameStringPT_P750W;
  case BFElementModelNameNumberTD_4100N: return BFElementModelNameStringTD_4100N;
  case BFElementModelNameNumberTD_4000: return BFElementModelNameStringTD_4000;
  case BFElementModelNameNumberPJ_762: return BFElementModelNameStringPJ_762;
  case BFElementModelNameNumberPJ_763: return BFElementModelNameStringPJ_763;
  case BFElementModelNameNumberPJ_773: return BFElementModelNameStringPJ_773;
  case BFElementModelNameNumberPJ_722: return BFElementModelNameStringPJ_722;
  case BFElementModelNameNumberPJ_723: return BFElementModelNameStringPJ_723;
  case BFElementModelNameNumberPJ_763MFi: return BFElementModelNameStringPJ_763MFi;
  case BFElementModelNameNumberPJ_673: return BFElementModelNameStringPJ_673;
  case BFElementModelNameNumberMW_145MFi: return BFElementModelNameStringMW_145MFi;
  case BFElementModelNameNumberMW_260MFi: return BFElementModelNameStringMW_260MFi;
  case BFElementModelNameNumberPT_P300BT: return BFElementModelNameStringPT_P300BT;
  case BFElementModelNameNumberPT_E850TKW: return BFElementModelNameStringPT_E850TKW;
  case BFElementModelNameNumberPT_D800W: return BFElementModelNameStringPT_D800W;
  case BFElementModelNameNumberPT_P900W: return BFElementModelNameStringPT_P900W;
  case BFElementModelNameNumberPT_P950NW: return BFElementModelNameStringPT_P950NW;
  case BFElementModelNameNumberRJ_4030Ai: return BFElementModelNameStringRJ_4030Ai;
  case BFElementModelNameNumberPT_E800W: return BFElementModelNameStringPT_E800W;
  case BFElementModelNameNumberRJ_2030: return BFElementModelNameStringRJ_2030;
  case BFElementModelNameNumberRJ_2050: return BFElementModelNameStringRJ_2050;
  case BFElementModelNameNumberRJ_2140: return BFElementModelNameStringRJ_2140;
  case BFElementModelNameNumberRJ_2150: return BFElementModelNameStringRJ_2150;
  case BFElementModelNameNumberRJ_3050Ai: return BFElementModelNameStringRJ_3050Ai;
  case BFElementModelNameNumberRJ_3150Ai: return BFElementModelNameStringRJ_3150Ai;
  case BFElementModelNameNumberQL_800: return BFElementModelNameStringQL_800;
  case BFElementModelNameNumberQL_810W: return BFElementModelNameStringQL_810W;
  case BFElementModelNameNumberQL_820NWB: return BFElementModelNameStringQL_820NWB;
  case BFElementModelNameNumberQL_1100: return BFElementModelNameStringQL_1100;
  case BFElementModelNameNumberQL_1110NWB: return BFElementModelNameStringQL_1110NWB;
  case BFElementModelNameNumberQL_1115NWB: return BFElementModelNameStringQL_1115NWB;
  case BFElementModelNameNumberPT_P710BT: return BFElementModelNameStringPT_P710BT;
  case BFElementModelNameNumberPT_E500: return BFElementModelNameStringPT_E500;
  case BFElementModelNameNumberRJ_4230B: return BFElementModelNameStringRJ_4230B;
  case BFElementModelNameNumberRJ_4250WB: return BFElementModelNameStringRJ_4250WB;
  case BFElementModelNameNumberTD_4410D: return BFElementModelNameStringTD_4410D;
  case BFElementModelNameNumberTD_4420DN: return BFElementModelNameStringTD_4420DN;
  case BFElementModelNameNumberTD_4510D: return BFElementModelNameStringTD_4510D;
  case BFElementModelNameNumberTD_4520DN: return BFElementModelNameStringTD_4520DN;
  case BFElementModelNameNumberTD_4550DNWB: return BFElementModelNameStringTD_4550DNWB;
  case BFElementModelNameNumberQL_600: return BFElementModelNameStringQL_600;
  case BFElementModelNameNumberMW_170: return BFElementModelNameStringMW_170;
  case BFElementModelNameNumberMW_270: return BFElementModelNameStringMW_270;
  case BFElementModelNameNumberPT_P910BT: return BFElementModelNameStringPT_P910BT;
  case BFElementModelNameNumberPT_D450: return BFElementModelNameStringPT_D450;
  case BFElementModelNameNumberPT_D600: return BFElementModelNameStringPT_D600;
  case BFElementModelNameNumberPT_P700: return BFElementModelNameStringPT_P700;
  case BFElementModelNameNumberPT_H500: return BFElementModelNameStringPT_H500;
  case BFElementModelNameNumberPT_P715eBT: return BFElementModelNameStringPT_P715eBT;
  case BFElementModelNameNumberQL_500: return BFElementModelNameStringQL_500;
  case BFElementModelNameNumberQL_550: return BFElementModelNameStringQL_550;
  case BFElementModelNameNumberQL_560: return BFElementModelNameStringQL_560;
  case BFElementModelNameNumberQL_570: return BFElementModelNameStringQL_570;
  case BFElementModelNameNumberQL_650TD: return BFElementModelNameStringQL_650TD;
  case BFElementModelNameNumberQL_1050: return BFElementModelNameStringQL_1050;
  case BFElementModelNameNumberQL_1060N: return BFElementModelNameStringQL_1060N;
  case BFElementModelNameNumberPT_9700PC: return BFElementModelNameStringPT_9700PC;
  case BFElementModelNameNumberPT_9800PCN: return BFElementModelNameStringPT_9800PCN;
  case BFElementModelNameNumberPT_3600: return BFElementModelNameStringPT_3600;
  case BFElementModelNameNumberPT_9600: return BFElementModelNameStringPT_9600;
  case BFElementModelNameNumberPT_9500PC: return BFElementModelNameStringPT_9500PC;
  case BFElementModelNameNumberPT_18NR: return BFElementModelNameStringPT_18NR;
  case BFElementModelNameNumberPT_18R: return BFElementModelNameStringPT_18R;
  case BFElementModelNameNumberPT_24: return BFElementModelNameStringPT_24;
  case BFElementModelNameNumberPT_2700: return BFElementModelNameStringPT_2700;
  case BFElementModelNameNumberPT_2430PC: return BFElementModelNameStringPT_2430PC;
  case BFElementModelNameNumberPT_2730: return BFElementModelNameStringPT_2730;
  case BFElementModelNameNumberRJ_3230B: return BFElementModelNameStringRJ_3230B;
  case BFElementModelNameNumberRJ_3250WB: return BFElementModelNameStringRJ_3250WB;
  case BFElementModelNameNumberPT_D410: return BFElementModelNameStringPT_D410;
  case BFElementModelNameNumberPT_D460BT: return BFElementModelNameStringPT_D460BT;
  case BFElementModelNameNumberPT_D610BT: return BFElementModelNameStringPT_D610BT;
  case BFElementModelNameNumberPJ_822: return BFElementModelNameStringPJ_822;
  case BFElementModelNameNumberPJ_823: return BFElementModelNameStringPJ_823;
  case BFElementModelNameNumberPJ_862: return BFElementModelNameStringPJ_862;
  case BFElementModelNameNumberPJ_863: return BFElementModelNameStringPJ_863;
  case BFElementModelNameNumberPJ_883: return BFElementModelNameStringPJ_883;
  case BFElementModelNameNumber__Null: return BFElementModelNameString__Null;
  }
  return BFElementModelNameString__Null;
}
+ (BFElementModelNameNumber)convertToNumber:(nonnull NSString*)str {
  if ([str isEqualToString:BFElementModelNameStringMW_140BT]) {
    return BFElementModelNameNumberMW_140BT;
  }
  if ([str isEqualToString:BFElementModelNameStringMW_145BT]) {
    return BFElementModelNameNumberMW_145BT;
  }
  if ([str isEqualToString:BFElementModelNameStringMW_260]) {
    return BFElementModelNameNumberMW_260;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_522]) {
    return BFElementModelNameNumberPJ_522;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_523]) {
    return BFElementModelNameNumberPJ_523;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_520]) {
    return BFElementModelNameNumberPJ_520;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_560]) {
    return BFElementModelNameNumberPJ_560;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_562]) {
    return BFElementModelNameNumberPJ_562;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_563]) {
    return BFElementModelNameNumberPJ_563;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_622]) {
    return BFElementModelNameNumberPJ_622;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_623]) {
    return BFElementModelNameNumberPJ_623;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_662]) {
    return BFElementModelNameNumberPJ_662;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_663]) {
    return BFElementModelNameNumberPJ_663;
  }
  if ([str isEqualToString:BFElementModelNameStringRJ_4030]) {
    return BFElementModelNameNumberRJ_4030;
  }
  if ([str isEqualToString:BFElementModelNameStringRJ_4040]) {
    return BFElementModelNameNumberRJ_4040;
  }
  if ([str isEqualToString:BFElementModelNameStringRJ_3150]) {
    return BFElementModelNameNumberRJ_3150;
  }
  if ([str isEqualToString:BFElementModelNameStringRJ_3050]) {
    return BFElementModelNameNumberRJ_3050;
  }
  if ([str isEqualToString:BFElementModelNameStringQL_580N]) {
    return BFElementModelNameNumberQL_580N;
  }
  if ([str isEqualToString:BFElementModelNameStringQL_700]) {
    return BFElementModelNameNumberQL_700;
  }
  if ([str isEqualToString:BFElementModelNameStringQL_710W]) {
    return BFElementModelNameNumberQL_710W;
  }
  if ([str isEqualToString:BFElementModelNameStringQL_720NW]) {
    return BFElementModelNameNumberQL_720NW;
  }
  if ([str isEqualToString:BFElementModelNameStringTD_2020]) {
    return BFElementModelNameNumberTD_2020;
  }
  if ([str isEqualToString:BFElementModelNameStringTD_2120N]) {
    return BFElementModelNameNumberTD_2120N;
  }
  if ([str isEqualToString:BFElementModelNameStringTD_2130N]) {
    return BFElementModelNameNumberTD_2130N;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_E550W]) {
    return BFElementModelNameNumberPT_E550W;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_P750W]) {
    return BFElementModelNameNumberPT_P750W;
  }
  if ([str isEqualToString:BFElementModelNameStringTD_4100N]) {
    return BFElementModelNameNumberTD_4100N;
  }
  if ([str isEqualToString:BFElementModelNameStringTD_4000]) {
    return BFElementModelNameNumberTD_4000;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_762]) {
    return BFElementModelNameNumberPJ_762;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_763]) {
    return BFElementModelNameNumberPJ_763;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_773]) {
    return BFElementModelNameNumberPJ_773;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_722]) {
    return BFElementModelNameNumberPJ_722;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_723]) {
    return BFElementModelNameNumberPJ_723;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_763MFi]) {
    return BFElementModelNameNumberPJ_763MFi;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_673]) {
    return BFElementModelNameNumberPJ_673;
  }
  if ([str isEqualToString:BFElementModelNameStringMW_145MFi]) {
    return BFElementModelNameNumberMW_145MFi;
  }
  if ([str isEqualToString:BFElementModelNameStringMW_260MFi]) {
    return BFElementModelNameNumberMW_260MFi;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_P300BT]) {
    return BFElementModelNameNumberPT_P300BT;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_E850TKW]) {
    return BFElementModelNameNumberPT_E850TKW;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_D800W]) {
    return BFElementModelNameNumberPT_D800W;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_P900W]) {
    return BFElementModelNameNumberPT_P900W;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_P950NW]) {
    return BFElementModelNameNumberPT_P950NW;
  }
  if ([str isEqualToString:BFElementModelNameStringRJ_4030Ai]) {
    return BFElementModelNameNumberRJ_4030Ai;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_E800W]) {
    return BFElementModelNameNumberPT_E800W;
  }
  if ([str isEqualToString:BFElementModelNameStringRJ_2030]) {
    return BFElementModelNameNumberRJ_2030;
  }
  if ([str isEqualToString:BFElementModelNameStringRJ_2050]) {
    return BFElementModelNameNumberRJ_2050;
  }
  if ([str isEqualToString:BFElementModelNameStringRJ_2140]) {
    return BFElementModelNameNumberRJ_2140;
  }
  if ([str isEqualToString:BFElementModelNameStringRJ_2150]) {
    return BFElementModelNameNumberRJ_2150;
  }
  if ([str isEqualToString:BFElementModelNameStringRJ_3050Ai]) {
    return BFElementModelNameNumberRJ_3050Ai;
  }
  if ([str isEqualToString:BFElementModelNameStringRJ_3150Ai]) {
    return BFElementModelNameNumberRJ_3150Ai;
  }
  if ([str isEqualToString:BFElementModelNameStringQL_800]) {
    return BFElementModelNameNumberQL_800;
  }
  if ([str isEqualToString:BFElementModelNameStringQL_810W]) {
    return BFElementModelNameNumberQL_810W;
  }
  if ([str isEqualToString:BFElementModelNameStringQL_820NWB]) {
    return BFElementModelNameNumberQL_820NWB;
  }
  if ([str isEqualToString:BFElementModelNameStringQL_1100]) {
    return BFElementModelNameNumberQL_1100;
  }
  if ([str isEqualToString:BFElementModelNameStringQL_1110NWB]) {
    return BFElementModelNameNumberQL_1110NWB;
  }
  if ([str isEqualToString:BFElementModelNameStringQL_1115NWB]) {
    return BFElementModelNameNumberQL_1115NWB;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_P710BT]) {
    return BFElementModelNameNumberPT_P710BT;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_E500]) {
    return BFElementModelNameNumberPT_E500;
  }
  if ([str isEqualToString:BFElementModelNameStringRJ_4230B]) {
    return BFElementModelNameNumberRJ_4230B;
  }
  if ([str isEqualToString:BFElementModelNameStringRJ_4250WB]) {
    return BFElementModelNameNumberRJ_4250WB;
  }
  if ([str isEqualToString:BFElementModelNameStringTD_4410D]) {
    return BFElementModelNameNumberTD_4410D;
  }
  if ([str isEqualToString:BFElementModelNameStringTD_4420DN]) {
    return BFElementModelNameNumberTD_4420DN;
  }
  if ([str isEqualToString:BFElementModelNameStringTD_4510D]) {
    return BFElementModelNameNumberTD_4510D;
  }
  if ([str isEqualToString:BFElementModelNameStringTD_4520DN]) {
    return BFElementModelNameNumberTD_4520DN;
  }
  if ([str isEqualToString:BFElementModelNameStringTD_4550DNWB]) {
    return BFElementModelNameNumberTD_4550DNWB;
  }
  if ([str isEqualToString:BFElementModelNameStringQL_600]) {
    return BFElementModelNameNumberQL_600;
  }
  if ([str isEqualToString:BFElementModelNameStringMW_170]) {
    return BFElementModelNameNumberMW_170;
  }
  if ([str isEqualToString:BFElementModelNameStringMW_270]) {
    return BFElementModelNameNumberMW_270;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_P910BT]) {
    return BFElementModelNameNumberPT_P910BT;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_D450]) {
    return BFElementModelNameNumberPT_D450;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_D600]) {
    return BFElementModelNameNumberPT_D600;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_P700]) {
    return BFElementModelNameNumberPT_P700;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_H500]) {
    return BFElementModelNameNumberPT_H500;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_P715eBT]) {
    return BFElementModelNameNumberPT_P715eBT;
  }
  if ([str isEqualToString:BFElementModelNameStringQL_500]) {
    return BFElementModelNameNumberQL_500;
  }
  if ([str isEqualToString:BFElementModelNameStringQL_550]) {
    return BFElementModelNameNumberQL_550;
  }
  if ([str isEqualToString:BFElementModelNameStringQL_560]) {
    return BFElementModelNameNumberQL_560;
  }
  if ([str isEqualToString:BFElementModelNameStringQL_570]) {
    return BFElementModelNameNumberQL_570;
  }
  if ([str isEqualToString:BFElementModelNameStringQL_650TD]) {
    return BFElementModelNameNumberQL_650TD;
  }
  if ([str isEqualToString:BFElementModelNameStringQL_1050]) {
    return BFElementModelNameNumberQL_1050;
  }
  if ([str isEqualToString:BFElementModelNameStringQL_1060N]) {
    return BFElementModelNameNumberQL_1060N;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_9700PC]) {
    return BFElementModelNameNumberPT_9700PC;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_9800PCN]) {
    return BFElementModelNameNumberPT_9800PCN;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_3600]) {
    return BFElementModelNameNumberPT_3600;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_9600]) {
    return BFElementModelNameNumberPT_9600;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_9500PC]) {
    return BFElementModelNameNumberPT_9500PC;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_18NR]) {
    return BFElementModelNameNumberPT_18NR;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_18R]) {
    return BFElementModelNameNumberPT_18R;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_24]) {
    return BFElementModelNameNumberPT_24;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_2700]) {
    return BFElementModelNameNumberPT_2700;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_2430PC]) {
    return BFElementModelNameNumberPT_2430PC;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_2730]) {
    return BFElementModelNameNumberPT_2730;
  }
  if ([str isEqualToString:BFElementModelNameStringRJ_3230B]) {
    return BFElementModelNameNumberRJ_3230B;
  }
  if ([str isEqualToString:BFElementModelNameStringRJ_3250WB]) {
    return BFElementModelNameNumberRJ_3250WB;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_D410]) {
    return BFElementModelNameNumberPT_D410;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_D460BT]) {
    return BFElementModelNameNumberPT_D460BT;
  }
  if ([str isEqualToString:BFElementModelNameStringPT_D610BT]) {
    return BFElementModelNameNumberPT_D610BT;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_822]) {
    return BFElementModelNameNumberPJ_822;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_823]) {
    return BFElementModelNameNumberPJ_823;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_862]) {
    return BFElementModelNameNumberPJ_862;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_863]) {
    return BFElementModelNameNumberPJ_863;
  }
  if ([str isEqualToString:BFElementModelNameStringPJ_883]) {
    return BFElementModelNameNumberPJ_883;
  }
  if ([str isEqualToString:BFElementModelNameString__Null]) {
    return BFElementModelNameNumber__Null;
  }
  return BFElementModelNameNumber__Null;
}
+ (nonnull NSString*)key {
  return @"ModelName";
}
@end

