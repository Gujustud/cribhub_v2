
#pragma once
#include <string>

namespace bf {
  namespace element {
    struct MediaBackgroundColor {
      enum class Number {
        Standard,
        White,
        Others,
        Clear,
        Red,
        Blue,
        Yellow,
        Green,
        Black,
        ClearWithWhiteInk,
        PremiumGold,
        PremiumSilver,
        PremiumOthers,
        MaskingOthers,
        MatteWhite,
        MatteClear,
        MatteSilver,
        SatinGold,
        SatinSilver,
        PastelPurple,
        BlueWithWhiteInk,
        RedWithWhiteInk,
        FluorescentOrange,
        FluorescentYellow,
        BerryPink,
        LightGray,
        LimeGreen,
        SatinNavyBlue,
        SatinWineRed,
        FabricYellow,
        FabricPink,
        FabricBlue,
        TubeWhite,
        SelfLaminatedWhite,
        FlexibleWhite,
        FlexibleYellow,
        CleaningWhite,
        StencilWhite,
        LightBlue_Satin,
        Mint_Satin,
        Silver_Satin,
        Incompatible,
        __Null,
      };
      struct String {
        constexpr static const char * Standard = "Standard";
        constexpr static const char * White = "White";
        constexpr static const char * Others = "Others";
        constexpr static const char * Clear = "Clear";
        constexpr static const char * Red = "Red";
        constexpr static const char * Blue = "Blue";
        constexpr static const char * Yellow = "Yellow";
        constexpr static const char * Green = "Green";
        constexpr static const char * Black = "Black";
        constexpr static const char * ClearWithWhiteInk = "ClearWithWhiteInk";
        constexpr static const char * PremiumGold = "PremiumGold";
        constexpr static const char * PremiumSilver = "PremiumSilver";
        constexpr static const char * PremiumOthers = "PremiumOthers";
        constexpr static const char * MaskingOthers = "MaskingOthers";
        constexpr static const char * MatteWhite = "MatteWhite";
        constexpr static const char * MatteClear = "MatteClear";
        constexpr static const char * MatteSilver = "MatteSilver";
        constexpr static const char * SatinGold = "SatinGold";
        constexpr static const char * SatinSilver = "SatinSilver";
        constexpr static const char * PastelPurple = "PastelPurple";
        constexpr static const char * BlueWithWhiteInk = "BlueWithWhiteInk";
        constexpr static const char * RedWithWhiteInk = "RedWithWhiteInk";
        constexpr static const char * FluorescentOrange = "FluorescentOrange";
        constexpr static const char * FluorescentYellow = "FluorescentYellow";
        constexpr static const char * BerryPink = "BerryPink";
        constexpr static const char * LightGray = "LightGray";
        constexpr static const char * LimeGreen = "LimeGreen";
        constexpr static const char * SatinNavyBlue = "SatinNavyBlue";
        constexpr static const char * SatinWineRed = "SatinWineRed";
        constexpr static const char * FabricYellow = "FabricYellow";
        constexpr static const char * FabricPink = "FabricPink";
        constexpr static const char * FabricBlue = "FabricBlue";
        constexpr static const char * TubeWhite = "TubeWhite";
        constexpr static const char * SelfLaminatedWhite = "SelfLaminatedWhite";
        constexpr static const char * FlexibleWhite = "FlexibleWhite";
        constexpr static const char * FlexibleYellow = "FlexibleYellow";
        constexpr static const char * CleaningWhite = "CleaningWhite";
        constexpr static const char * StencilWhite = "StencilWhite";
        constexpr static const char * LightBlue_Satin = "LightBlue_Satin";
        constexpr static const char * Mint_Satin = "Mint_Satin";
        constexpr static const char * Silver_Satin = "Silver_Satin";
        constexpr static const char * Incompatible = "Incompatible";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "MediaBackgroundColor";
    };

    struct MediaPaperInsertionPosition {
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
      constexpr static const char * key = "MediaPaperInsertionPosition";
    };

    struct MediaPJForceStretchPrintableArea {
      using Number = int;
      constexpr static const char * key = "MediaPJForceStretchPrintableArea";
    };

    struct MediaPJPaperType {
      enum class Number {
        Roll,
        CutSheet,
        PerforatedRoll,
        __Null,
      };
      struct String {
        constexpr static const char * Roll = "Roll";
        constexpr static const char * CutSheet = "CutSheet";
        constexpr static const char * PerforatedRoll = "PerforatedRoll";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "MediaPJPaperType";
    };

    struct MediaPJRollCase {
      enum class Number {
        None,
        PARC001_NoAntiCurl,
        PARC001,
        PARC001_ShortFeed,
        KeepPrinterSetting,
        __Null,
      };
      struct String {
        constexpr static const char * None = "None";
        constexpr static const char * PARC001_NoAntiCurl = "PARC001_NoAntiCurl";
        constexpr static const char * PARC001 = "PARC001";
        constexpr static const char * PARC001_ShortFeed = "PARC001_ShortFeed";
        constexpr static const char * KeepPrinterSetting = "KeepPrinterSetting";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "MediaPJRollCase";
    };

    struct MediaSize {
      enum class Number {
        L3_5mm,
        L6mm,
        L9mm,
        L12mm,
        L18mm,
        L24mm,
        L29mm,
        L36mm,
        L38mm,
        L50mm,
        L54mm,
        L62mm,
        L102mm,
        L103mm,
        L17mmx54mm,
        L17mmx87mm,
        L23mmx23mm,
        L29mmx42mm,
        L29mmx90mm,
        L38mmx90mm,
        L39mmx48mm,
        L52mmx29mm,
        L54mmx29mm,
        L60mmx86mm,
        L62mmx29mm,
        L62mmx60mm,
        L62mmx75mm,
        L62mmx100mm,
        L102mmx51mm,
        L102mmx152mm,
        L103mmx164mm,
        L12mmDia,
        L24mmDia,
        L58mmDia,
        HS5_8mm,
        HS8_8mm,
        HS11_7mm,
        HS17_7mm,
        HS23_6mm,
        HS5_2mm,
        HS9_0mm,
        HS11_2mm,
        HS21_0mm,
        HS31_0mm,
        FL21mmx45mm,
        A4,
        A5,
        Letter,
        Legal,
        Custom,
        __Null,
      };
      struct String {
        constexpr static const char * L3_5mm = "L3.5mm";
        constexpr static const char * L6mm = "L6mm";
        constexpr static const char * L9mm = "L9mm";
        constexpr static const char * L12mm = "L12mm";
        constexpr static const char * L18mm = "L18mm";
        constexpr static const char * L24mm = "L24mm";
        constexpr static const char * L29mm = "L29mm";
        constexpr static const char * L36mm = "L36mm";
        constexpr static const char * L38mm = "L38mm";
        constexpr static const char * L50mm = "L50mm";
        constexpr static const char * L54mm = "L54mm";
        constexpr static const char * L62mm = "L62mm";
        constexpr static const char * L102mm = "L102mm";
        constexpr static const char * L103mm = "L103mm";
        constexpr static const char * L17mmx54mm = "L17mmx54mm";
        constexpr static const char * L17mmx87mm = "L17mmx87mm";
        constexpr static const char * L23mmx23mm = "L23mmx23mm";
        constexpr static const char * L29mmx42mm = "L29mmx42mm";
        constexpr static const char * L29mmx90mm = "L29mmx90mm";
        constexpr static const char * L38mmx90mm = "L38mmx90mm";
        constexpr static const char * L39mmx48mm = "L39mmx48mm";
        constexpr static const char * L52mmx29mm = "L52mmx29mm";
        constexpr static const char * L54mmx29mm = "L54mmx29mm";
        constexpr static const char * L60mmx86mm = "L60mmx86mm";
        constexpr static const char * L62mmx29mm = "L62mmx29mm";
        constexpr static const char * L62mmx60mm = "L62mmx60mm";
        constexpr static const char * L62mmx75mm = "L62mmx75mm";
        constexpr static const char * L62mmx100mm = "L62mmx100mm";
        constexpr static const char * L102mmx51mm = "L102mmx51mm";
        constexpr static const char * L102mmx152mm = "L102mmx152mm";
        constexpr static const char * L103mmx164mm = "L103mmx164mm";
        constexpr static const char * L12mmDia = "L12mmDia";
        constexpr static const char * L24mmDia = "L24mmDia";
        constexpr static const char * L58mmDia = "L58mmDia";
        constexpr static const char * HS5_8mm = "HS5.8mm";
        constexpr static const char * HS8_8mm = "HS8.8mm";
        constexpr static const char * HS11_7mm = "HS11.7mm";
        constexpr static const char * HS17_7mm = "HS17.7mm";
        constexpr static const char * HS23_6mm = "HS23.6mm";
        constexpr static const char * HS5_2mm = "HS5.2mm";
        constexpr static const char * HS9_0mm = "HS9.0mm";
        constexpr static const char * HS11_2mm = "HS11.2mm";
        constexpr static const char * HS21_0mm = "HS21.0mm";
        constexpr static const char * HS31_0mm = "HS31.0mm";
        constexpr static const char * FL21mmx45mm = "FL21mmx45mm";
        constexpr static const char * A4 = "A4";
        constexpr static const char * A5 = "A5";
        constexpr static const char * Letter = "Letter";
        constexpr static const char * Legal = "Legal";
        constexpr static const char * Custom = "Custom";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "MediaSize";
    };

    struct MediaTextColor {
      enum class Number {
        Standard,
        White,
        Others,
        Red,
        Blue,
        Black,
        Gold,
        RedAndBlack,
        FabricBlue,
        CleaningBlack,
        StencilBlack,
        Incompatible,
        __Null,
      };
      struct String {
        constexpr static const char * Standard = "Standard";
        constexpr static const char * White = "White";
        constexpr static const char * Others = "Others";
        constexpr static const char * Red = "Red";
        constexpr static const char * Blue = "Blue";
        constexpr static const char * Black = "Black";
        constexpr static const char * Gold = "Gold";
        constexpr static const char * RedAndBlack = "RedAndBlack";
        constexpr static const char * FabricBlue = "FabricBlue";
        constexpr static const char * CleaningBlack = "CleaningBlack";
        constexpr static const char * StencilBlack = "StencilBlack";
        constexpr static const char * Incompatible = "Incompatible";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "MediaTextColor";
    };

    struct MediaType {
      enum class Number {
        Unknown,
        PTLaminate,
        PTNonLaminate,
        PTFabric,
        QLInfiniteLable,
        QLDieCutLable,
        PTHeatShrink,
        PTFLe,
        PTFlexibleID,
        PTSatin,
        PTSelfLaminate,
        Incompatible,
        __Null,
      };
      struct String {
        constexpr static const char * Unknown = "Unknown";
        constexpr static const char * PTLaminate = "PTLaminate";
        constexpr static const char * PTNonLaminate = "PTNonLaminate";
        constexpr static const char * PTFabric = "PTFabric";
        constexpr static const char * QLInfiniteLable = "QLInfiniteLable";
        constexpr static const char * QLDieCutLable = "QLDieCutLable";
        constexpr static const char * PTHeatShrink = "PTHeatShrink";
        constexpr static const char * PTFLe = "PTFLe";
        constexpr static const char * PTFlexibleID = "PTFlexibleID";
        constexpr static const char * PTSatin = "PTSatin";
        constexpr static const char * PTSelfLaminate = "PTSelfLaminate";
        constexpr static const char * Incompatible = "Incompatible";
        constexpr static const char * __Null = "__Null";
      };
      static const char* convertToString(Number number);
      static Number convertToNumber(const char* string);
      constexpr static const char * key = "MediaType";
    };

  }
}