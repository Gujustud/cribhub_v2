
#include "bf_element_print_definition.hpp"
#include <string>
#include <cstring>

namespace bf {
  namespace element {
    const char* PrintDensity::convertToString(Number num) {
      switch(num) {
        case Number::WeakLevel5: return String::WeakLevel5;
        case Number::WeakLevel4: return String::WeakLevel4;
        case Number::WeakLevel3: return String::WeakLevel3;
        case Number::WeakLevel2: return String::WeakLevel2;
        case Number::WeakLevel1: return String::WeakLevel1;
        case Number::Neutral: return String::Neutral;
        case Number::StrongLevel1: return String::StrongLevel1;
        case Number::StrongLevel2: return String::StrongLevel2;
        case Number::StrongLevel3: return String::StrongLevel3;
        case Number::StrongLevel4: return String::StrongLevel4;
        case Number::StrongLevel5: return String::StrongLevel5;
        case Number::UsePrinterSetting: return String::UsePrinterSetting;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    PrintDensity::Number PrintDensity::convertToNumber(const char* string) {
      if (!strcmp(string, String::WeakLevel5)) {
        return Number::WeakLevel5;
      }
      if (!strcmp(string, String::WeakLevel4)) {
        return Number::WeakLevel4;
      }
      if (!strcmp(string, String::WeakLevel3)) {
        return Number::WeakLevel3;
      }
      if (!strcmp(string, String::WeakLevel2)) {
        return Number::WeakLevel2;
      }
      if (!strcmp(string, String::WeakLevel1)) {
        return Number::WeakLevel1;
      }
      if (!strcmp(string, String::Neutral)) {
        return Number::Neutral;
      }
      if (!strcmp(string, String::StrongLevel1)) {
        return Number::StrongLevel1;
      }
      if (!strcmp(string, String::StrongLevel2)) {
        return Number::StrongLevel2;
      }
      if (!strcmp(string, String::StrongLevel3)) {
        return Number::StrongLevel3;
      }
      if (!strcmp(string, String::StrongLevel4)) {
        return Number::StrongLevel4;
      }
      if (!strcmp(string, String::StrongLevel5)) {
        return Number::StrongLevel5;
      }
      if (!strcmp(string, String::UsePrinterSetting)) {
        return Number::UsePrinterSetting;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* PrintFeedMode::convertToString(Number num) {
      switch(num) {
        case Number::NoFeed: return String::NoFeed;
        case Number::FixedPage: return String::FixedPage;
        case Number::EndOfPage: return String::EndOfPage;
        case Number::EndOfPageRetract: return String::EndOfPageRetract;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    PrintFeedMode::Number PrintFeedMode::convertToNumber(const char* string) {
      if (!strcmp(string, String::NoFeed)) {
        return Number::NoFeed;
      }
      if (!strcmp(string, String::FixedPage)) {
        return Number::FixedPage;
      }
      if (!strcmp(string, String::EndOfPage)) {
        return Number::EndOfPage;
      }
      if (!strcmp(string, String::EndOfPageRetract)) {
        return Number::EndOfPageRetract;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* PrintHorizontalAlign::convertToString(Number num) {
      switch(num) {
        case Number::Left: return String::Left;
        case Number::Center: return String::Center;
        case Number::Right: return String::Right;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    PrintHorizontalAlign::Number PrintHorizontalAlign::convertToNumber(const char* string) {
      if (!strcmp(string, String::Left)) {
        return Number::Left;
      }
      if (!strcmp(string, String::Center)) {
        return Number::Center;
      }
      if (!strcmp(string, String::Right)) {
        return Number::Right;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* PrintPolicyOfProcessingPrintData::convertToString(Number num) {
      switch(num) {
        case Number::BatchPrint: return String::BatchPrint;
        case Number::RealTimePrint: return String::RealTimePrint;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    PrintPolicyOfProcessingPrintData::Number PrintPolicyOfProcessingPrintData::convertToNumber(const char* string) {
      if (!strcmp(string, String::BatchPrint)) {
        return Number::BatchPrint;
      }
      if (!strcmp(string, String::RealTimePrint)) {
        return Number::RealTimePrint;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* PrintQuality::convertToString(Number num) {
      switch(num) {
        case Number::LowResolutionHighSpeed: return String::LowResolutionHighSpeed;
        case Number::NormalResolutionNormalSpeed: return String::NormalResolutionNormalSpeed;
        case Number::NormalResolutionDoubleSpeed: return String::NormalResolutionDoubleSpeed;
        case Number::HighResolutionLowSpeed: return String::HighResolutionLowSpeed;
        case Number::HighResolutionUsingHRImageLowSpeed: return String::HighResolutionUsingHRImageLowSpeed;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    PrintQuality::Number PrintQuality::convertToNumber(const char* string) {
      if (!strcmp(string, String::LowResolutionHighSpeed)) {
        return Number::LowResolutionHighSpeed;
      }
      if (!strcmp(string, String::NormalResolutionNormalSpeed)) {
        return Number::NormalResolutionNormalSpeed;
      }
      if (!strcmp(string, String::NormalResolutionDoubleSpeed)) {
        return Number::NormalResolutionDoubleSpeed;
      }
      if (!strcmp(string, String::HighResolutionLowSpeed)) {
        return Number::HighResolutionLowSpeed;
      }
      if (!strcmp(string, String::HighResolutionUsingHRImageLowSpeed)) {
        return Number::HighResolutionUsingHRImageLowSpeed;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* PrintScalingMode::convertToString(Number num) {
      switch(num) {
        case Number::Original: return String::Original;
        case Number::FitToPrintArea: return String::FitToPrintArea;
        case Number::FitToPaper: return String::FitToPaper;
        case Number::Custom: return String::Custom;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    PrintScalingMode::Number PrintScalingMode::convertToNumber(const char* string) {
      if (!strcmp(string, String::Original)) {
        return Number::Original;
      }
      if (!strcmp(string, String::FitToPrintArea)) {
        return Number::FitToPrintArea;
      }
      if (!strcmp(string, String::FitToPaper)) {
        return Number::FitToPaper;
      }
      if (!strcmp(string, String::Custom)) {
        return Number::Custom;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* PrintSpeed::convertToString(Number num) {
      switch(num) {
        case Number::HighSpeed: return String::HighSpeed;
        case Number::MediumHighSpeed: return String::MediumHighSpeed;
        case Number::MediumLowSpeed: return String::MediumLowSpeed;
        case Number::LowSpeed: return String::LowSpeed;
        case Number::Fast_DraftQuality: return String::Fast_DraftQuality;
        case Number::Fast_LineConversion: return String::Fast_LineConversion;
        case Number::UsePrinterSetting: return String::UsePrinterSetting;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    PrintSpeed::Number PrintSpeed::convertToNumber(const char* string) {
      if (!strcmp(string, String::HighSpeed)) {
        return Number::HighSpeed;
      }
      if (!strcmp(string, String::MediumHighSpeed)) {
        return Number::MediumHighSpeed;
      }
      if (!strcmp(string, String::MediumLowSpeed)) {
        return Number::MediumLowSpeed;
      }
      if (!strcmp(string, String::LowSpeed)) {
        return Number::LowSpeed;
      }
      if (!strcmp(string, String::Fast_DraftQuality)) {
        return Number::Fast_DraftQuality;
      }
      if (!strcmp(string, String::Fast_LineConversion)) {
        return Number::Fast_LineConversion;
      }
      if (!strcmp(string, String::UsePrinterSetting)) {
        return Number::UsePrinterSetting;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* PrintVerticalAlign::convertToString(Number num) {
      switch(num) {
        case Number::Top: return String::Top;
        case Number::Middle: return String::Middle;
        case Number::Bottom: return String::Bottom;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    PrintVerticalAlign::Number PrintVerticalAlign::convertToNumber(const char* string) {
      if (!strcmp(string, String::Top)) {
        return Number::Top;
      }
      if (!strcmp(string, String::Middle)) {
        return Number::Middle;
      }
      if (!strcmp(string, String::Bottom)) {
        return Number::Bottom;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

  }
}