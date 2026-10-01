
#include "bf_element_model_capability_definition.hpp"
#include <string>
#include <cstring>

namespace bf {
  namespace element {
    const char* ModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse::convertToString(Number num) {
      switch(num) {
        case Number::PrioritizeAutoCutEveryTrue: return String::PrioritizeAutoCutEveryTrue;
        case Number::PrioritizeAutoCutLastFalse: return String::PrioritizeAutoCutLastFalse;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    ModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse::Number ModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse::convertToNumber(const char* string) {
      if (!strcmp(string, String::PrioritizeAutoCutEveryTrue)) {
        return Number::PrioritizeAutoCutEveryTrue;
      }
      if (!strcmp(string, String::PrioritizeAutoCutLastFalse)) {
        return Number::PrioritizeAutoCutLastFalse;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

  }
}