

#import <XCTest/XCTest.h>
#include <string>
#include "bf_element_model_spec_legacy_definition.hpp"
#import "BFElementModelSpecLegacyDefinition.h"

@interface BFElementModelSpecLegacyTest : XCTestCase

@end

@implementation BFElementModelSpecLegacyTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) convertCheckingBFElementModelSpecLegacyBatteryCommandType: (BFElementModelSpecLegacyBatteryCommandTypeNumber)num {
    NSString *str = [BFElementModelSpecLegacyBatteryCommandType convertToString:num];
    BFElementModelSpecLegacyBatteryCommandTypeNumber convertedNum = [BFElementModelSpecLegacyBatteryCommandType convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementModelSpecLegacyBatteryCommandType: (BFElementModelSpecLegacyBatteryCommandTypeNumber)num {
    NSString *strOc = [BFElementModelSpecLegacyBatteryCommandType convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ModelSpecLegacyBatteryCommandType::Number numCpp = bf::element::ModelSpecLegacyBatteryCommandType::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementModelSpecLegacyBatteryCommandType: (bf::element::ModelSpecLegacyBatteryCommandType::Number)num {
    std::string strCpp = std::string(bf::element::ModelSpecLegacyBatteryCommandType::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementModelSpecLegacyBatteryCommandTypeNumber numOc = [BFElementModelSpecLegacyBatteryCommandType convertToNumber:strOc];
    bf::element::ModelSpecLegacyBatteryCommandType::Number numCpp = (bf::element::ModelSpecLegacyBatteryCommandType::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementModelSpecLegacyBatteryCommandType {
    NSString *str;
    BFElementModelSpecLegacyBatteryCommandTypeNumber num;
    str = [BFElementModelSpecLegacyBatteryCommandType convertToString:BFElementModelSpecLegacyBatteryCommandTypeNumber(-1)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyBatteryCommandTypeString__Null);
    str = [BFElementModelSpecLegacyBatteryCommandType convertToString:BFElementModelSpecLegacyBatteryCommandTypeNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyBatteryCommandTypeString__Null);
    num = [BFElementModelSpecLegacyBatteryCommandType convertToNumber:@""];
    XCTAssertEqual(num, BFElementModelSpecLegacyBatteryCommandTypeNumber__Null);
    num = [BFElementModelSpecLegacyBatteryCommandType convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementModelSpecLegacyBatteryCommandTypeNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementModelSpecLegacyBatteryCommandType
{
    [self convertCheckingBFElementModelSpecLegacyBatteryCommandType:BFElementModelSpecLegacyBatteryCommandTypeNumberPS_BAT_NON];
    [self convertCheckingOcToCppBFElementModelSpecLegacyBatteryCommandType:BFElementModelSpecLegacyBatteryCommandTypeNumberPS_BAT_NON];
    [self convertCheckingCppToOcBFElementModelSpecLegacyBatteryCommandType:bf::element::ModelSpecLegacyBatteryCommandType::Number::PS_BAT_NON];
    [self convertCheckingBFElementModelSpecLegacyBatteryCommandType:BFElementModelSpecLegacyBatteryCommandTypeNumberPS_BAT_PJCOMMAND];
    [self convertCheckingOcToCppBFElementModelSpecLegacyBatteryCommandType:BFElementModelSpecLegacyBatteryCommandTypeNumberPS_BAT_PJCOMMAND];
    [self convertCheckingCppToOcBFElementModelSpecLegacyBatteryCommandType:bf::element::ModelSpecLegacyBatteryCommandType::Number::PS_BAT_PJCOMMAND];
    [self convertCheckingBFElementModelSpecLegacyBatteryCommandType:BFElementModelSpecLegacyBatteryCommandTypeNumberPS_BAT_MW145COMMAND];
    [self convertCheckingOcToCppBFElementModelSpecLegacyBatteryCommandType:BFElementModelSpecLegacyBatteryCommandTypeNumberPS_BAT_MW145COMMAND];
    [self convertCheckingCppToOcBFElementModelSpecLegacyBatteryCommandType:bf::element::ModelSpecLegacyBatteryCommandType::Number::PS_BAT_MW145COMMAND];
    [self convertCheckingBFElementModelSpecLegacyBatteryCommandType:BFElementModelSpecLegacyBatteryCommandTypeNumberPS_BAT_MW260COMMAND];
    [self convertCheckingOcToCppBFElementModelSpecLegacyBatteryCommandType:BFElementModelSpecLegacyBatteryCommandTypeNumberPS_BAT_MW260COMMAND];
    [self convertCheckingCppToOcBFElementModelSpecLegacyBatteryCommandType:bf::element::ModelSpecLegacyBatteryCommandType::Number::PS_BAT_MW260COMMAND];
    [self convertCheckingBFElementModelSpecLegacyBatteryCommandType:BFElementModelSpecLegacyBatteryCommandTypeNumberPS_BAT_FROMSTATUS];
    [self convertCheckingOcToCppBFElementModelSpecLegacyBatteryCommandType:BFElementModelSpecLegacyBatteryCommandTypeNumberPS_BAT_FROMSTATUS];
    [self convertCheckingCppToOcBFElementModelSpecLegacyBatteryCommandType:bf::element::ModelSpecLegacyBatteryCommandType::Number::PS_BAT_FROMSTATUS];
    [self convertCheckingBFElementModelSpecLegacyBatteryCommandType:BFElementModelSpecLegacyBatteryCommandTypeNumber__Null];
    [self convertCheckingOcToCppBFElementModelSpecLegacyBatteryCommandType:BFElementModelSpecLegacyBatteryCommandTypeNumber__Null];
    [self convertCheckingCppToOcBFElementModelSpecLegacyBatteryCommandType:bf::element::ModelSpecLegacyBatteryCommandType::Number::__Null];
    [self irregularCheckingBFElementModelSpecLegacyBatteryCommandType];
    NSData* strAsData = [BFElementModelSpecLegacyBatteryCommandType.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ModelSpecLegacyBatteryCommandType::key == ocKey);
}

- (void) convertCheckingBFElementModelSpecLegacyGraphicCommandType: (BFElementModelSpecLegacyGraphicCommandTypeNumber)num {
    NSString *str = [BFElementModelSpecLegacyGraphicCommandType convertToString:num];
    BFElementModelSpecLegacyGraphicCommandTypeNumber convertedNum = [BFElementModelSpecLegacyGraphicCommandType convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementModelSpecLegacyGraphicCommandType: (BFElementModelSpecLegacyGraphicCommandTypeNumber)num {
    NSString *strOc = [BFElementModelSpecLegacyGraphicCommandType convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ModelSpecLegacyGraphicCommandType::Number numCpp = bf::element::ModelSpecLegacyGraphicCommandType::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementModelSpecLegacyGraphicCommandType: (bf::element::ModelSpecLegacyGraphicCommandType::Number)num {
    std::string strCpp = std::string(bf::element::ModelSpecLegacyGraphicCommandType::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementModelSpecLegacyGraphicCommandTypeNumber numOc = [BFElementModelSpecLegacyGraphicCommandType convertToNumber:strOc];
    bf::element::ModelSpecLegacyGraphicCommandType::Number numCpp = (bf::element::ModelSpecLegacyGraphicCommandType::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementModelSpecLegacyGraphicCommandType {
    NSString *str;
    BFElementModelSpecLegacyGraphicCommandTypeNumber num;
    str = [BFElementModelSpecLegacyGraphicCommandType convertToString:BFElementModelSpecLegacyGraphicCommandTypeNumber(-1)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyGraphicCommandTypeString__Null);
    str = [BFElementModelSpecLegacyGraphicCommandType convertToString:BFElementModelSpecLegacyGraphicCommandTypeNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyGraphicCommandTypeString__Null);
    num = [BFElementModelSpecLegacyGraphicCommandType convertToNumber:@""];
    XCTAssertEqual(num, BFElementModelSpecLegacyGraphicCommandTypeNumber__Null);
    num = [BFElementModelSpecLegacyGraphicCommandType convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementModelSpecLegacyGraphicCommandTypeNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementModelSpecLegacyGraphicCommandType
{
    [self convertCheckingBFElementModelSpecLegacyGraphicCommandType:BFElementModelSpecLegacyGraphicCommandTypeNumberG_COMMAND_g];
    [self convertCheckingOcToCppBFElementModelSpecLegacyGraphicCommandType:BFElementModelSpecLegacyGraphicCommandTypeNumberG_COMMAND_g];
    [self convertCheckingCppToOcBFElementModelSpecLegacyGraphicCommandType:bf::element::ModelSpecLegacyGraphicCommandType::Number::G_COMMAND_g];
    [self convertCheckingBFElementModelSpecLegacyGraphicCommandType:BFElementModelSpecLegacyGraphicCommandTypeNumberG_COMMAND_G];
    [self convertCheckingOcToCppBFElementModelSpecLegacyGraphicCommandType:BFElementModelSpecLegacyGraphicCommandTypeNumberG_COMMAND_G];
    [self convertCheckingCppToOcBFElementModelSpecLegacyGraphicCommandType:bf::element::ModelSpecLegacyGraphicCommandType::Number::G_COMMAND_G];
    [self convertCheckingBFElementModelSpecLegacyGraphicCommandType:BFElementModelSpecLegacyGraphicCommandTypeNumberG_COMMAND_PJ];
    [self convertCheckingOcToCppBFElementModelSpecLegacyGraphicCommandType:BFElementModelSpecLegacyGraphicCommandTypeNumberG_COMMAND_PJ];
    [self convertCheckingCppToOcBFElementModelSpecLegacyGraphicCommandType:bf::element::ModelSpecLegacyGraphicCommandType::Number::G_COMMAND_PJ];
    [self convertCheckingBFElementModelSpecLegacyGraphicCommandType:BFElementModelSpecLegacyGraphicCommandTypeNumber__Null];
    [self convertCheckingOcToCppBFElementModelSpecLegacyGraphicCommandType:BFElementModelSpecLegacyGraphicCommandTypeNumber__Null];
    [self convertCheckingCppToOcBFElementModelSpecLegacyGraphicCommandType:bf::element::ModelSpecLegacyGraphicCommandType::Number::__Null];
    [self irregularCheckingBFElementModelSpecLegacyGraphicCommandType];
    NSData* strAsData = [BFElementModelSpecLegacyGraphicCommandType.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ModelSpecLegacyGraphicCommandType::key == ocKey);
}

- (void) convertCheckingBFElementModelSpecLegacyMainVersionCommandType: (BFElementModelSpecLegacyMainVersionCommandTypeNumber)num {
    NSString *str = [BFElementModelSpecLegacyMainVersionCommandType convertToString:num];
    BFElementModelSpecLegacyMainVersionCommandTypeNumber convertedNum = [BFElementModelSpecLegacyMainVersionCommandType convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementModelSpecLegacyMainVersionCommandType: (BFElementModelSpecLegacyMainVersionCommandTypeNumber)num {
    NSString *strOc = [BFElementModelSpecLegacyMainVersionCommandType convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ModelSpecLegacyMainVersionCommandType::Number numCpp = bf::element::ModelSpecLegacyMainVersionCommandType::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementModelSpecLegacyMainVersionCommandType: (bf::element::ModelSpecLegacyMainVersionCommandType::Number)num {
    std::string strCpp = std::string(bf::element::ModelSpecLegacyMainVersionCommandType::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementModelSpecLegacyMainVersionCommandTypeNumber numOc = [BFElementModelSpecLegacyMainVersionCommandType convertToNumber:strOc];
    bf::element::ModelSpecLegacyMainVersionCommandType::Number numCpp = (bf::element::ModelSpecLegacyMainVersionCommandType::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementModelSpecLegacyMainVersionCommandType {
    NSString *str;
    BFElementModelSpecLegacyMainVersionCommandTypeNumber num;
    str = [BFElementModelSpecLegacyMainVersionCommandType convertToString:BFElementModelSpecLegacyMainVersionCommandTypeNumber(-1)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyMainVersionCommandTypeString__Null);
    str = [BFElementModelSpecLegacyMainVersionCommandType convertToString:BFElementModelSpecLegacyMainVersionCommandTypeNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyMainVersionCommandTypeString__Null);
    num = [BFElementModelSpecLegacyMainVersionCommandType convertToNumber:@""];
    XCTAssertEqual(num, BFElementModelSpecLegacyMainVersionCommandTypeNumber__Null);
    num = [BFElementModelSpecLegacyMainVersionCommandType convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementModelSpecLegacyMainVersionCommandTypeNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementModelSpecLegacyMainVersionCommandType
{
    [self convertCheckingBFElementModelSpecLegacyMainVersionCommandType:BFElementModelSpecLegacyMainVersionCommandTypeNumberMV_U0FH01H01H];
    [self convertCheckingOcToCppBFElementModelSpecLegacyMainVersionCommandType:BFElementModelSpecLegacyMainVersionCommandTypeNumberMV_U0FH01H01H];
    [self convertCheckingCppToOcBFElementModelSpecLegacyMainVersionCommandType:bf::element::ModelSpecLegacyMainVersionCommandType::Number::MV_U0FH01H01H];
    [self convertCheckingBFElementModelSpecLegacyMainVersionCommandType:BFElementModelSpecLegacyMainVersionCommandTypeNumberMV_U0EH01H];
    [self convertCheckingOcToCppBFElementModelSpecLegacyMainVersionCommandType:BFElementModelSpecLegacyMainVersionCommandTypeNumberMV_U0EH01H];
    [self convertCheckingCppToOcBFElementModelSpecLegacyMainVersionCommandType:bf::element::ModelSpecLegacyMainVersionCommandType::Number::MV_U0EH01H];
    [self convertCheckingBFElementModelSpecLegacyMainVersionCommandType:BFElementModelSpecLegacyMainVersionCommandTypeNumberMV_U0FH02H01H];
    [self convertCheckingOcToCppBFElementModelSpecLegacyMainVersionCommandType:BFElementModelSpecLegacyMainVersionCommandTypeNumberMV_U0FH02H01H];
    [self convertCheckingCppToOcBFElementModelSpecLegacyMainVersionCommandType:bf::element::ModelSpecLegacyMainVersionCommandType::Number::MV_U0FH02H01H];
    [self convertCheckingBFElementModelSpecLegacyMainVersionCommandType:BFElementModelSpecLegacyMainVersionCommandTypeNumberMV_UNKWOUN];
    [self convertCheckingOcToCppBFElementModelSpecLegacyMainVersionCommandType:BFElementModelSpecLegacyMainVersionCommandTypeNumberMV_UNKWOUN];
    [self convertCheckingCppToOcBFElementModelSpecLegacyMainVersionCommandType:bf::element::ModelSpecLegacyMainVersionCommandType::Number::MV_UNKWOUN];
    [self convertCheckingBFElementModelSpecLegacyMainVersionCommandType:BFElementModelSpecLegacyMainVersionCommandTypeNumber__Null];
    [self convertCheckingOcToCppBFElementModelSpecLegacyMainVersionCommandType:BFElementModelSpecLegacyMainVersionCommandTypeNumber__Null];
    [self convertCheckingCppToOcBFElementModelSpecLegacyMainVersionCommandType:bf::element::ModelSpecLegacyMainVersionCommandType::Number::__Null];
    [self irregularCheckingBFElementModelSpecLegacyMainVersionCommandType];
    NSData* strAsData = [BFElementModelSpecLegacyMainVersionCommandType.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ModelSpecLegacyMainVersionCommandType::key == ocKey);
}

- (void) convertCheckingBFElementModelSpecLegacyPageEndCommandType: (BFElementModelSpecLegacyPageEndCommandTypeNumber)num {
    NSString *str = [BFElementModelSpecLegacyPageEndCommandType convertToString:num];
    BFElementModelSpecLegacyPageEndCommandTypeNumber convertedNum = [BFElementModelSpecLegacyPageEndCommandType convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementModelSpecLegacyPageEndCommandType: (BFElementModelSpecLegacyPageEndCommandTypeNumber)num {
    NSString *strOc = [BFElementModelSpecLegacyPageEndCommandType convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ModelSpecLegacyPageEndCommandType::Number numCpp = bf::element::ModelSpecLegacyPageEndCommandType::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementModelSpecLegacyPageEndCommandType: (bf::element::ModelSpecLegacyPageEndCommandType::Number)num {
    std::string strCpp = std::string(bf::element::ModelSpecLegacyPageEndCommandType::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementModelSpecLegacyPageEndCommandTypeNumber numOc = [BFElementModelSpecLegacyPageEndCommandType convertToNumber:strOc];
    bf::element::ModelSpecLegacyPageEndCommandType::Number numCpp = (bf::element::ModelSpecLegacyPageEndCommandType::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementModelSpecLegacyPageEndCommandType {
    NSString *str;
    BFElementModelSpecLegacyPageEndCommandTypeNumber num;
    str = [BFElementModelSpecLegacyPageEndCommandType convertToString:BFElementModelSpecLegacyPageEndCommandTypeNumber(-1)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyPageEndCommandTypeString__Null);
    str = [BFElementModelSpecLegacyPageEndCommandType convertToString:BFElementModelSpecLegacyPageEndCommandTypeNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyPageEndCommandTypeString__Null);
    num = [BFElementModelSpecLegacyPageEndCommandType convertToNumber:@""];
    XCTAssertEqual(num, BFElementModelSpecLegacyPageEndCommandTypeNumber__Null);
    num = [BFElementModelSpecLegacyPageEndCommandType convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementModelSpecLegacyPageEndCommandTypeNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementModelSpecLegacyPageEndCommandType
{
    [self convertCheckingBFElementModelSpecLegacyPageEndCommandType:BFElementModelSpecLegacyPageEndCommandTypeNumberEND_PJCODE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPageEndCommandType:BFElementModelSpecLegacyPageEndCommandTypeNumberEND_PJCODE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPageEndCommandType:bf::element::ModelSpecLegacyPageEndCommandType::Number::END_PJCODE];
    [self convertCheckingBFElementModelSpecLegacyPageEndCommandType:BFElementModelSpecLegacyPageEndCommandTypeNumberEND_NORMAL];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPageEndCommandType:BFElementModelSpecLegacyPageEndCommandTypeNumberEND_NORMAL];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPageEndCommandType:bf::element::ModelSpecLegacyPageEndCommandType::Number::END_NORMAL];
    [self convertCheckingBFElementModelSpecLegacyPageEndCommandType:BFElementModelSpecLegacyPageEndCommandTypeNumber__Null];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPageEndCommandType:BFElementModelSpecLegacyPageEndCommandTypeNumber__Null];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPageEndCommandType:bf::element::ModelSpecLegacyPageEndCommandType::Number::__Null];
    [self irregularCheckingBFElementModelSpecLegacyPageEndCommandType];
    NSData* strAsData = [BFElementModelSpecLegacyPageEndCommandType.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ModelSpecLegacyPageEndCommandType::key == ocKey);
}

- (void) convertCheckingBFElementModelSpecLegacyPaperListKind: (BFElementModelSpecLegacyPaperListKindNumber)num {
    NSString *str = [BFElementModelSpecLegacyPaperListKind convertToString:num];
    BFElementModelSpecLegacyPaperListKindNumber convertedNum = [BFElementModelSpecLegacyPaperListKind convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementModelSpecLegacyPaperListKind: (BFElementModelSpecLegacyPaperListKindNumber)num {
    NSString *strOc = [BFElementModelSpecLegacyPaperListKind convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ModelSpecLegacyPaperListKind::Number numCpp = bf::element::ModelSpecLegacyPaperListKind::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementModelSpecLegacyPaperListKind: (bf::element::ModelSpecLegacyPaperListKind::Number)num {
    std::string strCpp = std::string(bf::element::ModelSpecLegacyPaperListKind::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementModelSpecLegacyPaperListKindNumber numOc = [BFElementModelSpecLegacyPaperListKind convertToNumber:strOc];
    bf::element::ModelSpecLegacyPaperListKind::Number numCpp = (bf::element::ModelSpecLegacyPaperListKind::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementModelSpecLegacyPaperListKind {
    NSString *str;
    BFElementModelSpecLegacyPaperListKindNumber num;
    str = [BFElementModelSpecLegacyPaperListKind convertToString:BFElementModelSpecLegacyPaperListKindNumber(-1)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyPaperListKindString__Null);
    str = [BFElementModelSpecLegacyPaperListKind convertToString:BFElementModelSpecLegacyPaperListKindNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyPaperListKindString__Null);
    num = [BFElementModelSpecLegacyPaperListKind convertToNumber:@""];
    XCTAssertEqual(num, BFElementModelSpecLegacyPaperListKindNumber__Null);
    num = [BFElementModelSpecLegacyPaperListKind convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementModelSpecLegacyPaperListKindNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementModelSpecLegacyPaperListKind
{
    [self convertCheckingBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_A7];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_A7];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPaperListKind:bf::element::ModelSpecLegacyPaperListKind::Number::PS_A7];
    [self convertCheckingBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_A6];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_A6];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPaperListKind:bf::element::ModelSpecLegacyPaperListKind::Number::PS_A6];
    [self convertCheckingBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_PJ];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_PJ];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPaperListKind:bf::element::ModelSpecLegacyPaperListKind::Number::PS_PJ];
    [self convertCheckingBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_BIN];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_BIN];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPaperListKind:bf::element::ModelSpecLegacyPaperListKind::Number::PS_BIN];
    [self convertCheckingBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_QL];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_QL];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPaperListKind:bf::element::ModelSpecLegacyPaperListKind::Number::PS_QL];
    [self convertCheckingBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_PT];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_PT];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPaperListKind:bf::element::ModelSpecLegacyPaperListKind::Number::PS_PT];
    [self convertCheckingBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_PT_36mm];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_PT_36mm];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPaperListKind:bf::element::ModelSpecLegacyPaperListKind::Number::PS_PT_36mm];
    [self convertCheckingBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_PT_18mm];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_PT_18mm];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPaperListKind:bf::element::ModelSpecLegacyPaperListKind::Number::PS_PT_18mm];
    [self convertCheckingBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_TUBE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_TUBE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPaperListKind:bf::element::ModelSpecLegacyPaperListKind::Number::PS_TUBE];
    [self convertCheckingBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_FLE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_FLE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPaperListKind:bf::element::ModelSpecLegacyPaperListKind::Number::PS_FLE];
    [self convertCheckingBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_PT3];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_PT3];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPaperListKind:bf::element::ModelSpecLegacyPaperListKind::Number::PS_PT3];
    [self convertCheckingBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_QL1000];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_QL1000];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPaperListKind:bf::element::ModelSpecLegacyPaperListKind::Number::PS_QL1000];
    [self convertCheckingBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_PT_CUBE3];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_PT_CUBE3];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPaperListKind:bf::element::ModelSpecLegacyPaperListKind::Number::PS_PT_CUBE3];
    [self convertCheckingBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_PT9000];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_PT9000];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPaperListKind:bf::element::ModelSpecLegacyPaperListKind::Number::PS_PT9000];
    [self convertCheckingBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_PT_3_5mmUNSUPPORT];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_PT_3_5mmUNSUPPORT];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPaperListKind:bf::element::ModelSpecLegacyPaperListKind::Number::PS_PT_3_5mmUNSUPPORT];
    [self convertCheckingBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_PT_HS3];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_PT_HS3];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPaperListKind:bf::element::ModelSpecLegacyPaperListKind::Number::PS_PT_HS3];
    [self convertCheckingBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_PT_36mm_HS3];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPS_PT_36mm_HS3];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPaperListKind:bf::element::ModelSpecLegacyPaperListKind::Number::PS_PT_36mm_HS3];
    [self convertCheckingBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPAPER_UNSUPPORT];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumberPAPER_UNSUPPORT];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPaperListKind:bf::element::ModelSpecLegacyPaperListKind::Number::PAPER_UNSUPPORT];
    [self convertCheckingBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumber__Null];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPaperListKind:BFElementModelSpecLegacyPaperListKindNumber__Null];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPaperListKind:bf::element::ModelSpecLegacyPaperListKind::Number::__Null];
    [self irregularCheckingBFElementModelSpecLegacyPaperListKind];
    NSData* strAsData = [BFElementModelSpecLegacyPaperListKind.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ModelSpecLegacyPaperListKind::key == ocKey);
}

- (void) convertCheckingBFElementModelSpecLegacyPrintCompressType: (BFElementModelSpecLegacyPrintCompressTypeNumber)num {
    NSString *str = [BFElementModelSpecLegacyPrintCompressType convertToString:num];
    BFElementModelSpecLegacyPrintCompressTypeNumber convertedNum = [BFElementModelSpecLegacyPrintCompressType convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementModelSpecLegacyPrintCompressType: (BFElementModelSpecLegacyPrintCompressTypeNumber)num {
    NSString *strOc = [BFElementModelSpecLegacyPrintCompressType convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ModelSpecLegacyPrintCompressType::Number numCpp = bf::element::ModelSpecLegacyPrintCompressType::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementModelSpecLegacyPrintCompressType: (bf::element::ModelSpecLegacyPrintCompressType::Number)num {
    std::string strCpp = std::string(bf::element::ModelSpecLegacyPrintCompressType::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementModelSpecLegacyPrintCompressTypeNumber numOc = [BFElementModelSpecLegacyPrintCompressType convertToNumber:strOc];
    bf::element::ModelSpecLegacyPrintCompressType::Number numCpp = (bf::element::ModelSpecLegacyPrintCompressType::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementModelSpecLegacyPrintCompressType {
    NSString *str;
    BFElementModelSpecLegacyPrintCompressTypeNumber num;
    str = [BFElementModelSpecLegacyPrintCompressType convertToString:BFElementModelSpecLegacyPrintCompressTypeNumber(-1)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyPrintCompressTypeString__Null);
    str = [BFElementModelSpecLegacyPrintCompressType convertToString:BFElementModelSpecLegacyPrintCompressTypeNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyPrintCompressTypeString__Null);
    num = [BFElementModelSpecLegacyPrintCompressType convertToNumber:@""];
    XCTAssertEqual(num, BFElementModelSpecLegacyPrintCompressTypeNumber__Null);
    num = [BFElementModelSpecLegacyPrintCompressType convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementModelSpecLegacyPrintCompressTypeNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementModelSpecLegacyPrintCompressType
{
    [self convertCheckingBFElementModelSpecLegacyPrintCompressType:BFElementModelSpecLegacyPrintCompressTypeNumberCOM_RAW];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrintCompressType:BFElementModelSpecLegacyPrintCompressTypeNumberCOM_RAW];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrintCompressType:bf::element::ModelSpecLegacyPrintCompressType::Number::COM_RAW];
    [self convertCheckingBFElementModelSpecLegacyPrintCompressType:BFElementModelSpecLegacyPrintCompressTypeNumberCOM_RAW_TIFF];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrintCompressType:BFElementModelSpecLegacyPrintCompressTypeNumberCOM_RAW_TIFF];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrintCompressType:bf::element::ModelSpecLegacyPrintCompressType::Number::COM_RAW_TIFF];
    [self convertCheckingBFElementModelSpecLegacyPrintCompressType:BFElementModelSpecLegacyPrintCompressTypeNumberCOM_TIFF];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrintCompressType:BFElementModelSpecLegacyPrintCompressTypeNumberCOM_TIFF];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrintCompressType:bf::element::ModelSpecLegacyPrintCompressType::Number::COM_TIFF];
    [self convertCheckingBFElementModelSpecLegacyPrintCompressType:BFElementModelSpecLegacyPrintCompressTypeNumber__Null];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrintCompressType:BFElementModelSpecLegacyPrintCompressTypeNumber__Null];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrintCompressType:bf::element::ModelSpecLegacyPrintCompressType::Number::__Null];
    [self irregularCheckingBFElementModelSpecLegacyPrintCompressType];
    NSData* strAsData = [BFElementModelSpecLegacyPrintCompressType.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ModelSpecLegacyPrintCompressType::key == ocKey);
}

- (void) convertCheckingBFElementModelSpecLegacyPrinterSettingCategory: (BFElementModelSpecLegacyPrinterSettingCategoryNumber)num {
    NSString *str = [BFElementModelSpecLegacyPrinterSettingCategory convertToString:num];
    BFElementModelSpecLegacyPrinterSettingCategoryNumber convertedNum = [BFElementModelSpecLegacyPrinterSettingCategory convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory: (BFElementModelSpecLegacyPrinterSettingCategoryNumber)num {
    NSString *strOc = [BFElementModelSpecLegacyPrinterSettingCategory convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ModelSpecLegacyPrinterSettingCategory::Number numCpp = bf::element::ModelSpecLegacyPrinterSettingCategory::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory: (bf::element::ModelSpecLegacyPrinterSettingCategory::Number)num {
    std::string strCpp = std::string(bf::element::ModelSpecLegacyPrinterSettingCategory::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementModelSpecLegacyPrinterSettingCategoryNumber numOc = [BFElementModelSpecLegacyPrinterSettingCategory convertToNumber:strOc];
    bf::element::ModelSpecLegacyPrinterSettingCategory::Number numCpp = (bf::element::ModelSpecLegacyPrinterSettingCategory::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementModelSpecLegacyPrinterSettingCategory {
    NSString *str;
    BFElementModelSpecLegacyPrinterSettingCategoryNumber num;
    str = [BFElementModelSpecLegacyPrinterSettingCategory convertToString:BFElementModelSpecLegacyPrinterSettingCategoryNumber(-1)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyPrinterSettingCategoryString__Null);
    str = [BFElementModelSpecLegacyPrinterSettingCategory convertToString:BFElementModelSpecLegacyPrinterSettingCategoryNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyPrinterSettingCategoryString__Null);
    num = [BFElementModelSpecLegacyPrinterSettingCategory convertToNumber:@""];
    XCTAssertEqual(num, BFElementModelSpecLegacyPrinterSettingCategoryNumber__Null);
    num = [BFElementModelSpecLegacyPrinterSettingCategory convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementModelSpecLegacyPrinterSettingCategoryNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementModelSpecLegacyPrinterSettingCategory
{
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_NET_IPV6];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_NET_IPV6];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_NET_IPV6];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_IPV6];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_IPV6];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_WIFI_IPV6];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_BOOTMODE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_BOOTMODE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_WIFI_BOOTMODE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_INTERFACE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_INTERFACE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_WIFI_INTERFACE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_WIRELESSDIRECT_BOOTMODE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_WIRELESSDIRECT_BOOTMODE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_WIFI_WIRELESSDIRECT_BOOTMODE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_SETTINGS];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_SETTINGS];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_WIFI_SETTINGS];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_NODENAME];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIFI_NODENAME];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_WIFI_NODENAME];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_LAN_SETTINGS];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_LAN_SETTINGS];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_LAN_SETTINGS];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_LAN_NODENAME];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_LAN_NODENAME];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_LAN_NODENAME];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_LAN_IPV6];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_LAN_IPV6];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_LAN_IPV6];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIRELESSDIRECT_CREATE_KRY];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIRELESSDIRECT_CREATE_KRY];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_WIRELESSDIRECT_CREATE_KRY];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIRELESSDIRECT_SETTINGS];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_WIRELESSDIRECT_SETTINGS];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_WIRELESSDIRECT_SETTINGS];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_AUTOPOWEROFFTIME];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_AUTOPOWEROFFTIME];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_BT_AUTOPOWEROFFTIME];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_AUTOSLEEPTIME];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_AUTOSLEEPTIME];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_BT_AUTOSLEEPTIME];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_AUTOSLEEPTOPOWEROFFTIME];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_AUTOSLEEPTOPOWEROFFTIME];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_BT_AUTOSLEEPTOPOWEROFFTIME];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_POWERSAVEMODE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_POWERSAVEMODE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_BT_POWERSAVEMODE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_ISDISCOVERABLE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_ISDISCOVERABLE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_BT_ISDISCOVERABLE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_DEVICENAME];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_DEVICENAME];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_BT_DEVICENAME];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_PINCODE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_PINCODE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_BT_PINCODE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_SSP];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_SSP];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_BT_SSP];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_PINCODE_ENABLE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_PINCODE_ENABLE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_BT_PINCODE_ENABLE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_SECURITYMODE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_SECURITYMODE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_BT_SECURITYMODE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_BOOTMODE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_BOOTMODE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_BT_BOOTMODE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_BLUETOOTH_TO_IRDA];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_BLUETOOTH_TO_IRDA];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_BT_BLUETOOTH_TO_IRDA];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_BLUETOOTH_TO_NET];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_BLUETOOTH_TO_NET];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_BT_BLUETOOTH_TO_NET];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_KEY];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_KEY];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_BT_KEY];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_AUTO_CONNECTION];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_AUTO_CONNECTION];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_BT_AUTO_CONNECTION];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_BOOTMODE_PJ];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_BT_BOOTMODE_PJ];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_BT_BOOTMODE_PJ];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_PRINT_JPEG_HALFTONE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_PRINT_JPEG_HALFTONE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_PRINT_JPEG_HALFTONE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_PRINT_JPEG_SCALE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_PRINT_JPEG_SCALE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_PRINT_JPEG_SCALE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_PRINT_DENSITY];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_PRINT_DENSITY];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_PRINT_DENSITY];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_PRINT_SPEED];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_PRINT_SPEED];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_PRINT_SPEED];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_POWER_POWEROFFTIME];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_BATTERY];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_BATTERY];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_POWER_POWEROFFTIME_BATTERY];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_RJ2];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_RJ2];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_POWER_POWEROFFTIME_RJ2];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_QL8];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_QL8];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_POWER_POWEROFFTIME_QL8];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_BATTERY_QL8];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_BATTERY_QL8];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_POWER_POWEROFFTIME_BATTERY_QL8];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_QL1100];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_QL1100];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_POWER_POWEROFFTIME_QL1100];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_RJ4000a];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_RJ4000a];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_POWER_POWEROFFTIME_RJ4000a];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_ModelFilter];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_ModelFilter];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_POWER_POWEROFFTIME_ModelFilter];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_PowerSupplyFilter];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumberPS_POWER_POWEROFFTIME_PowerSupplyFilter];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::PS_POWER_POWEROFFTIME_PowerSupplyFilter];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumber__Null];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategory:BFElementModelSpecLegacyPrinterSettingCategoryNumber__Null];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategory:bf::element::ModelSpecLegacyPrinterSettingCategory::Number::__Null];
    [self irregularCheckingBFElementModelSpecLegacyPrinterSettingCategory];
    NSData* strAsData = [BFElementModelSpecLegacyPrinterSettingCategory.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ModelSpecLegacyPrinterSettingCategory::key == ocKey);
}

- (void) convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryBluetooth: (BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumber)num {
    NSString *str = [BFElementModelSpecLegacyPrinterSettingCategoryBluetooth convertToString:num];
    BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumber convertedNum = [BFElementModelSpecLegacyPrinterSettingCategoryBluetooth convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryBluetooth: (BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumber)num {
    NSString *strOc = [BFElementModelSpecLegacyPrinterSettingCategoryBluetooth convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::Number numCpp = bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryBluetooth: (bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::Number)num {
    std::string strCpp = std::string(bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumber numOc = [BFElementModelSpecLegacyPrinterSettingCategoryBluetooth convertToNumber:strOc];
    bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::Number numCpp = (bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementModelSpecLegacyPrinterSettingCategoryBluetooth {
    NSString *str;
    BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumber num;
    str = [BFElementModelSpecLegacyPrinterSettingCategoryBluetooth convertToString:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumber(-1)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyPrinterSettingCategoryBluetoothString__Null);
    str = [BFElementModelSpecLegacyPrinterSettingCategoryBluetooth convertToString:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyPrinterSettingCategoryBluetoothString__Null);
    num = [BFElementModelSpecLegacyPrinterSettingCategoryBluetooth convertToNumber:@""];
    XCTAssertEqual(num, BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumber__Null);
    num = [BFElementModelSpecLegacyPrinterSettingCategoryBluetooth convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementModelSpecLegacyPrinterSettingCategoryBluetooth
{
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_AUTOPOWEROFFTIME];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_AUTOPOWEROFFTIME];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::Number::PS_BT_AUTOPOWEROFFTIME];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_AUTOSLEEPTIME];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_AUTOSLEEPTIME];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::Number::PS_BT_AUTOSLEEPTIME];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_AUTOSLEEPTOPOWEROFFTIME];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_AUTOSLEEPTOPOWEROFFTIME];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::Number::PS_BT_AUTOSLEEPTOPOWEROFFTIME];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_POWERSAVEMODE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_POWERSAVEMODE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::Number::PS_BT_POWERSAVEMODE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_ISDISCOVERABLE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_ISDISCOVERABLE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::Number::PS_BT_ISDISCOVERABLE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_DEVICENAME];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_DEVICENAME];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::Number::PS_BT_DEVICENAME];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_PINCODE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_PINCODE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::Number::PS_BT_PINCODE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_SSP];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_SSP];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::Number::PS_BT_SSP];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_PINCODE_ENABLE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_PINCODE_ENABLE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::Number::PS_BT_PINCODE_ENABLE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_SECURITYMODE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_SECURITYMODE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::Number::PS_BT_SECURITYMODE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_BOOTMODE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_BOOTMODE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::Number::PS_BT_BOOTMODE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_BLUETOOTH_TO_IRDA];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_BLUETOOTH_TO_IRDA];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::Number::PS_BT_BLUETOOTH_TO_IRDA];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_BLUETOOTH_TO_NET];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_BLUETOOTH_TO_NET];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::Number::PS_BT_BLUETOOTH_TO_NET];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_KEY];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_KEY];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::Number::PS_BT_KEY];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_AUTO_CONNECTION];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_AUTO_CONNECTION];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::Number::PS_BT_AUTO_CONNECTION];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_BOOTMODE_PJ];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumberPS_BT_BOOTMODE_PJ];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::Number::PS_BT_BOOTMODE_PJ];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumber__Null];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:BFElementModelSpecLegacyPrinterSettingCategoryBluetoothNumber__Null];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryBluetooth:bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::Number::__Null];
    [self irregularCheckingBFElementModelSpecLegacyPrinterSettingCategoryBluetooth];
    NSData* strAsData = [BFElementModelSpecLegacyPrinterSettingCategoryBluetooth.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::key == ocKey);
}

- (void) convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryNetwork: (BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumber)num {
    NSString *str = [BFElementModelSpecLegacyPrinterSettingCategoryNetwork convertToString:num];
    BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumber convertedNum = [BFElementModelSpecLegacyPrinterSettingCategoryNetwork convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryNetwork: (BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumber)num {
    NSString *strOc = [BFElementModelSpecLegacyPrinterSettingCategoryNetwork convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ModelSpecLegacyPrinterSettingCategoryNetwork::Number numCpp = bf::element::ModelSpecLegacyPrinterSettingCategoryNetwork::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryNetwork: (bf::element::ModelSpecLegacyPrinterSettingCategoryNetwork::Number)num {
    std::string strCpp = std::string(bf::element::ModelSpecLegacyPrinterSettingCategoryNetwork::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumber numOc = [BFElementModelSpecLegacyPrinterSettingCategoryNetwork convertToNumber:strOc];
    bf::element::ModelSpecLegacyPrinterSettingCategoryNetwork::Number numCpp = (bf::element::ModelSpecLegacyPrinterSettingCategoryNetwork::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementModelSpecLegacyPrinterSettingCategoryNetwork {
    NSString *str;
    BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumber num;
    str = [BFElementModelSpecLegacyPrinterSettingCategoryNetwork convertToString:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumber(-1)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyPrinterSettingCategoryNetworkString__Null);
    str = [BFElementModelSpecLegacyPrinterSettingCategoryNetwork convertToString:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyPrinterSettingCategoryNetworkString__Null);
    num = [BFElementModelSpecLegacyPrinterSettingCategoryNetwork convertToNumber:@""];
    XCTAssertEqual(num, BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumber__Null);
    num = [BFElementModelSpecLegacyPrinterSettingCategoryNetwork convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementModelSpecLegacyPrinterSettingCategoryNetwork
{
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_NET_IPV6];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_NET_IPV6];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryNetwork:bf::element::ModelSpecLegacyPrinterSettingCategoryNetwork::Number::PS_NET_IPV6];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_IPV6];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_IPV6];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryNetwork:bf::element::ModelSpecLegacyPrinterSettingCategoryNetwork::Number::PS_WIFI_IPV6];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_BOOTMODE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_BOOTMODE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryNetwork:bf::element::ModelSpecLegacyPrinterSettingCategoryNetwork::Number::PS_WIFI_BOOTMODE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_INTERFACE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_INTERFACE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryNetwork:bf::element::ModelSpecLegacyPrinterSettingCategoryNetwork::Number::PS_WIFI_INTERFACE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_WIRELESSDIRECT_BOOTMODE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_WIRELESSDIRECT_BOOTMODE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryNetwork:bf::element::ModelSpecLegacyPrinterSettingCategoryNetwork::Number::PS_WIFI_WIRELESSDIRECT_BOOTMODE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_SETTINGS];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_SETTINGS];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryNetwork:bf::element::ModelSpecLegacyPrinterSettingCategoryNetwork::Number::PS_WIFI_SETTINGS];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_NODENAME];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIFI_NODENAME];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryNetwork:bf::element::ModelSpecLegacyPrinterSettingCategoryNetwork::Number::PS_WIFI_NODENAME];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_LAN_SETTINGS];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_LAN_SETTINGS];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryNetwork:bf::element::ModelSpecLegacyPrinterSettingCategoryNetwork::Number::PS_LAN_SETTINGS];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_LAN_NODENAME];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_LAN_NODENAME];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryNetwork:bf::element::ModelSpecLegacyPrinterSettingCategoryNetwork::Number::PS_LAN_NODENAME];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_LAN_IPV6];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_LAN_IPV6];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryNetwork:bf::element::ModelSpecLegacyPrinterSettingCategoryNetwork::Number::PS_LAN_IPV6];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIRELESSDIRECT_CREATE_KRY];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIRELESSDIRECT_CREATE_KRY];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryNetwork:bf::element::ModelSpecLegacyPrinterSettingCategoryNetwork::Number::PS_WIRELESSDIRECT_CREATE_KRY];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIRELESSDIRECT_SETTINGS];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumberPS_WIRELESSDIRECT_SETTINGS];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryNetwork:bf::element::ModelSpecLegacyPrinterSettingCategoryNetwork::Number::PS_WIRELESSDIRECT_SETTINGS];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumber__Null];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryNetwork:BFElementModelSpecLegacyPrinterSettingCategoryNetworkNumber__Null];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryNetwork:bf::element::ModelSpecLegacyPrinterSettingCategoryNetwork::Number::__Null];
    [self irregularCheckingBFElementModelSpecLegacyPrinterSettingCategoryNetwork];
    NSData* strAsData = [BFElementModelSpecLegacyPrinterSettingCategoryNetwork.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ModelSpecLegacyPrinterSettingCategoryNetwork::key == ocKey);
}

- (void) convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryPower: (BFElementModelSpecLegacyPrinterSettingCategoryPowerNumber)num {
    NSString *str = [BFElementModelSpecLegacyPrinterSettingCategoryPower convertToString:num];
    BFElementModelSpecLegacyPrinterSettingCategoryPowerNumber convertedNum = [BFElementModelSpecLegacyPrinterSettingCategoryPower convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryPower: (BFElementModelSpecLegacyPrinterSettingCategoryPowerNumber)num {
    NSString *strOc = [BFElementModelSpecLegacyPrinterSettingCategoryPower convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ModelSpecLegacyPrinterSettingCategoryPower::Number numCpp = bf::element::ModelSpecLegacyPrinterSettingCategoryPower::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryPower: (bf::element::ModelSpecLegacyPrinterSettingCategoryPower::Number)num {
    std::string strCpp = std::string(bf::element::ModelSpecLegacyPrinterSettingCategoryPower::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementModelSpecLegacyPrinterSettingCategoryPowerNumber numOc = [BFElementModelSpecLegacyPrinterSettingCategoryPower convertToNumber:strOc];
    bf::element::ModelSpecLegacyPrinterSettingCategoryPower::Number numCpp = (bf::element::ModelSpecLegacyPrinterSettingCategoryPower::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementModelSpecLegacyPrinterSettingCategoryPower {
    NSString *str;
    BFElementModelSpecLegacyPrinterSettingCategoryPowerNumber num;
    str = [BFElementModelSpecLegacyPrinterSettingCategoryPower convertToString:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumber(-1)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyPrinterSettingCategoryPowerString__Null);
    str = [BFElementModelSpecLegacyPrinterSettingCategoryPower convertToString:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyPrinterSettingCategoryPowerString__Null);
    num = [BFElementModelSpecLegacyPrinterSettingCategoryPower convertToNumber:@""];
    XCTAssertEqual(num, BFElementModelSpecLegacyPrinterSettingCategoryPowerNumber__Null);
    num = [BFElementModelSpecLegacyPrinterSettingCategoryPower convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementModelSpecLegacyPrinterSettingCategoryPowerNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementModelSpecLegacyPrinterSettingCategoryPower
{
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryPower:bf::element::ModelSpecLegacyPrinterSettingCategoryPower::Number::PS_POWER_POWEROFFTIME];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_BATTERY];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_BATTERY];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryPower:bf::element::ModelSpecLegacyPrinterSettingCategoryPower::Number::PS_POWER_POWEROFFTIME_BATTERY];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_RJ2];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_RJ2];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryPower:bf::element::ModelSpecLegacyPrinterSettingCategoryPower::Number::PS_POWER_POWEROFFTIME_RJ2];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_QL8];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_QL8];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryPower:bf::element::ModelSpecLegacyPrinterSettingCategoryPower::Number::PS_POWER_POWEROFFTIME_QL8];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_BATTERY_QL8];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_BATTERY_QL8];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryPower:bf::element::ModelSpecLegacyPrinterSettingCategoryPower::Number::PS_POWER_POWEROFFTIME_BATTERY_QL8];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_QL1100];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_QL1100];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryPower:bf::element::ModelSpecLegacyPrinterSettingCategoryPower::Number::PS_POWER_POWEROFFTIME_QL1100];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_RJ4000a];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_RJ4000a];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryPower:bf::element::ModelSpecLegacyPrinterSettingCategoryPower::Number::PS_POWER_POWEROFFTIME_RJ4000a];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_BATTERY_PJ8];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_BATTERY_PJ8];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryPower:bf::element::ModelSpecLegacyPrinterSettingCategoryPower::Number::PS_POWER_POWEROFFTIME_BATTERY_PJ8];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_ModelFilter];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_ModelFilter];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryPower:bf::element::ModelSpecLegacyPrinterSettingCategoryPower::Number::PS_POWER_POWEROFFTIME_ModelFilter];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_PowerSupplyFilter];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumberPS_POWER_POWEROFFTIME_PowerSupplyFilter];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryPower:bf::element::ModelSpecLegacyPrinterSettingCategoryPower::Number::PS_POWER_POWEROFFTIME_PowerSupplyFilter];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumber__Null];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryPower:BFElementModelSpecLegacyPrinterSettingCategoryPowerNumber__Null];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryPower:bf::element::ModelSpecLegacyPrinterSettingCategoryPower::Number::__Null];
    [self irregularCheckingBFElementModelSpecLegacyPrinterSettingCategoryPower];
    NSData* strAsData = [BFElementModelSpecLegacyPrinterSettingCategoryPower.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ModelSpecLegacyPrinterSettingCategoryPower::key == ocKey);
}

- (void) convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryPrint: (BFElementModelSpecLegacyPrinterSettingCategoryPrintNumber)num {
    NSString *str = [BFElementModelSpecLegacyPrinterSettingCategoryPrint convertToString:num];
    BFElementModelSpecLegacyPrinterSettingCategoryPrintNumber convertedNum = [BFElementModelSpecLegacyPrinterSettingCategoryPrint convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryPrint: (BFElementModelSpecLegacyPrinterSettingCategoryPrintNumber)num {
    NSString *strOc = [BFElementModelSpecLegacyPrinterSettingCategoryPrint convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ModelSpecLegacyPrinterSettingCategoryPrint::Number numCpp = bf::element::ModelSpecLegacyPrinterSettingCategoryPrint::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryPrint: (bf::element::ModelSpecLegacyPrinterSettingCategoryPrint::Number)num {
    std::string strCpp = std::string(bf::element::ModelSpecLegacyPrinterSettingCategoryPrint::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementModelSpecLegacyPrinterSettingCategoryPrintNumber numOc = [BFElementModelSpecLegacyPrinterSettingCategoryPrint convertToNumber:strOc];
    bf::element::ModelSpecLegacyPrinterSettingCategoryPrint::Number numCpp = (bf::element::ModelSpecLegacyPrinterSettingCategoryPrint::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementModelSpecLegacyPrinterSettingCategoryPrint {
    NSString *str;
    BFElementModelSpecLegacyPrinterSettingCategoryPrintNumber num;
    str = [BFElementModelSpecLegacyPrinterSettingCategoryPrint convertToString:BFElementModelSpecLegacyPrinterSettingCategoryPrintNumber(-1)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyPrinterSettingCategoryPrintString__Null);
    str = [BFElementModelSpecLegacyPrinterSettingCategoryPrint convertToString:BFElementModelSpecLegacyPrinterSettingCategoryPrintNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyPrinterSettingCategoryPrintString__Null);
    num = [BFElementModelSpecLegacyPrinterSettingCategoryPrint convertToNumber:@""];
    XCTAssertEqual(num, BFElementModelSpecLegacyPrinterSettingCategoryPrintNumber__Null);
    num = [BFElementModelSpecLegacyPrinterSettingCategoryPrint convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementModelSpecLegacyPrinterSettingCategoryPrintNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementModelSpecLegacyPrinterSettingCategoryPrint
{
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryPrint:BFElementModelSpecLegacyPrinterSettingCategoryPrintNumberPS_PRINT_JPEG_HALFTONE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryPrint:BFElementModelSpecLegacyPrinterSettingCategoryPrintNumberPS_PRINT_JPEG_HALFTONE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryPrint:bf::element::ModelSpecLegacyPrinterSettingCategoryPrint::Number::PS_PRINT_JPEG_HALFTONE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryPrint:BFElementModelSpecLegacyPrinterSettingCategoryPrintNumberPS_PRINT_JPEG_SCALE];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryPrint:BFElementModelSpecLegacyPrinterSettingCategoryPrintNumberPS_PRINT_JPEG_SCALE];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryPrint:bf::element::ModelSpecLegacyPrinterSettingCategoryPrint::Number::PS_PRINT_JPEG_SCALE];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryPrint:BFElementModelSpecLegacyPrinterSettingCategoryPrintNumberPS_PRINT_DENSITY];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryPrint:BFElementModelSpecLegacyPrinterSettingCategoryPrintNumberPS_PRINT_DENSITY];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryPrint:bf::element::ModelSpecLegacyPrinterSettingCategoryPrint::Number::PS_PRINT_DENSITY];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryPrint:BFElementModelSpecLegacyPrinterSettingCategoryPrintNumberPS_PRINT_SPEED];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryPrint:BFElementModelSpecLegacyPrinterSettingCategoryPrintNumberPS_PRINT_SPEED];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryPrint:bf::element::ModelSpecLegacyPrinterSettingCategoryPrint::Number::PS_PRINT_SPEED];
    [self convertCheckingBFElementModelSpecLegacyPrinterSettingCategoryPrint:BFElementModelSpecLegacyPrinterSettingCategoryPrintNumber__Null];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrinterSettingCategoryPrint:BFElementModelSpecLegacyPrinterSettingCategoryPrintNumber__Null];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrinterSettingCategoryPrint:bf::element::ModelSpecLegacyPrinterSettingCategoryPrint::Number::__Null];
    [self irregularCheckingBFElementModelSpecLegacyPrinterSettingCategoryPrint];
    NSData* strAsData = [BFElementModelSpecLegacyPrinterSettingCategoryPrint.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ModelSpecLegacyPrinterSettingCategoryPrint::key == ocKey);
}

- (void) convertCheckingBFElementModelSpecLegacyPrintPageCommandType: (BFElementModelSpecLegacyPrintPageCommandTypeNumber)num {
    NSString *str = [BFElementModelSpecLegacyPrintPageCommandType convertToString:num];
    BFElementModelSpecLegacyPrintPageCommandTypeNumber convertedNum = [BFElementModelSpecLegacyPrintPageCommandType convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementModelSpecLegacyPrintPageCommandType: (BFElementModelSpecLegacyPrintPageCommandTypeNumber)num {
    NSString *strOc = [BFElementModelSpecLegacyPrintPageCommandType convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ModelSpecLegacyPrintPageCommandType::Number numCpp = bf::element::ModelSpecLegacyPrintPageCommandType::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementModelSpecLegacyPrintPageCommandType: (bf::element::ModelSpecLegacyPrintPageCommandType::Number)num {
    std::string strCpp = std::string(bf::element::ModelSpecLegacyPrintPageCommandType::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementModelSpecLegacyPrintPageCommandTypeNumber numOc = [BFElementModelSpecLegacyPrintPageCommandType convertToNumber:strOc];
    bf::element::ModelSpecLegacyPrintPageCommandType::Number numCpp = (bf::element::ModelSpecLegacyPrintPageCommandType::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementModelSpecLegacyPrintPageCommandType {
    NSString *str;
    BFElementModelSpecLegacyPrintPageCommandTypeNumber num;
    str = [BFElementModelSpecLegacyPrintPageCommandType convertToString:BFElementModelSpecLegacyPrintPageCommandTypeNumber(-1)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyPrintPageCommandTypeString__Null);
    str = [BFElementModelSpecLegacyPrintPageCommandType convertToString:BFElementModelSpecLegacyPrintPageCommandTypeNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacyPrintPageCommandTypeString__Null);
    num = [BFElementModelSpecLegacyPrintPageCommandType convertToNumber:@""];
    XCTAssertEqual(num, BFElementModelSpecLegacyPrintPageCommandTypeNumber__Null);
    num = [BFElementModelSpecLegacyPrintPageCommandType convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementModelSpecLegacyPrintPageCommandTypeNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementModelSpecLegacyPrintPageCommandType
{
    [self convertCheckingBFElementModelSpecLegacyPrintPageCommandType:BFElementModelSpecLegacyPrintPageCommandTypeNumberPAGE_START_END];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrintPageCommandType:BFElementModelSpecLegacyPrintPageCommandTypeNumberPAGE_START_END];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrintPageCommandType:bf::element::ModelSpecLegacyPrintPageCommandType::Number::PAGE_START_END];
    [self convertCheckingBFElementModelSpecLegacyPrintPageCommandType:BFElementModelSpecLegacyPrintPageCommandTypeNumberPAGE_START_NEXT_END];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrintPageCommandType:BFElementModelSpecLegacyPrintPageCommandTypeNumberPAGE_START_NEXT_END];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrintPageCommandType:bf::element::ModelSpecLegacyPrintPageCommandType::Number::PAGE_START_NEXT_END];
    [self convertCheckingBFElementModelSpecLegacyPrintPageCommandType:BFElementModelSpecLegacyPrintPageCommandTypeNumber__Null];
    [self convertCheckingOcToCppBFElementModelSpecLegacyPrintPageCommandType:BFElementModelSpecLegacyPrintPageCommandTypeNumber__Null];
    [self convertCheckingCppToOcBFElementModelSpecLegacyPrintPageCommandType:bf::element::ModelSpecLegacyPrintPageCommandType::Number::__Null];
    [self irregularCheckingBFElementModelSpecLegacyPrintPageCommandType];
    NSData* strAsData = [BFElementModelSpecLegacyPrintPageCommandType.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ModelSpecLegacyPrintPageCommandType::key == ocKey);
}

- (void) convertCheckingBFElementModelSpecLegacySupportAdvanceModeCommand: (BFElementModelSpecLegacySupportAdvanceModeCommandNumber)num {
    NSString *str = [BFElementModelSpecLegacySupportAdvanceModeCommand convertToString:num];
    BFElementModelSpecLegacySupportAdvanceModeCommandNumber convertedNum = [BFElementModelSpecLegacySupportAdvanceModeCommand convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementModelSpecLegacySupportAdvanceModeCommand: (BFElementModelSpecLegacySupportAdvanceModeCommandNumber)num {
    NSString *strOc = [BFElementModelSpecLegacySupportAdvanceModeCommand convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ModelSpecLegacySupportAdvanceModeCommand::Number numCpp = bf::element::ModelSpecLegacySupportAdvanceModeCommand::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementModelSpecLegacySupportAdvanceModeCommand: (bf::element::ModelSpecLegacySupportAdvanceModeCommand::Number)num {
    std::string strCpp = std::string(bf::element::ModelSpecLegacySupportAdvanceModeCommand::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementModelSpecLegacySupportAdvanceModeCommandNumber numOc = [BFElementModelSpecLegacySupportAdvanceModeCommand convertToNumber:strOc];
    bf::element::ModelSpecLegacySupportAdvanceModeCommand::Number numCpp = (bf::element::ModelSpecLegacySupportAdvanceModeCommand::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementModelSpecLegacySupportAdvanceModeCommand {
    NSString *str;
    BFElementModelSpecLegacySupportAdvanceModeCommandNumber num;
    str = [BFElementModelSpecLegacySupportAdvanceModeCommand convertToString:BFElementModelSpecLegacySupportAdvanceModeCommandNumber(-1)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacySupportAdvanceModeCommandString__Null);
    str = [BFElementModelSpecLegacySupportAdvanceModeCommand convertToString:BFElementModelSpecLegacySupportAdvanceModeCommandNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacySupportAdvanceModeCommandString__Null);
    num = [BFElementModelSpecLegacySupportAdvanceModeCommand convertToNumber:@""];
    XCTAssertEqual(num, BFElementModelSpecLegacySupportAdvanceModeCommandNumber__Null);
    num = [BFElementModelSpecLegacySupportAdvanceModeCommand convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementModelSpecLegacySupportAdvanceModeCommandNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementModelSpecLegacySupportAdvanceModeCommand
{
    [self convertCheckingBFElementModelSpecLegacySupportAdvanceModeCommand:BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_HALFCUT];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportAdvanceModeCommand:BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_HALFCUT];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportAdvanceModeCommand:bf::element::ModelSpecLegacySupportAdvanceModeCommand::Number::PS_AM_HALFCUT];
    [self convertCheckingBFElementModelSpecLegacySupportAdvanceModeCommand:BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_CUTEND];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportAdvanceModeCommand:BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_CUTEND];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportAdvanceModeCommand:bf::element::ModelSpecLegacySupportAdvanceModeCommand::Number::PS_AM_CUTEND];
    [self convertCheckingBFElementModelSpecLegacySupportAdvanceModeCommand:BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_SPECIALTAPE];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportAdvanceModeCommand:BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_SPECIALTAPE];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportAdvanceModeCommand:bf::element::ModelSpecLegacySupportAdvanceModeCommand::Number::PS_AM_SPECIALTAPE];
    [self convertCheckingBFElementModelSpecLegacySupportAdvanceModeCommand:BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_HIGH_RESOLUTION];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportAdvanceModeCommand:BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_HIGH_RESOLUTION];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportAdvanceModeCommand:bf::element::ModelSpecLegacySupportAdvanceModeCommand::Number::PS_AM_HIGH_RESOLUTION];
    [self convertCheckingBFElementModelSpecLegacySupportAdvanceModeCommand:BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_LABEL_CUTEND];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportAdvanceModeCommand:BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_LABEL_CUTEND];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportAdvanceModeCommand:bf::element::ModelSpecLegacySupportAdvanceModeCommand::Number::PS_AM_LABEL_CUTEND];
    [self convertCheckingBFElementModelSpecLegacySupportAdvanceModeCommand:BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_NOBUFFER];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportAdvanceModeCommand:BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_NOBUFFER];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportAdvanceModeCommand:bf::element::ModelSpecLegacySupportAdvanceModeCommand::Number::PS_AM_NOBUFFER];
    [self convertCheckingBFElementModelSpecLegacySupportAdvanceModeCommand:BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_LOW_RESOLUTION];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportAdvanceModeCommand:BFElementModelSpecLegacySupportAdvanceModeCommandNumberPS_AM_LOW_RESOLUTION];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportAdvanceModeCommand:bf::element::ModelSpecLegacySupportAdvanceModeCommand::Number::PS_AM_LOW_RESOLUTION];
    [self convertCheckingBFElementModelSpecLegacySupportAdvanceModeCommand:BFElementModelSpecLegacySupportAdvanceModeCommandNumber__Null];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportAdvanceModeCommand:BFElementModelSpecLegacySupportAdvanceModeCommandNumber__Null];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportAdvanceModeCommand:bf::element::ModelSpecLegacySupportAdvanceModeCommand::Number::__Null];
    [self irregularCheckingBFElementModelSpecLegacySupportAdvanceModeCommand];
    NSData* strAsData = [BFElementModelSpecLegacySupportAdvanceModeCommand.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ModelSpecLegacySupportAdvanceModeCommand::key == ocKey);
}

- (void) convertCheckingBFElementModelSpecLegacySupportFunc: (BFElementModelSpecLegacySupportFuncNumber)num {
    NSString *str = [BFElementModelSpecLegacySupportFunc convertToString:num];
    BFElementModelSpecLegacySupportFuncNumber convertedNum = [BFElementModelSpecLegacySupportFunc convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementModelSpecLegacySupportFunc: (BFElementModelSpecLegacySupportFuncNumber)num {
    NSString *strOc = [BFElementModelSpecLegacySupportFunc convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ModelSpecLegacySupportFunc::Number numCpp = bf::element::ModelSpecLegacySupportFunc::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementModelSpecLegacySupportFunc: (bf::element::ModelSpecLegacySupportFunc::Number)num {
    std::string strCpp = std::string(bf::element::ModelSpecLegacySupportFunc::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementModelSpecLegacySupportFuncNumber numOc = [BFElementModelSpecLegacySupportFunc convertToNumber:strOc];
    bf::element::ModelSpecLegacySupportFunc::Number numCpp = (bf::element::ModelSpecLegacySupportFunc::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementModelSpecLegacySupportFunc {
    NSString *str;
    BFElementModelSpecLegacySupportFuncNumber num;
    str = [BFElementModelSpecLegacySupportFunc convertToString:BFElementModelSpecLegacySupportFuncNumber(-1)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacySupportFuncString__Null);
    str = [BFElementModelSpecLegacySupportFunc convertToString:BFElementModelSpecLegacySupportFuncNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacySupportFuncString__Null);
    num = [BFElementModelSpecLegacySupportFunc convertToNumber:@""];
    XCTAssertEqual(num, BFElementModelSpecLegacySupportFuncNumber__Null);
    num = [BFElementModelSpecLegacySupportFunc convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementModelSpecLegacySupportFuncNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementModelSpecLegacySupportFunc
{
    [self convertCheckingBFElementModelSpecLegacySupportFunc:BFElementModelSpecLegacySupportFuncNumberSP_FUC_RASTER_PRINT];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportFunc:BFElementModelSpecLegacySupportFuncNumberSP_FUC_RASTER_PRINT];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportFunc:bf::element::ModelSpecLegacySupportFunc::Number::SP_FUC_RASTER_PRINT];
    [self convertCheckingBFElementModelSpecLegacySupportFunc:BFElementModelSpecLegacySupportFuncNumberSP_FUC_TEMPLATE_PRINT];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportFunc:BFElementModelSpecLegacySupportFuncNumberSP_FUC_TEMPLATE_PRINT];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportFunc:bf::element::ModelSpecLegacySupportFunc::Number::SP_FUC_TEMPLATE_PRINT];
    [self convertCheckingBFElementModelSpecLegacySupportFunc:BFElementModelSpecLegacySupportFuncNumberSP_FUC_TEMPLATE_TRANS];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportFunc:BFElementModelSpecLegacySupportFuncNumberSP_FUC_TEMPLATE_TRANS];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportFunc:bf::element::ModelSpecLegacySupportFunc::Number::SP_FUC_TEMPLATE_TRANS];
    [self convertCheckingBFElementModelSpecLegacySupportFunc:BFElementModelSpecLegacySupportFuncNumberSP_FUC_TEMPLATE_REMOVE];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportFunc:BFElementModelSpecLegacySupportFuncNumberSP_FUC_TEMPLATE_REMOVE];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportFunc:bf::element::ModelSpecLegacySupportFunc::Number::SP_FUC_TEMPLATE_REMOVE];
    [self convertCheckingBFElementModelSpecLegacySupportFunc:BFElementModelSpecLegacySupportFuncNumberSP_FUC_PRINTER_SETTINGS];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportFunc:BFElementModelSpecLegacySupportFuncNumberSP_FUC_PRINTER_SETTINGS];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportFunc:bf::element::ModelSpecLegacySupportFunc::Number::SP_FUC_PRINTER_SETTINGS];
    [self convertCheckingBFElementModelSpecLegacySupportFunc:BFElementModelSpecLegacySupportFuncNumberSP_FUC_FIRM_UPDATE];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportFunc:BFElementModelSpecLegacySupportFuncNumberSP_FUC_FIRM_UPDATE];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportFunc:bf::element::ModelSpecLegacySupportFunc::Number::SP_FUC_FIRM_UPDATE];
    [self convertCheckingBFElementModelSpecLegacySupportFunc:BFElementModelSpecLegacySupportFuncNumber__Null];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportFunc:BFElementModelSpecLegacySupportFuncNumber__Null];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportFunc:bf::element::ModelSpecLegacySupportFunc::Number::__Null];
    [self irregularCheckingBFElementModelSpecLegacySupportFunc];
    NSData* strAsData = [BFElementModelSpecLegacySupportFunc.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ModelSpecLegacySupportFunc::key == ocKey);
}

- (void) convertCheckingBFElementModelSpecLegacySupportMultiColorLabel: (BFElementModelSpecLegacySupportMultiColorLabelNumber)num {
    NSString *str = [BFElementModelSpecLegacySupportMultiColorLabel convertToString:num];
    BFElementModelSpecLegacySupportMultiColorLabelNumber convertedNum = [BFElementModelSpecLegacySupportMultiColorLabel convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementModelSpecLegacySupportMultiColorLabel: (BFElementModelSpecLegacySupportMultiColorLabelNumber)num {
    NSString *strOc = [BFElementModelSpecLegacySupportMultiColorLabel convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ModelSpecLegacySupportMultiColorLabel::Number numCpp = bf::element::ModelSpecLegacySupportMultiColorLabel::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementModelSpecLegacySupportMultiColorLabel: (bf::element::ModelSpecLegacySupportMultiColorLabel::Number)num {
    std::string strCpp = std::string(bf::element::ModelSpecLegacySupportMultiColorLabel::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementModelSpecLegacySupportMultiColorLabelNumber numOc = [BFElementModelSpecLegacySupportMultiColorLabel convertToNumber:strOc];
    bf::element::ModelSpecLegacySupportMultiColorLabel::Number numCpp = (bf::element::ModelSpecLegacySupportMultiColorLabel::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementModelSpecLegacySupportMultiColorLabel {
    NSString *str;
    BFElementModelSpecLegacySupportMultiColorLabelNumber num;
    str = [BFElementModelSpecLegacySupportMultiColorLabel convertToString:BFElementModelSpecLegacySupportMultiColorLabelNumber(-1)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacySupportMultiColorLabelString__Null);
    str = [BFElementModelSpecLegacySupportMultiColorLabel convertToString:BFElementModelSpecLegacySupportMultiColorLabelNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacySupportMultiColorLabelString__Null);
    num = [BFElementModelSpecLegacySupportMultiColorLabel convertToNumber:@""];
    XCTAssertEqual(num, BFElementModelSpecLegacySupportMultiColorLabelNumber__Null);
    num = [BFElementModelSpecLegacySupportMultiColorLabel convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementModelSpecLegacySupportMultiColorLabelNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementModelSpecLegacySupportMultiColorLabel
{
    [self convertCheckingBFElementModelSpecLegacySupportMultiColorLabel:BFElementModelSpecLegacySupportMultiColorLabelNumberMONO_COLOR];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportMultiColorLabel:BFElementModelSpecLegacySupportMultiColorLabelNumberMONO_COLOR];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportMultiColorLabel:bf::element::ModelSpecLegacySupportMultiColorLabel::Number::MONO_COLOR];
    [self convertCheckingBFElementModelSpecLegacySupportMultiColorLabel:BFElementModelSpecLegacySupportMultiColorLabelNumberBI_COLOR];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportMultiColorLabel:BFElementModelSpecLegacySupportMultiColorLabelNumberBI_COLOR];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportMultiColorLabel:bf::element::ModelSpecLegacySupportMultiColorLabel::Number::BI_COLOR];
    [self convertCheckingBFElementModelSpecLegacySupportMultiColorLabel:BFElementModelSpecLegacySupportMultiColorLabelNumberUNSUPPORTED_COLOR];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportMultiColorLabel:BFElementModelSpecLegacySupportMultiColorLabelNumberUNSUPPORTED_COLOR];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportMultiColorLabel:bf::element::ModelSpecLegacySupportMultiColorLabel::Number::UNSUPPORTED_COLOR];
    [self convertCheckingBFElementModelSpecLegacySupportMultiColorLabel:BFElementModelSpecLegacySupportMultiColorLabelNumber__Null];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportMultiColorLabel:BFElementModelSpecLegacySupportMultiColorLabelNumber__Null];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportMultiColorLabel:bf::element::ModelSpecLegacySupportMultiColorLabel::Number::__Null];
    [self irregularCheckingBFElementModelSpecLegacySupportMultiColorLabel];
    NSData* strAsData = [BFElementModelSpecLegacySupportMultiColorLabel.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ModelSpecLegacySupportMultiColorLabel::key == ocKey);
}

- (void) convertCheckingBFElementModelSpecLegacySupportPJFeedMode: (BFElementModelSpecLegacySupportPJFeedModeNumber)num {
    NSString *str = [BFElementModelSpecLegacySupportPJFeedMode convertToString:num];
    BFElementModelSpecLegacySupportPJFeedModeNumber convertedNum = [BFElementModelSpecLegacySupportPJFeedMode convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementModelSpecLegacySupportPJFeedMode: (BFElementModelSpecLegacySupportPJFeedModeNumber)num {
    NSString *strOc = [BFElementModelSpecLegacySupportPJFeedMode convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ModelSpecLegacySupportPJFeedMode::Number numCpp = bf::element::ModelSpecLegacySupportPJFeedMode::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementModelSpecLegacySupportPJFeedMode: (bf::element::ModelSpecLegacySupportPJFeedMode::Number)num {
    std::string strCpp = std::string(bf::element::ModelSpecLegacySupportPJFeedMode::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementModelSpecLegacySupportPJFeedModeNumber numOc = [BFElementModelSpecLegacySupportPJFeedMode convertToNumber:strOc];
    bf::element::ModelSpecLegacySupportPJFeedMode::Number numCpp = (bf::element::ModelSpecLegacySupportPJFeedMode::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementModelSpecLegacySupportPJFeedMode {
    NSString *str;
    BFElementModelSpecLegacySupportPJFeedModeNumber num;
    str = [BFElementModelSpecLegacySupportPJFeedMode convertToString:BFElementModelSpecLegacySupportPJFeedModeNumber(-1)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacySupportPJFeedModeString__Null);
    str = [BFElementModelSpecLegacySupportPJFeedMode convertToString:BFElementModelSpecLegacySupportPJFeedModeNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacySupportPJFeedModeString__Null);
    num = [BFElementModelSpecLegacySupportPJFeedMode convertToNumber:@""];
    XCTAssertEqual(num, BFElementModelSpecLegacySupportPJFeedModeNumber__Null);
    num = [BFElementModelSpecLegacySupportPJFeedMode convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementModelSpecLegacySupportPJFeedModeNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementModelSpecLegacySupportPJFeedMode
{
    [self convertCheckingBFElementModelSpecLegacySupportPJFeedMode:BFElementModelSpecLegacySupportPJFeedModeNumberFEED_MODE_FREE];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportPJFeedMode:BFElementModelSpecLegacySupportPJFeedModeNumberFEED_MODE_FREE];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportPJFeedMode:bf::element::ModelSpecLegacySupportPJFeedMode::Number::FEED_MODE_FREE];
    [self convertCheckingBFElementModelSpecLegacySupportPJFeedMode:BFElementModelSpecLegacySupportPJFeedModeNumberFEED_MODE_FIXEDPAGE];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportPJFeedMode:BFElementModelSpecLegacySupportPJFeedModeNumberFEED_MODE_FIXEDPAGE];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportPJFeedMode:bf::element::ModelSpecLegacySupportPJFeedMode::Number::FEED_MODE_FIXEDPAGE];
    [self convertCheckingBFElementModelSpecLegacySupportPJFeedMode:BFElementModelSpecLegacySupportPJFeedModeNumberFEED_MODE_ENDOFPAGE];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportPJFeedMode:BFElementModelSpecLegacySupportPJFeedModeNumberFEED_MODE_ENDOFPAGE];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportPJFeedMode:bf::element::ModelSpecLegacySupportPJFeedMode::Number::FEED_MODE_ENDOFPAGE];
    [self convertCheckingBFElementModelSpecLegacySupportPJFeedMode:BFElementModelSpecLegacySupportPJFeedModeNumberFEED_MODE_ENDOFPAGERETRACT];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportPJFeedMode:BFElementModelSpecLegacySupportPJFeedModeNumberFEED_MODE_ENDOFPAGERETRACT];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportPJFeedMode:bf::element::ModelSpecLegacySupportPJFeedMode::Number::FEED_MODE_ENDOFPAGERETRACT];
    [self convertCheckingBFElementModelSpecLegacySupportPJFeedMode:BFElementModelSpecLegacySupportPJFeedModeNumber__Null];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportPJFeedMode:BFElementModelSpecLegacySupportPJFeedModeNumber__Null];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportPJFeedMode:bf::element::ModelSpecLegacySupportPJFeedMode::Number::__Null];
    [self irregularCheckingBFElementModelSpecLegacySupportPJFeedMode];
    NSData* strAsData = [BFElementModelSpecLegacySupportPJFeedMode.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ModelSpecLegacySupportPJFeedMode::key == ocKey);
}

- (void) convertCheckingBFElementModelSpecLegacySupportVariousModeCommand: (BFElementModelSpecLegacySupportVariousModeCommandNumber)num {
    NSString *str = [BFElementModelSpecLegacySupportVariousModeCommand convertToString:num];
    BFElementModelSpecLegacySupportVariousModeCommandNumber convertedNum = [BFElementModelSpecLegacySupportVariousModeCommand convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementModelSpecLegacySupportVariousModeCommand: (BFElementModelSpecLegacySupportVariousModeCommandNumber)num {
    NSString *strOc = [BFElementModelSpecLegacySupportVariousModeCommand convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ModelSpecLegacySupportVariousModeCommand::Number numCpp = bf::element::ModelSpecLegacySupportVariousModeCommand::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementModelSpecLegacySupportVariousModeCommand: (bf::element::ModelSpecLegacySupportVariousModeCommand::Number)num {
    std::string strCpp = std::string(bf::element::ModelSpecLegacySupportVariousModeCommand::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementModelSpecLegacySupportVariousModeCommandNumber numOc = [BFElementModelSpecLegacySupportVariousModeCommand convertToNumber:strOc];
    bf::element::ModelSpecLegacySupportVariousModeCommand::Number numCpp = (bf::element::ModelSpecLegacySupportVariousModeCommand::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementModelSpecLegacySupportVariousModeCommand {
    NSString *str;
    BFElementModelSpecLegacySupportVariousModeCommandNumber num;
    str = [BFElementModelSpecLegacySupportVariousModeCommand convertToString:BFElementModelSpecLegacySupportVariousModeCommandNumber(-1)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacySupportVariousModeCommandString__Null);
    str = [BFElementModelSpecLegacySupportVariousModeCommand convertToString:BFElementModelSpecLegacySupportVariousModeCommandNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementModelSpecLegacySupportVariousModeCommandString__Null);
    num = [BFElementModelSpecLegacySupportVariousModeCommand convertToNumber:@""];
    XCTAssertEqual(num, BFElementModelSpecLegacySupportVariousModeCommandNumber__Null);
    num = [BFElementModelSpecLegacySupportVariousModeCommand convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementModelSpecLegacySupportVariousModeCommandNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementModelSpecLegacySupportVariousModeCommand
{
    [self convertCheckingBFElementModelSpecLegacySupportVariousModeCommand:BFElementModelSpecLegacySupportVariousModeCommandNumberPS_VM_AUTOCUT];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportVariousModeCommand:BFElementModelSpecLegacySupportVariousModeCommandNumberPS_VM_AUTOCUT];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportVariousModeCommand:bf::element::ModelSpecLegacySupportVariousModeCommand::Number::PS_VM_AUTOCUT];
    [self convertCheckingBFElementModelSpecLegacySupportVariousModeCommand:BFElementModelSpecLegacySupportVariousModeCommandNumberPS_VM_MIRROR];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportVariousModeCommand:BFElementModelSpecLegacySupportVariousModeCommandNumberPS_VM_MIRROR];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportVariousModeCommand:bf::element::ModelSpecLegacySupportVariousModeCommand::Number::PS_VM_MIRROR];
    [self convertCheckingBFElementModelSpecLegacySupportVariousModeCommand:BFElementModelSpecLegacySupportVariousModeCommandNumberPS_VM_PEEL];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportVariousModeCommand:BFElementModelSpecLegacySupportVariousModeCommandNumberPS_VM_PEEL];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportVariousModeCommand:bf::element::ModelSpecLegacySupportVariousModeCommand::Number::PS_VM_PEEL];
    [self convertCheckingBFElementModelSpecLegacySupportVariousModeCommand:BFElementModelSpecLegacySupportVariousModeCommandNumberPS_VM_ROTATE180];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportVariousModeCommand:BFElementModelSpecLegacySupportVariousModeCommandNumberPS_VM_ROTATE180];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportVariousModeCommand:bf::element::ModelSpecLegacySupportVariousModeCommand::Number::PS_VM_ROTATE180];
    [self convertCheckingBFElementModelSpecLegacySupportVariousModeCommand:BFElementModelSpecLegacySupportVariousModeCommandNumberPS_VM_CUTMARK];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportVariousModeCommand:BFElementModelSpecLegacySupportVariousModeCommandNumberPS_VM_CUTMARK];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportVariousModeCommand:bf::element::ModelSpecLegacySupportVariousModeCommand::Number::PS_VM_CUTMARK];
    [self convertCheckingBFElementModelSpecLegacySupportVariousModeCommand:BFElementModelSpecLegacySupportVariousModeCommandNumberPS_FEEDVOL];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportVariousModeCommand:BFElementModelSpecLegacySupportVariousModeCommandNumberPS_FEEDVOL];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportVariousModeCommand:bf::element::ModelSpecLegacySupportVariousModeCommand::Number::PS_FEEDVOL];
    [self convertCheckingBFElementModelSpecLegacySupportVariousModeCommand:BFElementModelSpecLegacySupportVariousModeCommandNumber__Null];
    [self convertCheckingOcToCppBFElementModelSpecLegacySupportVariousModeCommand:BFElementModelSpecLegacySupportVariousModeCommandNumber__Null];
    [self convertCheckingCppToOcBFElementModelSpecLegacySupportVariousModeCommand:bf::element::ModelSpecLegacySupportVariousModeCommand::Number::__Null];
    [self irregularCheckingBFElementModelSpecLegacySupportVariousModeCommand];
    NSData* strAsData = [BFElementModelSpecLegacySupportVariousModeCommand.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ModelSpecLegacySupportVariousModeCommand::key == ocKey);
}


@end