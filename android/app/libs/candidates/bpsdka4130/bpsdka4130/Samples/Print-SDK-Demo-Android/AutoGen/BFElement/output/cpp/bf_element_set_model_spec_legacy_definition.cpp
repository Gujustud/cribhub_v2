
#include "bf_element_set_model_spec_legacy_definition.hpp"
#include <string>
#include <cstring>

namespace bf {
  namespace element_set {
    const char* ModelSpecLegacy::convertToString(Number num) {
      switch(num) {
        case Number::ModelMajor: return String::ModelMajor;
        case Number::ModelInterface: return String::ModelInterface;
        case Number::ModelSpecLegacyBatteryCommandType: return String::ModelSpecLegacyBatteryCommandType;
        case Number::ModelSpecLegacyBitOrderOfBitmapIsLittle: return String::ModelSpecLegacyBitOrderOfBitmapIsLittle;
        case Number::ModelSpecLegacyChangeStatusMode: return String::ModelSpecLegacyChangeStatusMode;
        case Number::ModelSpecLegacyFirmUpdateShouldChangeCommandMode: return String::ModelSpecLegacyFirmUpdateShouldChangeCommandMode;
        case Number::ModelSpecLegacyGraphicCommandType: return String::ModelSpecLegacyGraphicCommandType;
        case Number::ModelSpecLegacyHeadPin: return String::ModelSpecLegacyHeadPin;
        case Number::ModelSpecLegacyHeadPinWhenPrintTube: return String::ModelSpecLegacyHeadPinWhenPrintTube;
        case Number::ModelSpecLegacyIgnorePaperEmptyWhenPrintEnd: return String::ModelSpecLegacyIgnorePaperEmptyWhenPrintEnd;
        case Number::ModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty: return String::ModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty;
        case Number::ModelSpecLegacyImageHalftoneShouldGammaAdjust: return String::ModelSpecLegacyImageHalftoneShouldGammaAdjust;
        case Number::ModelSpecLegacyMainVersionCommandType: return String::ModelSpecLegacyMainVersionCommandType;
        case Number::ModelSpecLegacyMediaSizeShouldCheck: return String::ModelSpecLegacyMediaSizeShouldCheck;
        case Number::ModelSpecLegacyMinPrintMerginPerTenthMM: return String::ModelSpecLegacyMinPrintMerginPerTenthMM;
        case Number::ModelSpecLegacyMinPrintPaperLengthPerTenthMM: return String::ModelSpecLegacyMinPrintPaperLengthPerTenthMM;
        case Number::ModelSpecLegacyMode9CompressionMaxByteSize: return String::ModelSpecLegacyMode9CompressionMaxByteSize;
        case Number::ModelSpecLegacyMode9ShouldFlipHorizontal: return String::ModelSpecLegacyMode9ShouldFlipHorizontal;
        case Number::ModelSpecLegacyModelCode: return String::ModelSpecLegacyModelCode;
        case Number::ModelSpecLegacyModelName: return String::ModelSpecLegacyModelName;
        case Number::ModelSpecLegacyNullCommandLength: return String::ModelSpecLegacyNullCommandLength;
        case Number::ModelSpecLegacyPageEndCommandType: return String::ModelSpecLegacyPageEndCommandType;
        case Number::ModelSpecLegacyPaperListKind: return String::ModelSpecLegacyPaperListKind;
        case Number::ModelSpecLegacyPrintCompressType: return String::ModelSpecLegacyPrintCompressType;
        case Number::ModelSpecLegacyPrinterSettingCategoryBluetooth: return String::ModelSpecLegacyPrinterSettingCategoryBluetooth;
        case Number::ModelSpecLegacyPrinterSettingCategoryNetwork: return String::ModelSpecLegacyPrinterSettingCategoryNetwork;
        case Number::ModelSpecLegacyPrinterSettingCategoryPower: return String::ModelSpecLegacyPrinterSettingCategoryPower;
        case Number::ModelSpecLegacyPrinterSettingCategoryPrint: return String::ModelSpecLegacyPrinterSettingCategoryPrint;
        case Number::ModelSpecLegacyPrintPageCommandType: return String::ModelSpecLegacyPrintPageCommandType;
        case Number::ModelSpecLegacyPrintShouldDensityCommand: return String::ModelSpecLegacyPrintShouldDensityCommand;
        case Number::ModelSpecLegacyPrintShouldPrinterInfoCommand: return String::ModelSpecLegacyPrintShouldPrinterInfoCommand;
        case Number::ModelSpecLegacyPrintShouldSpaceCommand: return String::ModelSpecLegacyPrintShouldSpaceCommand;
        case Number::ModelSpecLegacySeriesCode: return String::ModelSpecLegacySeriesCode;
        case Number::ModelSpecLegacyStatusIndexOfPaperBackgroundColor: return String::ModelSpecLegacyStatusIndexOfPaperBackgroundColor;
        case Number::ModelSpecLegacyStatusIndexOfPaperTextColor: return String::ModelSpecLegacyStatusIndexOfPaperTextColor;
        case Number::ModelSpecLegacyStatusIndexOfTubeRibbon: return String::ModelSpecLegacyStatusIndexOfTubeRibbon;
        case Number::ModelSpecLegacySupportAdjustPaperPosition: return String::ModelSpecLegacySupportAdjustPaperPosition;
        case Number::ModelSpecLegacySupportAdvanceModeCommand: return String::ModelSpecLegacySupportAdvanceModeCommand;
        case Number::ModelSpecLegacySupportChangeDpi: return String::ModelSpecLegacySupportChangeDpi;
        case Number::ModelSpecLegacySupportCommandProtocolVersion: return String::ModelSpecLegacySupportCommandProtocolVersion;
        case Number::ModelSpecLegacySupportFunc: return String::ModelSpecLegacySupportFunc;
        case Number::ModelSpecLegacySupportGetBatteryWeak: return String::ModelSpecLegacySupportGetBatteryWeak;
        case Number::ModelSpecLegacySupportGetMediaInfoVersion: return String::ModelSpecLegacySupportGetMediaInfoVersion;
        case Number::ModelSpecLegacySupportGetSerialNumber: return String::ModelSpecLegacySupportGetSerialNumber;
        case Number::ModelSpecLegacySupportMode9Compression: return String::ModelSpecLegacySupportMode9Compression;
        case Number::ModelSpecLegacySupportMultiColorLabel: return String::ModelSpecLegacySupportMultiColorLabel;
        case Number::ModelSpecLegacySupportPJFeedMode: return String::ModelSpecLegacySupportPJFeedMode;
        case Number::ModelSpecLegacySupportPJRollCase: return String::ModelSpecLegacySupportPJRollCase;
        case Number::ModelSpecLegacySupportPJSpeedCommand: return String::ModelSpecLegacySupportPJSpeedCommand;
        case Number::ModelSpecLegacySupportTube: return String::ModelSpecLegacySupportTube;
        case Number::ModelSpecLegacySupportVariousModeCommand: return String::ModelSpecLegacySupportVariousModeCommand;
        case Number::ModelSpecLegacyTemplateLimited: return String::ModelSpecLegacyTemplateLimited;
        case Number::ModelSpecLegacyTemplateLimitedFirmName: return String::ModelSpecLegacyTemplateLimitedFirmName;
        case Number::ModelSpecLegacyTemplateLimitedFirmType: return String::ModelSpecLegacyTemplateLimitedFirmType;
        case Number::ModelSpecLegacyTemplateMaxObjectSize: return String::ModelSpecLegacyTemplateMaxObjectSize;
        case Number::ModelSpecLegacyTemplateShouldChangeCommandMode: return String::ModelSpecLegacyTemplateShouldChangeCommandMode;
        case Number::ModelSpecLegacyUSBDeviceProductID: return String::ModelSpecLegacyUSBDeviceProductID;
        case Number::ModelSpecLegacyValidCommunicationBidirectional: return String::ModelSpecLegacyValidCommunicationBidirectional;
        case Number::ModelSpecLegacyValidResponseAfterFirmUpdate: return String::ModelSpecLegacyValidResponseAfterFirmUpdate;
        case Number::ModelSpecLegacyXdpi: return String::ModelSpecLegacyXdpi;
        case Number::ModelSpecLegacyYdpi: return String::ModelSpecLegacyYdpi;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelSpecLegacy::Number ModelSpecLegacy::convertToNumber(const char* string) {
      if (!strcmp(string, String::ModelMajor)) {
        return Number::ModelMajor;
      }
      if (!strcmp(string, String::ModelInterface)) {
        return Number::ModelInterface;
      }
      if (!strcmp(string, String::ModelSpecLegacyBatteryCommandType)) {
        return Number::ModelSpecLegacyBatteryCommandType;
      }
      if (!strcmp(string, String::ModelSpecLegacyBitOrderOfBitmapIsLittle)) {
        return Number::ModelSpecLegacyBitOrderOfBitmapIsLittle;
      }
      if (!strcmp(string, String::ModelSpecLegacyChangeStatusMode)) {
        return Number::ModelSpecLegacyChangeStatusMode;
      }
      if (!strcmp(string, String::ModelSpecLegacyFirmUpdateShouldChangeCommandMode)) {
        return Number::ModelSpecLegacyFirmUpdateShouldChangeCommandMode;
      }
      if (!strcmp(string, String::ModelSpecLegacyGraphicCommandType)) {
        return Number::ModelSpecLegacyGraphicCommandType;
      }
      if (!strcmp(string, String::ModelSpecLegacyHeadPin)) {
        return Number::ModelSpecLegacyHeadPin;
      }
      if (!strcmp(string, String::ModelSpecLegacyHeadPinWhenPrintTube)) {
        return Number::ModelSpecLegacyHeadPinWhenPrintTube;
      }
      if (!strcmp(string, String::ModelSpecLegacyIgnorePaperEmptyWhenPrintEnd)) {
        return Number::ModelSpecLegacyIgnorePaperEmptyWhenPrintEnd;
      }
      if (!strcmp(string, String::ModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty)) {
        return Number::ModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty;
      }
      if (!strcmp(string, String::ModelSpecLegacyImageHalftoneShouldGammaAdjust)) {
        return Number::ModelSpecLegacyImageHalftoneShouldGammaAdjust;
      }
      if (!strcmp(string, String::ModelSpecLegacyMainVersionCommandType)) {
        return Number::ModelSpecLegacyMainVersionCommandType;
      }
      if (!strcmp(string, String::ModelSpecLegacyMediaSizeShouldCheck)) {
        return Number::ModelSpecLegacyMediaSizeShouldCheck;
      }
      if (!strcmp(string, String::ModelSpecLegacyMinPrintMerginPerTenthMM)) {
        return Number::ModelSpecLegacyMinPrintMerginPerTenthMM;
      }
      if (!strcmp(string, String::ModelSpecLegacyMinPrintPaperLengthPerTenthMM)) {
        return Number::ModelSpecLegacyMinPrintPaperLengthPerTenthMM;
      }
      if (!strcmp(string, String::ModelSpecLegacyMode9CompressionMaxByteSize)) {
        return Number::ModelSpecLegacyMode9CompressionMaxByteSize;
      }
      if (!strcmp(string, String::ModelSpecLegacyMode9ShouldFlipHorizontal)) {
        return Number::ModelSpecLegacyMode9ShouldFlipHorizontal;
      }
      if (!strcmp(string, String::ModelSpecLegacyModelCode)) {
        return Number::ModelSpecLegacyModelCode;
      }
      if (!strcmp(string, String::ModelSpecLegacyModelName)) {
        return Number::ModelSpecLegacyModelName;
      }
      if (!strcmp(string, String::ModelSpecLegacyNullCommandLength)) {
        return Number::ModelSpecLegacyNullCommandLength;
      }
      if (!strcmp(string, String::ModelSpecLegacyPageEndCommandType)) {
        return Number::ModelSpecLegacyPageEndCommandType;
      }
      if (!strcmp(string, String::ModelSpecLegacyPaperListKind)) {
        return Number::ModelSpecLegacyPaperListKind;
      }
      if (!strcmp(string, String::ModelSpecLegacyPrintCompressType)) {
        return Number::ModelSpecLegacyPrintCompressType;
      }
      if (!strcmp(string, String::ModelSpecLegacyPrinterSettingCategoryBluetooth)) {
        return Number::ModelSpecLegacyPrinterSettingCategoryBluetooth;
      }
      if (!strcmp(string, String::ModelSpecLegacyPrinterSettingCategoryNetwork)) {
        return Number::ModelSpecLegacyPrinterSettingCategoryNetwork;
      }
      if (!strcmp(string, String::ModelSpecLegacyPrinterSettingCategoryPower)) {
        return Number::ModelSpecLegacyPrinterSettingCategoryPower;
      }
      if (!strcmp(string, String::ModelSpecLegacyPrinterSettingCategoryPrint)) {
        return Number::ModelSpecLegacyPrinterSettingCategoryPrint;
      }
      if (!strcmp(string, String::ModelSpecLegacyPrintPageCommandType)) {
        return Number::ModelSpecLegacyPrintPageCommandType;
      }
      if (!strcmp(string, String::ModelSpecLegacyPrintShouldDensityCommand)) {
        return Number::ModelSpecLegacyPrintShouldDensityCommand;
      }
      if (!strcmp(string, String::ModelSpecLegacyPrintShouldPrinterInfoCommand)) {
        return Number::ModelSpecLegacyPrintShouldPrinterInfoCommand;
      }
      if (!strcmp(string, String::ModelSpecLegacyPrintShouldSpaceCommand)) {
        return Number::ModelSpecLegacyPrintShouldSpaceCommand;
      }
      if (!strcmp(string, String::ModelSpecLegacySeriesCode)) {
        return Number::ModelSpecLegacySeriesCode;
      }
      if (!strcmp(string, String::ModelSpecLegacyStatusIndexOfPaperBackgroundColor)) {
        return Number::ModelSpecLegacyStatusIndexOfPaperBackgroundColor;
      }
      if (!strcmp(string, String::ModelSpecLegacyStatusIndexOfPaperTextColor)) {
        return Number::ModelSpecLegacyStatusIndexOfPaperTextColor;
      }
      if (!strcmp(string, String::ModelSpecLegacyStatusIndexOfTubeRibbon)) {
        return Number::ModelSpecLegacyStatusIndexOfTubeRibbon;
      }
      if (!strcmp(string, String::ModelSpecLegacySupportAdjustPaperPosition)) {
        return Number::ModelSpecLegacySupportAdjustPaperPosition;
      }
      if (!strcmp(string, String::ModelSpecLegacySupportAdvanceModeCommand)) {
        return Number::ModelSpecLegacySupportAdvanceModeCommand;
      }
      if (!strcmp(string, String::ModelSpecLegacySupportChangeDpi)) {
        return Number::ModelSpecLegacySupportChangeDpi;
      }
      if (!strcmp(string, String::ModelSpecLegacySupportCommandProtocolVersion)) {
        return Number::ModelSpecLegacySupportCommandProtocolVersion;
      }
      if (!strcmp(string, String::ModelSpecLegacySupportFunc)) {
        return Number::ModelSpecLegacySupportFunc;
      }
      if (!strcmp(string, String::ModelSpecLegacySupportGetBatteryWeak)) {
        return Number::ModelSpecLegacySupportGetBatteryWeak;
      }
      if (!strcmp(string, String::ModelSpecLegacySupportGetMediaInfoVersion)) {
        return Number::ModelSpecLegacySupportGetMediaInfoVersion;
      }
      if (!strcmp(string, String::ModelSpecLegacySupportGetSerialNumber)) {
        return Number::ModelSpecLegacySupportGetSerialNumber;
      }
      if (!strcmp(string, String::ModelSpecLegacySupportMode9Compression)) {
        return Number::ModelSpecLegacySupportMode9Compression;
      }
      if (!strcmp(string, String::ModelSpecLegacySupportMultiColorLabel)) {
        return Number::ModelSpecLegacySupportMultiColorLabel;
      }
      if (!strcmp(string, String::ModelSpecLegacySupportPJFeedMode)) {
        return Number::ModelSpecLegacySupportPJFeedMode;
      }
      if (!strcmp(string, String::ModelSpecLegacySupportPJRollCase)) {
        return Number::ModelSpecLegacySupportPJRollCase;
      }
      if (!strcmp(string, String::ModelSpecLegacySupportPJSpeedCommand)) {
        return Number::ModelSpecLegacySupportPJSpeedCommand;
      }
      if (!strcmp(string, String::ModelSpecLegacySupportTube)) {
        return Number::ModelSpecLegacySupportTube;
      }
      if (!strcmp(string, String::ModelSpecLegacySupportVariousModeCommand)) {
        return Number::ModelSpecLegacySupportVariousModeCommand;
      }
      if (!strcmp(string, String::ModelSpecLegacyTemplateLimited)) {
        return Number::ModelSpecLegacyTemplateLimited;
      }
      if (!strcmp(string, String::ModelSpecLegacyTemplateLimitedFirmName)) {
        return Number::ModelSpecLegacyTemplateLimitedFirmName;
      }
      if (!strcmp(string, String::ModelSpecLegacyTemplateLimitedFirmType)) {
        return Number::ModelSpecLegacyTemplateLimitedFirmType;
      }
      if (!strcmp(string, String::ModelSpecLegacyTemplateMaxObjectSize)) {
        return Number::ModelSpecLegacyTemplateMaxObjectSize;
      }
      if (!strcmp(string, String::ModelSpecLegacyTemplateShouldChangeCommandMode)) {
        return Number::ModelSpecLegacyTemplateShouldChangeCommandMode;
      }
      if (!strcmp(string, String::ModelSpecLegacyUSBDeviceProductID)) {
        return Number::ModelSpecLegacyUSBDeviceProductID;
      }
      if (!strcmp(string, String::ModelSpecLegacyValidCommunicationBidirectional)) {
        return Number::ModelSpecLegacyValidCommunicationBidirectional;
      }
      if (!strcmp(string, String::ModelSpecLegacyValidResponseAfterFirmUpdate)) {
        return Number::ModelSpecLegacyValidResponseAfterFirmUpdate;
      }
      if (!strcmp(string, String::ModelSpecLegacyXdpi)) {
        return Number::ModelSpecLegacyXdpi;
      }
      if (!strcmp(string, String::ModelSpecLegacyYdpi)) {
        return Number::ModelSpecLegacyYdpi;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

  }
}