

#import <XCTest/XCTest.h>
#include <string>
#include "bf_element_set_model_spec_legacy_definition.hpp"
#import "BFElementSetModelSpecLegacyDefinition.h"

@interface BFElementSetModelSpecLegacyTest : XCTestCase

@end

@implementation BFElementSetModelSpecLegacyTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) convertCheckingBFElementSetModelSpecLegacy: (BFElementSetModelSpecLegacyNumber)num {
    NSString *str = [BFElementSetModelSpecLegacy convertToString:num];
    BFElementSetModelSpecLegacyNumber convertedNum = [BFElementSetModelSpecLegacy convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementSetModelSpecLegacy: (BFElementSetModelSpecLegacyNumber)num {
    NSString *strOc = [BFElementSetModelSpecLegacy convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element_set::ModelSpecLegacy::Number numCpp = bf::element_set::ModelSpecLegacy::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementSetModelSpecLegacy: (bf::element_set::ModelSpecLegacy::Number)num {
    std::string strCpp = std::string(bf::element_set::ModelSpecLegacy::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementSetModelSpecLegacyNumber numOc = [BFElementSetModelSpecLegacy convertToNumber:strOc];
    bf::element_set::ModelSpecLegacy::Number numCpp = (bf::element_set::ModelSpecLegacy::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementSetModelSpecLegacy {
    NSString *str;
    BFElementSetModelSpecLegacyNumber num;
    str = [BFElementSetModelSpecLegacy convertToString:BFElementSetModelSpecLegacyNumber(-1)];
    XCTAssertEqualObjects(str, BFElementSetModelSpecLegacyString__Null);
    str = [BFElementSetModelSpecLegacy convertToString:BFElementSetModelSpecLegacyNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementSetModelSpecLegacyString__Null);
    num = [BFElementSetModelSpecLegacy convertToNumber:@""];
    XCTAssertEqual(num, BFElementSetModelSpecLegacyNumber__Null);
    num = [BFElementSetModelSpecLegacy convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementSetModelSpecLegacyNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementSetModelSpecLegacy
{
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelMajor];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelMajor];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelMajor];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelInterface];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelInterface];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelInterface];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyBatteryCommandType];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyBatteryCommandType];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyBatteryCommandType];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyBitOrderOfBitmapIsLittle];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyBitOrderOfBitmapIsLittle];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyBitOrderOfBitmapIsLittle];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyChangeStatusMode];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyChangeStatusMode];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyChangeStatusMode];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyFirmUpdateShouldChangeCommandMode];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyFirmUpdateShouldChangeCommandMode];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyFirmUpdateShouldChangeCommandMode];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyGraphicCommandType];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyGraphicCommandType];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyGraphicCommandType];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyHeadPin];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyHeadPin];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyHeadPin];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyHeadPinWhenPrintTube];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyHeadPinWhenPrintTube];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyHeadPinWhenPrintTube];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyIgnorePaperEmptyWhenPrintEnd];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyIgnorePaperEmptyWhenPrintEnd];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyIgnorePaperEmptyWhenPrintEnd];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyImageHalftoneShouldGammaAdjust];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyImageHalftoneShouldGammaAdjust];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyImageHalftoneShouldGammaAdjust];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyMainVersionCommandType];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyMainVersionCommandType];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyMainVersionCommandType];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyMediaSizeShouldCheck];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyMediaSizeShouldCheck];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyMediaSizeShouldCheck];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyMinPrintMerginPerTenthMM];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyMinPrintMerginPerTenthMM];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyMinPrintMerginPerTenthMM];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyMinPrintPaperLengthPerTenthMM];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyMinPrintPaperLengthPerTenthMM];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyMinPrintPaperLengthPerTenthMM];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyMode9CompressionMaxByteSize];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyMode9CompressionMaxByteSize];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyMode9CompressionMaxByteSize];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyMode9ShouldFlipHorizontal];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyMode9ShouldFlipHorizontal];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyMode9ShouldFlipHorizontal];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyModelCode];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyModelCode];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyModelCode];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyModelName];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyModelName];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyModelName];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyNullCommandLength];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyNullCommandLength];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyNullCommandLength];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPageEndCommandType];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPageEndCommandType];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyPageEndCommandType];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPaperListKind];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPaperListKind];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyPaperListKind];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPrintCompressType];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPrintCompressType];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyPrintCompressType];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPrinterSettingCategoryBluetooth];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPrinterSettingCategoryBluetooth];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyPrinterSettingCategoryBluetooth];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPrinterSettingCategoryNetwork];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPrinterSettingCategoryNetwork];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyPrinterSettingCategoryNetwork];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPrinterSettingCategoryPower];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPrinterSettingCategoryPower];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyPrinterSettingCategoryPower];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPrinterSettingCategoryPrint];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPrinterSettingCategoryPrint];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyPrinterSettingCategoryPrint];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPrintPageCommandType];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPrintPageCommandType];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyPrintPageCommandType];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPrintShouldDensityCommand];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPrintShouldDensityCommand];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyPrintShouldDensityCommand];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPrintShouldPrinterInfoCommand];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPrintShouldPrinterInfoCommand];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyPrintShouldPrinterInfoCommand];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPrintShouldSpaceCommand];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyPrintShouldSpaceCommand];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyPrintShouldSpaceCommand];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySeriesCode];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySeriesCode];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacySeriesCode];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyStatusIndexOfPaperBackgroundColor];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyStatusIndexOfPaperBackgroundColor];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyStatusIndexOfPaperBackgroundColor];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyStatusIndexOfPaperTextColor];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyStatusIndexOfPaperTextColor];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyStatusIndexOfPaperTextColor];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyStatusIndexOfTubeRibbon];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyStatusIndexOfTubeRibbon];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyStatusIndexOfTubeRibbon];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportAdjustPaperPosition];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportAdjustPaperPosition];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacySupportAdjustPaperPosition];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportAdvanceModeCommand];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportAdvanceModeCommand];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacySupportAdvanceModeCommand];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportChangeDpi];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportChangeDpi];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacySupportChangeDpi];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportCommandProtocolVersion];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportCommandProtocolVersion];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacySupportCommandProtocolVersion];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportFunc];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportFunc];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacySupportFunc];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportGetBatteryWeak];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportGetBatteryWeak];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacySupportGetBatteryWeak];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportGetMediaInfoVersion];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportGetMediaInfoVersion];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacySupportGetMediaInfoVersion];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportGetSerialNumber];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportGetSerialNumber];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacySupportGetSerialNumber];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportMode9Compression];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportMode9Compression];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacySupportMode9Compression];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportMultiColorLabel];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportMultiColorLabel];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacySupportMultiColorLabel];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportPJFeedMode];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportPJFeedMode];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacySupportPJFeedMode];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportPJRollCase];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportPJRollCase];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacySupportPJRollCase];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportPJSpeedCommand];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportPJSpeedCommand];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacySupportPJSpeedCommand];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportTube];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportTube];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacySupportTube];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportVariousModeCommand];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacySupportVariousModeCommand];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacySupportVariousModeCommand];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyTemplateLimited];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyTemplateLimited];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyTemplateLimited];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyTemplateLimitedFirmName];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyTemplateLimitedFirmName];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyTemplateLimitedFirmName];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyTemplateLimitedFirmType];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyTemplateLimitedFirmType];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyTemplateLimitedFirmType];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyTemplateMaxObjectSize];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyTemplateMaxObjectSize];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyTemplateMaxObjectSize];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyTemplateShouldChangeCommandMode];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyTemplateShouldChangeCommandMode];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyTemplateShouldChangeCommandMode];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyUSBDeviceProductID];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyUSBDeviceProductID];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyUSBDeviceProductID];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyValidCommunicationBidirectional];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyValidCommunicationBidirectional];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyValidCommunicationBidirectional];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyValidResponseAfterFirmUpdate];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyValidResponseAfterFirmUpdate];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyValidResponseAfterFirmUpdate];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyXdpi];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyXdpi];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyXdpi];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyYdpi];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumberModelSpecLegacyYdpi];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::ModelSpecLegacyYdpi];
    [self convertCheckingBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumber__Null];
    [self convertCheckingOcToCppBFElementSetModelSpecLegacy:BFElementSetModelSpecLegacyNumber__Null];
    [self convertCheckingCppToOcBFElementSetModelSpecLegacy:bf::element_set::ModelSpecLegacy::Number::__Null];
    [self irregularCheckingBFElementSetModelSpecLegacy];
    NSData* strAsData = [BFElementSetModelSpecLegacy.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element_set::ModelSpecLegacy::key == ocKey);
}


@end