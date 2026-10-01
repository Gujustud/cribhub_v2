
#pragma once
#include <string>

namespace bf {
  namespace element_set {
    struct ModelSpecLegacy {
      enum class Number {
        ModelMajor,
        ModelInterface,
        ModelSpecLegacyBatteryCommandType,
        ModelSpecLegacyBitOrderOfBitmapIsLittle,
        ModelSpecLegacyChangeStatusMode,
        ModelSpecLegacyFirmUpdateShouldChangeCommandMode,
        ModelSpecLegacyGraphicCommandType,
        ModelSpecLegacyHeadPin,
        ModelSpecLegacyHeadPinWhenPrintTube,
        ModelSpecLegacyIgnorePaperEmptyWhenPrintEnd,
        ModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty,
        ModelSpecLegacyImageHalftoneShouldGammaAdjust,
        ModelSpecLegacyMainVersionCommandType,
        ModelSpecLegacyMediaSizeShouldCheck,
        ModelSpecLegacyMinPrintMerginPerTenthMM,
        ModelSpecLegacyMinPrintPaperLengthPerTenthMM,
        ModelSpecLegacyMode9CompressionMaxByteSize,
        ModelSpecLegacyMode9ShouldFlipHorizontal,
        ModelSpecLegacyModelCode,
        ModelSpecLegacyModelName,
        ModelSpecLegacyNullCommandLength,
        ModelSpecLegacyPageEndCommandType,
        ModelSpecLegacyPaperListKind,
        ModelSpecLegacyPrintCompressType,
        ModelSpecLegacyPrinterSettingCategoryBluetooth,
        ModelSpecLegacyPrinterSettingCategoryNetwork,
        ModelSpecLegacyPrinterSettingCategoryPower,
        ModelSpecLegacyPrinterSettingCategoryPrint,
        ModelSpecLegacyPrintPageCommandType,
        ModelSpecLegacyPrintShouldDensityCommand,
        ModelSpecLegacyPrintShouldPrinterInfoCommand,
        ModelSpecLegacyPrintShouldSpaceCommand,
        ModelSpecLegacySeriesCode,
        ModelSpecLegacyStatusIndexOfPaperBackgroundColor,
        ModelSpecLegacyStatusIndexOfPaperTextColor,
        ModelSpecLegacyStatusIndexOfTubeRibbon,
        ModelSpecLegacySupportAdjustPaperPosition,
        ModelSpecLegacySupportAdvanceModeCommand,
        ModelSpecLegacySupportChangeDpi,
        ModelSpecLegacySupportCommandProtocolVersion,
        ModelSpecLegacySupportFunc,
        ModelSpecLegacySupportGetBatteryWeak,
        ModelSpecLegacySupportGetMediaInfoVersion,
        ModelSpecLegacySupportGetSerialNumber,
        ModelSpecLegacySupportMode9Compression,
        ModelSpecLegacySupportMultiColorLabel,
        ModelSpecLegacySupportPJFeedMode,
        ModelSpecLegacySupportPJRollCase,
        ModelSpecLegacySupportPJSpeedCommand,
        ModelSpecLegacySupportTube,
        ModelSpecLegacySupportVariousModeCommand,
        ModelSpecLegacyTemplateLimited,
        ModelSpecLegacyTemplateLimitedFirmName,
        ModelSpecLegacyTemplateLimitedFirmType,
        ModelSpecLegacyTemplateMaxObjectSize,
        ModelSpecLegacyTemplateShouldChangeCommandMode,
        ModelSpecLegacyUSBDeviceProductID,
        ModelSpecLegacyValidCommunicationBidirectional,
        ModelSpecLegacyValidResponseAfterFirmUpdate,
        ModelSpecLegacyXdpi,
        ModelSpecLegacyYdpi,
        __Null,
      };
      struct String {
        constexpr static const char * ModelMajor = "ModelMajor";
        constexpr static const char * ModelInterface = "ModelInterface";
        constexpr static const char * ModelSpecLegacyBatteryCommandType = "ModelSpecLegacyBatteryCommandType";
        constexpr static const char * ModelSpecLegacyBitOrderOfBitmapIsLittle = "ModelSpecLegacyBitOrderOfBitmapIsLittle";
        constexpr static const char * ModelSpecLegacyChangeStatusMode = "ModelSpecLegacyChangeStatusMode";
        constexpr static const char * ModelSpecLegacyFirmUpdateShouldChangeCommandMode = "ModelSpecLegacyFirmUpdateShouldChangeCommandMode";
        constexpr static const char * ModelSpecLegacyGraphicCommandType = "ModelSpecLegacyGraphicCommandType";
        constexpr static const char * ModelSpecLegacyHeadPin = "ModelSpecLegacyHeadPin";
        constexpr static const char * ModelSpecLegacyHeadPinWhenPrintTube = "ModelSpecLegacyHeadPinWhenPrintTube";
        constexpr static const char * ModelSpecLegacyIgnorePaperEmptyWhenPrintEnd = "ModelSpecLegacyIgnorePaperEmptyWhenPrintEnd";
        constexpr static const char * ModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty = "ModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty";
        constexpr static const char * ModelSpecLegacyImageHalftoneShouldGammaAdjust = "ModelSpecLegacyImageHalftoneShouldGammaAdjust";
        constexpr static const char * ModelSpecLegacyMainVersionCommandType = "ModelSpecLegacyMainVersionCommandType";
        constexpr static const char * ModelSpecLegacyMediaSizeShouldCheck = "ModelSpecLegacyMediaSizeShouldCheck";
        constexpr static const char * ModelSpecLegacyMinPrintMerginPerTenthMM = "ModelSpecLegacyMinPrintMerginPerTenthMM";
        constexpr static const char * ModelSpecLegacyMinPrintPaperLengthPerTenthMM = "ModelSpecLegacyMinPrintPaperLengthPerTenthMM";
        constexpr static const char * ModelSpecLegacyMode9CompressionMaxByteSize = "ModelSpecLegacyMode9CompressionMaxByteSize";
        constexpr static const char * ModelSpecLegacyMode9ShouldFlipHorizontal = "ModelSpecLegacyMode9ShouldFlipHorizontal";
        constexpr static const char * ModelSpecLegacyModelCode = "ModelSpecLegacyModelCode";
        constexpr static const char * ModelSpecLegacyModelName = "ModelSpecLegacyModelName";
        constexpr static const char * ModelSpecLegacyNullCommandLength = "ModelSpecLegacyNullCommandLength";
        constexpr static const char * ModelSpecLegacyPageEndCommandType = "ModelSpecLegacyPageEndCommandType";
        constexpr static const char * ModelSpecLegacyPaperListKind = "ModelSpecLegacyPaperListKind";
        constexpr static const char * ModelSpecLegacyPrintCompressType = "ModelSpecLegacyPrintCompressType";
        constexpr static const char * ModelSpecLegacyPrinterSettingCategoryBluetooth = "ModelSpecLegacyPrinterSettingCategoryBluetooth";
        constexpr static const char * ModelSpecLegacyPrinterSettingCategoryNetwork = "ModelSpecLegacyPrinterSettingCategoryNetwork";
        constexpr static const char * ModelSpecLegacyPrinterSettingCategoryPower = "ModelSpecLegacyPrinterSettingCategoryPower";
        constexpr static const char * ModelSpecLegacyPrinterSettingCategoryPrint = "ModelSpecLegacyPrinterSettingCategoryPrint";
        constexpr static const char * ModelSpecLegacyPrintPageCommandType = "ModelSpecLegacyPrintPageCommandType";
        constexpr static const char * ModelSpecLegacyPrintShouldDensityCommand = "ModelSpecLegacyPrintShouldDensityCommand";
        constexpr static const char * ModelSpecLegacyPrintShouldPrinterInfoCommand = "ModelSpecLegacyPrintShouldPrinterInfoCommand";
        constexpr static const char * ModelSpecLegacyPrintShouldSpaceCommand = "ModelSpecLegacyPrintShouldSpaceCommand";
        constexpr static const char * ModelSpecLegacySeriesCode = "ModelSpecLegacySeriesCode";
        constexpr static const char * ModelSpecLegacyStatusIndexOfPaperBackgroundColor = "ModelSpecLegacyStatusIndexOfPaperBackgroundColor";
        constexpr static const char * ModelSpecLegacyStatusIndexOfPaperTextColor = "ModelSpecLegacyStatusIndexOfPaperTextColor";
        constexpr static const char * ModelSpecLegacyStatusIndexOfTubeRibbon = "ModelSpecLegacyStatusIndexOfTubeRibbon";
        constexpr static const char * ModelSpecLegacySupportAdjustPaperPosition = "ModelSpecLegacySupportAdjustPaperPosition";
        constexpr static const char * ModelSpecLegacySupportAdvanceModeCommand = "ModelSpecLegacySupportAdvanceModeCommand";
        constexpr static const char * ModelSpecLegacySupportChangeDpi = "ModelSpecLegacySupportChangeDpi";
        constexpr static const char * ModelSpecLegacySupportCommandProtocolVersion = "ModelSpecLegacySupportCommandProtocolVersion";
        constexpr static const char * ModelSpecLegacySupportFunc = "ModelSpecLegacySupportFunc";
        constexpr static const char * ModelSpecLegacySupportGetBatteryWeak = "ModelSpecLegacySupportGetBatteryWeak";
        constexpr static const char * ModelSpecLegacySupportGetMediaInfoVersion = "ModelSpecLegacySupportGetMediaInfoVersion";
        constexpr static const char * ModelSpecLegacySupportGetSerialNumber = "ModelSpecLegacySupportGetSerialNumber";
        constexpr static const char * ModelSpecLegacySupportMode9Compression = "ModelSpecLegacySupportMode9Compression";
        constexpr static const char * ModelSpecLegacySupportMultiColorLabel = "ModelSpecLegacySupportMultiColorLabel";
        constexpr static const char * ModelSpecLegacySupportPJFeedMode = "ModelSpecLegacySupportPJFeedMode";
        constexpr static const char * ModelSpecLegacySupportPJRollCase = "ModelSpecLegacySupportPJRollCase";
        constexpr static const char * ModelSpecLegacySupportPJSpeedCommand = "ModelSpecLegacySupportPJSpeedCommand";
        constexpr static const char * ModelSpecLegacySupportTube = "ModelSpecLegacySupportTube";
        constexpr static const char * ModelSpecLegacySupportVariousModeCommand = "ModelSpecLegacySupportVariousModeCommand";
        constexpr static const char * ModelSpecLegacyTemplateLimited = "ModelSpecLegacyTemplateLimited";
        constexpr static const char * ModelSpecLegacyTemplateLimitedFirmName = "ModelSpecLegacyTemplateLimitedFirmName";
        constexpr static const char * ModelSpecLegacyTemplateLimitedFirmType = "ModelSpecLegacyTemplateLimitedFirmType";
        constexpr static const char * ModelSpecLegacyTemplateMaxObjectSize = "ModelSpecLegacyTemplateMaxObjectSize";
        constexpr static const char * ModelSpecLegacyTemplateShouldChangeCommandMode = "ModelSpecLegacyTemplateShouldChangeCommandMode";
        constexpr static const char * ModelSpecLegacyUSBDeviceProductID = "ModelSpecLegacyUSBDeviceProductID";
        constexpr static const char * ModelSpecLegacyValidCommunicationBidirectional = "ModelSpecLegacyValidCommunicationBidirectional";
        constexpr static const char * ModelSpecLegacyValidResponseAfterFirmUpdate = "ModelSpecLegacyValidResponseAfterFirmUpdate";
        constexpr static const char * ModelSpecLegacyXdpi = "ModelSpecLegacyXdpi";
        constexpr static const char * ModelSpecLegacyYdpi = "ModelSpecLegacyYdpi";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelSpecLegacy";
    };

  }
}