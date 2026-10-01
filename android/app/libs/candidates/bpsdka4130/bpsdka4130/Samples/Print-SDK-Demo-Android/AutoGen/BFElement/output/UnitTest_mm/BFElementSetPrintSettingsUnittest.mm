

#import <XCTest/XCTest.h>
#include <string>
#include "bf_element_set_print_settings_definition.hpp"
#import "BFElementSetPrintSettingsDefinition.h"

@interface BFElementSetPrintSettingsTest : XCTestCase

@end

@implementation BFElementSetPrintSettingsTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) convertCheckingBFElementSetPrintSettings: (BFElementSetPrintSettingsNumber)num {
    NSString *str = [BFElementSetPrintSettings convertToString:num];
    BFElementSetPrintSettingsNumber convertedNum = [BFElementSetPrintSettings convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementSetPrintSettings: (BFElementSetPrintSettingsNumber)num {
    NSString *strOc = [BFElementSetPrintSettings convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element_set::PrintSettings::Number numCpp = bf::element_set::PrintSettings::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementSetPrintSettings: (bf::element_set::PrintSettings::Number)num {
    std::string strCpp = std::string(bf::element_set::PrintSettings::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementSetPrintSettingsNumber numOc = [BFElementSetPrintSettings convertToNumber:strOc];
    bf::element_set::PrintSettings::Number numCpp = (bf::element_set::PrintSettings::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementSetPrintSettings {
    NSString *str;
    BFElementSetPrintSettingsNumber num;
    str = [BFElementSetPrintSettings convertToString:BFElementSetPrintSettingsNumber(-1)];
    XCTAssertEqualObjects(str, BFElementSetPrintSettingsString__Null);
    str = [BFElementSetPrintSettings convertToString:BFElementSetPrintSettingsNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementSetPrintSettingsString__Null);
    num = [BFElementSetPrintSettings convertToNumber:@""];
    XCTAssertEqual(num, BFElementSetPrintSettingsNumber__Null);
    num = [BFElementSetPrintSettings convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementSetPrintSettingsNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementSetPrintSettings
{
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberMediaSize];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberMediaSize];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::MediaSize];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberImageOrientation];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberImageOrientation];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::ImageOrientation];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintScalingMode];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintScalingMode];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintScalingMode];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberImageHalftone];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberImageHalftone];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::ImageHalftone];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberImageBrightness];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberImageBrightness];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::ImageBrightness];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberImageContrast];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberImageContrast];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::ImageContrast];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberImageRedEnhancement];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberImageRedEnhancement];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::ImageRedEnhancement];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberImageGreenEnhancement];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberImageGreenEnhancement];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::ImageGreenEnhancement];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberImageBlueEnhancement];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberImageBlueEnhancement];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::ImageBlueEnhancement];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintHorizontalAlign];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintHorizontalAlign];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintHorizontalAlign];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintVerticalAlign];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintVerticalAlign];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintVerticalAlign];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintTopMargin];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintTopMargin];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintTopMargin];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintLeftMargin];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintLeftMargin];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintLeftMargin];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberMediaTextColor];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberMediaTextColor];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::MediaTextColor];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberMediaBackgroundColor];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberMediaBackgroundColor];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::MediaBackgroundColor];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintScalingValue];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintScalingValue];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintScalingValue];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintAutoCutLast];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintAutoCutLast];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintAutoCutLast];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintAutoCutEvery];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintAutoCutEvery];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintAutoCutEvery];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintAutoCutEveryCyclePerPage];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintAutoCutEveryCyclePerPage];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintAutoCutEveryCyclePerPage];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintAutoCutDisableForSpecialTape];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintAutoCutDisableForSpecialTape];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintAutoCutDisableForSpecialTape];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintAutoHalfCut];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintAutoHalfCut];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintAutoHalfCut];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintDensity];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintDensity];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintDensity];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintSpeed];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintSpeed];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintSpeed];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintDashLine];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintDashLine];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintDashLine];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintUsingCarbonCopyPaper];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintUsingCarbonCopyPaper];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintUsingCarbonCopyPaper];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintFeedMode];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintFeedMode];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintFeedMode];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintQuality];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintQuality];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintQuality];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberMediaPJRollCase];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberMediaPJRollCase];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::MediaPJRollCase];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberMediaPaperInsertionPosition];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberMediaPaperInsertionPosition];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::MediaPaperInsertionPosition];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberMediaPJPaperType];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberMediaPJPaperType];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::MediaPJPaperType];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberMediaPJCustomSize];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberMediaPJCustomSize];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::MediaPJCustomSize];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberMediaPJForceStretchPrintableArea];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberMediaPJForceStretchPrintableArea];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::MediaPJForceStretchPrintableArea];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintExtraFeedDots];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintExtraFeedDots];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintExtraFeedDots];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintCopies];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintCopies];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintCopies];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintBidirectionalCommunication];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintBidirectionalCommunication];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintBidirectionalCommunication];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberImageTrimBlankDataFromTail];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberImageTrimBlankDataFromTail];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::ImageTrimBlankDataFromTail];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintPolicyOfProcessingPrintData];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintPolicyOfProcessingPrintData];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintPolicyOfProcessingPrintData];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintCollate];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintCollate];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintCollate];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintCheckMediaTextColor];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintCheckMediaTextColor];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintCheckMediaTextColor];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintCheckMediaBackgroundColor];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintCheckMediaBackgroundColor];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintCheckMediaBackgroundColor];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintCutPause];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumberPrintCutPause];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::PrintCutPause];
    [self convertCheckingBFElementSetPrintSettings:BFElementSetPrintSettingsNumber__Null];
    [self convertCheckingOcToCppBFElementSetPrintSettings:BFElementSetPrintSettingsNumber__Null];
    [self convertCheckingCppToOcBFElementSetPrintSettings:bf::element_set::PrintSettings::Number::__Null];
    [self irregularCheckingBFElementSetPrintSettings];
    NSData* strAsData = [BFElementSetPrintSettings.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element_set::PrintSettings::key == ocKey);
}


@end