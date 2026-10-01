

#import <XCTest/XCTest.h>
#include <string>
#include "bf_element_model_definition.hpp"
#import "BFElementModelDefinition.h"

@interface BFElementModelTest : XCTestCase

@end

@implementation BFElementModelTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) convertCheckingBFElementModelInterface: (BFElementModelInterfaceNumber)num {
    NSString *str = [BFElementModelInterface convertToString:num];
    BFElementModelInterfaceNumber convertedNum = [BFElementModelInterface convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementModelInterface: (BFElementModelInterfaceNumber)num {
    NSString *strOc = [BFElementModelInterface convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ModelInterface::Number numCpp = bf::element::ModelInterface::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementModelInterface: (bf::element::ModelInterface::Number)num {
    std::string strCpp = std::string(bf::element::ModelInterface::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementModelInterfaceNumber numOc = [BFElementModelInterface convertToNumber:strOc];
    bf::element::ModelInterface::Number numCpp = (bf::element::ModelInterface::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementModelInterface {
    NSString *str;
    BFElementModelInterfaceNumber num;
    str = [BFElementModelInterface convertToString:BFElementModelInterfaceNumber(-1)];
    XCTAssertEqualObjects(str, BFElementModelInterfaceString__Null);
    str = [BFElementModelInterface convertToString:BFElementModelInterfaceNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementModelInterfaceString__Null);
    num = [BFElementModelInterface convertToNumber:@""];
    XCTAssertEqual(num, BFElementModelInterfaceNumber__Null);
    num = [BFElementModelInterface convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementModelInterfaceNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementModelInterface
{
    [self convertCheckingBFElementModelInterface:BFElementModelInterfaceNumberUSB];
    [self convertCheckingOcToCppBFElementModelInterface:BFElementModelInterfaceNumberUSB];
    [self convertCheckingCppToOcBFElementModelInterface:bf::element::ModelInterface::Number::USB];
    [self convertCheckingBFElementModelInterface:BFElementModelInterfaceNumberNetwork];
    [self convertCheckingOcToCppBFElementModelInterface:BFElementModelInterfaceNumberNetwork];
    [self convertCheckingCppToOcBFElementModelInterface:bf::element::ModelInterface::Number::Network];
    [self convertCheckingBFElementModelInterface:BFElementModelInterfaceNumberBluetooth];
    [self convertCheckingOcToCppBFElementModelInterface:BFElementModelInterfaceNumberBluetooth];
    [self convertCheckingCppToOcBFElementModelInterface:bf::element::ModelInterface::Number::Bluetooth];
    [self convertCheckingBFElementModelInterface:BFElementModelInterfaceNumberBluetoothLowEnergy];
    [self convertCheckingOcToCppBFElementModelInterface:BFElementModelInterfaceNumberBluetoothLowEnergy];
    [self convertCheckingCppToOcBFElementModelInterface:bf::element::ModelInterface::Number::BluetoothLowEnergy];
    [self convertCheckingBFElementModelInterface:BFElementModelInterfaceNumber__Null];
    [self convertCheckingOcToCppBFElementModelInterface:BFElementModelInterfaceNumber__Null];
    [self convertCheckingCppToOcBFElementModelInterface:bf::element::ModelInterface::Number::__Null];
    [self irregularCheckingBFElementModelInterface];
    NSData* strAsData = [BFElementModelInterface.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ModelInterface::key == ocKey);
}

- (void) convertCheckingBFElementModelMajor: (BFElementModelMajorNumber)num {
    NSString *str = [BFElementModelMajor convertToString:num];
    BFElementModelMajorNumber convertedNum = [BFElementModelMajor convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementModelMajor: (BFElementModelMajorNumber)num {
    NSString *strOc = [BFElementModelMajor convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ModelMajor::Number numCpp = bf::element::ModelMajor::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementModelMajor: (bf::element::ModelMajor::Number)num {
    std::string strCpp = std::string(bf::element::ModelMajor::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementModelMajorNumber numOc = [BFElementModelMajor convertToNumber:strOc];
    bf::element::ModelMajor::Number numCpp = (bf::element::ModelMajor::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementModelMajor {
    NSString *str;
    BFElementModelMajorNumber num;
    str = [BFElementModelMajor convertToString:BFElementModelMajorNumber(-1)];
    XCTAssertEqualObjects(str, BFElementModelMajorString__Null);
    str = [BFElementModelMajor convertToString:BFElementModelMajorNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementModelMajorString__Null);
    num = [BFElementModelMajor convertToNumber:@""];
    XCTAssertEqual(num, BFElementModelMajorNumber__Null);
    num = [BFElementModelMajor convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementModelMajorNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementModelMajor
{
    [self convertCheckingBFElementModelMajor:BFElementModelMajorNumberQL];
    [self convertCheckingOcToCppBFElementModelMajor:BFElementModelMajorNumberQL];
    [self convertCheckingCppToOcBFElementModelMajor:bf::element::ModelMajor::Number::QL];
    [self convertCheckingBFElementModelMajor:BFElementModelMajorNumberPT];
    [self convertCheckingOcToCppBFElementModelMajor:BFElementModelMajorNumberPT];
    [self convertCheckingCppToOcBFElementModelMajor:bf::element::ModelMajor::Number::PT];
    [self convertCheckingBFElementModelMajor:BFElementModelMajorNumberPJ];
    [self convertCheckingOcToCppBFElementModelMajor:BFElementModelMajorNumberPJ];
    [self convertCheckingCppToOcBFElementModelMajor:bf::element::ModelMajor::Number::PJ];
    [self convertCheckingBFElementModelMajor:BFElementModelMajorNumberSC];
    [self convertCheckingOcToCppBFElementModelMajor:BFElementModelMajorNumberSC];
    [self convertCheckingCppToOcBFElementModelMajor:bf::element::ModelMajor::Number::SC];
    [self convertCheckingBFElementModelMajor:BFElementModelMajorNumberRJ];
    [self convertCheckingOcToCppBFElementModelMajor:BFElementModelMajorNumberRJ];
    [self convertCheckingCppToOcBFElementModelMajor:bf::element::ModelMajor::Number::RJ];
    [self convertCheckingBFElementModelMajor:BFElementModelMajorNumberTD];
    [self convertCheckingOcToCppBFElementModelMajor:BFElementModelMajorNumberTD];
    [self convertCheckingCppToOcBFElementModelMajor:bf::element::ModelMajor::Number::TD];
    [self convertCheckingBFElementModelMajor:BFElementModelMajorNumberTP];
    [self convertCheckingOcToCppBFElementModelMajor:BFElementModelMajorNumberTP];
    [self convertCheckingCppToOcBFElementModelMajor:bf::element::ModelMajor::Number::TP];
    [self convertCheckingBFElementModelMajor:BFElementModelMajorNumberMW];
    [self convertCheckingOcToCppBFElementModelMajor:BFElementModelMajorNumberMW];
    [self convertCheckingCppToOcBFElementModelMajor:bf::element::ModelMajor::Number::MW];
    [self convertCheckingBFElementModelMajor:BFElementModelMajorNumber__Null];
    [self convertCheckingOcToCppBFElementModelMajor:BFElementModelMajorNumber__Null];
    [self convertCheckingCppToOcBFElementModelMajor:bf::element::ModelMajor::Number::__Null];
    [self irregularCheckingBFElementModelMajor];
    NSData* strAsData = [BFElementModelMajor.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ModelMajor::key == ocKey);
}

- (void) convertCheckingBFElementModelName: (BFElementModelNameNumber)num {
    NSString *str = [BFElementModelName convertToString:num];
    BFElementModelNameNumber convertedNum = [BFElementModelName convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementModelName: (BFElementModelNameNumber)num {
    NSString *strOc = [BFElementModelName convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ModelName::Number numCpp = bf::element::ModelName::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementModelName: (bf::element::ModelName::Number)num {
    std::string strCpp = std::string(bf::element::ModelName::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementModelNameNumber numOc = [BFElementModelName convertToNumber:strOc];
    bf::element::ModelName::Number numCpp = (bf::element::ModelName::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementModelName {
    NSString *str;
    BFElementModelNameNumber num;
    str = [BFElementModelName convertToString:BFElementModelNameNumber(-1)];
    XCTAssertEqualObjects(str, BFElementModelNameString__Null);
    str = [BFElementModelName convertToString:BFElementModelNameNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementModelNameString__Null);
    num = [BFElementModelName convertToNumber:@""];
    XCTAssertEqual(num, BFElementModelNameNumber__Null);
    num = [BFElementModelName convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementModelNameNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementModelName
{
    [self convertCheckingBFElementModelName:BFElementModelNameNumberMW_140BT];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberMW_140BT];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::MW_140BT];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberMW_145BT];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberMW_145BT];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::MW_145BT];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberMW_260];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberMW_260];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::MW_260];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_522];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_522];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_522];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_523];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_523];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_523];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_520];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_520];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_520];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_560];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_560];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_560];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_562];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_562];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_562];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_563];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_563];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_563];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_622];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_622];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_622];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_623];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_623];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_623];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_662];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_662];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_662];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_663];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_663];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_663];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberRJ_4030];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberRJ_4030];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::RJ_4030];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberRJ_4040];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberRJ_4040];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::RJ_4040];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberRJ_3150];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberRJ_3150];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::RJ_3150];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberRJ_3050];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberRJ_3050];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::RJ_3050];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberQL_580N];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberQL_580N];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::QL_580N];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberQL_700];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberQL_700];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::QL_700];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberQL_710W];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberQL_710W];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::QL_710W];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberQL_720NW];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberQL_720NW];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::QL_720NW];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberTD_2020];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberTD_2020];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::TD_2020];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberTD_2120N];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberTD_2120N];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::TD_2120N];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberTD_2130N];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberTD_2130N];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::TD_2130N];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_E550W];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_E550W];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_E550W];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_P750W];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_P750W];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_P750W];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberTD_4100N];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberTD_4100N];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::TD_4100N];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberTD_4000];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberTD_4000];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::TD_4000];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_762];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_762];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_762];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_763];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_763];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_763];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_773];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_773];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_773];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_722];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_722];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_722];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_723];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_723];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_723];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_763MFi];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_763MFi];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_763MFi];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_673];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_673];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_673];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberMW_145MFi];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberMW_145MFi];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::MW_145MFi];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberMW_260MFi];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberMW_260MFi];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::MW_260MFi];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_P300BT];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_P300BT];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_P300BT];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_E850TKW];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_E850TKW];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_E850TKW];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_D800W];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_D800W];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_D800W];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_P900W];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_P900W];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_P900W];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_P950NW];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_P950NW];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_P950NW];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberRJ_4030Ai];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberRJ_4030Ai];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::RJ_4030Ai];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_E800W];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_E800W];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_E800W];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberRJ_2030];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberRJ_2030];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::RJ_2030];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberRJ_2050];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberRJ_2050];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::RJ_2050];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberRJ_2140];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberRJ_2140];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::RJ_2140];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberRJ_2150];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberRJ_2150];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::RJ_2150];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberRJ_3050Ai];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberRJ_3050Ai];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::RJ_3050Ai];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberRJ_3150Ai];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberRJ_3150Ai];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::RJ_3150Ai];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberQL_800];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberQL_800];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::QL_800];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberQL_810W];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberQL_810W];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::QL_810W];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberQL_820NWB];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberQL_820NWB];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::QL_820NWB];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberQL_1100];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberQL_1100];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::QL_1100];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberQL_1110NWB];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberQL_1110NWB];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::QL_1110NWB];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberQL_1115NWB];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberQL_1115NWB];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::QL_1115NWB];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_P710BT];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_P710BT];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_P710BT];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_E500];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_E500];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_E500];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberRJ_4230B];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberRJ_4230B];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::RJ_4230B];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberRJ_4250WB];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberRJ_4250WB];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::RJ_4250WB];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberTD_4410D];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberTD_4410D];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::TD_4410D];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberTD_4420DN];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberTD_4420DN];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::TD_4420DN];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberTD_4510D];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberTD_4510D];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::TD_4510D];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberTD_4520DN];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberTD_4520DN];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::TD_4520DN];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberTD_4550DNWB];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberTD_4550DNWB];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::TD_4550DNWB];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberQL_600];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberQL_600];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::QL_600];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberMW_170];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberMW_170];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::MW_170];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberMW_270];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberMW_270];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::MW_270];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_P910BT];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_P910BT];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_P910BT];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_D450];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_D450];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_D450];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_D600];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_D600];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_D600];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_P700];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_P700];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_P700];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_H500];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_H500];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_H500];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_P715eBT];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_P715eBT];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_P715eBT];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberQL_500];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberQL_500];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::QL_500];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberQL_550];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberQL_550];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::QL_550];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberQL_560];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberQL_560];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::QL_560];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberQL_570];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberQL_570];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::QL_570];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberQL_650TD];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberQL_650TD];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::QL_650TD];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberQL_1050];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberQL_1050];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::QL_1050];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberQL_1060N];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberQL_1060N];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::QL_1060N];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_9700PC];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_9700PC];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_9700PC];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_9800PCN];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_9800PCN];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_9800PCN];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_3600];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_3600];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_3600];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_9600];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_9600];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_9600];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_9500PC];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_9500PC];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_9500PC];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_18NR];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_18NR];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_18NR];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_18R];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_18R];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_18R];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_24];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_24];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_24];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_2700];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_2700];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_2700];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_2430PC];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_2430PC];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_2430PC];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_2730];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_2730];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_2730];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberRJ_3230B];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberRJ_3230B];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::RJ_3230B];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberRJ_3250WB];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberRJ_3250WB];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::RJ_3250WB];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_D410];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_D410];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_D410];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_D460BT];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_D460BT];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_D460BT];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPT_D610BT];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPT_D610BT];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PT_D610BT];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_822];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_822];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_822];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_823];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_823];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_823];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_862];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_862];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_862];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_863];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_863];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_863];
    [self convertCheckingBFElementModelName:BFElementModelNameNumberPJ_883];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumberPJ_883];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::PJ_883];
    [self convertCheckingBFElementModelName:BFElementModelNameNumber__Null];
    [self convertCheckingOcToCppBFElementModelName:BFElementModelNameNumber__Null];
    [self convertCheckingCppToOcBFElementModelName:bf::element::ModelName::Number::__Null];
    [self irregularCheckingBFElementModelName];
    NSData* strAsData = [BFElementModelName.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ModelName::key == ocKey);
}


@end