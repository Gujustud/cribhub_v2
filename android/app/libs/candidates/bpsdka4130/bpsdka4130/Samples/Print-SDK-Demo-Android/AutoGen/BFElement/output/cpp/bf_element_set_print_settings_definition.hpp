
#pragma once
#include <string>

namespace bf {
  namespace element_set {
    struct PrintSettings {
      enum class Number {
        MediaSize,
        ImageOrientation,
        PrintScalingMode,
        ImageHalftone,
        ImageBrightness,
        ImageContrast,
        ImageRedEnhancement,
        ImageGreenEnhancement,
        ImageBlueEnhancement,
        PrintHorizontalAlign,
        PrintVerticalAlign,
        PrintTopMargin,
        PrintLeftMargin,
        MediaTextColor,
        MediaBackgroundColor,
        PrintScalingValue,
        PrintAutoCutLast,
        PrintAutoCutEvery,
        PrintAutoCutEveryCyclePerPage,
        PrintAutoCutDisableForSpecialTape,
        PrintAutoHalfCut,
        PrintDensity,
        PrintSpeed,
        PrintDashLine,
        PrintUsingCarbonCopyPaper,
        PrintFeedMode,
        PrintQuality,
        MediaPJRollCase,
        MediaPaperInsertionPosition,
        MediaPJPaperType,
        MediaPJCustomSize,
        MediaPJForceStretchPrintableArea,
        PrintExtraFeedDots,
        PrintCopies,
        PrintBidirectionalCommunication,
        ImageTrimBlankDataFromTail,
        PrintPolicyOfProcessingPrintData,
        PrintCollate,
        PrintCheckMediaTextColor,
        PrintCheckMediaBackgroundColor,
        PrintCutPause,
        __Null,
      };
      struct String {
        constexpr static const char * MediaSize = "MediaSize";
        constexpr static const char * ImageOrientation = "ImageOrientation";
        constexpr static const char * PrintScalingMode = "PrintScalingMode";
        constexpr static const char * ImageHalftone = "ImageHalftone";
        constexpr static const char * ImageBrightness = "ImageBrightness";
        constexpr static const char * ImageContrast = "ImageContrast";
        constexpr static const char * ImageRedEnhancement = "ImageRedEnhancement";
        constexpr static const char * ImageGreenEnhancement = "ImageGreenEnhancement";
        constexpr static const char * ImageBlueEnhancement = "ImageBlueEnhancement";
        constexpr static const char * PrintHorizontalAlign = "PrintHorizontalAlign";
        constexpr static const char * PrintVerticalAlign = "PrintVerticalAlign";
        constexpr static const char * PrintTopMargin = "PrintTopMargin";
        constexpr static const char * PrintLeftMargin = "PrintLeftMargin";
        constexpr static const char * MediaTextColor = "MediaTextColor";
        constexpr static const char * MediaBackgroundColor = "MediaBackgroundColor";
        constexpr static const char * PrintScalingValue = "PrintScalingValue";
        constexpr static const char * PrintAutoCutLast = "PrintAutoCutLast";
        constexpr static const char * PrintAutoCutEvery = "PrintAutoCutEvery";
        constexpr static const char * PrintAutoCutEveryCyclePerPage = "PrintAutoCutEveryCyclePerPage";
        constexpr static const char * PrintAutoCutDisableForSpecialTape = "PrintAutoCutDisableForSpecialTape";
        constexpr static const char * PrintAutoHalfCut = "PrintAutoHalfCut";
        constexpr static const char * PrintDensity = "PrintDensity";
        constexpr static const char * PrintSpeed = "PrintSpeed";
        constexpr static const char * PrintDashLine = "PrintDashLine";
        constexpr static const char * PrintUsingCarbonCopyPaper = "PrintUsingCarbonCopyPaper";
        constexpr static const char * PrintFeedMode = "PrintFeedMode";
        constexpr static const char * PrintQuality = "PrintQuality";
        constexpr static const char * MediaPJRollCase = "MediaPJRollCase";
        constexpr static const char * MediaPaperInsertionPosition = "MediaPaperInsertionPosition";
        constexpr static const char * MediaPJPaperType = "MediaPJPaperType";
        constexpr static const char * MediaPJCustomSize = "MediaPJCustomSize";
        constexpr static const char * MediaPJForceStretchPrintableArea = "MediaPJForceStretchPrintableArea";
        constexpr static const char * PrintExtraFeedDots = "PrintExtraFeedDots";
        constexpr static const char * PrintCopies = "PrintCopies";
        constexpr static const char * PrintBidirectionalCommunication = "PrintBidirectionalCommunication";
        constexpr static const char * ImageTrimBlankDataFromTail = "ImageTrimBlankDataFromTail";
        constexpr static const char * PrintPolicyOfProcessingPrintData = "PrintPolicyOfProcessingPrintData";
        constexpr static const char * PrintCollate = "PrintCollate";
        constexpr static const char * PrintCheckMediaTextColor = "PrintCheckMediaTextColor";
        constexpr static const char * PrintCheckMediaBackgroundColor = "PrintCheckMediaBackgroundColor";
        constexpr static const char * PrintCutPause = "PrintCutPause";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "PrintSettings";
    };

  }
}