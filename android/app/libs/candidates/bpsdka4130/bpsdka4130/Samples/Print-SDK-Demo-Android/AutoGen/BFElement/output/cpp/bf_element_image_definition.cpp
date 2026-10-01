
#include "bf_element_image_definition.hpp"
#include <string>
#include <cstring>

namespace bf {
  namespace element {
    const char* ImageHalftone::convertToString(Number num) {
      switch(num) {
        case Number::SimpleThreshold: return String::SimpleThreshold;
        case Number::Dither: return String::Dither;
        case Number::ErrorDiffusion: return String::ErrorDiffusion;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ImageHalftone::Number ImageHalftone::convertToNumber(const char* string) {
      if (!strcmp(string, String::SimpleThreshold)) {
        return Number::SimpleThreshold;
      }
      if (!strcmp(string, String::Dither)) {
        return Number::Dither;
      }
      if (!strcmp(string, String::ErrorDiffusion)) {
        return Number::ErrorDiffusion;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* ImageOrientation::convertToString(Number num) {
      switch(num) {
        case Number::Portrait: return String::Portrait;
        case Number::Landscape: return String::Landscape;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ImageOrientation::Number ImageOrientation::convertToNumber(const char* string) {
      if (!strcmp(string, String::Portrait)) {
        return Number::Portrait;
      }
      if (!strcmp(string, String::Landscape)) {
        return Number::Landscape;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

  }
}