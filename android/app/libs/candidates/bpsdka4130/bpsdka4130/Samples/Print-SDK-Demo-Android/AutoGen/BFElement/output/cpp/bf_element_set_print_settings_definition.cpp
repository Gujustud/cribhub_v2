
#include "bf_element_set_print_settings_definition.hpp"
#include <string>
#include <cstring>

namespace bf {
  namespace element_set {
    const char* PrintSettings::convertToString(Number num) {
      switch(num) {
        case Number::MediaSize: return String::MediaSize;
        case Number::ImageOrientation: return String::ImageOrientation;
        case Number::PrintScalingMode: return String::PrintScalingMode;
        case Number::ImageHalftone: return String::ImageHalftone;
        case Number::ImageBrightness: return String::ImageBrightness;
        case Number::ImageContrast: return String::ImageContrast;
        case Number::ImageRedEnhancement: return String::ImageRedEnhancement;
        case Number::ImageGreenEnhancement: return String::ImageGreenEnhancement;
        case Number::ImageBlueEnhancement: return String::ImageBlueEnhancement;
        case Number::PrintHorizontalAlign: return String::PrintHorizontalAlign;
        case Number::PrintVerticalAlign: return String::PrintVerticalAlign;
        case Number::PrintTopMargin: return String::PrintTopMargin;
        case Number::PrintLeftMargin: return String::PrintLeftMargin;
        case Number::MediaTextColor: return String::MediaTextColor;
        case Number::MediaBackgroundColor: return String::MediaBackgroundColor;
        case Number::PrintScalingValue: return String::PrintScalingValue;
        case Number::PrintAutoCutLast: return String::PrintAutoCutLast;
        case Number::PrintAutoCutEvery: return String::PrintAutoCutEvery;
        case Number::PrintAutoCutEveryCyclePerPage: return String::PrintAutoCutEveryCyclePerPage;
        case Number::PrintAutoCutDisableForSpecialTape: return String::PrintAutoCutDisableForSpecialTape;
        case Number::PrintAutoHalfCut: return String::PrintAutoHalfCut;
        case Number::PrintDensity: return String::PrintDensity;
        case Number::PrintSpeed: return String::PrintSpeed;
        case Number::PrintDashLine: return String::PrintDashLine;
        case Number::PrintUsingCarbonCopyPaper: return String::PrintUsingCarbonCopyPaper;
        case Number::PrintFeedMode: return String::PrintFeedMode;
        case Number::PrintQuality: return String::PrintQuality;
        case Number::MediaPJRollCase: return String::MediaPJRollCase;
        case Number::MediaPaperInsertionPosition: return String::MediaPaperInsertionPosition;
        case Number::MediaPJPaperType: return String::MediaPJPaperType;
        case Number::MediaPJCustomSize: return String::MediaPJCustomSize;
        case Number::MediaPJForceStretchPrintableArea: return String::MediaPJForceStretchPrintableArea;
        case Number::PrintExtraFeedDots: return String::PrintExtraFeedDots;
        case Number::PrintCopies: return String::PrintCopies;
        case Number::PrintBidirectionalCommunication: return String::PrintBidirectionalCommunication;
        case Number::ImageTrimBlankDataFromTail: return String::ImageTrimBlankDataFromTail;
        case Number::PrintPolicyOfProcessingPrintData: return String::PrintPolicyOfProcessingPrintData;
        case Number::PrintCollate: return String::PrintCollate;
        case Number::PrintCheckMediaTextColor: return String::PrintCheckMediaTextColor;
        case Number::PrintCheckMediaBackgroundColor: return String::PrintCheckMediaBackgroundColor;
        case Number::PrintCutPause: return String::PrintCutPause;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    PrintSettings::Number PrintSettings::convertToNumber(const char* string) {
      if (!strcmp(string, String::MediaSize)) {
        return Number::MediaSize;
      }
      if (!strcmp(string, String::ImageOrientation)) {
        return Number::ImageOrientation;
      }
      if (!strcmp(string, String::PrintScalingMode)) {
        return Number::PrintScalingMode;
      }
      if (!strcmp(string, String::ImageHalftone)) {
        return Number::ImageHalftone;
      }
      if (!strcmp(string, String::ImageBrightness)) {
        return Number::ImageBrightness;
      }
      if (!strcmp(string, String::ImageContrast)) {
        return Number::ImageContrast;
      }
      if (!strcmp(string, String::ImageRedEnhancement)) {
        return Number::ImageRedEnhancement;
      }
      if (!strcmp(string, String::ImageGreenEnhancement)) {
        return Number::ImageGreenEnhancement;
      }
      if (!strcmp(string, String::ImageBlueEnhancement)) {
        return Number::ImageBlueEnhancement;
      }
      if (!strcmp(string, String::PrintHorizontalAlign)) {
        return Number::PrintHorizontalAlign;
      }
      if (!strcmp(string, String::PrintVerticalAlign)) {
        return Number::PrintVerticalAlign;
      }
      if (!strcmp(string, String::PrintTopMargin)) {
        return Number::PrintTopMargin;
      }
      if (!strcmp(string, String::PrintLeftMargin)) {
        return Number::PrintLeftMargin;
      }
      if (!strcmp(string, String::MediaTextColor)) {
        return Number::MediaTextColor;
      }
      if (!strcmp(string, String::MediaBackgroundColor)) {
        return Number::MediaBackgroundColor;
      }
      if (!strcmp(string, String::PrintScalingValue)) {
        return Number::PrintScalingValue;
      }
      if (!strcmp(string, String::PrintAutoCutLast)) {
        return Number::PrintAutoCutLast;
      }
      if (!strcmp(string, String::PrintAutoCutEvery)) {
        return Number::PrintAutoCutEvery;
      }
      if (!strcmp(string, String::PrintAutoCutEveryCyclePerPage)) {
        return Number::PrintAutoCutEveryCyclePerPage;
      }
      if (!strcmp(string, String::PrintAutoCutDisableForSpecialTape)) {
        return Number::PrintAutoCutDisableForSpecialTape;
      }
      if (!strcmp(string, String::PrintAutoHalfCut)) {
        return Number::PrintAutoHalfCut;
      }
      if (!strcmp(string, String::PrintDensity)) {
        return Number::PrintDensity;
      }
      if (!strcmp(string, String::PrintSpeed)) {
        return Number::PrintSpeed;
      }
      if (!strcmp(string, String::PrintDashLine)) {
        return Number::PrintDashLine;
      }
      if (!strcmp(string, String::PrintUsingCarbonCopyPaper)) {
        return Number::PrintUsingCarbonCopyPaper;
      }
      if (!strcmp(string, String::PrintFeedMode)) {
        return Number::PrintFeedMode;
      }
      if (!strcmp(string, String::PrintQuality)) {
        return Number::PrintQuality;
      }
      if (!strcmp(string, String::MediaPJRollCase)) {
        return Number::MediaPJRollCase;
      }
      if (!strcmp(string, String::MediaPaperInsertionPosition)) {
        return Number::MediaPaperInsertionPosition;
      }
      if (!strcmp(string, String::MediaPJPaperType)) {
        return Number::MediaPJPaperType;
      }
      if (!strcmp(string, String::MediaPJCustomSize)) {
        return Number::MediaPJCustomSize;
      }
      if (!strcmp(string, String::MediaPJForceStretchPrintableArea)) {
        return Number::MediaPJForceStretchPrintableArea;
      }
      if (!strcmp(string, String::PrintExtraFeedDots)) {
        return Number::PrintExtraFeedDots;
      }
      if (!strcmp(string, String::PrintCopies)) {
        return Number::PrintCopies;
      }
      if (!strcmp(string, String::PrintBidirectionalCommunication)) {
        return Number::PrintBidirectionalCommunication;
      }
      if (!strcmp(string, String::ImageTrimBlankDataFromTail)) {
        return Number::ImageTrimBlankDataFromTail;
      }
      if (!strcmp(string, String::PrintPolicyOfProcessingPrintData)) {
        return Number::PrintPolicyOfProcessingPrintData;
      }
      if (!strcmp(string, String::PrintCollate)) {
        return Number::PrintCollate;
      }
      if (!strcmp(string, String::PrintCheckMediaTextColor)) {
        return Number::PrintCheckMediaTextColor;
      }
      if (!strcmp(string, String::PrintCheckMediaBackgroundColor)) {
        return Number::PrintCheckMediaBackgroundColor;
      }
      if (!strcmp(string, String::PrintCutPause)) {
        return Number::PrintCutPause;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

  }
}