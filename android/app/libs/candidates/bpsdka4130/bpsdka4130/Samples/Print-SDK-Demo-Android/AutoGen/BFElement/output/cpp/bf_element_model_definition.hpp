
#pragma once
#include <string>

namespace bf {
  namespace element {
    struct ModelInterface {
      enum class Number {
        USB,
        Network,
        Bluetooth,
        BluetoothLowEnergy,
        __Null,
      };
      struct String {
        constexpr static const char * USB = "USB";
        constexpr static const char * Network = "Network";
        constexpr static const char * Bluetooth = "Bluetooth";
        constexpr static const char * BluetoothLowEnergy = "BluetoothLowEnergy";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelInterface";
    };

    struct ModelMajor {
      enum class Number {
        QL,
        PT,
        PJ,
        SC,
        RJ,
        TD,
        TP,
        MW,
        __Null,
      };
      struct String {
        constexpr static const char * QL = "QL";
        constexpr static const char * PT = "PT";
        constexpr static const char * PJ = "PJ";
        constexpr static const char * SC = "SC";
        constexpr static const char * RJ = "RJ";
        constexpr static const char * TD = "TD";
        constexpr static const char * TP = "TP";
        constexpr static const char * MW = "MW";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelMajor";
    };

    struct ModelName {
      enum class Number {
        MW_140BT,
        MW_145BT,
        MW_260,
        PJ_522,
        PJ_523,
        PJ_520,
        PJ_560,
        PJ_562,
        PJ_563,
        PJ_622,
        PJ_623,
        PJ_662,
        PJ_663,
        RJ_4030,
        RJ_4040,
        RJ_3150,
        RJ_3050,
        QL_580N,
        QL_700,
        QL_710W,
        QL_720NW,
        TD_2020,
        TD_2120N,
        TD_2130N,
        PT_E550W,
        PT_P750W,
        TD_4100N,
        TD_4000,
        PJ_762,
        PJ_763,
        PJ_773,
        PJ_722,
        PJ_723,
        PJ_763MFi,
        PJ_673,
        MW_145MFi,
        MW_260MFi,
        PT_P300BT,
        PT_E850TKW,
        PT_D800W,
        PT_P900W,
        PT_P950NW,
        RJ_4030Ai,
        PT_E800W,
        RJ_2030,
        RJ_2050,
        RJ_2140,
        RJ_2150,
        RJ_3050Ai,
        RJ_3150Ai,
        QL_800,
        QL_810W,
        QL_820NWB,
        QL_1100,
        QL_1110NWB,
        QL_1115NWB,
        PT_P710BT,
        PT_E500,
        RJ_4230B,
        RJ_4250WB,
        TD_4410D,
        TD_4420DN,
        TD_4510D,
        TD_4520DN,
        TD_4550DNWB,
        QL_600,
        MW_170,
        MW_270,
        PT_P910BT,
        PT_D450,
        PT_D600,
        PT_P700,
        PT_H500,
        PT_P715eBT,
        QL_500,
        QL_550,
        QL_560,
        QL_570,
        QL_650TD,
        QL_1050,
        QL_1060N,
        PT_9700PC,
        PT_9800PCN,
        PT_3600,
        PT_9600,
        PT_9500PC,
        PT_18NR,
        PT_18R,
        PT_24,
        PT_2700,
        PT_2430PC,
        PT_2730,
        RJ_3230B,
        RJ_3250WB,
        PT_D410,
        PT_D460BT,
        PT_D610BT,
        PJ_822,
        PJ_823,
        PJ_862,
        PJ_863,
        PJ_883,
        __Null,
      };
      struct String {
        constexpr static const char * MW_140BT = "MW-140BT";
        constexpr static const char * MW_145BT = "MW-145BT";
        constexpr static const char * MW_260 = "MW-260";
        constexpr static const char * PJ_522 = "PJ-522";
        constexpr static const char * PJ_523 = "PJ-523";
        constexpr static const char * PJ_520 = "PJ-520";
        constexpr static const char * PJ_560 = "PJ-560";
        constexpr static const char * PJ_562 = "PJ-562";
        constexpr static const char * PJ_563 = "PJ-563";
        constexpr static const char * PJ_622 = "PJ-622";
        constexpr static const char * PJ_623 = "PJ-623";
        constexpr static const char * PJ_662 = "PJ-662";
        constexpr static const char * PJ_663 = "PJ-663";
        constexpr static const char * RJ_4030 = "RJ-4030";
        constexpr static const char * RJ_4040 = "RJ-4040";
        constexpr static const char * RJ_3150 = "RJ-3150";
        constexpr static const char * RJ_3050 = "RJ-3050";
        constexpr static const char * QL_580N = "QL-580N";
        constexpr static const char * QL_700 = "QL-700";
        constexpr static const char * QL_710W = "QL-710W";
        constexpr static const char * QL_720NW = "QL-720NW";
        constexpr static const char * TD_2020 = "TD-2020";
        constexpr static const char * TD_2120N = "TD-2120N";
        constexpr static const char * TD_2130N = "TD-2130N";
        constexpr static const char * PT_E550W = "PT-E550W";
        constexpr static const char * PT_P750W = "PT-P750W";
        constexpr static const char * TD_4100N = "TD-4100N";
        constexpr static const char * TD_4000 = "TD-4000";
        constexpr static const char * PJ_762 = "PJ-762";
        constexpr static const char * PJ_763 = "PJ-763";
        constexpr static const char * PJ_773 = "PJ-773";
        constexpr static const char * PJ_722 = "PJ-722";
        constexpr static const char * PJ_723 = "PJ-723";
        constexpr static const char * PJ_763MFi = "PJ-763MFi";
        constexpr static const char * PJ_673 = "PJ-673";
        constexpr static const char * MW_145MFi = "MW-145MFi";
        constexpr static const char * MW_260MFi = "MW-260MFi";
        constexpr static const char * PT_P300BT = "PT-P300BT";
        constexpr static const char * PT_E850TKW = "PT-E850TKW";
        constexpr static const char * PT_D800W = "PT-D800W";
        constexpr static const char * PT_P900W = "PT-P900W";
        constexpr static const char * PT_P950NW = "PT-P950NW";
        constexpr static const char * RJ_4030Ai = "RJ-4030Ai";
        constexpr static const char * PT_E800W = "PT-E800W";
        constexpr static const char * RJ_2030 = "RJ-2030";
        constexpr static const char * RJ_2050 = "RJ-2050";
        constexpr static const char * RJ_2140 = "RJ-2140";
        constexpr static const char * RJ_2150 = "RJ-2150";
        constexpr static const char * RJ_3050Ai = "RJ-3050Ai";
        constexpr static const char * RJ_3150Ai = "RJ-3150Ai";
        constexpr static const char * QL_800 = "QL-800";
        constexpr static const char * QL_810W = "QL-810W";
        constexpr static const char * QL_820NWB = "QL-820NWB";
        constexpr static const char * QL_1100 = "QL-1100";
        constexpr static const char * QL_1110NWB = "QL-1110NWB";
        constexpr static const char * QL_1115NWB = "QL-1115NWB";
        constexpr static const char * PT_P710BT = "PT-P710BT";
        constexpr static const char * PT_E500 = "PT-E500";
        constexpr static const char * RJ_4230B = "RJ-4230B";
        constexpr static const char * RJ_4250WB = "RJ-4250WB";
        constexpr static const char * TD_4410D = "TD-4410D";
        constexpr static const char * TD_4420DN = "TD-4420DN";
        constexpr static const char * TD_4510D = "TD-4510D";
        constexpr static const char * TD_4520DN = "TD-4520DN";
        constexpr static const char * TD_4550DNWB = "TD-4550DNWB";
        constexpr static const char * QL_600 = "QL-600";
        constexpr static const char * MW_170 = "MW-170";
        constexpr static const char * MW_270 = "MW-270";
        constexpr static const char * PT_P910BT = "PT-P910BT";
        constexpr static const char * PT_D450 = "PT-D450";
        constexpr static const char * PT_D600 = "PT-D600";
        constexpr static const char * PT_P700 = "PT-P700";
        constexpr static const char * PT_H500 = "PT-H500";
        constexpr static const char * PT_P715eBT = "PT-P715eBT";
        constexpr static const char * QL_500 = "QL-500";
        constexpr static const char * QL_550 = "QL-550";
        constexpr static const char * QL_560 = "QL-560";
        constexpr static const char * QL_570 = "QL-570";
        constexpr static const char * QL_650TD = "QL-650TD";
        constexpr static const char * QL_1050 = "QL-1050";
        constexpr static const char * QL_1060N = "QL-1060N";
        constexpr static const char * PT_9700PC = "PT-9700PC";
        constexpr static const char * PT_9800PCN = "PT-9800PCN";
        constexpr static const char * PT_3600 = "PT-3600";
        constexpr static const char * PT_9600 = "PT-9600";
        constexpr static const char * PT_9500PC = "PT-9500PC";
        constexpr static const char * PT_18NR = "PT-18NR";
        constexpr static const char * PT_18R = "PT-18R";
        constexpr static const char * PT_24 = "PT-24";
        constexpr static const char * PT_2700 = "PT-2700";
        constexpr static const char * PT_2430PC = "PT-2430PC";
        constexpr static const char * PT_2730 = "PT-2730";
        constexpr static const char * RJ_3230B = "RJ-3230B";
        constexpr static const char * RJ_3250WB = "RJ-3250WB";
        constexpr static const char * PT_D410 = "PT-D410";
        constexpr static const char * PT_D460BT = "PT-D460BT";
        constexpr static const char * PT_D610BT = "PT-D610BT";
        constexpr static const char * PJ_822 = "PJ-822";
        constexpr static const char * PJ_823 = "PJ-823";
        constexpr static const char * PJ_862 = "PJ-862";
        constexpr static const char * PJ_863 = "PJ-863";
        constexpr static const char * PJ_883 = "PJ-883";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelName";
    };

  }
}