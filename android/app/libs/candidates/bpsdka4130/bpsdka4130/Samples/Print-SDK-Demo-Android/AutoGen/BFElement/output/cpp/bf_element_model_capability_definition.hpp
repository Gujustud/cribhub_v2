
#pragma once
#include <string>

namespace bf {
  namespace element {
    struct ModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse {
      enum class Number {
        PrioritizeAutoCutEveryTrue,
        PrioritizeAutoCutLastFalse,
        __Null,
      };
      struct String {
        constexpr static const char * PrioritizeAutoCutEveryTrue = "PrioritizeAutoCutEveryTrue";
        constexpr static const char * PrioritizeAutoCutLastFalse = "PrioritizeAutoCutLastFalse";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "ModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse";
    };

  }
}