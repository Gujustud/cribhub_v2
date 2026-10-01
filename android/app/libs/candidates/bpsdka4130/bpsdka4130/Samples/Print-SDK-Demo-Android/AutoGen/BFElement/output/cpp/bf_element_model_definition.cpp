
#include "bf_element_model_definition.hpp"
#include <string>
#include <cstring>

namespace bf {
  namespace element {
    const char* ModelInterface::convertToString(Number num) {
      switch(num) {
        case Number::USB: return String::USB;
        case Number::Network: return String::Network;
        case Number::Bluetooth: return String::Bluetooth;
        case Number::BluetoothLowEnergy: return String::BluetoothLowEnergy;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelInterface::Number ModelInterface::convertToNumber(const char* string) {
      if (!strcmp(string, String::USB)) {
        return Number::USB;
      }
      if (!strcmp(string, String::Network)) {
        return Number::Network;
      }
      if (!strcmp(string, String::Bluetooth)) {
        return Number::Bluetooth;
      }
      if (!strcmp(string, String::BluetoothLowEnergy)) {
        return Number::BluetoothLowEnergy;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* ModelMajor::convertToString(Number num) {
      switch(num) {
        case Number::QL: return String::QL;
        case Number::PT: return String::PT;
        case Number::PJ: return String::PJ;
        case Number::SC: return String::SC;
        case Number::RJ: return String::RJ;
        case Number::TD: return String::TD;
        case Number::TP: return String::TP;
        case Number::MW: return String::MW;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelMajor::Number ModelMajor::convertToNumber(const char* string) {
      if (!strcmp(string, String::QL)) {
        return Number::QL;
      }
      if (!strcmp(string, String::PT)) {
        return Number::PT;
      }
      if (!strcmp(string, String::PJ)) {
        return Number::PJ;
      }
      if (!strcmp(string, String::SC)) {
        return Number::SC;
      }
      if (!strcmp(string, String::RJ)) {
        return Number::RJ;
      }
      if (!strcmp(string, String::TD)) {
        return Number::TD;
      }
      if (!strcmp(string, String::TP)) {
        return Number::TP;
      }
      if (!strcmp(string, String::MW)) {
        return Number::MW;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* ModelName::convertToString(Number num) {
      switch(num) {
        case Number::MW_140BT: return String::MW_140BT;
        case Number::MW_145BT: return String::MW_145BT;
        case Number::MW_260: return String::MW_260;
        case Number::PJ_522: return String::PJ_522;
        case Number::PJ_523: return String::PJ_523;
        case Number::PJ_520: return String::PJ_520;
        case Number::PJ_560: return String::PJ_560;
        case Number::PJ_562: return String::PJ_562;
        case Number::PJ_563: return String::PJ_563;
        case Number::PJ_622: return String::PJ_622;
        case Number::PJ_623: return String::PJ_623;
        case Number::PJ_662: return String::PJ_662;
        case Number::PJ_663: return String::PJ_663;
        case Number::RJ_4030: return String::RJ_4030;
        case Number::RJ_4040: return String::RJ_4040;
        case Number::RJ_3150: return String::RJ_3150;
        case Number::RJ_3050: return String::RJ_3050;
        case Number::QL_580N: return String::QL_580N;
        case Number::QL_700: return String::QL_700;
        case Number::QL_710W: return String::QL_710W;
        case Number::QL_720NW: return String::QL_720NW;
        case Number::TD_2020: return String::TD_2020;
        case Number::TD_2120N: return String::TD_2120N;
        case Number::TD_2130N: return String::TD_2130N;
        case Number::PT_E550W: return String::PT_E550W;
        case Number::PT_P750W: return String::PT_P750W;
        case Number::TD_4100N: return String::TD_4100N;
        case Number::TD_4000: return String::TD_4000;
        case Number::PJ_762: return String::PJ_762;
        case Number::PJ_763: return String::PJ_763;
        case Number::PJ_773: return String::PJ_773;
        case Number::PJ_722: return String::PJ_722;
        case Number::PJ_723: return String::PJ_723;
        case Number::PJ_763MFi: return String::PJ_763MFi;
        case Number::PJ_673: return String::PJ_673;
        case Number::MW_145MFi: return String::MW_145MFi;
        case Number::MW_260MFi: return String::MW_260MFi;
        case Number::PT_P300BT: return String::PT_P300BT;
        case Number::PT_E850TKW: return String::PT_E850TKW;
        case Number::PT_D800W: return String::PT_D800W;
        case Number::PT_P900W: return String::PT_P900W;
        case Number::PT_P950NW: return String::PT_P950NW;
        case Number::RJ_4030Ai: return String::RJ_4030Ai;
        case Number::PT_E800W: return String::PT_E800W;
        case Number::RJ_2030: return String::RJ_2030;
        case Number::RJ_2050: return String::RJ_2050;
        case Number::RJ_2140: return String::RJ_2140;
        case Number::RJ_2150: return String::RJ_2150;
        case Number::RJ_3050Ai: return String::RJ_3050Ai;
        case Number::RJ_3150Ai: return String::RJ_3150Ai;
        case Number::QL_800: return String::QL_800;
        case Number::QL_810W: return String::QL_810W;
        case Number::QL_820NWB: return String::QL_820NWB;
        case Number::QL_1100: return String::QL_1100;
        case Number::QL_1110NWB: return String::QL_1110NWB;
        case Number::QL_1115NWB: return String::QL_1115NWB;
        case Number::PT_P710BT: return String::PT_P710BT;
        case Number::PT_E500: return String::PT_E500;
        case Number::RJ_4230B: return String::RJ_4230B;
        case Number::RJ_4250WB: return String::RJ_4250WB;
        case Number::TD_4410D: return String::TD_4410D;
        case Number::TD_4420DN: return String::TD_4420DN;
        case Number::TD_4510D: return String::TD_4510D;
        case Number::TD_4520DN: return String::TD_4520DN;
        case Number::TD_4550DNWB: return String::TD_4550DNWB;
        case Number::QL_600: return String::QL_600;
        case Number::MW_170: return String::MW_170;
        case Number::MW_270: return String::MW_270;
        case Number::PT_P910BT: return String::PT_P910BT;
        case Number::PT_D450: return String::PT_D450;
        case Number::PT_D600: return String::PT_D600;
        case Number::PT_P700: return String::PT_P700;
        case Number::PT_H500: return String::PT_H500;
        case Number::PT_P715eBT: return String::PT_P715eBT;
        case Number::QL_500: return String::QL_500;
        case Number::QL_550: return String::QL_550;
        case Number::QL_560: return String::QL_560;
        case Number::QL_570: return String::QL_570;
        case Number::QL_650TD: return String::QL_650TD;
        case Number::QL_1050: return String::QL_1050;
        case Number::QL_1060N: return String::QL_1060N;
        case Number::PT_9700PC: return String::PT_9700PC;
        case Number::PT_9800PCN: return String::PT_9800PCN;
        case Number::PT_3600: return String::PT_3600;
        case Number::PT_9600: return String::PT_9600;
        case Number::PT_9500PC: return String::PT_9500PC;
        case Number::PT_18NR: return String::PT_18NR;
        case Number::PT_18R: return String::PT_18R;
        case Number::PT_24: return String::PT_24;
        case Number::PT_2700: return String::PT_2700;
        case Number::PT_2430PC: return String::PT_2430PC;
        case Number::PT_2730: return String::PT_2730;
        case Number::RJ_3230B: return String::RJ_3230B;
        case Number::RJ_3250WB: return String::RJ_3250WB;
        case Number::PT_D410: return String::PT_D410;
        case Number::PT_D460BT: return String::PT_D460BT;
        case Number::PT_D610BT: return String::PT_D610BT;
        case Number::PJ_822: return String::PJ_822;
        case Number::PJ_823: return String::PJ_823;
        case Number::PJ_862: return String::PJ_862;
        case Number::PJ_863: return String::PJ_863;
        case Number::PJ_883: return String::PJ_883;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelName::Number ModelName::convertToNumber(const char* string) {
      if (!strcmp(string, String::MW_140BT)) {
        return Number::MW_140BT;
      }
      if (!strcmp(string, String::MW_145BT)) {
        return Number::MW_145BT;
      }
      if (!strcmp(string, String::MW_260)) {
        return Number::MW_260;
      }
      if (!strcmp(string, String::PJ_522)) {
        return Number::PJ_522;
      }
      if (!strcmp(string, String::PJ_523)) {
        return Number::PJ_523;
      }
      if (!strcmp(string, String::PJ_520)) {
        return Number::PJ_520;
      }
      if (!strcmp(string, String::PJ_560)) {
        return Number::PJ_560;
      }
      if (!strcmp(string, String::PJ_562)) {
        return Number::PJ_562;
      }
      if (!strcmp(string, String::PJ_563)) {
        return Number::PJ_563;
      }
      if (!strcmp(string, String::PJ_622)) {
        return Number::PJ_622;
      }
      if (!strcmp(string, String::PJ_623)) {
        return Number::PJ_623;
      }
      if (!strcmp(string, String::PJ_662)) {
        return Number::PJ_662;
      }
      if (!strcmp(string, String::PJ_663)) {
        return Number::PJ_663;
      }
      if (!strcmp(string, String::RJ_4030)) {
        return Number::RJ_4030;
      }
      if (!strcmp(string, String::RJ_4040)) {
        return Number::RJ_4040;
      }
      if (!strcmp(string, String::RJ_3150)) {
        return Number::RJ_3150;
      }
      if (!strcmp(string, String::RJ_3050)) {
        return Number::RJ_3050;
      }
      if (!strcmp(string, String::QL_580N)) {
        return Number::QL_580N;
      }
      if (!strcmp(string, String::QL_700)) {
        return Number::QL_700;
      }
      if (!strcmp(string, String::QL_710W)) {
        return Number::QL_710W;
      }
      if (!strcmp(string, String::QL_720NW)) {
        return Number::QL_720NW;
      }
      if (!strcmp(string, String::TD_2020)) {
        return Number::TD_2020;
      }
      if (!strcmp(string, String::TD_2120N)) {
        return Number::TD_2120N;
      }
      if (!strcmp(string, String::TD_2130N)) {
        return Number::TD_2130N;
      }
      if (!strcmp(string, String::PT_E550W)) {
        return Number::PT_E550W;
      }
      if (!strcmp(string, String::PT_P750W)) {
        return Number::PT_P750W;
      }
      if (!strcmp(string, String::TD_4100N)) {
        return Number::TD_4100N;
      }
      if (!strcmp(string, String::TD_4000)) {
        return Number::TD_4000;
      }
      if (!strcmp(string, String::PJ_762)) {
        return Number::PJ_762;
      }
      if (!strcmp(string, String::PJ_763)) {
        return Number::PJ_763;
      }
      if (!strcmp(string, String::PJ_773)) {
        return Number::PJ_773;
      }
      if (!strcmp(string, String::PJ_722)) {
        return Number::PJ_722;
      }
      if (!strcmp(string, String::PJ_723)) {
        return Number::PJ_723;
      }
      if (!strcmp(string, String::PJ_763MFi)) {
        return Number::PJ_763MFi;
      }
      if (!strcmp(string, String::PJ_673)) {
        return Number::PJ_673;
      }
      if (!strcmp(string, String::MW_145MFi)) {
        return Number::MW_145MFi;
      }
      if (!strcmp(string, String::MW_260MFi)) {
        return Number::MW_260MFi;
      }
      if (!strcmp(string, String::PT_P300BT)) {
        return Number::PT_P300BT;
      }
      if (!strcmp(string, String::PT_E850TKW)) {
        return Number::PT_E850TKW;
      }
      if (!strcmp(string, String::PT_D800W)) {
        return Number::PT_D800W;
      }
      if (!strcmp(string, String::PT_P900W)) {
        return Number::PT_P900W;
      }
      if (!strcmp(string, String::PT_P950NW)) {
        return Number::PT_P950NW;
      }
      if (!strcmp(string, String::RJ_4030Ai)) {
        return Number::RJ_4030Ai;
      }
      if (!strcmp(string, String::PT_E800W)) {
        return Number::PT_E800W;
      }
      if (!strcmp(string, String::RJ_2030)) {
        return Number::RJ_2030;
      }
      if (!strcmp(string, String::RJ_2050)) {
        return Number::RJ_2050;
      }
      if (!strcmp(string, String::RJ_2140)) {
        return Number::RJ_2140;
      }
      if (!strcmp(string, String::RJ_2150)) {
        return Number::RJ_2150;
      }
      if (!strcmp(string, String::RJ_3050Ai)) {
        return Number::RJ_3050Ai;
      }
      if (!strcmp(string, String::RJ_3150Ai)) {
        return Number::RJ_3150Ai;
      }
      if (!strcmp(string, String::QL_800)) {
        return Number::QL_800;
      }
      if (!strcmp(string, String::QL_810W)) {
        return Number::QL_810W;
      }
      if (!strcmp(string, String::QL_820NWB)) {
        return Number::QL_820NWB;
      }
      if (!strcmp(string, String::QL_1100)) {
        return Number::QL_1100;
      }
      if (!strcmp(string, String::QL_1110NWB)) {
        return Number::QL_1110NWB;
      }
      if (!strcmp(string, String::QL_1115NWB)) {
        return Number::QL_1115NWB;
      }
      if (!strcmp(string, String::PT_P710BT)) {
        return Number::PT_P710BT;
      }
      if (!strcmp(string, String::PT_E500)) {
        return Number::PT_E500;
      }
      if (!strcmp(string, String::RJ_4230B)) {
        return Number::RJ_4230B;
      }
      if (!strcmp(string, String::RJ_4250WB)) {
        return Number::RJ_4250WB;
      }
      if (!strcmp(string, String::TD_4410D)) {
        return Number::TD_4410D;
      }
      if (!strcmp(string, String::TD_4420DN)) {
        return Number::TD_4420DN;
      }
      if (!strcmp(string, String::TD_4510D)) {
        return Number::TD_4510D;
      }
      if (!strcmp(string, String::TD_4520DN)) {
        return Number::TD_4520DN;
      }
      if (!strcmp(string, String::TD_4550DNWB)) {
        return Number::TD_4550DNWB;
      }
      if (!strcmp(string, String::QL_600)) {
        return Number::QL_600;
      }
      if (!strcmp(string, String::MW_170)) {
        return Number::MW_170;
      }
      if (!strcmp(string, String::MW_270)) {
        return Number::MW_270;
      }
      if (!strcmp(string, String::PT_P910BT)) {
        return Number::PT_P910BT;
      }
      if (!strcmp(string, String::PT_D450)) {
        return Number::PT_D450;
      }
      if (!strcmp(string, String::PT_D600)) {
        return Number::PT_D600;
      }
      if (!strcmp(string, String::PT_P700)) {
        return Number::PT_P700;
      }
      if (!strcmp(string, String::PT_H500)) {
        return Number::PT_H500;
      }
      if (!strcmp(string, String::PT_P715eBT)) {
        return Number::PT_P715eBT;
      }
      if (!strcmp(string, String::QL_500)) {
        return Number::QL_500;
      }
      if (!strcmp(string, String::QL_550)) {
        return Number::QL_550;
      }
      if (!strcmp(string, String::QL_560)) {
        return Number::QL_560;
      }
      if (!strcmp(string, String::QL_570)) {
        return Number::QL_570;
      }
      if (!strcmp(string, String::QL_650TD)) {
        return Number::QL_650TD;
      }
      if (!strcmp(string, String::QL_1050)) {
        return Number::QL_1050;
      }
      if (!strcmp(string, String::QL_1060N)) {
        return Number::QL_1060N;
      }
      if (!strcmp(string, String::PT_9700PC)) {
        return Number::PT_9700PC;
      }
      if (!strcmp(string, String::PT_9800PCN)) {
        return Number::PT_9800PCN;
      }
      if (!strcmp(string, String::PT_3600)) {
        return Number::PT_3600;
      }
      if (!strcmp(string, String::PT_9600)) {
        return Number::PT_9600;
      }
      if (!strcmp(string, String::PT_9500PC)) {
        return Number::PT_9500PC;
      }
      if (!strcmp(string, String::PT_18NR)) {
        return Number::PT_18NR;
      }
      if (!strcmp(string, String::PT_18R)) {
        return Number::PT_18R;
      }
      if (!strcmp(string, String::PT_24)) {
        return Number::PT_24;
      }
      if (!strcmp(string, String::PT_2700)) {
        return Number::PT_2700;
      }
      if (!strcmp(string, String::PT_2430PC)) {
        return Number::PT_2430PC;
      }
      if (!strcmp(string, String::PT_2730)) {
        return Number::PT_2730;
      }
      if (!strcmp(string, String::RJ_3230B)) {
        return Number::RJ_3230B;
      }
      if (!strcmp(string, String::RJ_3250WB)) {
        return Number::RJ_3250WB;
      }
      if (!strcmp(string, String::PT_D410)) {
        return Number::PT_D410;
      }
      if (!strcmp(string, String::PT_D460BT)) {
        return Number::PT_D460BT;
      }
      if (!strcmp(string, String::PT_D610BT)) {
        return Number::PT_D610BT;
      }
      if (!strcmp(string, String::PJ_822)) {
        return Number::PJ_822;
      }
      if (!strcmp(string, String::PJ_823)) {
        return Number::PJ_823;
      }
      if (!strcmp(string, String::PJ_862)) {
        return Number::PJ_862;
      }
      if (!strcmp(string, String::PJ_863)) {
        return Number::PJ_863;
      }
      if (!strcmp(string, String::PJ_883)) {
        return Number::PJ_883;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

  }
}