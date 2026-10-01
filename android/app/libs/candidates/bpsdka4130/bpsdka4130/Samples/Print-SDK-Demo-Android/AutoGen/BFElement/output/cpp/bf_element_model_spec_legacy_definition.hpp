
#pragma once
#include <string>

namespace bf {
  namespace element {
    struct ModelSpecLegacyBatteryCommandType {
      enum class Number {
        PS_BAT_NON,
        PS_BAT_PJCOMMAND,
        PS_BAT_MW145COMMAND,
        PS_BAT_MW260COMMAND,
        PS_BAT_FROMSTATUS,
        __Null,
      };
      struct String {
        constexpr static const char * PS_BAT_NON = "PS_BAT_NON";
        constexpr static const char * PS_BAT_PJCOMMAND = "PS_BAT_PJCOMMAND";
        constexpr static const char * PS_BAT_MW145COMMAND = "PS_BAT_MW145COMMAND";
        constexpr static const char * PS_BAT_MW260COMMAND = "PS_BAT_MW260COMMAND";
        constexpr static const char * PS_BAT_FROMSTATUS = "PS_BAT_FROMSTATUS";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelSpecLegacyBatteryCommandType";
    };

    struct ModelSpecLegacyBitOrderOfBitmapIsLittle {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacyBitOrderOfBitmapIsLittle";
    };

    struct ModelSpecLegacyChangeStatusMode {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacyChangeStatusMode";
    };

    struct ModelSpecLegacyFirmUpdateShouldChangeCommandMode {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacyFirmUpdateShouldChangeCommandMode";
    };

    struct ModelSpecLegacyGraphicCommandType {
      enum class Number {
        G_COMMAND_g,
        G_COMMAND_G,
        G_COMMAND_PJ,
        __Null,
      };
      struct String {
        constexpr static const char * G_COMMAND_g = "G_COMMAND_g";
        constexpr static const char * G_COMMAND_G = "G_COMMAND_G";
        constexpr static const char * G_COMMAND_PJ = "G_COMMAND_PJ";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelSpecLegacyGraphicCommandType";
    };

    struct ModelSpecLegacyHeadPin {
      using Number = int;
      constexpr static const char * key = "ModelSpecLegacyHeadPin";
    };

    struct ModelSpecLegacyHeadPinWhenPrintTube {
      using Number = int;
      constexpr static const char * key = "ModelSpecLegacyHeadPinWhenPrintTube";
    };

    struct ModelSpecLegacyIgnorePaperEmptyWhenPrintEnd {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacyIgnorePaperEmptyWhenPrintEnd";
    };

    struct ModelSpecLegacyImageHalftoneShouldGammaAdjust {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacyImageHalftoneShouldGammaAdjust";
    };

    struct ModelSpecLegacyMainVersionCommandType {
      enum class Number {
        MV_U0FH01H01H,
        MV_U0EH01H,
        MV_U0FH02H01H,
        MV_UNKWOUN,
        __Null,
      };
      struct String {
        constexpr static const char * MV_U0FH01H01H = "MV_U0FH01H01H";
        constexpr static const char * MV_U0EH01H = "MV_U0EH01H";
        constexpr static const char * MV_U0FH02H01H = "MV_U0FH02H01H";
        constexpr static const char * MV_UNKWOUN = "MV_UNKWOUN";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelSpecLegacyMainVersionCommandType";
    };

    struct ModelSpecLegacyMediaSizeShouldCheck {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacyMediaSizeShouldCheck";
    };

    struct ModelSpecLegacyMinPrintMerginPerTenthMM {
      using Number = int;
      constexpr static const char * key = "ModelSpecLegacyMinPrintMerginPerTenthMM";
    };

    struct ModelSpecLegacyMinPrintPaperLengthPerTenthMM {
      using Number = int;
      constexpr static const char * key = "ModelSpecLegacyMinPrintPaperLengthPerTenthMM";
    };

    struct ModelSpecLegacyMode9CompressionMaxByteSize {
      using Number = int;
      constexpr static const char * key = "ModelSpecLegacyMode9CompressionMaxByteSize";
    };

    struct ModelSpecLegacyMode9ShouldFlipHorizontal {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacyMode9ShouldFlipHorizontal";
    };

    struct ModelSpecLegacyModelCode {
      using Number = int;
      constexpr static const char * key = "ModelSpecLegacyModelCode";
    };

    struct ModelSpecLegacyModelName {
      using Number = std::string;
      constexpr static const char * key = "ModelSpecLegacyModelName";
    };

    struct ModelSpecLegacyNullCommandLength {
      using Number = int;
      constexpr static const char * key = "ModelSpecLegacyNullCommandLength";
    };

    struct ModelSpecLegacyPageEndCommandType {
      enum class Number {
        END_PJCODE,
        END_NORMAL,
        __Null,
      };
      struct String {
        constexpr static const char * END_PJCODE = "END_PJCODE";
        constexpr static const char * END_NORMAL = "END_NORMAL";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelSpecLegacyPageEndCommandType";
    };

    struct ModelSpecLegacyPaperListKind {
      enum class Number {
        PS_A7,
        PS_A6,
        PS_PJ,
        PS_BIN,
        PS_QL,
        PS_PT,
        PS_PT_36mm,
        PS_PT_18mm,
        PS_TUBE,
        PS_FLE,
        PS_PT3,
        PS_QL1000,
        PS_PT_CUBE3,
        PS_PT9000,
        PS_PT_3_5mmUNSUPPORT,
        PS_PT_HS3,
        PS_PT_36mm_HS3,
        PAPER_UNSUPPORT,
        __Null,
      };
      struct String {
        constexpr static const char * PS_A7 = "PS_A7";
        constexpr static const char * PS_A6 = "PS_A6";
        constexpr static const char * PS_PJ = "PS_PJ";
        constexpr static const char * PS_BIN = "PS_BIN";
        constexpr static const char * PS_QL = "PS_QL";
        constexpr static const char * PS_PT = "PS_PT";
        constexpr static const char * PS_PT_36mm = "PS_PT_36mm";
        constexpr static const char * PS_PT_18mm = "PS_PT_18mm";
        constexpr static const char * PS_TUBE = "PS_TUBE";
        constexpr static const char * PS_FLE = "PS_FLE";
        constexpr static const char * PS_PT3 = "PS_PT3";
        constexpr static const char * PS_QL1000 = "PS_QL1000";
        constexpr static const char * PS_PT_CUBE3 = "PS_PT_CUBE3";
        constexpr static const char * PS_PT9000 = "PS_PT9000";
        constexpr static const char * PS_PT_3_5mmUNSUPPORT = "PS_PT_3_5mmUNSUPPORT";
        constexpr static const char * PS_PT_HS3 = "PS_PT_HS3";
        constexpr static const char * PS_PT_36mm_HS3 = "PS_PT_36mm_HS3";
        constexpr static const char * PAPER_UNSUPPORT = "PAPER_UNSUPPORT";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelSpecLegacyPaperListKind";
    };

    struct ModelSpecLegacyPrintCompressType {
      enum class Number {
        COM_RAW,
        COM_RAW_TIFF,
        COM_TIFF,
        __Null,
      };
      struct String {
        constexpr static const char * COM_RAW = "COM_RAW";
        constexpr static const char * COM_RAW_TIFF = "COM_RAW_TIFF";
        constexpr static const char * COM_TIFF = "COM_TIFF";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelSpecLegacyPrintCompressType";
    };

    struct ModelSpecLegacyPrinterSettingCategory {
      enum class Number {
        PS_NET_IPV6,
        PS_WIFI_IPV6,
        PS_WIFI_BOOTMODE,
        PS_WIFI_INTERFACE,
        PS_WIFI_WIRELESSDIRECT_BOOTMODE,
        PS_WIFI_SETTINGS,
        PS_WIFI_NODENAME,
        PS_LAN_SETTINGS,
        PS_LAN_NODENAME,
        PS_LAN_IPV6,
        PS_WIRELESSDIRECT_CREATE_KRY,
        PS_WIRELESSDIRECT_SETTINGS,
        PS_BT_AUTOPOWEROFFTIME,
        PS_BT_AUTOSLEEPTIME,
        PS_BT_AUTOSLEEPTOPOWEROFFTIME,
        PS_BT_POWERSAVEMODE,
        PS_BT_ISDISCOVERABLE,
        PS_BT_DEVICENAME,
        PS_BT_PINCODE,
        PS_BT_SSP,
        PS_BT_PINCODE_ENABLE,
        PS_BT_SECURITYMODE,
        PS_BT_BOOTMODE,
        PS_BT_BLUETOOTH_TO_IRDA,
        PS_BT_BLUETOOTH_TO_NET,
        PS_BT_KEY,
        PS_BT_AUTO_CONNECTION,
        PS_BT_BOOTMODE_PJ,
        PS_PRINT_JPEG_HALFTONE,
        PS_PRINT_JPEG_SCALE,
        PS_PRINT_DENSITY,
        PS_PRINT_SPEED,
        PS_POWER_POWEROFFTIME,
        PS_POWER_POWEROFFTIME_BATTERY,
        PS_POWER_POWEROFFTIME_RJ2,
        PS_POWER_POWEROFFTIME_QL8,
        PS_POWER_POWEROFFTIME_BATTERY_QL8,
        PS_POWER_POWEROFFTIME_QL1100,
        PS_POWER_POWEROFFTIME_RJ4000a,
        PS_POWER_POWEROFFTIME_ModelFilter,
        PS_POWER_POWEROFFTIME_PowerSupplyFilter,
        __Null,
      };
      struct String {
        constexpr static const char * PS_NET_IPV6 = "PS_NET_IPV6";
        constexpr static const char * PS_WIFI_IPV6 = "PS_WIFI_IPV6";
        constexpr static const char * PS_WIFI_BOOTMODE = "PS_WIFI_BOOTMODE";
        constexpr static const char * PS_WIFI_INTERFACE = "PS_WIFI_INTERFACE";
        constexpr static const char * PS_WIFI_WIRELESSDIRECT_BOOTMODE = "PS_WIFI_WIRELESSDIRECT_BOOTMODE";
        constexpr static const char * PS_WIFI_SETTINGS = "PS_WIFI_SETTINGS";
        constexpr static const char * PS_WIFI_NODENAME = "PS_WIFI_NODENAME";
        constexpr static const char * PS_LAN_SETTINGS = "PS_LAN_SETTINGS";
        constexpr static const char * PS_LAN_NODENAME = "PS_LAN_NODENAME";
        constexpr static const char * PS_LAN_IPV6 = "PS_LAN_IPV6";
        constexpr static const char * PS_WIRELESSDIRECT_CREATE_KRY = "PS_WIRELESSDIRECT_CREATE_KRY";
        constexpr static const char * PS_WIRELESSDIRECT_SETTINGS = "PS_WIRELESSDIRECT_SETTINGS";
        constexpr static const char * PS_BT_AUTOPOWEROFFTIME = "PS_BT_AUTOPOWEROFFTIME";
        constexpr static const char * PS_BT_AUTOSLEEPTIME = "PS_BT_AUTOSLEEPTIME";
        constexpr static const char * PS_BT_AUTOSLEEPTOPOWEROFFTIME = "PS_BT_AUTOSLEEPTOPOWEROFFTIME";
        constexpr static const char * PS_BT_POWERSAVEMODE = "PS_BT_POWERSAVEMODE";
        constexpr static const char * PS_BT_ISDISCOVERABLE = "PS_BT_ISDISCOVERABLE";
        constexpr static const char * PS_BT_DEVICENAME = "PS_BT_DEVICENAME";
        constexpr static const char * PS_BT_PINCODE = "PS_BT_PINCODE";
        constexpr static const char * PS_BT_SSP = "PS_BT_SSP";
        constexpr static const char * PS_BT_PINCODE_ENABLE = "PS_BT_PINCODE_ENABLE";
        constexpr static const char * PS_BT_SECURITYMODE = "PS_BT_SECURITYMODE";
        constexpr static const char * PS_BT_BOOTMODE = "PS_BT_BOOTMODE";
        constexpr static const char * PS_BT_BLUETOOTH_TO_IRDA = "PS_BT_BLUETOOTH_TO_IRDA";
        constexpr static const char * PS_BT_BLUETOOTH_TO_NET = "PS_BT_BLUETOOTH_TO_NET";
        constexpr static const char * PS_BT_KEY = "PS_BT_KEY";
        constexpr static const char * PS_BT_AUTO_CONNECTION = "PS_BT_AUTO_CONNECTION";
        constexpr static const char * PS_BT_BOOTMODE_PJ = "PS_BT_BOOTMODE_PJ";
        constexpr static const char * PS_PRINT_JPEG_HALFTONE = "PS_PRINT_JPEG_HALFTONE";
        constexpr static const char * PS_PRINT_JPEG_SCALE = "PS_PRINT_JPEG_SCALE";
        constexpr static const char * PS_PRINT_DENSITY = "PS_PRINT_DENSITY";
        constexpr static const char * PS_PRINT_SPEED = "PS_PRINT_SPEED";
        constexpr static const char * PS_POWER_POWEROFFTIME = "PS_POWER_POWEROFFTIME";
        constexpr static const char * PS_POWER_POWEROFFTIME_BATTERY = "PS_POWER_POWEROFFTIME_BATTERY";
        constexpr static const char * PS_POWER_POWEROFFTIME_RJ2 = "PS_POWER_POWEROFFTIME_RJ2";
        constexpr static const char * PS_POWER_POWEROFFTIME_QL8 = "PS_POWER_POWEROFFTIME_QL8";
        constexpr static const char * PS_POWER_POWEROFFTIME_BATTERY_QL8 = "PS_POWER_POWEROFFTIME_BATTERY_QL8";
        constexpr static const char * PS_POWER_POWEROFFTIME_QL1100 = "PS_POWER_POWEROFFTIME_QL1100";
        constexpr static const char * PS_POWER_POWEROFFTIME_RJ4000a = "PS_POWER_POWEROFFTIME_RJ4000a";
        constexpr static const char * PS_POWER_POWEROFFTIME_ModelFilter = "PS_POWER_POWEROFFTIME_ModelFilter";
        constexpr static const char * PS_POWER_POWEROFFTIME_PowerSupplyFilter = "PS_POWER_POWEROFFTIME_PowerSupplyFilter";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelSpecLegacyPrinterSettingCategory";
    };

    struct ModelSpecLegacyPrinterSettingCategoryBluetooth {
      enum class Number {
        PS_BT_AUTOPOWEROFFTIME,
        PS_BT_AUTOSLEEPTIME,
        PS_BT_AUTOSLEEPTOPOWEROFFTIME,
        PS_BT_POWERSAVEMODE,
        PS_BT_ISDISCOVERABLE,
        PS_BT_DEVICENAME,
        PS_BT_PINCODE,
        PS_BT_SSP,
        PS_BT_PINCODE_ENABLE,
        PS_BT_SECURITYMODE,
        PS_BT_BOOTMODE,
        PS_BT_BLUETOOTH_TO_IRDA,
        PS_BT_BLUETOOTH_TO_NET,
        PS_BT_KEY,
        PS_BT_AUTO_CONNECTION,
        PS_BT_BOOTMODE_PJ,
        __Null,
      };
      struct String {
        constexpr static const char * PS_BT_AUTOPOWEROFFTIME = "PS_BT_AUTOPOWEROFFTIME";
        constexpr static const char * PS_BT_AUTOSLEEPTIME = "PS_BT_AUTOSLEEPTIME";
        constexpr static const char * PS_BT_AUTOSLEEPTOPOWEROFFTIME = "PS_BT_AUTOSLEEPTOPOWEROFFTIME";
        constexpr static const char * PS_BT_POWERSAVEMODE = "PS_BT_POWERSAVEMODE";
        constexpr static const char * PS_BT_ISDISCOVERABLE = "PS_BT_ISDISCOVERABLE";
        constexpr static const char * PS_BT_DEVICENAME = "PS_BT_DEVICENAME";
        constexpr static const char * PS_BT_PINCODE = "PS_BT_PINCODE";
        constexpr static const char * PS_BT_SSP = "PS_BT_SSP";
        constexpr static const char * PS_BT_PINCODE_ENABLE = "PS_BT_PINCODE_ENABLE";
        constexpr static const char * PS_BT_SECURITYMODE = "PS_BT_SECURITYMODE";
        constexpr static const char * PS_BT_BOOTMODE = "PS_BT_BOOTMODE";
        constexpr static const char * PS_BT_BLUETOOTH_TO_IRDA = "PS_BT_BLUETOOTH_TO_IRDA";
        constexpr static const char * PS_BT_BLUETOOTH_TO_NET = "PS_BT_BLUETOOTH_TO_NET";
        constexpr static const char * PS_BT_KEY = "PS_BT_KEY";
        constexpr static const char * PS_BT_AUTO_CONNECTION = "PS_BT_AUTO_CONNECTION";
        constexpr static const char * PS_BT_BOOTMODE_PJ = "PS_BT_BOOTMODE_PJ";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelSpecLegacyPrinterSettingCategoryBluetooth";
    };

    struct ModelSpecLegacyPrinterSettingCategoryNetwork {
      enum class Number {
        PS_NET_IPV6,
        PS_WIFI_IPV6,
        PS_WIFI_BOOTMODE,
        PS_WIFI_INTERFACE,
        PS_WIFI_WIRELESSDIRECT_BOOTMODE,
        PS_WIFI_SETTINGS,
        PS_WIFI_NODENAME,
        PS_LAN_SETTINGS,
        PS_LAN_NODENAME,
        PS_LAN_IPV6,
        PS_WIRELESSDIRECT_CREATE_KRY,
        PS_WIRELESSDIRECT_SETTINGS,
        __Null,
      };
      struct String {
        constexpr static const char * PS_NET_IPV6 = "PS_NET_IPV6";
        constexpr static const char * PS_WIFI_IPV6 = "PS_WIFI_IPV6";
        constexpr static const char * PS_WIFI_BOOTMODE = "PS_WIFI_BOOTMODE";
        constexpr static const char * PS_WIFI_INTERFACE = "PS_WIFI_INTERFACE";
        constexpr static const char * PS_WIFI_WIRELESSDIRECT_BOOTMODE = "PS_WIFI_WIRELESSDIRECT_BOOTMODE";
        constexpr static const char * PS_WIFI_SETTINGS = "PS_WIFI_SETTINGS";
        constexpr static const char * PS_WIFI_NODENAME = "PS_WIFI_NODENAME";
        constexpr static const char * PS_LAN_SETTINGS = "PS_LAN_SETTINGS";
        constexpr static const char * PS_LAN_NODENAME = "PS_LAN_NODENAME";
        constexpr static const char * PS_LAN_IPV6 = "PS_LAN_IPV6";
        constexpr static const char * PS_WIRELESSDIRECT_CREATE_KRY = "PS_WIRELESSDIRECT_CREATE_KRY";
        constexpr static const char * PS_WIRELESSDIRECT_SETTINGS = "PS_WIRELESSDIRECT_SETTINGS";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelSpecLegacyPrinterSettingCategoryNetwork";
    };

    struct ModelSpecLegacyPrinterSettingCategoryPower {
      enum class Number {
        PS_POWER_POWEROFFTIME,
        PS_POWER_POWEROFFTIME_BATTERY,
        PS_POWER_POWEROFFTIME_RJ2,
        PS_POWER_POWEROFFTIME_QL8,
        PS_POWER_POWEROFFTIME_BATTERY_QL8,
        PS_POWER_POWEROFFTIME_QL1100,
        PS_POWER_POWEROFFTIME_RJ4000a,
        PS_POWER_POWEROFFTIME_BATTERY_PJ8,
        PS_POWER_POWEROFFTIME_ModelFilter,
        PS_POWER_POWEROFFTIME_PowerSupplyFilter,
        __Null,
      };
      struct String {
        constexpr static const char * PS_POWER_POWEROFFTIME = "PS_POWER_POWEROFFTIME";
        constexpr static const char * PS_POWER_POWEROFFTIME_BATTERY = "PS_POWER_POWEROFFTIME_BATTERY";
        constexpr static const char * PS_POWER_POWEROFFTIME_RJ2 = "PS_POWER_POWEROFFTIME_RJ2";
        constexpr static const char * PS_POWER_POWEROFFTIME_QL8 = "PS_POWER_POWEROFFTIME_QL8";
        constexpr static const char * PS_POWER_POWEROFFTIME_BATTERY_QL8 = "PS_POWER_POWEROFFTIME_BATTERY_QL8";
        constexpr static const char * PS_POWER_POWEROFFTIME_QL1100 = "PS_POWER_POWEROFFTIME_QL1100";
        constexpr static const char * PS_POWER_POWEROFFTIME_RJ4000a = "PS_POWER_POWEROFFTIME_RJ4000a";
        constexpr static const char * PS_POWER_POWEROFFTIME_BATTERY_PJ8 = "PS_POWER_POWEROFFTIME_BATTERY_PJ8";
        constexpr static const char * PS_POWER_POWEROFFTIME_ModelFilter = "PS_POWER_POWEROFFTIME_ModelFilter";
        constexpr static const char * PS_POWER_POWEROFFTIME_PowerSupplyFilter = "PS_POWER_POWEROFFTIME_PowerSupplyFilter";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelSpecLegacyPrinterSettingCategoryPower";
    };

    struct ModelSpecLegacyPrinterSettingCategoryPrint {
      enum class Number {
        PS_PRINT_JPEG_HALFTONE,
        PS_PRINT_JPEG_SCALE,
        PS_PRINT_DENSITY,
        PS_PRINT_SPEED,
        __Null,
      };
      struct String {
        constexpr static const char * PS_PRINT_JPEG_HALFTONE = "PS_PRINT_JPEG_HALFTONE";
        constexpr static const char * PS_PRINT_JPEG_SCALE = "PS_PRINT_JPEG_SCALE";
        constexpr static const char * PS_PRINT_DENSITY = "PS_PRINT_DENSITY";
        constexpr static const char * PS_PRINT_SPEED = "PS_PRINT_SPEED";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelSpecLegacyPrinterSettingCategoryPrint";
    };

    struct ModelSpecLegacyPrintPageCommandType {
      enum class Number {
        PAGE_START_END,
        PAGE_START_NEXT_END,
        __Null,
      };
      struct String {
        constexpr static const char * PAGE_START_END = "PAGE_START_END";
        constexpr static const char * PAGE_START_NEXT_END = "PAGE_START_NEXT_END";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelSpecLegacyPrintPageCommandType";
    };

    struct ModelSpecLegacyPrintShouldDensityCommand {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacyPrintShouldDensityCommand";
    };

    struct ModelSpecLegacyPrintShouldPrinterInfoCommand {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacyPrintShouldPrinterInfoCommand";
    };

    struct ModelSpecLegacyPrintShouldSpaceCommand {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacyPrintShouldSpaceCommand";
    };

    struct ModelSpecLegacySeriesCode {
      using Number = int;
      constexpr static const char * key = "ModelSpecLegacySeriesCode";
    };

    struct ModelSpecLegacyStatusIndexOfPaperBackgroundColor {
      using Number = int;
      constexpr static const char * key = "ModelSpecLegacyStatusIndexOfPaperBackgroundColor";
    };

    struct ModelSpecLegacyStatusIndexOfPaperTextColor {
      using Number = int;
      constexpr static const char * key = "ModelSpecLegacyStatusIndexOfPaperTextColor";
    };

    struct ModelSpecLegacyStatusIndexOfTubeRibbon {
      using Number = int;
      constexpr static const char * key = "ModelSpecLegacyStatusIndexOfTubeRibbon";
    };

    struct ModelSpecLegacySupportAdjustPaperPosition {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacySupportAdjustPaperPosition";
    };

    struct ModelSpecLegacySupportAdvanceModeCommand {
      enum class Number {
        PS_AM_HALFCUT,
        PS_AM_CUTEND,
        PS_AM_SPECIALTAPE,
        PS_AM_HIGH_RESOLUTION,
        PS_AM_LABEL_CUTEND,
        PS_AM_NOBUFFER,
        PS_AM_LOW_RESOLUTION,
        __Null,
      };
      struct String {
        constexpr static const char * PS_AM_HALFCUT = "PS_AM_HALFCUT";
        constexpr static const char * PS_AM_CUTEND = "PS_AM_CUTEND";
        constexpr static const char * PS_AM_SPECIALTAPE = "PS_AM_SPECIALTAPE";
        constexpr static const char * PS_AM_HIGH_RESOLUTION = "PS_AM_HIGH_RESOLUTION";
        constexpr static const char * PS_AM_LABEL_CUTEND = "PS_AM_LABEL_CUTEND";
        constexpr static const char * PS_AM_NOBUFFER = "PS_AM_NOBUFFER";
        constexpr static const char * PS_AM_LOW_RESOLUTION = "PS_AM_LOW_RESOLUTION";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelSpecLegacySupportAdvanceModeCommand";
    };

    struct ModelSpecLegacySupportChangeDpi {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacySupportChangeDpi";
    };

    struct ModelSpecLegacySupportCommandProtocolVersion {
      using Number = int;
      constexpr static const char * key = "ModelSpecLegacySupportCommandProtocolVersion";
    };

    struct ModelSpecLegacySupportFunc {
      enum class Number {
        SP_FUC_RASTER_PRINT,
        SP_FUC_TEMPLATE_PRINT,
        SP_FUC_TEMPLATE_TRANS,
        SP_FUC_TEMPLATE_REMOVE,
        SP_FUC_PRINTER_SETTINGS,
        SP_FUC_FIRM_UPDATE,
        __Null,
      };
      struct String {
        constexpr static const char * SP_FUC_RASTER_PRINT = "SP_FUC_RASTER_PRINT";
        constexpr static const char * SP_FUC_TEMPLATE_PRINT = "SP_FUC_TEMPLATE_PRINT";
        constexpr static const char * SP_FUC_TEMPLATE_TRANS = "SP_FUC_TEMPLATE_TRANS";
        constexpr static const char * SP_FUC_TEMPLATE_REMOVE = "SP_FUC_TEMPLATE_REMOVE";
        constexpr static const char * SP_FUC_PRINTER_SETTINGS = "SP_FUC_PRINTER_SETTINGS";
        constexpr static const char * SP_FUC_FIRM_UPDATE = "SP_FUC_FIRM_UPDATE";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelSpecLegacySupportFunc";
    };

    struct ModelSpecLegacySupportGetBatteryWeak {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacySupportGetBatteryWeak";
    };

    struct ModelSpecLegacySupportGetMediaInfoVersion {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacySupportGetMediaInfoVersion";
    };

    struct ModelSpecLegacySupportGetSerialNumber {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacySupportGetSerialNumber";
    };

    struct ModelSpecLegacySupportMode9Compression {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacySupportMode9Compression";
    };

    struct ModelSpecLegacySupportMultiColorLabel {
      enum class Number {
        MONO_COLOR,
        BI_COLOR,
        UNSUPPORTED_COLOR,
        __Null,
      };
      struct String {
        constexpr static const char * MONO_COLOR = "MONO_COLOR";
        constexpr static const char * BI_COLOR = "BI_COLOR";
        constexpr static const char * UNSUPPORTED_COLOR = "UNSUPPORTED_COLOR";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelSpecLegacySupportMultiColorLabel";
    };

    struct ModelSpecLegacySupportPJFeedMode {
      enum class Number {
        FEED_MODE_FREE,
        FEED_MODE_FIXEDPAGE,
        FEED_MODE_ENDOFPAGE,
        FEED_MODE_ENDOFPAGERETRACT,
        __Null,
      };
      struct String {
        constexpr static const char * FEED_MODE_FREE = "FEED_MODE_FREE";
        constexpr static const char * FEED_MODE_FIXEDPAGE = "FEED_MODE_FIXEDPAGE";
        constexpr static const char * FEED_MODE_ENDOFPAGE = "FEED_MODE_ENDOFPAGE";
        constexpr static const char * FEED_MODE_ENDOFPAGERETRACT = "FEED_MODE_ENDOFPAGERETRACT";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelSpecLegacySupportPJFeedMode";
    };

    struct ModelSpecLegacySupportPJRollCase {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacySupportPJRollCase";
    };

    struct ModelSpecLegacySupportPJSpeedCommand {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacySupportPJSpeedCommand";
    };

    struct ModelSpecLegacySupportTube {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacySupportTube";
    };

    struct ModelSpecLegacySupportVariousModeCommand {
      enum class Number {
        PS_VM_AUTOCUT,
        PS_VM_MIRROR,
        PS_VM_PEEL,
        PS_VM_ROTATE180,
        PS_VM_CUTMARK,
        PS_FEEDVOL,
        __Null,
      };
      struct String {
        constexpr static const char * PS_VM_AUTOCUT = "PS_VM_AUTOCUT";
        constexpr static const char * PS_VM_MIRROR = "PS_VM_MIRROR";
        constexpr static const char * PS_VM_PEEL = "PS_VM_PEEL";
        constexpr static const char * PS_VM_ROTATE180 = "PS_VM_ROTATE180";
        constexpr static const char * PS_VM_CUTMARK = "PS_VM_CUTMARK";
        constexpr static const char * PS_FEEDVOL = "PS_FEEDVOL";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelSpecLegacySupportVariousModeCommand";
    };

    struct ModelSpecLegacyTemplateLimited {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacyTemplateLimited";
    };

    struct ModelSpecLegacyTemplateLimitedFirmName {
      using Number = std::string;
      constexpr static const char * key = "ModelSpecLegacyTemplateLimitedFirmName";
    };

    struct ModelSpecLegacyTemplateLimitedFirmType {
      using Number = int;
      constexpr static const char * key = "ModelSpecLegacyTemplateLimitedFirmType";
    };

    struct ModelSpecLegacyTemplateMaxObjectSize {
      using Number = int;
      constexpr static const char * key = "ModelSpecLegacyTemplateMaxObjectSize";
    };

    struct ModelSpecLegacyTemplateShouldChangeCommandMode {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacyTemplateShouldChangeCommandMode";
    };

    struct ModelSpecLegacyUSBDeviceProductID {
      using Number = int;
      constexpr static const char * key = "ModelSpecLegacyUSBDeviceProductID";
    };

    struct ModelSpecLegacyValidCommunicationBidirectional {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacyValidCommunicationBidirectional";
    };

    struct ModelSpecLegacyValidResponseAfterFirmUpdate {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacyValidResponseAfterFirmUpdate";
    };

    struct ModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty {
      using Number = bool;
      constexpr static const char * key = "ModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty";
    };

    struct ModelSpecLegacyXdpi {
      using Number = int;
      constexpr static const char * key = "ModelSpecLegacyXdpi";
    };

    struct ModelSpecLegacyYdpi {
      using Number = int;
      constexpr static const char * key = "ModelSpecLegacyYdpi";
    };

  }
}