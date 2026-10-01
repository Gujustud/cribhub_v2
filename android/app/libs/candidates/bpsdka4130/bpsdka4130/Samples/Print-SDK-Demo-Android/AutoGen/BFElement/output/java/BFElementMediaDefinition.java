package com.brother.bfelement;

public class BFElementMediaDefinition {

public enum MediaBackgroundColor {
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
    __Null;    

    public static final String key = "MediaBackgroundColor";
}


public enum MediaPaperInsertionPosition {
    Left,    
    Center,    
    Right,    
    __Null;    

    public static final String key = "MediaPaperInsertionPosition";
}


public class MediaPJForceStretchPrintableArea {
    public static final String key = "MediaPJForceStretchPrintableArea";
}

public enum MediaPJPaperType {
    Roll,    
    CutSheet,    
    PerforatedRoll,    
    __Null;    

    public static final String key = "MediaPJPaperType";
}


public enum MediaPJRollCase {
    None,    
    PARC001_NoAntiCurl,    
    PARC001,    
    PARC001_ShortFeed,    
    KeepPrinterSetting,    
    __Null;    

    public static final String key = "MediaPJRollCase";
}


public enum MediaSize {
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
    FL21mmx45mm,    
    A4,    
    A5,    
    Letter,    
    Legal,    
    Custom,    
    __Null;    

    public static final String key = "MediaSize";
}


public enum MediaTextColor {
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
    __Null;    

    public static final String key = "MediaTextColor";
}


public enum MediaType {
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
    __Null;    

    public static final String key = "MediaType";
}


}