
#include "bf_element_media_definition.hpp"
#include <string>
#include <cstring>

namespace bf {
  namespace element {
    const char* MediaBackgroundColor::convertToString(Number num) {
      switch(num) {
        case Number::Standard: return String::Standard;
        case Number::White: return String::White;
        case Number::Others: return String::Others;
        case Number::Clear: return String::Clear;
        case Number::Red: return String::Red;
        case Number::Blue: return String::Blue;
        case Number::Yellow: return String::Yellow;
        case Number::Green: return String::Green;
        case Number::Black: return String::Black;
        case Number::ClearWithWhiteInk: return String::ClearWithWhiteInk;
        case Number::PremiumGold: return String::PremiumGold;
        case Number::PremiumSilver: return String::PremiumSilver;
        case Number::PremiumOthers: return String::PremiumOthers;
        case Number::MaskingOthers: return String::MaskingOthers;
        case Number::MatteWhite: return String::MatteWhite;
        case Number::MatteClear: return String::MatteClear;
        case Number::MatteSilver: return String::MatteSilver;
        case Number::SatinGold: return String::SatinGold;
        case Number::SatinSilver: return String::SatinSilver;
        case Number::PastelPurple: return String::PastelPurple;
        case Number::BlueWithWhiteInk: return String::BlueWithWhiteInk;
        case Number::RedWithWhiteInk: return String::RedWithWhiteInk;
        case Number::FluorescentOrange: return String::FluorescentOrange;
        case Number::FluorescentYellow: return String::FluorescentYellow;
        case Number::BerryPink: return String::BerryPink;
        case Number::LightGray: return String::LightGray;
        case Number::LimeGreen: return String::LimeGreen;
        case Number::SatinNavyBlue: return String::SatinNavyBlue;
        case Number::SatinWineRed: return String::SatinWineRed;
        case Number::FabricYellow: return String::FabricYellow;
        case Number::FabricPink: return String::FabricPink;
        case Number::FabricBlue: return String::FabricBlue;
        case Number::TubeWhite: return String::TubeWhite;
        case Number::SelfLaminatedWhite: return String::SelfLaminatedWhite;
        case Number::FlexibleWhite: return String::FlexibleWhite;
        case Number::FlexibleYellow: return String::FlexibleYellow;
        case Number::CleaningWhite: return String::CleaningWhite;
        case Number::StencilWhite: return String::StencilWhite;
        case Number::LightBlue_Satin: return String::LightBlue_Satin;
        case Number::Mint_Satin: return String::Mint_Satin;
        case Number::Silver_Satin: return String::Silver_Satin;
        case Number::Incompatible: return String::Incompatible;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    MediaBackgroundColor::Number MediaBackgroundColor::convertToNumber(const char* string) {
      if (!strcmp(string, String::Standard)) {
        return Number::Standard;
      }
      if (!strcmp(string, String::White)) {
        return Number::White;
      }
      if (!strcmp(string, String::Others)) {
        return Number::Others;
      }
      if (!strcmp(string, String::Clear)) {
        return Number::Clear;
      }
      if (!strcmp(string, String::Red)) {
        return Number::Red;
      }
      if (!strcmp(string, String::Blue)) {
        return Number::Blue;
      }
      if (!strcmp(string, String::Yellow)) {
        return Number::Yellow;
      }
      if (!strcmp(string, String::Green)) {
        return Number::Green;
      }
      if (!strcmp(string, String::Black)) {
        return Number::Black;
      }
      if (!strcmp(string, String::ClearWithWhiteInk)) {
        return Number::ClearWithWhiteInk;
      }
      if (!strcmp(string, String::PremiumGold)) {
        return Number::PremiumGold;
      }
      if (!strcmp(string, String::PremiumSilver)) {
        return Number::PremiumSilver;
      }
      if (!strcmp(string, String::PremiumOthers)) {
        return Number::PremiumOthers;
      }
      if (!strcmp(string, String::MaskingOthers)) {
        return Number::MaskingOthers;
      }
      if (!strcmp(string, String::MatteWhite)) {
        return Number::MatteWhite;
      }
      if (!strcmp(string, String::MatteClear)) {
        return Number::MatteClear;
      }
      if (!strcmp(string, String::MatteSilver)) {
        return Number::MatteSilver;
      }
      if (!strcmp(string, String::SatinGold)) {
        return Number::SatinGold;
      }
      if (!strcmp(string, String::SatinSilver)) {
        return Number::SatinSilver;
      }
      if (!strcmp(string, String::PastelPurple)) {
        return Number::PastelPurple;
      }
      if (!strcmp(string, String::BlueWithWhiteInk)) {
        return Number::BlueWithWhiteInk;
      }
      if (!strcmp(string, String::RedWithWhiteInk)) {
        return Number::RedWithWhiteInk;
      }
      if (!strcmp(string, String::FluorescentOrange)) {
        return Number::FluorescentOrange;
      }
      if (!strcmp(string, String::FluorescentYellow)) {
        return Number::FluorescentYellow;
      }
      if (!strcmp(string, String::BerryPink)) {
        return Number::BerryPink;
      }
      if (!strcmp(string, String::LightGray)) {
        return Number::LightGray;
      }
      if (!strcmp(string, String::LimeGreen)) {
        return Number::LimeGreen;
      }
      if (!strcmp(string, String::SatinNavyBlue)) {
        return Number::SatinNavyBlue;
      }
      if (!strcmp(string, String::SatinWineRed)) {
        return Number::SatinWineRed;
      }
      if (!strcmp(string, String::FabricYellow)) {
        return Number::FabricYellow;
      }
      if (!strcmp(string, String::FabricPink)) {
        return Number::FabricPink;
      }
      if (!strcmp(string, String::FabricBlue)) {
        return Number::FabricBlue;
      }
      if (!strcmp(string, String::TubeWhite)) {
        return Number::TubeWhite;
      }
      if (!strcmp(string, String::SelfLaminatedWhite)) {
        return Number::SelfLaminatedWhite;
      }
      if (!strcmp(string, String::FlexibleWhite)) {
        return Number::FlexibleWhite;
      }
      if (!strcmp(string, String::FlexibleYellow)) {
        return Number::FlexibleYellow;
      }
      if (!strcmp(string, String::CleaningWhite)) {
        return Number::CleaningWhite;
      }
      if (!strcmp(string, String::StencilWhite)) {
        return Number::StencilWhite;
      }
      if (!strcmp(string, String::LightBlue_Satin)) {
        return Number::LightBlue_Satin;
      }
      if (!strcmp(string, String::Mint_Satin)) {
        return Number::Mint_Satin;
      }
      if (!strcmp(string, String::Silver_Satin)) {
        return Number::Silver_Satin;
      }
      if (!strcmp(string, String::Incompatible)) {
        return Number::Incompatible;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* MediaPaperInsertionPosition::convertToString(Number num) {
      switch(num) {
        case Number::Left: return String::Left;
        case Number::Center: return String::Center;
        case Number::Right: return String::Right;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    MediaPaperInsertionPosition::Number MediaPaperInsertionPosition::convertToNumber(const char* string) {
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

    const char* MediaPJPaperType::convertToString(Number num) {
      switch(num) {
        case Number::Roll: return String::Roll;
        case Number::CutSheet: return String::CutSheet;
        case Number::PerforatedRoll: return String::PerforatedRoll;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    MediaPJPaperType::Number MediaPJPaperType::convertToNumber(const char* string) {
      if (!strcmp(string, String::Roll)) {
        return Number::Roll;
      }
      if (!strcmp(string, String::CutSheet)) {
        return Number::CutSheet;
      }
      if (!strcmp(string, String::PerforatedRoll)) {
        return Number::PerforatedRoll;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* MediaPJRollCase::convertToString(Number num) {
      switch(num) {
        case Number::None: return String::None;
        case Number::PARC001_NoAntiCurl: return String::PARC001_NoAntiCurl;
        case Number::PARC001: return String::PARC001;
        case Number::PARC001_ShortFeed: return String::PARC001_ShortFeed;
        case Number::KeepPrinterSetting: return String::KeepPrinterSetting;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    MediaPJRollCase::Number MediaPJRollCase::convertToNumber(const char* string) {
      if (!strcmp(string, String::None)) {
        return Number::None;
      }
      if (!strcmp(string, String::PARC001_NoAntiCurl)) {
        return Number::PARC001_NoAntiCurl;
      }
      if (!strcmp(string, String::PARC001)) {
        return Number::PARC001;
      }
      if (!strcmp(string, String::PARC001_ShortFeed)) {
        return Number::PARC001_ShortFeed;
      }
      if (!strcmp(string, String::KeepPrinterSetting)) {
        return Number::KeepPrinterSetting;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* MediaSize::convertToString(Number num) {
      switch(num) {
        case Number::L3_5mm: return String::L3_5mm;
        case Number::L6mm: return String::L6mm;
        case Number::L9mm: return String::L9mm;
        case Number::L12mm: return String::L12mm;
        case Number::L18mm: return String::L18mm;
        case Number::L24mm: return String::L24mm;
        case Number::L29mm: return String::L29mm;
        case Number::L36mm: return String::L36mm;
        case Number::L38mm: return String::L38mm;
        case Number::L50mm: return String::L50mm;
        case Number::L54mm: return String::L54mm;
        case Number::L62mm: return String::L62mm;
        case Number::L102mm: return String::L102mm;
        case Number::L103mm: return String::L103mm;
        case Number::L17mmx54mm: return String::L17mmx54mm;
        case Number::L17mmx87mm: return String::L17mmx87mm;
        case Number::L23mmx23mm: return String::L23mmx23mm;
        case Number::L29mmx42mm: return String::L29mmx42mm;
        case Number::L29mmx90mm: return String::L29mmx90mm;
        case Number::L38mmx90mm: return String::L38mmx90mm;
        case Number::L39mmx48mm: return String::L39mmx48mm;
        case Number::L52mmx29mm: return String::L52mmx29mm;
        case Number::L54mmx29mm: return String::L54mmx29mm;
        case Number::L60mmx86mm: return String::L60mmx86mm;
        case Number::L62mmx29mm: return String::L62mmx29mm;
        case Number::L62mmx60mm: return String::L62mmx60mm;
        case Number::L62mmx75mm: return String::L62mmx75mm;
        case Number::L62mmx100mm: return String::L62mmx100mm;
        case Number::L102mmx51mm: return String::L102mmx51mm;
        case Number::L102mmx152mm: return String::L102mmx152mm;
        case Number::L103mmx164mm: return String::L103mmx164mm;
        case Number::L12mmDia: return String::L12mmDia;
        case Number::L24mmDia: return String::L24mmDia;
        case Number::L58mmDia: return String::L58mmDia;
        case Number::HS5_8mm: return String::HS5_8mm;
        case Number::HS8_8mm: return String::HS8_8mm;
        case Number::HS11_7mm: return String::HS11_7mm;
        case Number::HS17_7mm: return String::HS17_7mm;
        case Number::HS23_6mm: return String::HS23_6mm;
        case Number::HS5_2mm: return String::HS5_2mm;
        case Number::HS9_0mm: return String::HS9_0mm;
        case Number::HS11_2mm: return String::HS11_2mm;
        case Number::HS21_0mm: return String::HS21_0mm;
        case Number::HS31_0mm: return String::HS31_0mm;
        case Number::FL21mmx45mm: return String::FL21mmx45mm;
        case Number::A4: return String::A4;
        case Number::A5: return String::A5;
        case Number::Letter: return String::Letter;
        case Number::Legal: return String::Legal;
        case Number::Custom: return String::Custom;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    MediaSize::Number MediaSize::convertToNumber(const char* string) {
      if (!strcmp(string, String::L3_5mm)) {
        return Number::L3_5mm;
      }
      if (!strcmp(string, String::L6mm)) {
        return Number::L6mm;
      }
      if (!strcmp(string, String::L9mm)) {
        return Number::L9mm;
      }
      if (!strcmp(string, String::L12mm)) {
        return Number::L12mm;
      }
      if (!strcmp(string, String::L18mm)) {
        return Number::L18mm;
      }
      if (!strcmp(string, String::L24mm)) {
        return Number::L24mm;
      }
      if (!strcmp(string, String::L29mm)) {
        return Number::L29mm;
      }
      if (!strcmp(string, String::L36mm)) {
        return Number::L36mm;
      }
      if (!strcmp(string, String::L38mm)) {
        return Number::L38mm;
      }
      if (!strcmp(string, String::L50mm)) {
        return Number::L50mm;
      }
      if (!strcmp(string, String::L54mm)) {
        return Number::L54mm;
      }
      if (!strcmp(string, String::L62mm)) {
        return Number::L62mm;
      }
      if (!strcmp(string, String::L102mm)) {
        return Number::L102mm;
      }
      if (!strcmp(string, String::L103mm)) {
        return Number::L103mm;
      }
      if (!strcmp(string, String::L17mmx54mm)) {
        return Number::L17mmx54mm;
      }
      if (!strcmp(string, String::L17mmx87mm)) {
        return Number::L17mmx87mm;
      }
      if (!strcmp(string, String::L23mmx23mm)) {
        return Number::L23mmx23mm;
      }
      if (!strcmp(string, String::L29mmx42mm)) {
        return Number::L29mmx42mm;
      }
      if (!strcmp(string, String::L29mmx90mm)) {
        return Number::L29mmx90mm;
      }
      if (!strcmp(string, String::L38mmx90mm)) {
        return Number::L38mmx90mm;
      }
      if (!strcmp(string, String::L39mmx48mm)) {
        return Number::L39mmx48mm;
      }
      if (!strcmp(string, String::L52mmx29mm)) {
        return Number::L52mmx29mm;
      }
      if (!strcmp(string, String::L54mmx29mm)) {
        return Number::L54mmx29mm;
      }
      if (!strcmp(string, String::L60mmx86mm)) {
        return Number::L60mmx86mm;
      }
      if (!strcmp(string, String::L62mmx29mm)) {
        return Number::L62mmx29mm;
      }
      if (!strcmp(string, String::L62mmx60mm)) {
        return Number::L62mmx60mm;
      }
      if (!strcmp(string, String::L62mmx75mm)) {
        return Number::L62mmx75mm;
      }
      if (!strcmp(string, String::L62mmx100mm)) {
        return Number::L62mmx100mm;
      }
      if (!strcmp(string, String::L102mmx51mm)) {
        return Number::L102mmx51mm;
      }
      if (!strcmp(string, String::L102mmx152mm)) {
        return Number::L102mmx152mm;
      }
      if (!strcmp(string, String::L103mmx164mm)) {
        return Number::L103mmx164mm;
      }
      if (!strcmp(string, String::L12mmDia)) {
        return Number::L12mmDia;
      }
      if (!strcmp(string, String::L24mmDia)) {
        return Number::L24mmDia;
      }
      if (!strcmp(string, String::L58mmDia)) {
        return Number::L58mmDia;
      }
      if (!strcmp(string, String::HS5_8mm)) {
        return Number::HS5_8mm;
      }
      if (!strcmp(string, String::HS8_8mm)) {
        return Number::HS8_8mm;
      }
      if (!strcmp(string, String::HS11_7mm)) {
        return Number::HS11_7mm;
      }
      if (!strcmp(string, String::HS17_7mm)) {
        return Number::HS17_7mm;
      }
      if (!strcmp(string, String::HS23_6mm)) {
        return Number::HS23_6mm;
      }
      if (!strcmp(string, String::HS5_2mm)) {
        return Number::HS5_2mm;
      }
      if (!strcmp(string, String::HS9_0mm)) {
        return Number::HS9_0mm;
      }
      if (!strcmp(string, String::HS11_2mm)) {
        return Number::HS11_2mm;
      }
      if (!strcmp(string, String::HS21_0mm)) {
        return Number::HS21_0mm;
      }
      if (!strcmp(string, String::HS31_0mm)) {
        return Number::HS31_0mm;
      }
      if (!strcmp(string, String::FL21mmx45mm)) {
        return Number::FL21mmx45mm;
      }
      if (!strcmp(string, String::A4)) {
        return Number::A4;
      }
      if (!strcmp(string, String::A5)) {
        return Number::A5;
      }
      if (!strcmp(string, String::Letter)) {
        return Number::Letter;
      }
      if (!strcmp(string, String::Legal)) {
        return Number::Legal;
      }
      if (!strcmp(string, String::Custom)) {
        return Number::Custom;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* MediaTextColor::convertToString(Number num) {
      switch(num) {
        case Number::Standard: return String::Standard;
        case Number::White: return String::White;
        case Number::Others: return String::Others;
        case Number::Red: return String::Red;
        case Number::Blue: return String::Blue;
        case Number::Black: return String::Black;
        case Number::Gold: return String::Gold;
        case Number::RedAndBlack: return String::RedAndBlack;
        case Number::FabricBlue: return String::FabricBlue;
        case Number::CleaningBlack: return String::CleaningBlack;
        case Number::StencilBlack: return String::StencilBlack;
        case Number::Incompatible: return String::Incompatible;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    MediaTextColor::Number MediaTextColor::convertToNumber(const char* string) {
      if (!strcmp(string, String::Standard)) {
        return Number::Standard;
      }
      if (!strcmp(string, String::White)) {
        return Number::White;
      }
      if (!strcmp(string, String::Others)) {
        return Number::Others;
      }
      if (!strcmp(string, String::Red)) {
        return Number::Red;
      }
      if (!strcmp(string, String::Blue)) {
        return Number::Blue;
      }
      if (!strcmp(string, String::Black)) {
        return Number::Black;
      }
      if (!strcmp(string, String::Gold)) {
        return Number::Gold;
      }
      if (!strcmp(string, String::RedAndBlack)) {
        return Number::RedAndBlack;
      }
      if (!strcmp(string, String::FabricBlue)) {
        return Number::FabricBlue;
      }
      if (!strcmp(string, String::CleaningBlack)) {
        return Number::CleaningBlack;
      }
      if (!strcmp(string, String::StencilBlack)) {
        return Number::StencilBlack;
      }
      if (!strcmp(string, String::Incompatible)) {
        return Number::Incompatible;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

    const char* MediaType::convertToString(Number num) {
      switch(num) {
        case Number::Unknown: return String::Unknown;
        case Number::PTLaminate: return String::PTLaminate;
        case Number::PTNonLaminate: return String::PTNonLaminate;
        case Number::PTFabric: return String::PTFabric;
        case Number::QLInfiniteLable: return String::QLInfiniteLable;
        case Number::QLDieCutLable: return String::QLDieCutLable;
        case Number::PTHeatShrink: return String::PTHeatShrink;
        case Number::PTFLe: return String::PTFLe;
        case Number::PTFlexibleID: return String::PTFlexibleID;
        case Number::PTSatin: return String::PTSatin;
        case Number::PTSelfLaminate: return String::PTSelfLaminate;
        case Number::Incompatible: return String::Incompatible;
        case Number::__Null: return String::__Null;
      }
      return String::__Null;
    };
    MediaType::Number MediaType::convertToNumber(const char* string) {
      if (!strcmp(string, String::Unknown)) {
        return Number::Unknown;
      }
      if (!strcmp(string, String::PTLaminate)) {
        return Number::PTLaminate;
      }
      if (!strcmp(string, String::PTNonLaminate)) {
        return Number::PTNonLaminate;
      }
      if (!strcmp(string, String::PTFabric)) {
        return Number::PTFabric;
      }
      if (!strcmp(string, String::QLInfiniteLable)) {
        return Number::QLInfiniteLable;
      }
      if (!strcmp(string, String::QLDieCutLable)) {
        return Number::QLDieCutLable;
      }
      if (!strcmp(string, String::PTHeatShrink)) {
        return Number::PTHeatShrink;
      }
      if (!strcmp(string, String::PTFLe)) {
        return Number::PTFLe;
      }
      if (!strcmp(string, String::PTFlexibleID)) {
        return Number::PTFlexibleID;
      }
      if (!strcmp(string, String::PTSatin)) {
        return Number::PTSatin;
      }
      if (!strcmp(string, String::PTSelfLaminate)) {
        return Number::PTSelfLaminate;
      }
      if (!strcmp(string, String::Incompatible)) {
        return Number::Incompatible;
      }
      if (!strcmp(string, String::__Null)) {
        return Number::__Null;
      }
      return Number::__Null;
    };

  }
}