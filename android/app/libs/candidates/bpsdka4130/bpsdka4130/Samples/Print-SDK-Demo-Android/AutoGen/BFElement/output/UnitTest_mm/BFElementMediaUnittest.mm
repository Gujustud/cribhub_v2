

#import <XCTest/XCTest.h>
#include <string>
#include "bf_element_media_definition.hpp"
#import "BFElementMediaDefinition.h"

@interface BFElementMediaTest : XCTestCase

@end

@implementation BFElementMediaTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) convertCheckingBFElementMediaBackgroundColor: (BFElementMediaBackgroundColorNumber)num {
    NSString *str = [BFElementMediaBackgroundColor convertToString:num];
    BFElementMediaBackgroundColorNumber convertedNum = [BFElementMediaBackgroundColor convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementMediaBackgroundColor: (BFElementMediaBackgroundColorNumber)num {
    NSString *strOc = [BFElementMediaBackgroundColor convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::MediaBackgroundColor::Number numCpp = bf::element::MediaBackgroundColor::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementMediaBackgroundColor: (bf::element::MediaBackgroundColor::Number)num {
    std::string strCpp = std::string(bf::element::MediaBackgroundColor::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementMediaBackgroundColorNumber numOc = [BFElementMediaBackgroundColor convertToNumber:strOc];
    bf::element::MediaBackgroundColor::Number numCpp = (bf::element::MediaBackgroundColor::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementMediaBackgroundColor {
    NSString *str;
    BFElementMediaBackgroundColorNumber num;
    str = [BFElementMediaBackgroundColor convertToString:BFElementMediaBackgroundColorNumber(-1)];
    XCTAssertEqualObjects(str, BFElementMediaBackgroundColorString__Null);
    str = [BFElementMediaBackgroundColor convertToString:BFElementMediaBackgroundColorNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementMediaBackgroundColorString__Null);
    num = [BFElementMediaBackgroundColor convertToNumber:@""];
    XCTAssertEqual(num, BFElementMediaBackgroundColorNumber__Null);
    num = [BFElementMediaBackgroundColor convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementMediaBackgroundColorNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementMediaBackgroundColor
{
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberStandard];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberStandard];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::Standard];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberWhite];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberWhite];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::White];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberOthers];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberOthers];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::Others];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberClear];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberClear];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::Clear];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberRed];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberRed];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::Red];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberBlue];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberBlue];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::Blue];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberYellow];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberYellow];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::Yellow];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberGreen];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberGreen];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::Green];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberBlack];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberBlack];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::Black];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberClearWithWhiteInk];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberClearWithWhiteInk];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::ClearWithWhiteInk];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberPremiumGold];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberPremiumGold];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::PremiumGold];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberPremiumSilver];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberPremiumSilver];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::PremiumSilver];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberPremiumOthers];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberPremiumOthers];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::PremiumOthers];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberMaskingOthers];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberMaskingOthers];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::MaskingOthers];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberMatteWhite];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberMatteWhite];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::MatteWhite];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberMatteClear];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberMatteClear];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::MatteClear];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberMatteSilver];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberMatteSilver];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::MatteSilver];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberSatinGold];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberSatinGold];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::SatinGold];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberSatinSilver];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberSatinSilver];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::SatinSilver];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberPastelPurple];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberPastelPurple];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::PastelPurple];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberBlueWithWhiteInk];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberBlueWithWhiteInk];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::BlueWithWhiteInk];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberRedWithWhiteInk];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberRedWithWhiteInk];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::RedWithWhiteInk];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberFluorescentOrange];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberFluorescentOrange];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::FluorescentOrange];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberFluorescentYellow];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberFluorescentYellow];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::FluorescentYellow];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberBerryPink];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberBerryPink];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::BerryPink];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberLightGray];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberLightGray];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::LightGray];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberLimeGreen];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberLimeGreen];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::LimeGreen];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberSatinNavyBlue];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberSatinNavyBlue];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::SatinNavyBlue];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberSatinWineRed];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberSatinWineRed];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::SatinWineRed];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberFabricYellow];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberFabricYellow];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::FabricYellow];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberFabricPink];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberFabricPink];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::FabricPink];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberFabricBlue];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberFabricBlue];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::FabricBlue];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberTubeWhite];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberTubeWhite];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::TubeWhite];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberSelfLaminatedWhite];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberSelfLaminatedWhite];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::SelfLaminatedWhite];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberFlexibleWhite];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberFlexibleWhite];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::FlexibleWhite];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberFlexibleYellow];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberFlexibleYellow];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::FlexibleYellow];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberCleaningWhite];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberCleaningWhite];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::CleaningWhite];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberStencilWhite];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberStencilWhite];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::StencilWhite];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberLightBlue_Satin];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberLightBlue_Satin];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::LightBlue_Satin];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberMint_Satin];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberMint_Satin];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::Mint_Satin];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberSilver_Satin];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberSilver_Satin];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::Silver_Satin];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberIncompatible];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumberIncompatible];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::Incompatible];
    [self convertCheckingBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumber__Null];
    [self convertCheckingOcToCppBFElementMediaBackgroundColor:BFElementMediaBackgroundColorNumber__Null];
    [self convertCheckingCppToOcBFElementMediaBackgroundColor:bf::element::MediaBackgroundColor::Number::__Null];
    [self irregularCheckingBFElementMediaBackgroundColor];
    NSData* strAsData = [BFElementMediaBackgroundColor.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::MediaBackgroundColor::key == ocKey);
}

- (void) convertCheckingBFElementMediaPaperInsertionPosition: (BFElementMediaPaperInsertionPositionNumber)num {
    NSString *str = [BFElementMediaPaperInsertionPosition convertToString:num];
    BFElementMediaPaperInsertionPositionNumber convertedNum = [BFElementMediaPaperInsertionPosition convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementMediaPaperInsertionPosition: (BFElementMediaPaperInsertionPositionNumber)num {
    NSString *strOc = [BFElementMediaPaperInsertionPosition convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::MediaPaperInsertionPosition::Number numCpp = bf::element::MediaPaperInsertionPosition::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementMediaPaperInsertionPosition: (bf::element::MediaPaperInsertionPosition::Number)num {
    std::string strCpp = std::string(bf::element::MediaPaperInsertionPosition::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementMediaPaperInsertionPositionNumber numOc = [BFElementMediaPaperInsertionPosition convertToNumber:strOc];
    bf::element::MediaPaperInsertionPosition::Number numCpp = (bf::element::MediaPaperInsertionPosition::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementMediaPaperInsertionPosition {
    NSString *str;
    BFElementMediaPaperInsertionPositionNumber num;
    str = [BFElementMediaPaperInsertionPosition convertToString:BFElementMediaPaperInsertionPositionNumber(-1)];
    XCTAssertEqualObjects(str, BFElementMediaPaperInsertionPositionString__Null);
    str = [BFElementMediaPaperInsertionPosition convertToString:BFElementMediaPaperInsertionPositionNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementMediaPaperInsertionPositionString__Null);
    num = [BFElementMediaPaperInsertionPosition convertToNumber:@""];
    XCTAssertEqual(num, BFElementMediaPaperInsertionPositionNumber__Null);
    num = [BFElementMediaPaperInsertionPosition convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementMediaPaperInsertionPositionNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementMediaPaperInsertionPosition
{
    [self convertCheckingBFElementMediaPaperInsertionPosition:BFElementMediaPaperInsertionPositionNumberLeft];
    [self convertCheckingOcToCppBFElementMediaPaperInsertionPosition:BFElementMediaPaperInsertionPositionNumberLeft];
    [self convertCheckingCppToOcBFElementMediaPaperInsertionPosition:bf::element::MediaPaperInsertionPosition::Number::Left];
    [self convertCheckingBFElementMediaPaperInsertionPosition:BFElementMediaPaperInsertionPositionNumberCenter];
    [self convertCheckingOcToCppBFElementMediaPaperInsertionPosition:BFElementMediaPaperInsertionPositionNumberCenter];
    [self convertCheckingCppToOcBFElementMediaPaperInsertionPosition:bf::element::MediaPaperInsertionPosition::Number::Center];
    [self convertCheckingBFElementMediaPaperInsertionPosition:BFElementMediaPaperInsertionPositionNumberRight];
    [self convertCheckingOcToCppBFElementMediaPaperInsertionPosition:BFElementMediaPaperInsertionPositionNumberRight];
    [self convertCheckingCppToOcBFElementMediaPaperInsertionPosition:bf::element::MediaPaperInsertionPosition::Number::Right];
    [self convertCheckingBFElementMediaPaperInsertionPosition:BFElementMediaPaperInsertionPositionNumber__Null];
    [self convertCheckingOcToCppBFElementMediaPaperInsertionPosition:BFElementMediaPaperInsertionPositionNumber__Null];
    [self convertCheckingCppToOcBFElementMediaPaperInsertionPosition:bf::element::MediaPaperInsertionPosition::Number::__Null];
    [self irregularCheckingBFElementMediaPaperInsertionPosition];
    NSData* strAsData = [BFElementMediaPaperInsertionPosition.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::MediaPaperInsertionPosition::key == ocKey);
}

- (void) convertCheckingBFElementMediaPJPaperType: (BFElementMediaPJPaperTypeNumber)num {
    NSString *str = [BFElementMediaPJPaperType convertToString:num];
    BFElementMediaPJPaperTypeNumber convertedNum = [BFElementMediaPJPaperType convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementMediaPJPaperType: (BFElementMediaPJPaperTypeNumber)num {
    NSString *strOc = [BFElementMediaPJPaperType convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::MediaPJPaperType::Number numCpp = bf::element::MediaPJPaperType::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementMediaPJPaperType: (bf::element::MediaPJPaperType::Number)num {
    std::string strCpp = std::string(bf::element::MediaPJPaperType::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementMediaPJPaperTypeNumber numOc = [BFElementMediaPJPaperType convertToNumber:strOc];
    bf::element::MediaPJPaperType::Number numCpp = (bf::element::MediaPJPaperType::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementMediaPJPaperType {
    NSString *str;
    BFElementMediaPJPaperTypeNumber num;
    str = [BFElementMediaPJPaperType convertToString:BFElementMediaPJPaperTypeNumber(-1)];
    XCTAssertEqualObjects(str, BFElementMediaPJPaperTypeString__Null);
    str = [BFElementMediaPJPaperType convertToString:BFElementMediaPJPaperTypeNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementMediaPJPaperTypeString__Null);
    num = [BFElementMediaPJPaperType convertToNumber:@""];
    XCTAssertEqual(num, BFElementMediaPJPaperTypeNumber__Null);
    num = [BFElementMediaPJPaperType convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementMediaPJPaperTypeNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementMediaPJPaperType
{
    [self convertCheckingBFElementMediaPJPaperType:BFElementMediaPJPaperTypeNumberRoll];
    [self convertCheckingOcToCppBFElementMediaPJPaperType:BFElementMediaPJPaperTypeNumberRoll];
    [self convertCheckingCppToOcBFElementMediaPJPaperType:bf::element::MediaPJPaperType::Number::Roll];
    [self convertCheckingBFElementMediaPJPaperType:BFElementMediaPJPaperTypeNumberCutSheet];
    [self convertCheckingOcToCppBFElementMediaPJPaperType:BFElementMediaPJPaperTypeNumberCutSheet];
    [self convertCheckingCppToOcBFElementMediaPJPaperType:bf::element::MediaPJPaperType::Number::CutSheet];
    [self convertCheckingBFElementMediaPJPaperType:BFElementMediaPJPaperTypeNumberPerforatedRoll];
    [self convertCheckingOcToCppBFElementMediaPJPaperType:BFElementMediaPJPaperTypeNumberPerforatedRoll];
    [self convertCheckingCppToOcBFElementMediaPJPaperType:bf::element::MediaPJPaperType::Number::PerforatedRoll];
    [self convertCheckingBFElementMediaPJPaperType:BFElementMediaPJPaperTypeNumber__Null];
    [self convertCheckingOcToCppBFElementMediaPJPaperType:BFElementMediaPJPaperTypeNumber__Null];
    [self convertCheckingCppToOcBFElementMediaPJPaperType:bf::element::MediaPJPaperType::Number::__Null];
    [self irregularCheckingBFElementMediaPJPaperType];
    NSData* strAsData = [BFElementMediaPJPaperType.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::MediaPJPaperType::key == ocKey);
}

- (void) convertCheckingBFElementMediaPJRollCase: (BFElementMediaPJRollCaseNumber)num {
    NSString *str = [BFElementMediaPJRollCase convertToString:num];
    BFElementMediaPJRollCaseNumber convertedNum = [BFElementMediaPJRollCase convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementMediaPJRollCase: (BFElementMediaPJRollCaseNumber)num {
    NSString *strOc = [BFElementMediaPJRollCase convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::MediaPJRollCase::Number numCpp = bf::element::MediaPJRollCase::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementMediaPJRollCase: (bf::element::MediaPJRollCase::Number)num {
    std::string strCpp = std::string(bf::element::MediaPJRollCase::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementMediaPJRollCaseNumber numOc = [BFElementMediaPJRollCase convertToNumber:strOc];
    bf::element::MediaPJRollCase::Number numCpp = (bf::element::MediaPJRollCase::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementMediaPJRollCase {
    NSString *str;
    BFElementMediaPJRollCaseNumber num;
    str = [BFElementMediaPJRollCase convertToString:BFElementMediaPJRollCaseNumber(-1)];
    XCTAssertEqualObjects(str, BFElementMediaPJRollCaseString__Null);
    str = [BFElementMediaPJRollCase convertToString:BFElementMediaPJRollCaseNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementMediaPJRollCaseString__Null);
    num = [BFElementMediaPJRollCase convertToNumber:@""];
    XCTAssertEqual(num, BFElementMediaPJRollCaseNumber__Null);
    num = [BFElementMediaPJRollCase convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementMediaPJRollCaseNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementMediaPJRollCase
{
    [self convertCheckingBFElementMediaPJRollCase:BFElementMediaPJRollCaseNumberNone];
    [self convertCheckingOcToCppBFElementMediaPJRollCase:BFElementMediaPJRollCaseNumberNone];
    [self convertCheckingCppToOcBFElementMediaPJRollCase:bf::element::MediaPJRollCase::Number::None];
    [self convertCheckingBFElementMediaPJRollCase:BFElementMediaPJRollCaseNumberPARC001_NoAntiCurl];
    [self convertCheckingOcToCppBFElementMediaPJRollCase:BFElementMediaPJRollCaseNumberPARC001_NoAntiCurl];
    [self convertCheckingCppToOcBFElementMediaPJRollCase:bf::element::MediaPJRollCase::Number::PARC001_NoAntiCurl];
    [self convertCheckingBFElementMediaPJRollCase:BFElementMediaPJRollCaseNumberPARC001];
    [self convertCheckingOcToCppBFElementMediaPJRollCase:BFElementMediaPJRollCaseNumberPARC001];
    [self convertCheckingCppToOcBFElementMediaPJRollCase:bf::element::MediaPJRollCase::Number::PARC001];
    [self convertCheckingBFElementMediaPJRollCase:BFElementMediaPJRollCaseNumberPARC001_ShortFeed];
    [self convertCheckingOcToCppBFElementMediaPJRollCase:BFElementMediaPJRollCaseNumberPARC001_ShortFeed];
    [self convertCheckingCppToOcBFElementMediaPJRollCase:bf::element::MediaPJRollCase::Number::PARC001_ShortFeed];
    [self convertCheckingBFElementMediaPJRollCase:BFElementMediaPJRollCaseNumberKeepPrinterSetting];
    [self convertCheckingOcToCppBFElementMediaPJRollCase:BFElementMediaPJRollCaseNumberKeepPrinterSetting];
    [self convertCheckingCppToOcBFElementMediaPJRollCase:bf::element::MediaPJRollCase::Number::KeepPrinterSetting];
    [self convertCheckingBFElementMediaPJRollCase:BFElementMediaPJRollCaseNumber__Null];
    [self convertCheckingOcToCppBFElementMediaPJRollCase:BFElementMediaPJRollCaseNumber__Null];
    [self convertCheckingCppToOcBFElementMediaPJRollCase:bf::element::MediaPJRollCase::Number::__Null];
    [self irregularCheckingBFElementMediaPJRollCase];
    NSData* strAsData = [BFElementMediaPJRollCase.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::MediaPJRollCase::key == ocKey);
}

- (void) convertCheckingBFElementMediaSize: (BFElementMediaSizeNumber)num {
    NSString *str = [BFElementMediaSize convertToString:num];
    BFElementMediaSizeNumber convertedNum = [BFElementMediaSize convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementMediaSize: (BFElementMediaSizeNumber)num {
    NSString *strOc = [BFElementMediaSize convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::MediaSize::Number numCpp = bf::element::MediaSize::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementMediaSize: (bf::element::MediaSize::Number)num {
    std::string strCpp = std::string(bf::element::MediaSize::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementMediaSizeNumber numOc = [BFElementMediaSize convertToNumber:strOc];
    bf::element::MediaSize::Number numCpp = (bf::element::MediaSize::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementMediaSize {
    NSString *str;
    BFElementMediaSizeNumber num;
    str = [BFElementMediaSize convertToString:BFElementMediaSizeNumber(-1)];
    XCTAssertEqualObjects(str, BFElementMediaSizeString__Null);
    str = [BFElementMediaSize convertToString:BFElementMediaSizeNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementMediaSizeString__Null);
    num = [BFElementMediaSize convertToNumber:@""];
    XCTAssertEqual(num, BFElementMediaSizeNumber__Null);
    num = [BFElementMediaSize convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementMediaSizeNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementMediaSize
{
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL3_5mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL3_5mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L3_5mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL6mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL6mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L6mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL9mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL9mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L9mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL12mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL12mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L12mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL18mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL18mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L18mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL24mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL24mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L24mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL29mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL29mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L29mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL36mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL36mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L36mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL38mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL38mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L38mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL50mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL50mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L50mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL54mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL54mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L54mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL62mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL62mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L62mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL102mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL102mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L102mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL103mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL103mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L103mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL17mmx54mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL17mmx54mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L17mmx54mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL17mmx87mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL17mmx87mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L17mmx87mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL23mmx23mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL23mmx23mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L23mmx23mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL29mmx42mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL29mmx42mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L29mmx42mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL29mmx90mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL29mmx90mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L29mmx90mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL38mmx90mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL38mmx90mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L38mmx90mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL39mmx48mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL39mmx48mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L39mmx48mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL52mmx29mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL52mmx29mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L52mmx29mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL54mmx29mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL54mmx29mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L54mmx29mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL60mmx86mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL60mmx86mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L60mmx86mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL62mmx29mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL62mmx29mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L62mmx29mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL62mmx60mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL62mmx60mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L62mmx60mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL62mmx75mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL62mmx75mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L62mmx75mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL62mmx100mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL62mmx100mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L62mmx100mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL102mmx51mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL102mmx51mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L102mmx51mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL102mmx152mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL102mmx152mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L102mmx152mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL103mmx164mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL103mmx164mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L103mmx164mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL12mmDia];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL12mmDia];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L12mmDia];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL24mmDia];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL24mmDia];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L24mmDia];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberL58mmDia];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberL58mmDia];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::L58mmDia];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberHS5_8mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberHS5_8mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::HS5_8mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberHS8_8mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberHS8_8mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::HS8_8mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberHS11_7mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberHS11_7mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::HS11_7mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberHS17_7mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberHS17_7mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::HS17_7mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberHS23_6mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberHS23_6mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::HS23_6mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberHS5_2mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberHS5_2mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::HS5_2mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberHS9_0mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberHS9_0mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::HS9_0mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberHS11_2mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberHS11_2mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::HS11_2mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberHS21_0mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberHS21_0mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::HS21_0mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberHS31_0mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberHS31_0mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::HS31_0mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberFL21mmx45mm];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberFL21mmx45mm];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::FL21mmx45mm];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberA4];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberA4];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::A4];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberA5];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberA5];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::A5];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberLetter];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberLetter];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::Letter];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberLegal];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberLegal];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::Legal];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumberCustom];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumberCustom];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::Custom];
    [self convertCheckingBFElementMediaSize:BFElementMediaSizeNumber__Null];
    [self convertCheckingOcToCppBFElementMediaSize:BFElementMediaSizeNumber__Null];
    [self convertCheckingCppToOcBFElementMediaSize:bf::element::MediaSize::Number::__Null];
    [self irregularCheckingBFElementMediaSize];
    NSData* strAsData = [BFElementMediaSize.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::MediaSize::key == ocKey);
}

- (void) convertCheckingBFElementMediaTextColor: (BFElementMediaTextColorNumber)num {
    NSString *str = [BFElementMediaTextColor convertToString:num];
    BFElementMediaTextColorNumber convertedNum = [BFElementMediaTextColor convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementMediaTextColor: (BFElementMediaTextColorNumber)num {
    NSString *strOc = [BFElementMediaTextColor convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::MediaTextColor::Number numCpp = bf::element::MediaTextColor::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementMediaTextColor: (bf::element::MediaTextColor::Number)num {
    std::string strCpp = std::string(bf::element::MediaTextColor::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementMediaTextColorNumber numOc = [BFElementMediaTextColor convertToNumber:strOc];
    bf::element::MediaTextColor::Number numCpp = (bf::element::MediaTextColor::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementMediaTextColor {
    NSString *str;
    BFElementMediaTextColorNumber num;
    str = [BFElementMediaTextColor convertToString:BFElementMediaTextColorNumber(-1)];
    XCTAssertEqualObjects(str, BFElementMediaTextColorString__Null);
    str = [BFElementMediaTextColor convertToString:BFElementMediaTextColorNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementMediaTextColorString__Null);
    num = [BFElementMediaTextColor convertToNumber:@""];
    XCTAssertEqual(num, BFElementMediaTextColorNumber__Null);
    num = [BFElementMediaTextColor convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementMediaTextColorNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementMediaTextColor
{
    [self convertCheckingBFElementMediaTextColor:BFElementMediaTextColorNumberStandard];
    [self convertCheckingOcToCppBFElementMediaTextColor:BFElementMediaTextColorNumberStandard];
    [self convertCheckingCppToOcBFElementMediaTextColor:bf::element::MediaTextColor::Number::Standard];
    [self convertCheckingBFElementMediaTextColor:BFElementMediaTextColorNumberWhite];
    [self convertCheckingOcToCppBFElementMediaTextColor:BFElementMediaTextColorNumberWhite];
    [self convertCheckingCppToOcBFElementMediaTextColor:bf::element::MediaTextColor::Number::White];
    [self convertCheckingBFElementMediaTextColor:BFElementMediaTextColorNumberOthers];
    [self convertCheckingOcToCppBFElementMediaTextColor:BFElementMediaTextColorNumberOthers];
    [self convertCheckingCppToOcBFElementMediaTextColor:bf::element::MediaTextColor::Number::Others];
    [self convertCheckingBFElementMediaTextColor:BFElementMediaTextColorNumberRed];
    [self convertCheckingOcToCppBFElementMediaTextColor:BFElementMediaTextColorNumberRed];
    [self convertCheckingCppToOcBFElementMediaTextColor:bf::element::MediaTextColor::Number::Red];
    [self convertCheckingBFElementMediaTextColor:BFElementMediaTextColorNumberBlue];
    [self convertCheckingOcToCppBFElementMediaTextColor:BFElementMediaTextColorNumberBlue];
    [self convertCheckingCppToOcBFElementMediaTextColor:bf::element::MediaTextColor::Number::Blue];
    [self convertCheckingBFElementMediaTextColor:BFElementMediaTextColorNumberBlack];
    [self convertCheckingOcToCppBFElementMediaTextColor:BFElementMediaTextColorNumberBlack];
    [self convertCheckingCppToOcBFElementMediaTextColor:bf::element::MediaTextColor::Number::Black];
    [self convertCheckingBFElementMediaTextColor:BFElementMediaTextColorNumberGold];
    [self convertCheckingOcToCppBFElementMediaTextColor:BFElementMediaTextColorNumberGold];
    [self convertCheckingCppToOcBFElementMediaTextColor:bf::element::MediaTextColor::Number::Gold];
    [self convertCheckingBFElementMediaTextColor:BFElementMediaTextColorNumberRedAndBlack];
    [self convertCheckingOcToCppBFElementMediaTextColor:BFElementMediaTextColorNumberRedAndBlack];
    [self convertCheckingCppToOcBFElementMediaTextColor:bf::element::MediaTextColor::Number::RedAndBlack];
    [self convertCheckingBFElementMediaTextColor:BFElementMediaTextColorNumberFabricBlue];
    [self convertCheckingOcToCppBFElementMediaTextColor:BFElementMediaTextColorNumberFabricBlue];
    [self convertCheckingCppToOcBFElementMediaTextColor:bf::element::MediaTextColor::Number::FabricBlue];
    [self convertCheckingBFElementMediaTextColor:BFElementMediaTextColorNumberCleaningBlack];
    [self convertCheckingOcToCppBFElementMediaTextColor:BFElementMediaTextColorNumberCleaningBlack];
    [self convertCheckingCppToOcBFElementMediaTextColor:bf::element::MediaTextColor::Number::CleaningBlack];
    [self convertCheckingBFElementMediaTextColor:BFElementMediaTextColorNumberStencilBlack];
    [self convertCheckingOcToCppBFElementMediaTextColor:BFElementMediaTextColorNumberStencilBlack];
    [self convertCheckingCppToOcBFElementMediaTextColor:bf::element::MediaTextColor::Number::StencilBlack];
    [self convertCheckingBFElementMediaTextColor:BFElementMediaTextColorNumberIncompatible];
    [self convertCheckingOcToCppBFElementMediaTextColor:BFElementMediaTextColorNumberIncompatible];
    [self convertCheckingCppToOcBFElementMediaTextColor:bf::element::MediaTextColor::Number::Incompatible];
    [self convertCheckingBFElementMediaTextColor:BFElementMediaTextColorNumber__Null];
    [self convertCheckingOcToCppBFElementMediaTextColor:BFElementMediaTextColorNumber__Null];
    [self convertCheckingCppToOcBFElementMediaTextColor:bf::element::MediaTextColor::Number::__Null];
    [self irregularCheckingBFElementMediaTextColor];
    NSData* strAsData = [BFElementMediaTextColor.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::MediaTextColor::key == ocKey);
}

- (void) convertCheckingBFElementMediaType: (BFElementMediaTypeNumber)num {
    NSString *str = [BFElementMediaType convertToString:num];
    BFElementMediaTypeNumber convertedNum = [BFElementMediaType convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementMediaType: (BFElementMediaTypeNumber)num {
    NSString *strOc = [BFElementMediaType convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::MediaType::Number numCpp = bf::element::MediaType::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementMediaType: (bf::element::MediaType::Number)num {
    std::string strCpp = std::string(bf::element::MediaType::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementMediaTypeNumber numOc = [BFElementMediaType convertToNumber:strOc];
    bf::element::MediaType::Number numCpp = (bf::element::MediaType::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementMediaType {
    NSString *str;
    BFElementMediaTypeNumber num;
    str = [BFElementMediaType convertToString:BFElementMediaTypeNumber(-1)];
    XCTAssertEqualObjects(str, BFElementMediaTypeString__Null);
    str = [BFElementMediaType convertToString:BFElementMediaTypeNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementMediaTypeString__Null);
    num = [BFElementMediaType convertToNumber:@""];
    XCTAssertEqual(num, BFElementMediaTypeNumber__Null);
    num = [BFElementMediaType convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementMediaTypeNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementMediaType
{
    [self convertCheckingBFElementMediaType:BFElementMediaTypeNumberUnknown];
    [self convertCheckingOcToCppBFElementMediaType:BFElementMediaTypeNumberUnknown];
    [self convertCheckingCppToOcBFElementMediaType:bf::element::MediaType::Number::Unknown];
    [self convertCheckingBFElementMediaType:BFElementMediaTypeNumberPTLaminate];
    [self convertCheckingOcToCppBFElementMediaType:BFElementMediaTypeNumberPTLaminate];
    [self convertCheckingCppToOcBFElementMediaType:bf::element::MediaType::Number::PTLaminate];
    [self convertCheckingBFElementMediaType:BFElementMediaTypeNumberPTNonLaminate];
    [self convertCheckingOcToCppBFElementMediaType:BFElementMediaTypeNumberPTNonLaminate];
    [self convertCheckingCppToOcBFElementMediaType:bf::element::MediaType::Number::PTNonLaminate];
    [self convertCheckingBFElementMediaType:BFElementMediaTypeNumberPTFabric];
    [self convertCheckingOcToCppBFElementMediaType:BFElementMediaTypeNumberPTFabric];
    [self convertCheckingCppToOcBFElementMediaType:bf::element::MediaType::Number::PTFabric];
    [self convertCheckingBFElementMediaType:BFElementMediaTypeNumberQLInfiniteLable];
    [self convertCheckingOcToCppBFElementMediaType:BFElementMediaTypeNumberQLInfiniteLable];
    [self convertCheckingCppToOcBFElementMediaType:bf::element::MediaType::Number::QLInfiniteLable];
    [self convertCheckingBFElementMediaType:BFElementMediaTypeNumberQLDieCutLable];
    [self convertCheckingOcToCppBFElementMediaType:BFElementMediaTypeNumberQLDieCutLable];
    [self convertCheckingCppToOcBFElementMediaType:bf::element::MediaType::Number::QLDieCutLable];
    [self convertCheckingBFElementMediaType:BFElementMediaTypeNumberPTHeatShrink];
    [self convertCheckingOcToCppBFElementMediaType:BFElementMediaTypeNumberPTHeatShrink];
    [self convertCheckingCppToOcBFElementMediaType:bf::element::MediaType::Number::PTHeatShrink];
    [self convertCheckingBFElementMediaType:BFElementMediaTypeNumberPTFLe];
    [self convertCheckingOcToCppBFElementMediaType:BFElementMediaTypeNumberPTFLe];
    [self convertCheckingCppToOcBFElementMediaType:bf::element::MediaType::Number::PTFLe];
    [self convertCheckingBFElementMediaType:BFElementMediaTypeNumberPTFlexibleID];
    [self convertCheckingOcToCppBFElementMediaType:BFElementMediaTypeNumberPTFlexibleID];
    [self convertCheckingCppToOcBFElementMediaType:bf::element::MediaType::Number::PTFlexibleID];
    [self convertCheckingBFElementMediaType:BFElementMediaTypeNumberPTSatin];
    [self convertCheckingOcToCppBFElementMediaType:BFElementMediaTypeNumberPTSatin];
    [self convertCheckingCppToOcBFElementMediaType:bf::element::MediaType::Number::PTSatin];
    [self convertCheckingBFElementMediaType:BFElementMediaTypeNumberPTSelfLaminate];
    [self convertCheckingOcToCppBFElementMediaType:BFElementMediaTypeNumberPTSelfLaminate];
    [self convertCheckingCppToOcBFElementMediaType:bf::element::MediaType::Number::PTSelfLaminate];
    [self convertCheckingBFElementMediaType:BFElementMediaTypeNumberIncompatible];
    [self convertCheckingOcToCppBFElementMediaType:BFElementMediaTypeNumberIncompatible];
    [self convertCheckingCppToOcBFElementMediaType:bf::element::MediaType::Number::Incompatible];
    [self convertCheckingBFElementMediaType:BFElementMediaTypeNumber__Null];
    [self convertCheckingOcToCppBFElementMediaType:BFElementMediaTypeNumber__Null];
    [self convertCheckingCppToOcBFElementMediaType:bf::element::MediaType::Number::__Null];
    [self irregularCheckingBFElementMediaType];
    NSData* strAsData = [BFElementMediaType.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::MediaType::key == ocKey);
}


@end