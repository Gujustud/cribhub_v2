
#pragma once
#include <string>

namespace bf {
  namespace element {
    struct PrintAutoCutDisableForSpecialTape {
      using Number = bool;
      constexpr static const char * key = "PrintAutoCutDisableForSpecialTape";
    };

    struct PrintAutoCutEvery {
      using Number = bool;
      constexpr static const char * key = "PrintAutoCutEvery";
    };

    struct PrintAutoCutEveryCyclePerPage {
      using Number = int;
      constexpr static const char * key = "PrintAutoCutEveryCyclePerPage";
    };

    struct PrintAutoCutLast {
      using Number = bool;
      constexpr static const char * key = "PrintAutoCutLast";
    };

    struct PrintAutoHalfCut {
      using Number = bool;
      constexpr static const char * key = "PrintAutoHalfCut";
    };

    struct PrintBidirectionalCommunication {
      using Number = bool;
      constexpr static const char * key = "PrintBidirectionalCommunication";
    };

    struct PrintCheckMediaBackgroundColor {
      using Number = bool;
      constexpr static const char * key = "PrintCheckMediaBackgroundColor";
    };

    struct PrintCheckMediaTextColor {
      using Number = bool;
      constexpr static const char * key = "PrintCheckMediaTextColor";
    };

    struct PrintCollate {
      using Number = bool;
      constexpr static const char * key = "PrintCollate";
    };

    struct PrintCopies {
      using Number = int;
      constexpr static const char * key = "PrintCopies";
    };

    struct PrintCutPause {
      using Number = bool;
      constexpr static const char * key = "PrintCutPause";
    };

    struct PrintDashLine {
      using Number = bool;
      constexpr static const char * key = "PrintDashLine";
    };

    struct PrintDensity {
      enum class Number {
        WeakLevel5,
        WeakLevel4,
        WeakLevel3,
        WeakLevel2,
        WeakLevel1,
        Neutral,
        StrongLevel1,
        StrongLevel2,
        StrongLevel3,
        StrongLevel4,
        StrongLevel5,
        UsePrinterSetting,
        __Null,
      };
      struct String {
        constexpr static const char * WeakLevel5 = "WeakLevel5";
        constexpr static const char * WeakLevel4 = "WeakLevel4";
        constexpr static const char * WeakLevel3 = "WeakLevel3";
        constexpr static const char * WeakLevel2 = "WeakLevel2";
        constexpr static const char * WeakLevel1 = "WeakLevel1";
        constexpr static const char * Neutral = "Neutral";
        constexpr static const char * StrongLevel1 = "StrongLevel1";
        constexpr static const char * StrongLevel2 = "StrongLevel2";
        constexpr static const char * StrongLevel3 = "StrongLevel3";
        constexpr static const char * StrongLevel4 = "StrongLevel4";
        constexpr static const char * StrongLevel5 = "StrongLevel5";
        constexpr static const char * UsePrinterSetting = "UsePrinterSetting";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "PrintDensity";
    };

    struct PrintExtraFeedDots {
      using Number = int;
      constexpr static const char * key = "PrintExtraFeedDots";
    };

    struct PrintFeedMode {
      enum class Number {
        NoFeed,
        FixedPage,
        EndOfPage,
        EndOfPageRetract,
        __Null,
      };
      struct String {
        constexpr static const char * NoFeed = "NoFeed";
        constexpr static const char * FixedPage = "FixedPage";
        constexpr static const char * EndOfPage = "EndOfPage";
        constexpr static const char * EndOfPageRetract = "EndOfPageRetract";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "PrintFeedMode";
    };

    struct PrintHorizontalAlign {
      enum class Number {
        Left,
        Center,
        Right,
        __Null,
      };
      struct String {
        constexpr static const char * Left = "Left";
        constexpr static const char * Center = "Center";
        constexpr static const char * Right = "Right";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "PrintHorizontalAlign";
    };

    struct PrintLeftMargin {
      using Number = double;
      constexpr static const char * key = "PrintLeftMargin";
    };

    struct PrintPolicyOfProcessingPrintData {
      enum class Number {
        BatchPrint,
        RealTimePrint,
        __Null,
      };
      struct String {
        constexpr static const char * BatchPrint = "BatchPrint";
        constexpr static const char * RealTimePrint = "RealTimePrint";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "PrintPolicyOfProcessingPrintData";
    };

    struct PrintQuality {
      enum class Number {
        LowResolutionHighSpeed,
        NormalResolutionNormalSpeed,
        NormalResolutionDoubleSpeed,
        HighResolutionLowSpeed,
        HighResolutionUsingHRImageLowSpeed,
        __Null,
      };
      struct String {
        constexpr static const char * LowResolutionHighSpeed = "LowResolutionHighSpeed";
        constexpr static const char * NormalResolutionNormalSpeed = "NormalResolutionNormalSpeed";
        constexpr static const char * NormalResolutionDoubleSpeed = "NormalResolutionDoubleSpeed";
        constexpr static const char * HighResolutionLowSpeed = "HighResolutionLowSpeed";
        constexpr static const char * HighResolutionUsingHRImageLowSpeed = "HighResolutionUsingHRImageLowSpeed";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "PrintQuality";
    };

    struct PrintScalingMode {
      enum class Number {
        Original,
        FitToPrintArea,
        FitToPaper,
        Custom,
        __Null,
      };
      struct String {
        constexpr static const char * Original = "Original";
        constexpr static const char * FitToPrintArea = "FitToPrintArea";
        constexpr static const char * FitToPaper = "FitToPaper";
        constexpr static const char * Custom = "Custom";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "PrintScalingMode";
    };

    struct PrintScalingValue {
      using Number = double;
      constexpr static const char * key = "PrintScalingValue";
    };

    struct PrintSpeed {
      enum class Number {
        HighSpeed,
        MediumHighSpeed,
        MediumLowSpeed,
        LowSpeed,
        Fast_DraftQuality,
        Fast_LineConversion,
        UsePrinterSetting,
        __Null,
      };
      struct String {
        constexpr static const char * HighSpeed = "HighSpeed";
        constexpr static const char * MediumHighSpeed = "MediumHighSpeed";
        constexpr static const char * MediumLowSpeed = "MediumLowSpeed";
        constexpr static const char * LowSpeed = "LowSpeed";
        constexpr static const char * Fast_DraftQuality = "Fast_DraftQuality";
        constexpr static const char * Fast_LineConversion = "Fast_LineConversion";
        constexpr static const char * UsePrinterSetting = "UsePrinterSetting";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "PrintSpeed";
    };

    struct PrintTopMargin {
      using Number = double;
      constexpr static const char * key = "PrintTopMargin";
    };

    struct PrintUsingCarbonCopyPaper {
      using Number = bool;
      constexpr static const char * key = "PrintUsingCarbonCopyPaper";
    };

    struct PrintVerticalAlign {
      enum class Number {
        Top,
        Middle,
        Bottom,
        __Null,
      };
      struct String {
        constexpr static const char * Top = "Top";
        constexpr static const char * Middle = "Middle";
        constexpr static const char * Bottom = "Bottom";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "PrintVerticalAlign";
    };

  }
}