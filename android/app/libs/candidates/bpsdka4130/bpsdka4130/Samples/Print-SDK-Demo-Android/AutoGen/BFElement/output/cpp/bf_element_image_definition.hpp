
#pragma once
#include <string>

namespace bf {
  namespace element {
    struct ImageBlueEnhancement {
      using Number = int;
      constexpr static const char * key = "ImageBlueEnhancement";
    };

    struct ImageBrightness {
      using Number = int;
      constexpr static const char * key = "ImageBrightness";
    };

    struct ImageContrast {
      using Number = int;
      constexpr static const char * key = "ImageContrast";
    };

    struct ImageGreenEnhancement {
      using Number = int;
      constexpr static const char * key = "ImageGreenEnhancement";
    };

    struct ImageHalftone {
      enum class Number {
        SimpleThreshold,
        Dither,
        ErrorDiffusion,
        __Null,
      };
      struct String {
        constexpr static const char * SimpleThreshold = "SimpleThreshold";
        constexpr static const char * Dither = "Dither";
        constexpr static const char * ErrorDiffusion = "ErrorDiffusion";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ImageHalftone";
    };

    struct ImageOrientation {
      enum class Number {
        Portrait,
        Landscape,
        __Null,
      };
      struct String {
        constexpr static const char * Portrait = "Portrait";
        constexpr static const char * Landscape = "Landscape";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ImageOrientation";
    };

    struct ImageRedEnhancement {
      using Number = int;
      constexpr static const char * key = "ImageRedEnhancement";
    };

    struct ImageTrimBlankDataFromTail {
      using Number = bool;
      constexpr static const char * key = "ImageTrimBlankDataFromTail";
    };

  }
}