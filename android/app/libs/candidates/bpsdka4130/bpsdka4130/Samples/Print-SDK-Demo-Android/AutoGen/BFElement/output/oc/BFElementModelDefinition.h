

#pragma once
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BFElementModelInterfaceNumber) {
  BFElementModelInterfaceNumberUSB,
  BFElementModelInterfaceNumberNetwork,
  BFElementModelInterfaceNumberBluetooth,
  BFElementModelInterfaceNumberBluetoothLowEnergy,
  BFElementModelInterfaceNumber__Null,
};
extern NSString * __nonnull const BFElementModelInterfaceStringUSB;
extern NSString * __nonnull const BFElementModelInterfaceStringNetwork;
extern NSString * __nonnull const BFElementModelInterfaceStringBluetooth;
extern NSString * __nonnull const BFElementModelInterfaceStringBluetoothLowEnergy;
extern NSString * __nonnull const BFElementModelInterfaceString__Null;
@interface BFElementModelInterface : NSObject
+ (nonnull NSString*)convertToString:(BFElementModelInterfaceNumber)num;
+ (BFElementModelInterfaceNumber)convertToNumber:(nonnull NSString*)str;
+ (nonnull NSString*)key;
@end

typedef NS_ENUM(NSUInteger, BFElementModelMajorNumber) {
  BFElementModelMajorNumberQL,
  BFElementModelMajorNumberPT,
  BFElementModelMajorNumberPJ,
  BFElementModelMajorNumberSC,
  BFElementModelMajorNumberRJ,
  BFElementModelMajorNumberTD,
  BFElementModelMajorNumberTP,
  BFElementModelMajorNumberMW,
  BFElementModelMajorNumber__Null,
};
extern NSString * __nonnull const BFElementModelMajorStringQL;
extern NSString * __nonnull const BFElementModelMajorStringPT;
extern NSString * __nonnull const BFElementModelMajorStringPJ;
extern NSString * __nonnull const BFElementModelMajorStringSC;
extern NSString * __nonnull const BFElementModelMajorStringRJ;
extern NSString * __nonnull const BFElementModelMajorStringTD;
extern NSString * __nonnull const BFElementModelMajorStringTP;
extern NSString * __nonnull const BFElementModelMajorStringMW;
extern NSString * __nonnull const BFElementModelMajorString__Null;
@interface BFElementModelMajor : NSObject
+ (nonnull NSString*)convertToString:(BFElementModelMajorNumber)num;
+ (BFElementModelMajorNumber)convertToNumber:(nonnull NSString*)str;
+ (nonnull NSString*)key;
@end

typedef NS_ENUM(NSUInteger, BFElementModelNameNumber) {
  BFElementModelNameNumberMW_140BT,
  BFElementModelNameNumberMW_145BT,
  BFElementModelNameNumberMW_260,
  BFElementModelNameNumberPJ_522,
  BFElementModelNameNumberPJ_523,
  BFElementModelNameNumberPJ_520,
  BFElementModelNameNumberPJ_560,
  BFElementModelNameNumberPJ_562,
  BFElementModelNameNumberPJ_563,
  BFElementModelNameNumberPJ_622,
  BFElementModelNameNumberPJ_623,
  BFElementModelNameNumberPJ_662,
  BFElementModelNameNumberPJ_663,
  BFElementModelNameNumberRJ_4030,
  BFElementModelNameNumberRJ_4040,
  BFElementModelNameNumberRJ_3150,
  BFElementModelNameNumberRJ_3050,
  BFElementModelNameNumberQL_580N,
  BFElementModelNameNumberQL_700,
  BFElementModelNameNumberQL_710W,
  BFElementModelNameNumberQL_720NW,
  BFElementModelNameNumberTD_2020,
  BFElementModelNameNumberTD_2120N,
  BFElementModelNameNumberTD_2130N,
  BFElementModelNameNumberPT_E550W,
  BFElementModelNameNumberPT_P750W,
  BFElementModelNameNumberTD_4100N,
  BFElementModelNameNumberTD_4000,
  BFElementModelNameNumberPJ_762,
  BFElementModelNameNumberPJ_763,
  BFElementModelNameNumberPJ_773,
  BFElementModelNameNumberPJ_722,
  BFElementModelNameNumberPJ_723,
  BFElementModelNameNumberPJ_763MFi,
  BFElementModelNameNumberPJ_673,
  BFElementModelNameNumberMW_145MFi,
  BFElementModelNameNumberMW_260MFi,
  BFElementModelNameNumberPT_P300BT,
  BFElementModelNameNumberPT_E850TKW,
  BFElementModelNameNumberPT_D800W,
  BFElementModelNameNumberPT_P900W,
  BFElementModelNameNumberPT_P950NW,
  BFElementModelNameNumberRJ_4030Ai,
  BFElementModelNameNumberPT_E800W,
  BFElementModelNameNumberRJ_2030,
  BFElementModelNameNumberRJ_2050,
  BFElementModelNameNumberRJ_2140,
  BFElementModelNameNumberRJ_2150,
  BFElementModelNameNumberRJ_3050Ai,
  BFElementModelNameNumberRJ_3150Ai,
  BFElementModelNameNumberQL_800,
  BFElementModelNameNumberQL_810W,
  BFElementModelNameNumberQL_820NWB,
  BFElementModelNameNumberQL_1100,
  BFElementModelNameNumberQL_1110NWB,
  BFElementModelNameNumberQL_1115NWB,
  BFElementModelNameNumberPT_P710BT,
  BFElementModelNameNumberPT_E500,
  BFElementModelNameNumberRJ_4230B,
  BFElementModelNameNumberRJ_4250WB,
  BFElementModelNameNumberTD_4410D,
  BFElementModelNameNumberTD_4420DN,
  BFElementModelNameNumberTD_4510D,
  BFElementModelNameNumberTD_4520DN,
  BFElementModelNameNumberTD_4550DNWB,
  BFElementModelNameNumberQL_600,
  BFElementModelNameNumberMW_170,
  BFElementModelNameNumberMW_270,
  BFElementModelNameNumberPT_P910BT,
  BFElementModelNameNumberPT_D450,
  BFElementModelNameNumberPT_D600,
  BFElementModelNameNumberPT_P700,
  BFElementModelNameNumberPT_H500,
  BFElementModelNameNumberPT_P715eBT,
  BFElementModelNameNumberQL_500,
  BFElementModelNameNumberQL_550,
  BFElementModelNameNumberQL_560,
  BFElementModelNameNumberQL_570,
  BFElementModelNameNumberQL_650TD,
  BFElementModelNameNumberQL_1050,
  BFElementModelNameNumberQL_1060N,
  BFElementModelNameNumberPT_9700PC,
  BFElementModelNameNumberPT_9800PCN,
  BFElementModelNameNumberPT_3600,
  BFElementModelNameNumberPT_9600,
  BFElementModelNameNumberPT_9500PC,
  BFElementModelNameNumberPT_18NR,
  BFElementModelNameNumberPT_18R,
  BFElementModelNameNumberPT_24,
  BFElementModelNameNumberPT_2700,
  BFElementModelNameNumberPT_2430PC,
  BFElementModelNameNumberPT_2730,
  BFElementModelNameNumberRJ_3230B,
  BFElementModelNameNumberRJ_3250WB,
  BFElementModelNameNumberPT_D410,
  BFElementModelNameNumberPT_D460BT,
  BFElementModelNameNumberPT_D610BT,
  BFElementModelNameNumberPJ_822,
  BFElementModelNameNumberPJ_823,
  BFElementModelNameNumberPJ_862,
  BFElementModelNameNumberPJ_863,
  BFElementModelNameNumberPJ_883,
  BFElementModelNameNumber__Null,
};
extern NSString * __nonnull const BFElementModelNameStringMW_140BT;
extern NSString * __nonnull const BFElementModelNameStringMW_145BT;
extern NSString * __nonnull const BFElementModelNameStringMW_260;
extern NSString * __nonnull const BFElementModelNameStringPJ_522;
extern NSString * __nonnull const BFElementModelNameStringPJ_523;
extern NSString * __nonnull const BFElementModelNameStringPJ_520;
extern NSString * __nonnull const BFElementModelNameStringPJ_560;
extern NSString * __nonnull const BFElementModelNameStringPJ_562;
extern NSString * __nonnull const BFElementModelNameStringPJ_563;
extern NSString * __nonnull const BFElementModelNameStringPJ_622;
extern NSString * __nonnull const BFElementModelNameStringPJ_623;
extern NSString * __nonnull const BFElementModelNameStringPJ_662;
extern NSString * __nonnull const BFElementModelNameStringPJ_663;
extern NSString * __nonnull const BFElementModelNameStringRJ_4030;
extern NSString * __nonnull const BFElementModelNameStringRJ_4040;
extern NSString * __nonnull const BFElementModelNameStringRJ_3150;
extern NSString * __nonnull const BFElementModelNameStringRJ_3050;
extern NSString * __nonnull const BFElementModelNameStringQL_580N;
extern NSString * __nonnull const BFElementModelNameStringQL_700;
extern NSString * __nonnull const BFElementModelNameStringQL_710W;
extern NSString * __nonnull const BFElementModelNameStringQL_720NW;
extern NSString * __nonnull const BFElementModelNameStringTD_2020;
extern NSString * __nonnull const BFElementModelNameStringTD_2120N;
extern NSString * __nonnull const BFElementModelNameStringTD_2130N;
extern NSString * __nonnull const BFElementModelNameStringPT_E550W;
extern NSString * __nonnull const BFElementModelNameStringPT_P750W;
extern NSString * __nonnull const BFElementModelNameStringTD_4100N;
extern NSString * __nonnull const BFElementModelNameStringTD_4000;
extern NSString * __nonnull const BFElementModelNameStringPJ_762;
extern NSString * __nonnull const BFElementModelNameStringPJ_763;
extern NSString * __nonnull const BFElementModelNameStringPJ_773;
extern NSString * __nonnull const BFElementModelNameStringPJ_722;
extern NSString * __nonnull const BFElementModelNameStringPJ_723;
extern NSString * __nonnull const BFElementModelNameStringPJ_763MFi;
extern NSString * __nonnull const BFElementModelNameStringPJ_673;
extern NSString * __nonnull const BFElementModelNameStringMW_145MFi;
extern NSString * __nonnull const BFElementModelNameStringMW_260MFi;
extern NSString * __nonnull const BFElementModelNameStringPT_P300BT;
extern NSString * __nonnull const BFElementModelNameStringPT_E850TKW;
extern NSString * __nonnull const BFElementModelNameStringPT_D800W;
extern NSString * __nonnull const BFElementModelNameStringPT_P900W;
extern NSString * __nonnull const BFElementModelNameStringPT_P950NW;
extern NSString * __nonnull const BFElementModelNameStringRJ_4030Ai;
extern NSString * __nonnull const BFElementModelNameStringPT_E800W;
extern NSString * __nonnull const BFElementModelNameStringRJ_2030;
extern NSString * __nonnull const BFElementModelNameStringRJ_2050;
extern NSString * __nonnull const BFElementModelNameStringRJ_2140;
extern NSString * __nonnull const BFElementModelNameStringRJ_2150;
extern NSString * __nonnull const BFElementModelNameStringRJ_3050Ai;
extern NSString * __nonnull const BFElementModelNameStringRJ_3150Ai;
extern NSString * __nonnull const BFElementModelNameStringQL_800;
extern NSString * __nonnull const BFElementModelNameStringQL_810W;
extern NSString * __nonnull const BFElementModelNameStringQL_820NWB;
extern NSString * __nonnull const BFElementModelNameStringQL_1100;
extern NSString * __nonnull const BFElementModelNameStringQL_1110NWB;
extern NSString * __nonnull const BFElementModelNameStringQL_1115NWB;
extern NSString * __nonnull const BFElementModelNameStringPT_P710BT;
extern NSString * __nonnull const BFElementModelNameStringPT_E500;
extern NSString * __nonnull const BFElementModelNameStringRJ_4230B;
extern NSString * __nonnull const BFElementModelNameStringRJ_4250WB;
extern NSString * __nonnull const BFElementModelNameStringTD_4410D;
extern NSString * __nonnull const BFElementModelNameStringTD_4420DN;
extern NSString * __nonnull const BFElementModelNameStringTD_4510D;
extern NSString * __nonnull const BFElementModelNameStringTD_4520DN;
extern NSString * __nonnull const BFElementModelNameStringTD_4550DNWB;
extern NSString * __nonnull const BFElementModelNameStringQL_600;
extern NSString * __nonnull const BFElementModelNameStringMW_170;
extern NSString * __nonnull const BFElementModelNameStringMW_270;
extern NSString * __nonnull const BFElementModelNameStringPT_P910BT;
extern NSString * __nonnull const BFElementModelNameStringPT_D450;
extern NSString * __nonnull const BFElementModelNameStringPT_D600;
extern NSString * __nonnull const BFElementModelNameStringPT_P700;
extern NSString * __nonnull const BFElementModelNameStringPT_H500;
extern NSString * __nonnull const BFElementModelNameStringPT_P715eBT;
extern NSString * __nonnull const BFElementModelNameStringQL_500;
extern NSString * __nonnull const BFElementModelNameStringQL_550;
extern NSString * __nonnull const BFElementModelNameStringQL_560;
extern NSString * __nonnull const BFElementModelNameStringQL_570;
extern NSString * __nonnull const BFElementModelNameStringQL_650TD;
extern NSString * __nonnull const BFElementModelNameStringQL_1050;
extern NSString * __nonnull const BFElementModelNameStringQL_1060N;
extern NSString * __nonnull const BFElementModelNameStringPT_9700PC;
extern NSString * __nonnull const BFElementModelNameStringPT_9800PCN;
extern NSString * __nonnull const BFElementModelNameStringPT_3600;
extern NSString * __nonnull const BFElementModelNameStringPT_9600;
extern NSString * __nonnull const BFElementModelNameStringPT_9500PC;
extern NSString * __nonnull const BFElementModelNameStringPT_18NR;
extern NSString * __nonnull const BFElementModelNameStringPT_18R;
extern NSString * __nonnull const BFElementModelNameStringPT_24;
extern NSString * __nonnull const BFElementModelNameStringPT_2700;
extern NSString * __nonnull const BFElementModelNameStringPT_2430PC;
extern NSString * __nonnull const BFElementModelNameStringPT_2730;
extern NSString * __nonnull const BFElementModelNameStringRJ_3230B;
extern NSString * __nonnull const BFElementModelNameStringRJ_3250WB;
extern NSString * __nonnull const BFElementModelNameStringPT_D410;
extern NSString * __nonnull const BFElementModelNameStringPT_D460BT;
extern NSString * __nonnull const BFElementModelNameStringPT_D610BT;
extern NSString * __nonnull const BFElementModelNameStringPJ_822;
extern NSString * __nonnull const BFElementModelNameStringPJ_823;
extern NSString * __nonnull const BFElementModelNameStringPJ_862;
extern NSString * __nonnull const BFElementModelNameStringPJ_863;
extern NSString * __nonnull const BFElementModelNameStringPJ_883;
extern NSString * __nonnull const BFElementModelNameString__Null;
@interface BFElementModelName : NSObject
+ (nonnull NSString*)convertToString:(BFElementModelNameNumber)num;
+ (BFElementModelNameNumber)convertToNumber:(nonnull NSString*)str;
+ (nonnull NSString*)key;
@end

