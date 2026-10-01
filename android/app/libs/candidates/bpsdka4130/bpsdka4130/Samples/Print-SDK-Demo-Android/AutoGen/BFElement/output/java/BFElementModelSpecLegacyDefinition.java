package com.brother.bfelement;

public class BFElementModelSpecLegacyDefinition {

public enum ModelSpecLegacyBatteryCommandType {
    PS_BAT_NON,    
    PS_BAT_PJCOMMAND,    
    PS_BAT_MW145COMMAND,    
    PS_BAT_MW260COMMAND,    
    PS_BAT_FROMSTATUS,    
    __Null;    

    public static final String key = "ModelSpecLegacyBatteryCommandType";
}


public class ModelSpecLegacyBitOrderOfBitmapIsLittle {
    public static final String key = "ModelSpecLegacyBitOrderOfBitmapIsLittle";
}

public class ModelSpecLegacyChangeStatusMode {
    public static final String key = "ModelSpecLegacyChangeStatusMode";
}

public class ModelSpecLegacyFirmUpdateShouldChangeCommandMode {
    public static final String key = "ModelSpecLegacyFirmUpdateShouldChangeCommandMode";
}

public enum ModelSpecLegacyGraphicCommandType {
    G_COMMAND_g,    
    G_COMMAND_G,    
    G_COMMAND_PJ,    
    __Null;    

    public static final String key = "ModelSpecLegacyGraphicCommandType";
}


public class ModelSpecLegacyHeadPin {
    public static final String key = "ModelSpecLegacyHeadPin";
}

public class ModelSpecLegacyHeadPinWhenPrintTube {
    public static final String key = "ModelSpecLegacyHeadPinWhenPrintTube";
}

public class ModelSpecLegacyIgnorePaperEmptyWhenPrintEnd {
    public static final String key = "ModelSpecLegacyIgnorePaperEmptyWhenPrintEnd";
}

public class ModelSpecLegacyImageHalftoneShouldGammaAdjust {
    public static final String key = "ModelSpecLegacyImageHalftoneShouldGammaAdjust";
}

public enum ModelSpecLegacyMainVersionCommandType {
    MV_U0FH01H01H,    
    MV_U0EH01H,    
    MV_U0FH02H01H,    
    MV_UNKWOUN,    
    __Null;    

    public static final String key = "ModelSpecLegacyMainVersionCommandType";
}


public class ModelSpecLegacyMediaSizeShouldCheck {
    public static final String key = "ModelSpecLegacyMediaSizeShouldCheck";
}

public class ModelSpecLegacyMinPrintMerginPerTenthMM {
    public static final String key = "ModelSpecLegacyMinPrintMerginPerTenthMM";
}

public class ModelSpecLegacyMinPrintPaperLengthPerTenthMM {
    public static final String key = "ModelSpecLegacyMinPrintPaperLengthPerTenthMM";
}

public class ModelSpecLegacyMode9CompressionMaxByteSize {
    public static final String key = "ModelSpecLegacyMode9CompressionMaxByteSize";
}

public class ModelSpecLegacyMode9ShouldFlipHorizontal {
    public static final String key = "ModelSpecLegacyMode9ShouldFlipHorizontal";
}

public class ModelSpecLegacyModelCode {
    public static final String key = "ModelSpecLegacyModelCode";
}

public class ModelSpecLegacyModelName {
    public static final String key = "ModelSpecLegacyModelName";
}

public class ModelSpecLegacyNullCommandLength {
    public static final String key = "ModelSpecLegacyNullCommandLength";
}

public enum ModelSpecLegacyPageEndCommandType {
    END_PJCODE,    
    END_NORMAL,    
    __Null;    

    public static final String key = "ModelSpecLegacyPageEndCommandType";
}


public enum ModelSpecLegacyPaperListKind {
    PS_A7,    
    PS_A6,    
    PS_PJ,    
    PS_BIN,    
    PS_QL,    
    PS_PT,    
    PS_PT_36mm,    
    PS_PT_18mm,    
    PS_TUBE,    
    PS_FLE,    
    PS_PT3,    
    PS_QL1000,    
    PS_PT_CUBE3,    
    PS_PT9000,    
    PS_PT_3_5mmUNSUPPORT,    
    PAPER_UNSUPPORT,    
    __Null;    

    public static final String key = "ModelSpecLegacyPaperListKind";
}


public enum ModelSpecLegacyPrintCompressType {
    COM_RAW,    
    COM_RAW_TIFF,    
    COM_TIFF,    
    __Null;    

    public static final String key = "ModelSpecLegacyPrintCompressType";
}


public enum ModelSpecLegacyPrinterSettingCategory {
    PS_NET_IPV6,    
    PS_WIFI_IPV6,    
    PS_WIFI_BOOTMODE,    
    PS_WIFI_INTERFACE,    
    PS_WIFI_WIRELESSDIRECT_BOOTMODE,    
    PS_WIFI_SETTINGS,    
    PS_WIFI_NODENAME,    
    PS_LAN_SETTINGS,    
    PS_LAN_NODENAME,    
    PS_LAN_IPV6,    
    PS_WIRELESSDIRECT_CREATE_KRY,    
    PS_WIRELESSDIRECT_SETTINGS,    
    PS_BT_AUTOPOWEROFFTIME,    
    PS_BT_AUTOSLEEPTIME,    
    PS_BT_AUTOSLEEPTOPOWEROFFTIME,    
    PS_BT_POWERSAVEMODE,    
    PS_BT_ISDISCOVERABLE,    
    PS_BT_DEVICENAME,    
    PS_BT_PINCODE,    
    PS_BT_SSP,    
    PS_BT_PINCODE_ENABLE,    
    PS_BT_SECURITYMODE,    
    PS_BT_BOOTMODE,    
    PS_BT_BLUETOOTH_TO_IRDA,    
    PS_BT_BLUETOOTH_TO_NET,    
    PS_BT_KEY,    
    PS_BT_AUTO_CONNECTION,    
    PS_BT_BOOTMODE_PJ,    
    PS_PRINT_JPEG_HALFTONE,    
    PS_PRINT_JPEG_SCALE,    
    PS_PRINT_DENSITY,    
    PS_PRINT_SPEED,    
    PS_POWER_POWEROFFTIME,    
    PS_POWER_POWEROFFTIME_BATTERY,    
    PS_POWER_POWEROFFTIME_RJ2,    
    PS_POWER_POWEROFFTIME_QL8,    
    PS_POWER_POWEROFFTIME_BATTERY_QL8,    
    PS_POWER_POWEROFFTIME_QL1100,    
    PS_POWER_POWEROFFTIME_RJ4000a,    
    PS_POWER_POWEROFFTIME_ModelFilter,    
    PS_POWER_POWEROFFTIME_PowerSupplyFilter,    
    __Null;    

    public static final String key = "ModelSpecLegacyPrinterSettingCategory";
}


public enum ModelSpecLegacyPrinterSettingCategoryBluetooth {
    PS_BT_AUTOPOWEROFFTIME,    
    PS_BT_AUTOSLEEPTIME,    
    PS_BT_AUTOSLEEPTOPOWEROFFTIME,    
    PS_BT_POWERSAVEMODE,    
    PS_BT_ISDISCOVERABLE,    
    PS_BT_DEVICENAME,    
    PS_BT_PINCODE,    
    PS_BT_SSP,    
    PS_BT_PINCODE_ENABLE,    
    PS_BT_SECURITYMODE,    
    PS_BT_BOOTMODE,    
    PS_BT_BLUETOOTH_TO_IRDA,    
    PS_BT_BLUETOOTH_TO_NET,    
    PS_BT_KEY,    
    PS_BT_AUTO_CONNECTION,    
    PS_BT_BOOTMODE_PJ,    
    __Null;    

    public static final String key = "ModelSpecLegacyPrinterSettingCategoryBluetooth";
}


public enum ModelSpecLegacyPrinterSettingCategoryNetwork {
    PS_NET_IPV6,    
    PS_WIFI_IPV6,    
    PS_WIFI_BOOTMODE,    
    PS_WIFI_INTERFACE,    
    PS_WIFI_WIRELESSDIRECT_BOOTMODE,    
    PS_WIFI_SETTINGS,    
    PS_WIFI_NODENAME,    
    PS_LAN_SETTINGS,    
    PS_LAN_NODENAME,    
    PS_LAN_IPV6,    
    PS_WIRELESSDIRECT_CREATE_KRY,    
    PS_WIRELESSDIRECT_SETTINGS,    
    __Null;    

    public static final String key = "ModelSpecLegacyPrinterSettingCategoryNetwork";
}


public enum ModelSpecLegacyPrinterSettingCategoryPower {
    PS_POWER_POWEROFFTIME,    
    PS_POWER_POWEROFFTIME_BATTERY,    
    PS_POWER_POWEROFFTIME_RJ2,    
    PS_POWER_POWEROFFTIME_QL8,    
    PS_POWER_POWEROFFTIME_BATTERY_QL8,    
    PS_POWER_POWEROFFTIME_QL1100,    
    PS_POWER_POWEROFFTIME_RJ4000a,    
    PS_POWER_POWEROFFTIME_BATTERY_PJ8,    
    PS_POWER_POWEROFFTIME_ModelFilter,    
    PS_POWER_POWEROFFTIME_PowerSupplyFilter,    
    __Null;    

    public static final String key = "ModelSpecLegacyPrinterSettingCategoryPower";
}


public enum ModelSpecLegacyPrinterSettingCategoryPrint {
    PS_PRINT_JPEG_HALFTONE,    
    PS_PRINT_JPEG_SCALE,    
    PS_PRINT_DENSITY,    
    PS_PRINT_SPEED,    
    __Null;    

    public static final String key = "ModelSpecLegacyPrinterSettingCategoryPrint";
}


public enum ModelSpecLegacyPrintPageCommandType {
    PAGE_START_END,    
    PAGE_START_NEXT_END,    
    __Null;    

    public static final String key = "ModelSpecLegacyPrintPageCommandType";
}


public class ModelSpecLegacyPrintShouldDensityCommand {
    public static final String key = "ModelSpecLegacyPrintShouldDensityCommand";
}

public class ModelSpecLegacyPrintShouldPrinterInfoCommand {
    public static final String key = "ModelSpecLegacyPrintShouldPrinterInfoCommand";
}

public class ModelSpecLegacyPrintShouldSpaceCommand {
    public static final String key = "ModelSpecLegacyPrintShouldSpaceCommand";
}

public class ModelSpecLegacySeriesCode {
    public static final String key = "ModelSpecLegacySeriesCode";
}

public class ModelSpecLegacyStatusIndexOfPaperBackgroundColor {
    public static final String key = "ModelSpecLegacyStatusIndexOfPaperBackgroundColor";
}

public class ModelSpecLegacyStatusIndexOfPaperTextColor {
    public static final String key = "ModelSpecLegacyStatusIndexOfPaperTextColor";
}

public class ModelSpecLegacyStatusIndexOfTubeRibbon {
    public static final String key = "ModelSpecLegacyStatusIndexOfTubeRibbon";
}

public class ModelSpecLegacySupportAdjustPaperPosition {
    public static final String key = "ModelSpecLegacySupportAdjustPaperPosition";
}

public enum ModelSpecLegacySupportAdvanceModeCommand {
    PS_AM_HALFCUT,    
    PS_AM_CUTEND,    
    PS_AM_SPECIALTAPE,    
    PS_AM_HIGH_RESOLUTION,    
    PS_AM_LABEL_CUTEND,    
    PS_AM_NOBUFFER,    
    PS_AM_LOW_RESOLUTION,    
    __Null;    

    public static final String key = "ModelSpecLegacySupportAdvanceModeCommand";
}


public class ModelSpecLegacySupportChangeDpi {
    public static final String key = "ModelSpecLegacySupportChangeDpi";
}

public class ModelSpecLegacySupportCommandProtocolVersion {
    public static final String key = "ModelSpecLegacySupportCommandProtocolVersion";
}

public enum ModelSpecLegacySupportFunc {
    SP_FUC_RASTER_PRINT,    
    SP_FUC_TEMPLATE_PRINT,    
    SP_FUC_TEMPLATE_TRANS,    
    SP_FUC_TEMPLATE_REMOVE,    
    SP_FUC_PRINTER_SETTINGS,    
    SP_FUC_FIRM_UPDATE,    
    __Null;    

    public static final String key = "ModelSpecLegacySupportFunc";
}


public class ModelSpecLegacySupportGetBatteryWeak {
    public static final String key = "ModelSpecLegacySupportGetBatteryWeak";
}

public class ModelSpecLegacySupportGetMediaInfoVersion {
    public static final String key = "ModelSpecLegacySupportGetMediaInfoVersion";
}

public class ModelSpecLegacySupportGetSerialNumber {
    public static final String key = "ModelSpecLegacySupportGetSerialNumber";
}

public class ModelSpecLegacySupportMode9Compression {
    public static final String key = "ModelSpecLegacySupportMode9Compression";
}

public enum ModelSpecLegacySupportMultiColorLabel {
    MONO_COLOR,    
    BI_COLOR,    
    UNSUPPORTED_COLOR,    
    __Null;    

    public static final String key = "ModelSpecLegacySupportMultiColorLabel";
}


public enum ModelSpecLegacySupportPJFeedMode {
    FEED_MODE_FREE,    
    FEED_MODE_FIXEDPAGE,    
    FEED_MODE_ENDOFPAGE,    
    FEED_MODE_ENDOFPAGERETRACT,    
    __Null;    

    public static final String key = "ModelSpecLegacySupportPJFeedMode";
}


public class ModelSpecLegacySupportPJRollCase {
    public static final String key = "ModelSpecLegacySupportPJRollCase";
}

public class ModelSpecLegacySupportPJSpeedCommand {
    public static final String key = "ModelSpecLegacySupportPJSpeedCommand";
}

public class ModelSpecLegacySupportTube {
    public static final String key = "ModelSpecLegacySupportTube";
}

public enum ModelSpecLegacySupportVariousModeCommand {
    PS_VM_AUTOCUT,    
    PS_VM_MIRROR,    
    PS_VM_PEEL,    
    PS_VM_ROTATE180,    
    PS_VM_CUTMARK,    
    PS_FEEDVOL,    
    __Null;    

    public static final String key = "ModelSpecLegacySupportVariousModeCommand";
}


public class ModelSpecLegacyTemplateLimited {
    public static final String key = "ModelSpecLegacyTemplateLimited";
}

public class ModelSpecLegacyTemplateLimitedFirmName {
    public static final String key = "ModelSpecLegacyTemplateLimitedFirmName";
}

public class ModelSpecLegacyTemplateLimitedFirmType {
    public static final String key = "ModelSpecLegacyTemplateLimitedFirmType";
}

public class ModelSpecLegacyTemplateMaxObjectSize {
    public static final String key = "ModelSpecLegacyTemplateMaxObjectSize";
}

public class ModelSpecLegacyTemplateShouldChangeCommandMode {
    public static final String key = "ModelSpecLegacyTemplateShouldChangeCommandMode";
}

public class ModelSpecLegacyUSBDeviceProductID {
    public static final String key = "ModelSpecLegacyUSBDeviceProductID";
}

public class ModelSpecLegacyValidCommunicationBidirectional {
    public static final String key = "ModelSpecLegacyValidCommunicationBidirectional";
}

public class ModelSpecLegacyValidResponseAfterFirmUpdate {
    public static final String key = "ModelSpecLegacyValidResponseAfterFirmUpdate";
}

public class ModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty {
    public static final String key = "ModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty";
}

public class ModelSpecLegacyXdpi {
    public static final String key = "ModelSpecLegacyXdpi";
}

public class ModelSpecLegacyYdpi {
    public static final String key = "ModelSpecLegacyYdpi";
}

}