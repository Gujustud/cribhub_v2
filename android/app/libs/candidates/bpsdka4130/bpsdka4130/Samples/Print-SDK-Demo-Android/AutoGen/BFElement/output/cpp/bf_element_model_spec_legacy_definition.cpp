
#include "bf_element_model_spec_legacy_definition.hpp"
#include <string>
#include <cstring>

namespace bf {
  namespace element {
    const char* ModelSpecLegacyBatteryCommandType::convertToString(Number num) {
      switch(num) {
        case Number::PS_BAT_NON: return String::PS_BAT_NON;
        case Number::PS_BAT_PJCOMMAND: return String::PS_BAT_PJCOMMAND;
        case Number::PS_BAT_MW145COMMAND: return String::PS_BAT_MW145COMMAND;
        case Number::PS_BAT_MW260COMMAND: return String::PS_BAT_MW260COMMAND;
        case Number::PS_BAT_FROMSTATUS: return String::PS_BAT_FROMSTATUS;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelSpecLegacyBatteryCommandType::Number ModelSpecLegacyBatteryCommandType::convertToNumber(const char* string) {
      if (!strcmp(string, String::PS_BAT_NON)) {
        return Number::PS_BAT_NON;
      }
      if (!strcmp(string, String::PS_BAT_PJCOMMAND)) {
        return Number::PS_BAT_PJCOMMAND;
      }
      if (!strcmp(string, String::PS_BAT_MW145COMMAND)) {
        return Number::PS_BAT_MW145COMMAND;
      }
      if (!strcmp(string, String::PS_BAT_MW260COMMAND)) {
        return Number::PS_BAT_MW260COMMAND;
      }
      if (!strcmp(string, String::PS_BAT_FROMSTATUS)) {
        return Number::PS_BAT_FROMSTATUS;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* ModelSpecLegacyGraphicCommandType::convertToString(Number num) {
      switch(num) {
        case Number::G_COMMAND_g: return String::G_COMMAND_g;
        case Number::G_COMMAND_G: return String::G_COMMAND_G;
        case Number::G_COMMAND_PJ: return String::G_COMMAND_PJ;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelSpecLegacyGraphicCommandType::Number ModelSpecLegacyGraphicCommandType::convertToNumber(const char* string) {
      if (!strcmp(string, String::G_COMMAND_g)) {
        return Number::G_COMMAND_g;
      }
      if (!strcmp(string, String::G_COMMAND_G)) {
        return Number::G_COMMAND_G;
      }
      if (!strcmp(string, String::G_COMMAND_PJ)) {
        return Number::G_COMMAND_PJ;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* ModelSpecLegacyMainVersionCommandType::convertToString(Number num) {
      switch(num) {
        case Number::MV_U0FH01H01H: return String::MV_U0FH01H01H;
        case Number::MV_U0EH01H: return String::MV_U0EH01H;
        case Number::MV_U0FH02H01H: return String::MV_U0FH02H01H;
        case Number::MV_UNKWOUN: return String::MV_UNKWOUN;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelSpecLegacyMainVersionCommandType::Number ModelSpecLegacyMainVersionCommandType::convertToNumber(const char* string) {
      if (!strcmp(string, String::MV_U0FH01H01H)) {
        return Number::MV_U0FH01H01H;
      }
      if (!strcmp(string, String::MV_U0EH01H)) {
        return Number::MV_U0EH01H;
      }
      if (!strcmp(string, String::MV_U0FH02H01H)) {
        return Number::MV_U0FH02H01H;
      }
      if (!strcmp(string, String::MV_UNKWOUN)) {
        return Number::MV_UNKWOUN;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* ModelSpecLegacyPageEndCommandType::convertToString(Number num) {
      switch(num) {
        case Number::END_PJCODE: return String::END_PJCODE;
        case Number::END_NORMAL: return String::END_NORMAL;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelSpecLegacyPageEndCommandType::Number ModelSpecLegacyPageEndCommandType::convertToNumber(const char* string) {
      if (!strcmp(string, String::END_PJCODE)) {
        return Number::END_PJCODE;
      }
      if (!strcmp(string, String::END_NORMAL)) {
        return Number::END_NORMAL;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* ModelSpecLegacyPaperListKind::convertToString(Number num) {
      switch(num) {
        case Number::PS_A7: return String::PS_A7;
        case Number::PS_A6: return String::PS_A6;
        case Number::PS_PJ: return String::PS_PJ;
        case Number::PS_BIN: return String::PS_BIN;
        case Number::PS_QL: return String::PS_QL;
        case Number::PS_PT: return String::PS_PT;
        case Number::PS_PT_36mm: return String::PS_PT_36mm;
        case Number::PS_PT_18mm: return String::PS_PT_18mm;
        case Number::PS_TUBE: return String::PS_TUBE;
        case Number::PS_FLE: return String::PS_FLE;
        case Number::PS_PT3: return String::PS_PT3;
        case Number::PS_QL1000: return String::PS_QL1000;
        case Number::PS_PT_CUBE3: return String::PS_PT_CUBE3;
        case Number::PS_PT9000: return String::PS_PT9000;
        case Number::PS_PT_3_5mmUNSUPPORT: return String::PS_PT_3_5mmUNSUPPORT;
        case Number::PS_PT_HS3: return String::PS_PT_HS3;
        case Number::PS_PT_36mm_HS3: return String::PS_PT_36mm_HS3;
        case Number::PAPER_UNSUPPORT: return String::PAPER_UNSUPPORT;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelSpecLegacyPaperListKind::Number ModelSpecLegacyPaperListKind::convertToNumber(const char* string) {
      if (!strcmp(string, String::PS_A7)) {
        return Number::PS_A7;
      }
      if (!strcmp(string, String::PS_A6)) {
        return Number::PS_A6;
      }
      if (!strcmp(string, String::PS_PJ)) {
        return Number::PS_PJ;
      }
      if (!strcmp(string, String::PS_BIN)) {
        return Number::PS_BIN;
      }
      if (!strcmp(string, String::PS_QL)) {
        return Number::PS_QL;
      }
      if (!strcmp(string, String::PS_PT)) {
        return Number::PS_PT;
      }
      if (!strcmp(string, String::PS_PT_36mm)) {
        return Number::PS_PT_36mm;
      }
      if (!strcmp(string, String::PS_PT_18mm)) {
        return Number::PS_PT_18mm;
      }
      if (!strcmp(string, String::PS_TUBE)) {
        return Number::PS_TUBE;
      }
      if (!strcmp(string, String::PS_FLE)) {
        return Number::PS_FLE;
      }
      if (!strcmp(string, String::PS_PT3)) {
        return Number::PS_PT3;
      }
      if (!strcmp(string, String::PS_QL1000)) {
        return Number::PS_QL1000;
      }
      if (!strcmp(string, String::PS_PT_CUBE3)) {
        return Number::PS_PT_CUBE3;
      }
      if (!strcmp(string, String::PS_PT9000)) {
        return Number::PS_PT9000;
      }
      if (!strcmp(string, String::PS_PT_3_5mmUNSUPPORT)) {
        return Number::PS_PT_3_5mmUNSUPPORT;
      }
      if (!strcmp(string, String::PS_PT_HS3)) {
        return Number::PS_PT_HS3;
      }
      if (!strcmp(string, String::PS_PT_36mm_HS3)) {
        return Number::PS_PT_36mm_HS3;
      }
      if (!strcmp(string, String::PAPER_UNSUPPORT)) {
        return Number::PAPER_UNSUPPORT;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* ModelSpecLegacyPrintCompressType::convertToString(Number num) {
      switch(num) {
        case Number::COM_RAW: return String::COM_RAW;
        case Number::COM_RAW_TIFF: return String::COM_RAW_TIFF;
        case Number::COM_TIFF: return String::COM_TIFF;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelSpecLegacyPrintCompressType::Number ModelSpecLegacyPrintCompressType::convertToNumber(const char* string) {
      if (!strcmp(string, String::COM_RAW)) {
        return Number::COM_RAW;
      }
      if (!strcmp(string, String::COM_RAW_TIFF)) {
        return Number::COM_RAW_TIFF;
      }
      if (!strcmp(string, String::COM_TIFF)) {
        return Number::COM_TIFF;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* ModelSpecLegacyPrinterSettingCategory::convertToString(Number num) {
      switch(num) {
        case Number::PS_NET_IPV6: return String::PS_NET_IPV6;
        case Number::PS_WIFI_IPV6: return String::PS_WIFI_IPV6;
        case Number::PS_WIFI_BOOTMODE: return String::PS_WIFI_BOOTMODE;
        case Number::PS_WIFI_INTERFACE: return String::PS_WIFI_INTERFACE;
        case Number::PS_WIFI_WIRELESSDIRECT_BOOTMODE: return String::PS_WIFI_WIRELESSDIRECT_BOOTMODE;
        case Number::PS_WIFI_SETTINGS: return String::PS_WIFI_SETTINGS;
        case Number::PS_WIFI_NODENAME: return String::PS_WIFI_NODENAME;
        case Number::PS_LAN_SETTINGS: return String::PS_LAN_SETTINGS;
        case Number::PS_LAN_NODENAME: return String::PS_LAN_NODENAME;
        case Number::PS_LAN_IPV6: return String::PS_LAN_IPV6;
        case Number::PS_WIRELESSDIRECT_CREATE_KRY: return String::PS_WIRELESSDIRECT_CREATE_KRY;
        case Number::PS_WIRELESSDIRECT_SETTINGS: return String::PS_WIRELESSDIRECT_SETTINGS;
        case Number::PS_BT_AUTOPOWEROFFTIME: return String::PS_BT_AUTOPOWEROFFTIME;
        case Number::PS_BT_AUTOSLEEPTIME: return String::PS_BT_AUTOSLEEPTIME;
        case Number::PS_BT_AUTOSLEEPTOPOWEROFFTIME: return String::PS_BT_AUTOSLEEPTOPOWEROFFTIME;
        case Number::PS_BT_POWERSAVEMODE: return String::PS_BT_POWERSAVEMODE;
        case Number::PS_BT_ISDISCOVERABLE: return String::PS_BT_ISDISCOVERABLE;
        case Number::PS_BT_DEVICENAME: return String::PS_BT_DEVICENAME;
        case Number::PS_BT_PINCODE: return String::PS_BT_PINCODE;
        case Number::PS_BT_SSP: return String::PS_BT_SSP;
        case Number::PS_BT_PINCODE_ENABLE: return String::PS_BT_PINCODE_ENABLE;
        case Number::PS_BT_SECURITYMODE: return String::PS_BT_SECURITYMODE;
        case Number::PS_BT_BOOTMODE: return String::PS_BT_BOOTMODE;
        case Number::PS_BT_BLUETOOTH_TO_IRDA: return String::PS_BT_BLUETOOTH_TO_IRDA;
        case Number::PS_BT_BLUETOOTH_TO_NET: return String::PS_BT_BLUETOOTH_TO_NET;
        case Number::PS_BT_KEY: return String::PS_BT_KEY;
        case Number::PS_BT_AUTO_CONNECTION: return String::PS_BT_AUTO_CONNECTION;
        case Number::PS_BT_BOOTMODE_PJ: return String::PS_BT_BOOTMODE_PJ;
        case Number::PS_PRINT_JPEG_HALFTONE: return String::PS_PRINT_JPEG_HALFTONE;
        case Number::PS_PRINT_JPEG_SCALE: return String::PS_PRINT_JPEG_SCALE;
        case Number::PS_PRINT_DENSITY: return String::PS_PRINT_DENSITY;
        case Number::PS_PRINT_SPEED: return String::PS_PRINT_SPEED;
        case Number::PS_POWER_POWEROFFTIME: return String::PS_POWER_POWEROFFTIME;
        case Number::PS_POWER_POWEROFFTIME_BATTERY: return String::PS_POWER_POWEROFFTIME_BATTERY;
        case Number::PS_POWER_POWEROFFTIME_RJ2: return String::PS_POWER_POWEROFFTIME_RJ2;
        case Number::PS_POWER_POWEROFFTIME_QL8: return String::PS_POWER_POWEROFFTIME_QL8;
        case Number::PS_POWER_POWEROFFTIME_BATTERY_QL8: return String::PS_POWER_POWEROFFTIME_BATTERY_QL8;
        case Number::PS_POWER_POWEROFFTIME_QL1100: return String::PS_POWER_POWEROFFTIME_QL1100;
        case Number::PS_POWER_POWEROFFTIME_RJ4000a: return String::PS_POWER_POWEROFFTIME_RJ4000a;
        case Number::PS_POWER_POWEROFFTIME_ModelFilter: return String::PS_POWER_POWEROFFTIME_ModelFilter;
        case Number::PS_POWER_POWEROFFTIME_PowerSupplyFilter: return String::PS_POWER_POWEROFFTIME_PowerSupplyFilter;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelSpecLegacyPrinterSettingCategory::Number ModelSpecLegacyPrinterSettingCategory::convertToNumber(const char* string) {
      if (!strcmp(string, String::PS_NET_IPV6)) {
        return Number::PS_NET_IPV6;
      }
      if (!strcmp(string, String::PS_WIFI_IPV6)) {
        return Number::PS_WIFI_IPV6;
      }
      if (!strcmp(string, String::PS_WIFI_BOOTMODE)) {
        return Number::PS_WIFI_BOOTMODE;
      }
      if (!strcmp(string, String::PS_WIFI_INTERFACE)) {
        return Number::PS_WIFI_INTERFACE;
      }
      if (!strcmp(string, String::PS_WIFI_WIRELESSDIRECT_BOOTMODE)) {
        return Number::PS_WIFI_WIRELESSDIRECT_BOOTMODE;
      }
      if (!strcmp(string, String::PS_WIFI_SETTINGS)) {
        return Number::PS_WIFI_SETTINGS;
      }
      if (!strcmp(string, String::PS_WIFI_NODENAME)) {
        return Number::PS_WIFI_NODENAME;
      }
      if (!strcmp(string, String::PS_LAN_SETTINGS)) {
        return Number::PS_LAN_SETTINGS;
      }
      if (!strcmp(string, String::PS_LAN_NODENAME)) {
        return Number::PS_LAN_NODENAME;
      }
      if (!strcmp(string, String::PS_LAN_IPV6)) {
        return Number::PS_LAN_IPV6;
      }
      if (!strcmp(string, String::PS_WIRELESSDIRECT_CREATE_KRY)) {
        return Number::PS_WIRELESSDIRECT_CREATE_KRY;
      }
      if (!strcmp(string, String::PS_WIRELESSDIRECT_SETTINGS)) {
        return Number::PS_WIRELESSDIRECT_SETTINGS;
      }
      if (!strcmp(string, String::PS_BT_AUTOPOWEROFFTIME)) {
        return Number::PS_BT_AUTOPOWEROFFTIME;
      }
      if (!strcmp(string, String::PS_BT_AUTOSLEEPTIME)) {
        return Number::PS_BT_AUTOSLEEPTIME;
      }
      if (!strcmp(string, String::PS_BT_AUTOSLEEPTOPOWEROFFTIME)) {
        return Number::PS_BT_AUTOSLEEPTOPOWEROFFTIME;
      }
      if (!strcmp(string, String::PS_BT_POWERSAVEMODE)) {
        return Number::PS_BT_POWERSAVEMODE;
      }
      if (!strcmp(string, String::PS_BT_ISDISCOVERABLE)) {
        return Number::PS_BT_ISDISCOVERABLE;
      }
      if (!strcmp(string, String::PS_BT_DEVICENAME)) {
        return Number::PS_BT_DEVICENAME;
      }
      if (!strcmp(string, String::PS_BT_PINCODE)) {
        return Number::PS_BT_PINCODE;
      }
      if (!strcmp(string, String::PS_BT_SSP)) {
        return Number::PS_BT_SSP;
      }
      if (!strcmp(string, String::PS_BT_PINCODE_ENABLE)) {
        return Number::PS_BT_PINCODE_ENABLE;
      }
      if (!strcmp(string, String::PS_BT_SECURITYMODE)) {
        return Number::PS_BT_SECURITYMODE;
      }
      if (!strcmp(string, String::PS_BT_BOOTMODE)) {
        return Number::PS_BT_BOOTMODE;
      }
      if (!strcmp(string, String::PS_BT_BLUETOOTH_TO_IRDA)) {
        return Number::PS_BT_BLUETOOTH_TO_IRDA;
      }
      if (!strcmp(string, String::PS_BT_BLUETOOTH_TO_NET)) {
        return Number::PS_BT_BLUETOOTH_TO_NET;
      }
      if (!strcmp(string, String::PS_BT_KEY)) {
        return Number::PS_BT_KEY;
      }
      if (!strcmp(string, String::PS_BT_AUTO_CONNECTION)) {
        return Number::PS_BT_AUTO_CONNECTION;
      }
      if (!strcmp(string, String::PS_BT_BOOTMODE_PJ)) {
        return Number::PS_BT_BOOTMODE_PJ;
      }
      if (!strcmp(string, String::PS_PRINT_JPEG_HALFTONE)) {
        return Number::PS_PRINT_JPEG_HALFTONE;
      }
      if (!strcmp(string, String::PS_PRINT_JPEG_SCALE)) {
        return Number::PS_PRINT_JPEG_SCALE;
      }
      if (!strcmp(string, String::PS_PRINT_DENSITY)) {
        return Number::PS_PRINT_DENSITY;
      }
      if (!strcmp(string, String::PS_PRINT_SPEED)) {
        return Number::PS_PRINT_SPEED;
      }
      if (!strcmp(string, String::PS_POWER_POWEROFFTIME)) {
        return Number::PS_POWER_POWEROFFTIME;
      }
      if (!strcmp(string, String::PS_POWER_POWEROFFTIME_BATTERY)) {
        return Number::PS_POWER_POWEROFFTIME_BATTERY;
      }
      if (!strcmp(string, String::PS_POWER_POWEROFFTIME_RJ2)) {
        return Number::PS_POWER_POWEROFFTIME_RJ2;
      }
      if (!strcmp(string, String::PS_POWER_POWEROFFTIME_QL8)) {
        return Number::PS_POWER_POWEROFFTIME_QL8;
      }
      if (!strcmp(string, String::PS_POWER_POWEROFFTIME_BATTERY_QL8)) {
        return Number::PS_POWER_POWEROFFTIME_BATTERY_QL8;
      }
      if (!strcmp(string, String::PS_POWER_POWEROFFTIME_QL1100)) {
        return Number::PS_POWER_POWEROFFTIME_QL1100;
      }
      if (!strcmp(string, String::PS_POWER_POWEROFFTIME_RJ4000a)) {
        return Number::PS_POWER_POWEROFFTIME_RJ4000a;
      }
      if (!strcmp(string, String::PS_POWER_POWEROFFTIME_ModelFilter)) {
        return Number::PS_POWER_POWEROFFTIME_ModelFilter;
      }
      if (!strcmp(string, String::PS_POWER_POWEROFFTIME_PowerSupplyFilter)) {
        return Number::PS_POWER_POWEROFFTIME_PowerSupplyFilter;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* ModelSpecLegacyPrinterSettingCategoryBluetooth::convertToString(Number num) {
      switch(num) {
        case Number::PS_BT_AUTOPOWEROFFTIME: return String::PS_BT_AUTOPOWEROFFTIME;
        case Number::PS_BT_AUTOSLEEPTIME: return String::PS_BT_AUTOSLEEPTIME;
        case Number::PS_BT_AUTOSLEEPTOPOWEROFFTIME: return String::PS_BT_AUTOSLEEPTOPOWEROFFTIME;
        case Number::PS_BT_POWERSAVEMODE: return String::PS_BT_POWERSAVEMODE;
        case Number::PS_BT_ISDISCOVERABLE: return String::PS_BT_ISDISCOVERABLE;
        case Number::PS_BT_DEVICENAME: return String::PS_BT_DEVICENAME;
        case Number::PS_BT_PINCODE: return String::PS_BT_PINCODE;
        case Number::PS_BT_SSP: return String::PS_BT_SSP;
        case Number::PS_BT_PINCODE_ENABLE: return String::PS_BT_PINCODE_ENABLE;
        case Number::PS_BT_SECURITYMODE: return String::PS_BT_SECURITYMODE;
        case Number::PS_BT_BOOTMODE: return String::PS_BT_BOOTMODE;
        case Number::PS_BT_BLUETOOTH_TO_IRDA: return String::PS_BT_BLUETOOTH_TO_IRDA;
        case Number::PS_BT_BLUETOOTH_TO_NET: return String::PS_BT_BLUETOOTH_TO_NET;
        case Number::PS_BT_KEY: return String::PS_BT_KEY;
        case Number::PS_BT_AUTO_CONNECTION: return String::PS_BT_AUTO_CONNECTION;
        case Number::PS_BT_BOOTMODE_PJ: return String::PS_BT_BOOTMODE_PJ;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelSpecLegacyPrinterSettingCategoryBluetooth::Number ModelSpecLegacyPrinterSettingCategoryBluetooth::convertToNumber(const char* string) {
      if (!strcmp(string, String::PS_BT_AUTOPOWEROFFTIME)) {
        return Number::PS_BT_AUTOPOWEROFFTIME;
      }
      if (!strcmp(string, String::PS_BT_AUTOSLEEPTIME)) {
        return Number::PS_BT_AUTOSLEEPTIME;
      }
      if (!strcmp(string, String::PS_BT_AUTOSLEEPTOPOWEROFFTIME)) {
        return Number::PS_BT_AUTOSLEEPTOPOWEROFFTIME;
      }
      if (!strcmp(string, String::PS_BT_POWERSAVEMODE)) {
        return Number::PS_BT_POWERSAVEMODE;
      }
      if (!strcmp(string, String::PS_BT_ISDISCOVERABLE)) {
        return Number::PS_BT_ISDISCOVERABLE;
      }
      if (!strcmp(string, String::PS_BT_DEVICENAME)) {
        return Number::PS_BT_DEVICENAME;
      }
      if (!strcmp(string, String::PS_BT_PINCODE)) {
        return Number::PS_BT_PINCODE;
      }
      if (!strcmp(string, String::PS_BT_SSP)) {
        return Number::PS_BT_SSP;
      }
      if (!strcmp(string, String::PS_BT_PINCODE_ENABLE)) {
        return Number::PS_BT_PINCODE_ENABLE;
      }
      if (!strcmp(string, String::PS_BT_SECURITYMODE)) {
        return Number::PS_BT_SECURITYMODE;
      }
      if (!strcmp(string, String::PS_BT_BOOTMODE)) {
        return Number::PS_BT_BOOTMODE;
      }
      if (!strcmp(string, String::PS_BT_BLUETOOTH_TO_IRDA)) {
        return Number::PS_BT_BLUETOOTH_TO_IRDA;
      }
      if (!strcmp(string, String::PS_BT_BLUETOOTH_TO_NET)) {
        return Number::PS_BT_BLUETOOTH_TO_NET;
      }
      if (!strcmp(string, String::PS_BT_KEY)) {
        return Number::PS_BT_KEY;
      }
      if (!strcmp(string, String::PS_BT_AUTO_CONNECTION)) {
        return Number::PS_BT_AUTO_CONNECTION;
      }
      if (!strcmp(string, String::PS_BT_BOOTMODE_PJ)) {
        return Number::PS_BT_BOOTMODE_PJ;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* ModelSpecLegacyPrinterSettingCategoryNetwork::convertToString(Number num) {
      switch(num) {
        case Number::PS_NET_IPV6: return String::PS_NET_IPV6;
        case Number::PS_WIFI_IPV6: return String::PS_WIFI_IPV6;
        case Number::PS_WIFI_BOOTMODE: return String::PS_WIFI_BOOTMODE;
        case Number::PS_WIFI_INTERFACE: return String::PS_WIFI_INTERFACE;
        case Number::PS_WIFI_WIRELESSDIRECT_BOOTMODE: return String::PS_WIFI_WIRELESSDIRECT_BOOTMODE;
        case Number::PS_WIFI_SETTINGS: return String::PS_WIFI_SETTINGS;
        case Number::PS_WIFI_NODENAME: return String::PS_WIFI_NODENAME;
        case Number::PS_LAN_SETTINGS: return String::PS_LAN_SETTINGS;
        case Number::PS_LAN_NODENAME: return String::PS_LAN_NODENAME;
        case Number::PS_LAN_IPV6: return String::PS_LAN_IPV6;
        case Number::PS_WIRELESSDIRECT_CREATE_KRY: return String::PS_WIRELESSDIRECT_CREATE_KRY;
        case Number::PS_WIRELESSDIRECT_SETTINGS: return String::PS_WIRELESSDIRECT_SETTINGS;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelSpecLegacyPrinterSettingCategoryNetwork::Number ModelSpecLegacyPrinterSettingCategoryNetwork::convertToNumber(const char* string) {
      if (!strcmp(string, String::PS_NET_IPV6)) {
        return Number::PS_NET_IPV6;
      }
      if (!strcmp(string, String::PS_WIFI_IPV6)) {
        return Number::PS_WIFI_IPV6;
      }
      if (!strcmp(string, String::PS_WIFI_BOOTMODE)) {
        return Number::PS_WIFI_BOOTMODE;
      }
      if (!strcmp(string, String::PS_WIFI_INTERFACE)) {
        return Number::PS_WIFI_INTERFACE;
      }
      if (!strcmp(string, String::PS_WIFI_WIRELESSDIRECT_BOOTMODE)) {
        return Number::PS_WIFI_WIRELESSDIRECT_BOOTMODE;
      }
      if (!strcmp(string, String::PS_WIFI_SETTINGS)) {
        return Number::PS_WIFI_SETTINGS;
      }
      if (!strcmp(string, String::PS_WIFI_NODENAME)) {
        return Number::PS_WIFI_NODENAME;
      }
      if (!strcmp(string, String::PS_LAN_SETTINGS)) {
        return Number::PS_LAN_SETTINGS;
      }
      if (!strcmp(string, String::PS_LAN_NODENAME)) {
        return Number::PS_LAN_NODENAME;
      }
      if (!strcmp(string, String::PS_LAN_IPV6)) {
        return Number::PS_LAN_IPV6;
      }
      if (!strcmp(string, String::PS_WIRELESSDIRECT_CREATE_KRY)) {
        return Number::PS_WIRELESSDIRECT_CREATE_KRY;
      }
      if (!strcmp(string, String::PS_WIRELESSDIRECT_SETTINGS)) {
        return Number::PS_WIRELESSDIRECT_SETTINGS;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* ModelSpecLegacyPrinterSettingCategoryPower::convertToString(Number num) {
      switch(num) {
        case Number::PS_POWER_POWEROFFTIME: return String::PS_POWER_POWEROFFTIME;
        case Number::PS_POWER_POWEROFFTIME_BATTERY: return String::PS_POWER_POWEROFFTIME_BATTERY;
        case Number::PS_POWER_POWEROFFTIME_RJ2: return String::PS_POWER_POWEROFFTIME_RJ2;
        case Number::PS_POWER_POWEROFFTIME_QL8: return String::PS_POWER_POWEROFFTIME_QL8;
        case Number::PS_POWER_POWEROFFTIME_BATTERY_QL8: return String::PS_POWER_POWEROFFTIME_BATTERY_QL8;
        case Number::PS_POWER_POWEROFFTIME_QL1100: return String::PS_POWER_POWEROFFTIME_QL1100;
        case Number::PS_POWER_POWEROFFTIME_RJ4000a: return String::PS_POWER_POWEROFFTIME_RJ4000a;
        case Number::PS_POWER_POWEROFFTIME_BATTERY_PJ8: return String::PS_POWER_POWEROFFTIME_BATTERY_PJ8;
        case Number::PS_POWER_POWEROFFTIME_ModelFilter: return String::PS_POWER_POWEROFFTIME_ModelFilter;
        case Number::PS_POWER_POWEROFFTIME_PowerSupplyFilter: return String::PS_POWER_POWEROFFTIME_PowerSupplyFilter;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelSpecLegacyPrinterSettingCategoryPower::Number ModelSpecLegacyPrinterSettingCategoryPower::convertToNumber(const char* string) {
      if (!strcmp(string, String::PS_POWER_POWEROFFTIME)) {
        return Number::PS_POWER_POWEROFFTIME;
      }
      if (!strcmp(string, String::PS_POWER_POWEROFFTIME_BATTERY)) {
        return Number::PS_POWER_POWEROFFTIME_BATTERY;
      }
      if (!strcmp(string, String::PS_POWER_POWEROFFTIME_RJ2)) {
        return Number::PS_POWER_POWEROFFTIME_RJ2;
      }
      if (!strcmp(string, String::PS_POWER_POWEROFFTIME_QL8)) {
        return Number::PS_POWER_POWEROFFTIME_QL8;
      }
      if (!strcmp(string, String::PS_POWER_POWEROFFTIME_BATTERY_QL8)) {
        return Number::PS_POWER_POWEROFFTIME_BATTERY_QL8;
      }
      if (!strcmp(string, String::PS_POWER_POWEROFFTIME_QL1100)) {
        return Number::PS_POWER_POWEROFFTIME_QL1100;
      }
      if (!strcmp(string, String::PS_POWER_POWEROFFTIME_RJ4000a)) {
        return Number::PS_POWER_POWEROFFTIME_RJ4000a;
      }
      if (!strcmp(string, String::PS_POWER_POWEROFFTIME_BATTERY_PJ8)) {
        return Number::PS_POWER_POWEROFFTIME_BATTERY_PJ8;
      }
      if (!strcmp(string, String::PS_POWER_POWEROFFTIME_ModelFilter)) {
        return Number::PS_POWER_POWEROFFTIME_ModelFilter;
      }
      if (!strcmp(string, String::PS_POWER_POWEROFFTIME_PowerSupplyFilter)) {
        return Number::PS_POWER_POWEROFFTIME_PowerSupplyFilter;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* ModelSpecLegacyPrinterSettingCategoryPrint::convertToString(Number num) {
      switch(num) {
        case Number::PS_PRINT_JPEG_HALFTONE: return String::PS_PRINT_JPEG_HALFTONE;
        case Number::PS_PRINT_JPEG_SCALE: return String::PS_PRINT_JPEG_SCALE;
        case Number::PS_PRINT_DENSITY: return String::PS_PRINT_DENSITY;
        case Number::PS_PRINT_SPEED: return String::PS_PRINT_SPEED;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelSpecLegacyPrinterSettingCategoryPrint::Number ModelSpecLegacyPrinterSettingCategoryPrint::convertToNumber(const char* string) {
      if (!strcmp(string, String::PS_PRINT_JPEG_HALFTONE)) {
        return Number::PS_PRINT_JPEG_HALFTONE;
      }
      if (!strcmp(string, String::PS_PRINT_JPEG_SCALE)) {
        return Number::PS_PRINT_JPEG_SCALE;
      }
      if (!strcmp(string, String::PS_PRINT_DENSITY)) {
        return Number::PS_PRINT_DENSITY;
      }
      if (!strcmp(string, String::PS_PRINT_SPEED)) {
        return Number::PS_PRINT_SPEED;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* ModelSpecLegacyPrintPageCommandType::convertToString(Number num) {
      switch(num) {
        case Number::PAGE_START_END: return String::PAGE_START_END;
        case Number::PAGE_START_NEXT_END: return String::PAGE_START_NEXT_END;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelSpecLegacyPrintPageCommandType::Number ModelSpecLegacyPrintPageCommandType::convertToNumber(const char* string) {
      if (!strcmp(string, String::PAGE_START_END)) {
        return Number::PAGE_START_END;
      }
      if (!strcmp(string, String::PAGE_START_NEXT_END)) {
        return Number::PAGE_START_NEXT_END;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* ModelSpecLegacySupportAdvanceModeCommand::convertToString(Number num) {
      switch(num) {
        case Number::PS_AM_HALFCUT: return String::PS_AM_HALFCUT;
        case Number::PS_AM_CUTEND: return String::PS_AM_CUTEND;
        case Number::PS_AM_SPECIALTAPE: return String::PS_AM_SPECIALTAPE;
        case Number::PS_AM_HIGH_RESOLUTION: return String::PS_AM_HIGH_RESOLUTION;
        case Number::PS_AM_LABEL_CUTEND: return String::PS_AM_LABEL_CUTEND;
        case Number::PS_AM_NOBUFFER: return String::PS_AM_NOBUFFER;
        case Number::PS_AM_LOW_RESOLUTION: return String::PS_AM_LOW_RESOLUTION;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelSpecLegacySupportAdvanceModeCommand::Number ModelSpecLegacySupportAdvanceModeCommand::convertToNumber(const char* string) {
      if (!strcmp(string, String::PS_AM_HALFCUT)) {
        return Number::PS_AM_HALFCUT;
      }
      if (!strcmp(string, String::PS_AM_CUTEND)) {
        return Number::PS_AM_CUTEND;
      }
      if (!strcmp(string, String::PS_AM_SPECIALTAPE)) {
        return Number::PS_AM_SPECIALTAPE;
      }
      if (!strcmp(string, String::PS_AM_HIGH_RESOLUTION)) {
        return Number::PS_AM_HIGH_RESOLUTION;
      }
      if (!strcmp(string, String::PS_AM_LABEL_CUTEND)) {
        return Number::PS_AM_LABEL_CUTEND;
      }
      if (!strcmp(string, String::PS_AM_NOBUFFER)) {
        return Number::PS_AM_NOBUFFER;
      }
      if (!strcmp(string, String::PS_AM_LOW_RESOLUTION)) {
        return Number::PS_AM_LOW_RESOLUTION;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* ModelSpecLegacySupportFunc::convertToString(Number num) {
      switch(num) {
        case Number::SP_FUC_RASTER_PRINT: return String::SP_FUC_RASTER_PRINT;
        case Number::SP_FUC_TEMPLATE_PRINT: return String::SP_FUC_TEMPLATE_PRINT;
        case Number::SP_FUC_TEMPLATE_TRANS: return String::SP_FUC_TEMPLATE_TRANS;
        case Number::SP_FUC_TEMPLATE_REMOVE: return String::SP_FUC_TEMPLATE_REMOVE;
        case Number::SP_FUC_PRINTER_SETTINGS: return String::SP_FUC_PRINTER_SETTINGS;
        case Number::SP_FUC_FIRM_UPDATE: return String::SP_FUC_FIRM_UPDATE;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelSpecLegacySupportFunc::Number ModelSpecLegacySupportFunc::convertToNumber(const char* string) {
      if (!strcmp(string, String::SP_FUC_RASTER_PRINT)) {
        return Number::SP_FUC_RASTER_PRINT;
      }
      if (!strcmp(string, String::SP_FUC_TEMPLATE_PRINT)) {
        return Number::SP_FUC_TEMPLATE_PRINT;
      }
      if (!strcmp(string, String::SP_FUC_TEMPLATE_TRANS)) {
        return Number::SP_FUC_TEMPLATE_TRANS;
      }
      if (!strcmp(string, String::SP_FUC_TEMPLATE_REMOVE)) {
        return Number::SP_FUC_TEMPLATE_REMOVE;
      }
      if (!strcmp(string, String::SP_FUC_PRINTER_SETTINGS)) {
        return Number::SP_FUC_PRINTER_SETTINGS;
      }
      if (!strcmp(string, String::SP_FUC_FIRM_UPDATE)) {
        return Number::SP_FUC_FIRM_UPDATE;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* ModelSpecLegacySupportMultiColorLabel::convertToString(Number num) {
      switch(num) {
        case Number::MONO_COLOR: return String::MONO_COLOR;
        case Number::BI_COLOR: return String::BI_COLOR;
        case Number::UNSUPPORTED_COLOR: return String::UNSUPPORTED_COLOR;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelSpecLegacySupportMultiColorLabel::Number ModelSpecLegacySupportMultiColorLabel::convertToNumber(const char* string) {
      if (!strcmp(string, String::MONO_COLOR)) {
        return Number::MONO_COLOR;
      }
      if (!strcmp(string, String::BI_COLOR)) {
        return Number::BI_COLOR;
      }
      if (!strcmp(string, String::UNSUPPORTED_COLOR)) {
        return Number::UNSUPPORTED_COLOR;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* ModelSpecLegacySupportPJFeedMode::convertToString(Number num) {
      switch(num) {
        case Number::FEED_MODE_FREE: return String::FEED_MODE_FREE;
        case Number::FEED_MODE_FIXEDPAGE: return String::FEED_MODE_FIXEDPAGE;
        case Number::FEED_MODE_ENDOFPAGE: return String::FEED_MODE_ENDOFPAGE;
        case Number::FEED_MODE_ENDOFPAGERETRACT: return String::FEED_MODE_ENDOFPAGERETRACT;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelSpecLegacySupportPJFeedMode::Number ModelSpecLegacySupportPJFeedMode::convertToNumber(const char* string) {
      if (!strcmp(string, String::FEED_MODE_FREE)) {
        return Number::FEED_MODE_FREE;
      }
      if (!strcmp(string, String::FEED_MODE_FIXEDPAGE)) {
        return Number::FEED_MODE_FIXEDPAGE;
      }
      if (!strcmp(string, String::FEED_MODE_ENDOFPAGE)) {
        return Number::FEED_MODE_ENDOFPAGE;
      }
      if (!strcmp(string, String::FEED_MODE_ENDOFPAGERETRACT)) {
        return Number::FEED_MODE_ENDOFPAGERETRACT;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* ModelSpecLegacySupportVariousModeCommand::convertToString(Number num) {
      switch(num) {
        case Number::PS_VM_AUTOCUT: return String::PS_VM_AUTOCUT;
        case Number::PS_VM_MIRROR: return String::PS_VM_MIRROR;
        case Number::PS_VM_PEEL: return String::PS_VM_PEEL;
        case Number::PS_VM_ROTATE180: return String::PS_VM_ROTATE180;
        case Number::PS_VM_CUTMARK: return String::PS_VM_CUTMARK;
        case Number::PS_FEEDVOL: return String::PS_FEEDVOL;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelSpecLegacySupportVariousModeCommand::Number ModelSpecLegacySupportVariousModeCommand::convertToNumber(const char* string) {
      if (!strcmp(string, String::PS_VM_AUTOCUT)) {
        return Number::PS_VM_AUTOCUT;
      }
      if (!strcmp(string, String::PS_VM_MIRROR)) {
        return Number::PS_VM_MIRROR;
      }
      if (!strcmp(string, String::PS_VM_PEEL)) {
        return Number::PS_VM_PEEL;
      }
      if (!strcmp(string, String::PS_VM_ROTATE180)) {
        return Number::PS_VM_ROTATE180;
      }
      if (!strcmp(string, String::PS_VM_CUTMARK)) {
        return Number::PS_VM_CUTMARK;
      }
      if (!strcmp(string, String::PS_FEEDVOL)) {
        return Number::PS_FEEDVOL;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

  }
}