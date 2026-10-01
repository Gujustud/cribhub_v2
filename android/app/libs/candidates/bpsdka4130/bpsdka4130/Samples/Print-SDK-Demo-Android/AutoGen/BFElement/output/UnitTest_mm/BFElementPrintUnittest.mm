

#import <XCTest/XCTest.h>
#include <string>
#include "bf_element_print_definition.hpp"
#import "BFElementPrintDefinition.h"

@interface BFElementPrintTest : XCTestCase

@end

@implementation BFElementPrintTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) convertCheckingBFElementPrintDensity: (BFElementPrintDensityNumber)num {
    NSString *str = [BFElementPrintDensity convertToString:num];
    BFElementPrintDensityNumber convertedNum = [BFElementPrintDensity convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementPrintDensity: (BFElementPrintDensityNumber)num {
    NSString *strOc = [BFElementPrintDensity convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::PrintDensity::Number numCpp = bf::element::PrintDensity::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementPrintDensity: (bf::element::PrintDensity::Number)num {
    std::string strCpp = std::string(bf::element::PrintDensity::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementPrintDensityNumber numOc = [BFElementPrintDensity convertToNumber:strOc];
    bf::element::PrintDensity::Number numCpp = (bf::element::PrintDensity::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementPrintDensity {
    NSString *str;
    BFElementPrintDensityNumber num;
    str = [BFElementPrintDensity convertToString:BFElementPrintDensityNumber(-1)];
    XCTAssertEqualObjects(str, BFElementPrintDensityString__Null);
    str = [BFElementPrintDensity convertToString:BFElementPrintDensityNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementPrintDensityString__Null);
    num = [BFElementPrintDensity convertToNumber:@""];
    XCTAssertEqual(num, BFElementPrintDensityNumber__Null);
    num = [BFElementPrintDensity convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementPrintDensityNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementPrintDensity
{
    [self convertCheckingBFElementPrintDensity:BFElementPrintDensityNumberWeakLevel5];
    [self convertCheckingOcToCppBFElementPrintDensity:BFElementPrintDensityNumberWeakLevel5];
    [self convertCheckingCppToOcBFElementPrintDensity:bf::element::PrintDensity::Number::WeakLevel5];
    [self convertCheckingBFElementPrintDensity:BFElementPrintDensityNumberWeakLevel4];
    [self convertCheckingOcToCppBFElementPrintDensity:BFElementPrintDensityNumberWeakLevel4];
    [self convertCheckingCppToOcBFElementPrintDensity:bf::element::PrintDensity::Number::WeakLevel4];
    [self convertCheckingBFElementPrintDensity:BFElementPrintDensityNumberWeakLevel3];
    [self convertCheckingOcToCppBFElementPrintDensity:BFElementPrintDensityNumberWeakLevel3];
    [self convertCheckingCppToOcBFElementPrintDensity:bf::element::PrintDensity::Number::WeakLevel3];
    [self convertCheckingBFElementPrintDensity:BFElementPrintDensityNumberWeakLevel2];
    [self convertCheckingOcToCppBFElementPrintDensity:BFElementPrintDensityNumberWeakLevel2];
    [self convertCheckingCppToOcBFElementPrintDensity:bf::element::PrintDensity::Number::WeakLevel2];
    [self convertCheckingBFElementPrintDensity:BFElementPrintDensityNumberWeakLevel1];
    [self convertCheckingOcToCppBFElementPrintDensity:BFElementPrintDensityNumberWeakLevel1];
    [self convertCheckingCppToOcBFElementPrintDensity:bf::element::PrintDensity::Number::WeakLevel1];
    [self convertCheckingBFElementPrintDensity:BFElementPrintDensityNumberNeutral];
    [self convertCheckingOcToCppBFElementPrintDensity:BFElementPrintDensityNumberNeutral];
    [self convertCheckingCppToOcBFElementPrintDensity:bf::element::PrintDensity::Number::Neutral];
    [self convertCheckingBFElementPrintDensity:BFElementPrintDensityNumberStrongLevel1];
    [self convertCheckingOcToCppBFElementPrintDensity:BFElementPrintDensityNumberStrongLevel1];
    [self convertCheckingCppToOcBFElementPrintDensity:bf::element::PrintDensity::Number::StrongLevel1];
    [self convertCheckingBFElementPrintDensity:BFElementPrintDensityNumberStrongLevel2];
    [self convertCheckingOcToCppBFElementPrintDensity:BFElementPrintDensityNumberStrongLevel2];
    [self convertCheckingCppToOcBFElementPrintDensity:bf::element::PrintDensity::Number::StrongLevel2];
    [self convertCheckingBFElementPrintDensity:BFElementPrintDensityNumberStrongLevel3];
    [self convertCheckingOcToCppBFElementPrintDensity:BFElementPrintDensityNumberStrongLevel3];
    [self convertCheckingCppToOcBFElementPrintDensity:bf::element::PrintDensity::Number::StrongLevel3];
    [self convertCheckingBFElementPrintDensity:BFElementPrintDensityNumberStrongLevel4];
    [self convertCheckingOcToCppBFElementPrintDensity:BFElementPrintDensityNumberStrongLevel4];
    [self convertCheckingCppToOcBFElementPrintDensity:bf::element::PrintDensity::Number::StrongLevel4];
    [self convertCheckingBFElementPrintDensity:BFElementPrintDensityNumberStrongLevel5];
    [self convertCheckingOcToCppBFElementPrintDensity:BFElementPrintDensityNumberStrongLevel5];
    [self convertCheckingCppToOcBFElementPrintDensity:bf::element::PrintDensity::Number::StrongLevel5];
    [self convertCheckingBFElementPrintDensity:BFElementPrintDensityNumberUsePrinterSetting];
    [self convertCheckingOcToCppBFElementPrintDensity:BFElementPrintDensityNumberUsePrinterSetting];
    [self convertCheckingCppToOcBFElementPrintDensity:bf::element::PrintDensity::Number::UsePrinterSetting];
    [self convertCheckingBFElementPrintDensity:BFElementPrintDensityNumber__Null];
    [self convertCheckingOcToCppBFElementPrintDensity:BFElementPrintDensityNumber__Null];
    [self convertCheckingCppToOcBFElementPrintDensity:bf::element::PrintDensity::Number::__Null];
    [self irregularCheckingBFElementPrintDensity];
    NSData* strAsData = [BFElementPrintDensity.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::PrintDensity::key == ocKey);
}

- (void) convertCheckingBFElementPrintFeedMode: (BFElementPrintFeedModeNumber)num {
    NSString *str = [BFElementPrintFeedMode convertToString:num];
    BFElementPrintFeedModeNumber convertedNum = [BFElementPrintFeedMode convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementPrintFeedMode: (BFElementPrintFeedModeNumber)num {
    NSString *strOc = [BFElementPrintFeedMode convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::PrintFeedMode::Number numCpp = bf::element::PrintFeedMode::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementPrintFeedMode: (bf::element::PrintFeedMode::Number)num {
    std::string strCpp = std::string(bf::element::PrintFeedMode::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementPrintFeedModeNumber numOc = [BFElementPrintFeedMode convertToNumber:strOc];
    bf::element::PrintFeedMode::Number numCpp = (bf::element::PrintFeedMode::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementPrintFeedMode {
    NSString *str;
    BFElementPrintFeedModeNumber num;
    str = [BFElementPrintFeedMode convertToString:BFElementPrintFeedModeNumber(-1)];
    XCTAssertEqualObjects(str, BFElementPrintFeedModeString__Null);
    str = [BFElementPrintFeedMode convertToString:BFElementPrintFeedModeNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementPrintFeedModeString__Null);
    num = [BFElementPrintFeedMode convertToNumber:@""];
    XCTAssertEqual(num, BFElementPrintFeedModeNumber__Null);
    num = [BFElementPrintFeedMode convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementPrintFeedModeNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementPrintFeedMode
{
    [self convertCheckingBFElementPrintFeedMode:BFElementPrintFeedModeNumberNoFeed];
    [self convertCheckingOcToCppBFElementPrintFeedMode:BFElementPrintFeedModeNumberNoFeed];
    [self convertCheckingCppToOcBFElementPrintFeedMode:bf::element::PrintFeedMode::Number::NoFeed];
    [self convertCheckingBFElementPrintFeedMode:BFElementPrintFeedModeNumberFixedPage];
    [self convertCheckingOcToCppBFElementPrintFeedMode:BFElementPrintFeedModeNumberFixedPage];
    [self convertCheckingCppToOcBFElementPrintFeedMode:bf::element::PrintFeedMode::Number::FixedPage];
    [self convertCheckingBFElementPrintFeedMode:BFElementPrintFeedModeNumberEndOfPage];
    [self convertCheckingOcToCppBFElementPrintFeedMode:BFElementPrintFeedModeNumberEndOfPage];
    [self convertCheckingCppToOcBFElementPrintFeedMode:bf::element::PrintFeedMode::Number::EndOfPage];
    [self convertCheckingBFElementPrintFeedMode:BFElementPrintFeedModeNumberEndOfPageRetract];
    [self convertCheckingOcToCppBFElementPrintFeedMode:BFElementPrintFeedModeNumberEndOfPageRetract];
    [self convertCheckingCppToOcBFElementPrintFeedMode:bf::element::PrintFeedMode::Number::EndOfPageRetract];
    [self convertCheckingBFElementPrintFeedMode:BFElementPrintFeedModeNumber__Null];
    [self convertCheckingOcToCppBFElementPrintFeedMode:BFElementPrintFeedModeNumber__Null];
    [self convertCheckingCppToOcBFElementPrintFeedMode:bf::element::PrintFeedMode::Number::__Null];
    [self irregularCheckingBFElementPrintFeedMode];
    NSData* strAsData = [BFElementPrintFeedMode.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::PrintFeedMode::key == ocKey);
}

- (void) convertCheckingBFElementPrintHorizontalAlign: (BFElementPrintHorizontalAlignNumber)num {
    NSString *str = [BFElementPrintHorizontalAlign convertToString:num];
    BFElementPrintHorizontalAlignNumber convertedNum = [BFElementPrintHorizontalAlign convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementPrintHorizontalAlign: (BFElementPrintHorizontalAlignNumber)num {
    NSString *strOc = [BFElementPrintHorizontalAlign convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::PrintHorizontalAlign::Number numCpp = bf::element::PrintHorizontalAlign::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementPrintHorizontalAlign: (bf::element::PrintHorizontalAlign::Number)num {
    std::string strCpp = std::string(bf::element::PrintHorizontalAlign::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementPrintHorizontalAlignNumber numOc = [BFElementPrintHorizontalAlign convertToNumber:strOc];
    bf::element::PrintHorizontalAlign::Number numCpp = (bf::element::PrintHorizontalAlign::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementPrintHorizontalAlign {
    NSString *str;
    BFElementPrintHorizontalAlignNumber num;
    str = [BFElementPrintHorizontalAlign convertToString:BFElementPrintHorizontalAlignNumber(-1)];
    XCTAssertEqualObjects(str, BFElementPrintHorizontalAlignString__Null);
    str = [BFElementPrintHorizontalAlign convertToString:BFElementPrintHorizontalAlignNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementPrintHorizontalAlignString__Null);
    num = [BFElementPrintHorizontalAlign convertToNumber:@""];
    XCTAssertEqual(num, BFElementPrintHorizontalAlignNumber__Null);
    num = [BFElementPrintHorizontalAlign convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementPrintHorizontalAlignNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementPrintHorizontalAlign
{
    [self convertCheckingBFElementPrintHorizontalAlign:BFElementPrintHorizontalAlignNumberLeft];
    [self convertCheckingOcToCppBFElementPrintHorizontalAlign:BFElementPrintHorizontalAlignNumberLeft];
    [self convertCheckingCppToOcBFElementPrintHorizontalAlign:bf::element::PrintHorizontalAlign::Number::Left];
    [self convertCheckingBFElementPrintHorizontalAlign:BFElementPrintHorizontalAlignNumberCenter];
    [self convertCheckingOcToCppBFElementPrintHorizontalAlign:BFElementPrintHorizontalAlignNumberCenter];
    [self convertCheckingCppToOcBFElementPrintHorizontalAlign:bf::element::PrintHorizontalAlign::Number::Center];
    [self convertCheckingBFElementPrintHorizontalAlign:BFElementPrintHorizontalAlignNumberRight];
    [self convertCheckingOcToCppBFElementPrintHorizontalAlign:BFElementPrintHorizontalAlignNumberRight];
    [self convertCheckingCppToOcBFElementPrintHorizontalAlign:bf::element::PrintHorizontalAlign::Number::Right];
    [self convertCheckingBFElementPrintHorizontalAlign:BFElementPrintHorizontalAlignNumber__Null];
    [self convertCheckingOcToCppBFElementPrintHorizontalAlign:BFElementPrintHorizontalAlignNumber__Null];
    [self convertCheckingCppToOcBFElementPrintHorizontalAlign:bf::element::PrintHorizontalAlign::Number::__Null];
    [self irregularCheckingBFElementPrintHorizontalAlign];
    NSData* strAsData = [BFElementPrintHorizontalAlign.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::PrintHorizontalAlign::key == ocKey);
}

- (void) convertCheckingBFElementPrintPolicyOfProcessingPrintData: (BFElementPrintPolicyOfProcessingPrintDataNumber)num {
    NSString *str = [BFElementPrintPolicyOfProcessingPrintData convertToString:num];
    BFElementPrintPolicyOfProcessingPrintDataNumber convertedNum = [BFElementPrintPolicyOfProcessingPrintData convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementPrintPolicyOfProcessingPrintData: (BFElementPrintPolicyOfProcessingPrintDataNumber)num {
    NSString *strOc = [BFElementPrintPolicyOfProcessingPrintData convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::PrintPolicyOfProcessingPrintData::Number numCpp = bf::element::PrintPolicyOfProcessingPrintData::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementPrintPolicyOfProcessingPrintData: (bf::element::PrintPolicyOfProcessingPrintData::Number)num {
    std::string strCpp = std::string(bf::element::PrintPolicyOfProcessingPrintData::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementPrintPolicyOfProcessingPrintDataNumber numOc = [BFElementPrintPolicyOfProcessingPrintData convertToNumber:strOc];
    bf::element::PrintPolicyOfProcessingPrintData::Number numCpp = (bf::element::PrintPolicyOfProcessingPrintData::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementPrintPolicyOfProcessingPrintData {
    NSString *str;
    BFElementPrintPolicyOfProcessingPrintDataNumber num;
    str = [BFElementPrintPolicyOfProcessingPrintData convertToString:BFElementPrintPolicyOfProcessingPrintDataNumber(-1)];
    XCTAssertEqualObjects(str, BFElementPrintPolicyOfProcessingPrintDataString__Null);
    str = [BFElementPrintPolicyOfProcessingPrintData convertToString:BFElementPrintPolicyOfProcessingPrintDataNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementPrintPolicyOfProcessingPrintDataString__Null);
    num = [BFElementPrintPolicyOfProcessingPrintData convertToNumber:@""];
    XCTAssertEqual(num, BFElementPrintPolicyOfProcessingPrintDataNumber__Null);
    num = [BFElementPrintPolicyOfProcessingPrintData convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementPrintPolicyOfProcessingPrintDataNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementPrintPolicyOfProcessingPrintData
{
    [self convertCheckingBFElementPrintPolicyOfProcessingPrintData:BFElementPrintPolicyOfProcessingPrintDataNumberBatchPrint];
    [self convertCheckingOcToCppBFElementPrintPolicyOfProcessingPrintData:BFElementPrintPolicyOfProcessingPrintDataNumberBatchPrint];
    [self convertCheckingCppToOcBFElementPrintPolicyOfProcessingPrintData:bf::element::PrintPolicyOfProcessingPrintData::Number::BatchPrint];
    [self convertCheckingBFElementPrintPolicyOfProcessingPrintData:BFElementPrintPolicyOfProcessingPrintDataNumberRealTimePrint];
    [self convertCheckingOcToCppBFElementPrintPolicyOfProcessingPrintData:BFElementPrintPolicyOfProcessingPrintDataNumberRealTimePrint];
    [self convertCheckingCppToOcBFElementPrintPolicyOfProcessingPrintData:bf::element::PrintPolicyOfProcessingPrintData::Number::RealTimePrint];
    [self convertCheckingBFElementPrintPolicyOfProcessingPrintData:BFElementPrintPolicyOfProcessingPrintDataNumber__Null];
    [self convertCheckingOcToCppBFElementPrintPolicyOfProcessingPrintData:BFElementPrintPolicyOfProcessingPrintDataNumber__Null];
    [self convertCheckingCppToOcBFElementPrintPolicyOfProcessingPrintData:bf::element::PrintPolicyOfProcessingPrintData::Number::__Null];
    [self irregularCheckingBFElementPrintPolicyOfProcessingPrintData];
    NSData* strAsData = [BFElementPrintPolicyOfProcessingPrintData.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::PrintPolicyOfProcessingPrintData::key == ocKey);
}

- (void) convertCheckingBFElementPrintQuality: (BFElementPrintQualityNumber)num {
    NSString *str = [BFElementPrintQuality convertToString:num];
    BFElementPrintQualityNumber convertedNum = [BFElementPrintQuality convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementPrintQuality: (BFElementPrintQualityNumber)num {
    NSString *strOc = [BFElementPrintQuality convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::PrintQuality::Number numCpp = bf::element::PrintQuality::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementPrintQuality: (bf::element::PrintQuality::Number)num {
    std::string strCpp = std::string(bf::element::PrintQuality::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementPrintQualityNumber numOc = [BFElementPrintQuality convertToNumber:strOc];
    bf::element::PrintQuality::Number numCpp = (bf::element::PrintQuality::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementPrintQuality {
    NSString *str;
    BFElementPrintQualityNumber num;
    str = [BFElementPrintQuality convertToString:BFElementPrintQualityNumber(-1)];
    XCTAssertEqualObjects(str, BFElementPrintQualityString__Null);
    str = [BFElementPrintQuality convertToString:BFElementPrintQualityNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementPrintQualityString__Null);
    num = [BFElementPrintQuality convertToNumber:@""];
    XCTAssertEqual(num, BFElementPrintQualityNumber__Null);
    num = [BFElementPrintQuality convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementPrintQualityNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementPrintQuality
{
    [self convertCheckingBFElementPrintQuality:BFElementPrintQualityNumberLowResolutionHighSpeed];
    [self convertCheckingOcToCppBFElementPrintQuality:BFElementPrintQualityNumberLowResolutionHighSpeed];
    [self convertCheckingCppToOcBFElementPrintQuality:bf::element::PrintQuality::Number::LowResolutionHighSpeed];
    [self convertCheckingBFElementPrintQuality:BFElementPrintQualityNumberNormalResolutionNormalSpeed];
    [self convertCheckingOcToCppBFElementPrintQuality:BFElementPrintQualityNumberNormalResolutionNormalSpeed];
    [self convertCheckingCppToOcBFElementPrintQuality:bf::element::PrintQuality::Number::NormalResolutionNormalSpeed];
    [self convertCheckingBFElementPrintQuality:BFElementPrintQualityNumberNormalResolutionDoubleSpeed];
    [self convertCheckingOcToCppBFElementPrintQuality:BFElementPrintQualityNumberNormalResolutionDoubleSpeed];
    [self convertCheckingCppToOcBFElementPrintQuality:bf::element::PrintQuality::Number::NormalResolutionDoubleSpeed];
    [self convertCheckingBFElementPrintQuality:BFElementPrintQualityNumberHighResolutionLowSpeed];
    [self convertCheckingOcToCppBFElementPrintQuality:BFElementPrintQualityNumberHighResolutionLowSpeed];
    [self convertCheckingCppToOcBFElementPrintQuality:bf::element::PrintQuality::Number::HighResolutionLowSpeed];
    [self convertCheckingBFElementPrintQuality:BFElementPrintQualityNumberHighResolutionUsingHRImageLowSpeed];
    [self convertCheckingOcToCppBFElementPrintQuality:BFElementPrintQualityNumberHighResolutionUsingHRImageLowSpeed];
    [self convertCheckingCppToOcBFElementPrintQuality:bf::element::PrintQuality::Number::HighResolutionUsingHRImageLowSpeed];
    [self convertCheckingBFElementPrintQuality:BFElementPrintQualityNumber__Null];
    [self convertCheckingOcToCppBFElementPrintQuality:BFElementPrintQualityNumber__Null];
    [self convertCheckingCppToOcBFElementPrintQuality:bf::element::PrintQuality::Number::__Null];
    [self irregularCheckingBFElementPrintQuality];
    NSData* strAsData = [BFElementPrintQuality.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::PrintQuality::key == ocKey);
}

- (void) convertCheckingBFElementPrintScalingMode: (BFElementPrintScalingModeNumber)num {
    NSString *str = [BFElementPrintScalingMode convertToString:num];
    BFElementPrintScalingModeNumber convertedNum = [BFElementPrintScalingMode convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementPrintScalingMode: (BFElementPrintScalingModeNumber)num {
    NSString *strOc = [BFElementPrintScalingMode convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::PrintScalingMode::Number numCpp = bf::element::PrintScalingMode::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementPrintScalingMode: (bf::element::PrintScalingMode::Number)num {
    std::string strCpp = std::string(bf::element::PrintScalingMode::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementPrintScalingModeNumber numOc = [BFElementPrintScalingMode convertToNumber:strOc];
    bf::element::PrintScalingMode::Number numCpp = (bf::element::PrintScalingMode::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementPrintScalingMode {
    NSString *str;
    BFElementPrintScalingModeNumber num;
    str = [BFElementPrintScalingMode convertToString:BFElementPrintScalingModeNumber(-1)];
    XCTAssertEqualObjects(str, BFElementPrintScalingModeString__Null);
    str = [BFElementPrintScalingMode convertToString:BFElementPrintScalingModeNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementPrintScalingModeString__Null);
    num = [BFElementPrintScalingMode convertToNumber:@""];
    XCTAssertEqual(num, BFElementPrintScalingModeNumber__Null);
    num = [BFElementPrintScalingMode convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementPrintScalingModeNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementPrintScalingMode
{
    [self convertCheckingBFElementPrintScalingMode:BFElementPrintScalingModeNumberOriginal];
    [self convertCheckingOcToCppBFElementPrintScalingMode:BFElementPrintScalingModeNumberOriginal];
    [self convertCheckingCppToOcBFElementPrintScalingMode:bf::element::PrintScalingMode::Number::Original];
    [self convertCheckingBFElementPrintScalingMode:BFElementPrintScalingModeNumberFitToPrintArea];
    [self convertCheckingOcToCppBFElementPrintScalingMode:BFElementPrintScalingModeNumberFitToPrintArea];
    [self convertCheckingCppToOcBFElementPrintScalingMode:bf::element::PrintScalingMode::Number::FitToPrintArea];
    [self convertCheckingBFElementPrintScalingMode:BFElementPrintScalingModeNumberFitToPaper];
    [self convertCheckingOcToCppBFElementPrintScalingMode:BFElementPrintScalingModeNumberFitToPaper];
    [self convertCheckingCppToOcBFElementPrintScalingMode:bf::element::PrintScalingMode::Number::FitToPaper];
    [self convertCheckingBFElementPrintScalingMode:BFElementPrintScalingModeNumberCustom];
    [self convertCheckingOcToCppBFElementPrintScalingMode:BFElementPrintScalingModeNumberCustom];
    [self convertCheckingCppToOcBFElementPrintScalingMode:bf::element::PrintScalingMode::Number::Custom];
    [self convertCheckingBFElementPrintScalingMode:BFElementPrintScalingModeNumber__Null];
    [self convertCheckingOcToCppBFElementPrintScalingMode:BFElementPrintScalingModeNumber__Null];
    [self convertCheckingCppToOcBFElementPrintScalingMode:bf::element::PrintScalingMode::Number::__Null];
    [self irregularCheckingBFElementPrintScalingMode];
    NSData* strAsData = [BFElementPrintScalingMode.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::PrintScalingMode::key == ocKey);
}

- (void) convertCheckingBFElementPrintSpeed: (BFElementPrintSpeedNumber)num {
    NSString *str = [BFElementPrintSpeed convertToString:num];
    BFElementPrintSpeedNumber convertedNum = [BFElementPrintSpeed convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementPrintSpeed: (BFElementPrintSpeedNumber)num {
    NSString *strOc = [BFElementPrintSpeed convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::PrintSpeed::Number numCpp = bf::element::PrintSpeed::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementPrintSpeed: (bf::element::PrintSpeed::Number)num {
    std::string strCpp = std::string(bf::element::PrintSpeed::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementPrintSpeedNumber numOc = [BFElementPrintSpeed convertToNumber:strOc];
    bf::element::PrintSpeed::Number numCpp = (bf::element::PrintSpeed::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementPrintSpeed {
    NSString *str;
    BFElementPrintSpeedNumber num;
    str = [BFElementPrintSpeed convertToString:BFElementPrintSpeedNumber(-1)];
    XCTAssertEqualObjects(str, BFElementPrintSpeedString__Null);
    str = [BFElementPrintSpeed convertToString:BFElementPrintSpeedNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementPrintSpeedString__Null);
    num = [BFElementPrintSpeed convertToNumber:@""];
    XCTAssertEqual(num, BFElementPrintSpeedNumber__Null);
    num = [BFElementPrintSpeed convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementPrintSpeedNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementPrintSpeed
{
    [self convertCheckingBFElementPrintSpeed:BFElementPrintSpeedNumberHighSpeed];
    [self convertCheckingOcToCppBFElementPrintSpeed:BFElementPrintSpeedNumberHighSpeed];
    [self convertCheckingCppToOcBFElementPrintSpeed:bf::element::PrintSpeed::Number::HighSpeed];
    [self convertCheckingBFElementPrintSpeed:BFElementPrintSpeedNumberMediumHighSpeed];
    [self convertCheckingOcToCppBFElementPrintSpeed:BFElementPrintSpeedNumberMediumHighSpeed];
    [self convertCheckingCppToOcBFElementPrintSpeed:bf::element::PrintSpeed::Number::MediumHighSpeed];
    [self convertCheckingBFElementPrintSpeed:BFElementPrintSpeedNumberMediumLowSpeed];
    [self convertCheckingOcToCppBFElementPrintSpeed:BFElementPrintSpeedNumberMediumLowSpeed];
    [self convertCheckingCppToOcBFElementPrintSpeed:bf::element::PrintSpeed::Number::MediumLowSpeed];
    [self convertCheckingBFElementPrintSpeed:BFElementPrintSpeedNumberLowSpeed];
    [self convertCheckingOcToCppBFElementPrintSpeed:BFElementPrintSpeedNumberLowSpeed];
    [self convertCheckingCppToOcBFElementPrintSpeed:bf::element::PrintSpeed::Number::LowSpeed];
    [self convertCheckingBFElementPrintSpeed:BFElementPrintSpeedNumberFast_DraftQuality];
    [self convertCheckingOcToCppBFElementPrintSpeed:BFElementPrintSpeedNumberFast_DraftQuality];
    [self convertCheckingCppToOcBFElementPrintSpeed:bf::element::PrintSpeed::Number::Fast_DraftQuality];
    [self convertCheckingBFElementPrintSpeed:BFElementPrintSpeedNumberFast_LineConversion];
    [self convertCheckingOcToCppBFElementPrintSpeed:BFElementPrintSpeedNumberFast_LineConversion];
    [self convertCheckingCppToOcBFElementPrintSpeed:bf::element::PrintSpeed::Number::Fast_LineConversion];
    [self convertCheckingBFElementPrintSpeed:BFElementPrintSpeedNumberUsePrinterSetting];
    [self convertCheckingOcToCppBFElementPrintSpeed:BFElementPrintSpeedNumberUsePrinterSetting];
    [self convertCheckingCppToOcBFElementPrintSpeed:bf::element::PrintSpeed::Number::UsePrinterSetting];
    [self convertCheckingBFElementPrintSpeed:BFElementPrintSpeedNumber__Null];
    [self convertCheckingOcToCppBFElementPrintSpeed:BFElementPrintSpeedNumber__Null];
    [self convertCheckingCppToOcBFElementPrintSpeed:bf::element::PrintSpeed::Number::__Null];
    [self irregularCheckingBFElementPrintSpeed];
    NSData* strAsData = [BFElementPrintSpeed.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::PrintSpeed::key == ocKey);
}

- (void) convertCheckingBFElementPrintVerticalAlign: (BFElementPrintVerticalAlignNumber)num {
    NSString *str = [BFElementPrintVerticalAlign convertToString:num];
    BFElementPrintVerticalAlignNumber convertedNum = [BFElementPrintVerticalAlign convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementPrintVerticalAlign: (BFElementPrintVerticalAlignNumber)num {
    NSString *strOc = [BFElementPrintVerticalAlign convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::PrintVerticalAlign::Number numCpp = bf::element::PrintVerticalAlign::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementPrintVerticalAlign: (bf::element::PrintVerticalAlign::Number)num {
    std::string strCpp = std::string(bf::element::PrintVerticalAlign::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementPrintVerticalAlignNumber numOc = [BFElementPrintVerticalAlign convertToNumber:strOc];
    bf::element::PrintVerticalAlign::Number numCpp = (bf::element::PrintVerticalAlign::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementPrintVerticalAlign {
    NSString *str;
    BFElementPrintVerticalAlignNumber num;
    str = [BFElementPrintVerticalAlign convertToString:BFElementPrintVerticalAlignNumber(-1)];
    XCTAssertEqualObjects(str, BFElementPrintVerticalAlignString__Null);
    str = [BFElementPrintVerticalAlign convertToString:BFElementPrintVerticalAlignNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementPrintVerticalAlignString__Null);
    num = [BFElementPrintVerticalAlign convertToNumber:@""];
    XCTAssertEqual(num, BFElementPrintVerticalAlignNumber__Null);
    num = [BFElementPrintVerticalAlign convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementPrintVerticalAlignNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementPrintVerticalAlign
{
    [self convertCheckingBFElementPrintVerticalAlign:BFElementPrintVerticalAlignNumberTop];
    [self convertCheckingOcToCppBFElementPrintVerticalAlign:BFElementPrintVerticalAlignNumberTop];
    [self convertCheckingCppToOcBFElementPrintVerticalAlign:bf::element::PrintVerticalAlign::Number::Top];
    [self convertCheckingBFElementPrintVerticalAlign:BFElementPrintVerticalAlignNumberMiddle];
    [self convertCheckingOcToCppBFElementPrintVerticalAlign:BFElementPrintVerticalAlignNumberMiddle];
    [self convertCheckingCppToOcBFElementPrintVerticalAlign:bf::element::PrintVerticalAlign::Number::Middle];
    [self convertCheckingBFElementPrintVerticalAlign:BFElementPrintVerticalAlignNumberBottom];
    [self convertCheckingOcToCppBFElementPrintVerticalAlign:BFElementPrintVerticalAlignNumberBottom];
    [self convertCheckingCppToOcBFElementPrintVerticalAlign:bf::element::PrintVerticalAlign::Number::Bottom];
    [self convertCheckingBFElementPrintVerticalAlign:BFElementPrintVerticalAlignNumber__Null];
    [self convertCheckingOcToCppBFElementPrintVerticalAlign:BFElementPrintVerticalAlignNumber__Null];
    [self convertCheckingCppToOcBFElementPrintVerticalAlign:bf::element::PrintVerticalAlign::Number::__Null];
    [self irregularCheckingBFElementPrintVerticalAlign];
    NSData* strAsData = [BFElementPrintVerticalAlign.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::PrintVerticalAlign::key == ocKey);
}


@end