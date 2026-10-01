

#import <XCTest/XCTest.h>
#include <string>
#include "bf_element_image_definition.hpp"
#import "BFElementImageDefinition.h"

@interface BFElementImageTest : XCTestCase

@end

@implementation BFElementImageTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) convertCheckingBFElementImageHalftone: (BFElementImageHalftoneNumber)num {
    NSString *str = [BFElementImageHalftone convertToString:num];
    BFElementImageHalftoneNumber convertedNum = [BFElementImageHalftone convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementImageHalftone: (BFElementImageHalftoneNumber)num {
    NSString *strOc = [BFElementImageHalftone convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ImageHalftone::Number numCpp = bf::element::ImageHalftone::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementImageHalftone: (bf::element::ImageHalftone::Number)num {
    std::string strCpp = std::string(bf::element::ImageHalftone::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementImageHalftoneNumber numOc = [BFElementImageHalftone convertToNumber:strOc];
    bf::element::ImageHalftone::Number numCpp = (bf::element::ImageHalftone::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementImageHalftone {
    NSString *str;
    BFElementImageHalftoneNumber num;
    str = [BFElementImageHalftone convertToString:BFElementImageHalftoneNumber(-1)];
    XCTAssertEqualObjects(str, BFElementImageHalftoneString__Null);
    str = [BFElementImageHalftone convertToString:BFElementImageHalftoneNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementImageHalftoneString__Null);
    num = [BFElementImageHalftone convertToNumber:@""];
    XCTAssertEqual(num, BFElementImageHalftoneNumber__Null);
    num = [BFElementImageHalftone convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementImageHalftoneNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementImageHalftone
{
    [self convertCheckingBFElementImageHalftone:BFElementImageHalftoneNumberSimpleThreshold];
    [self convertCheckingOcToCppBFElementImageHalftone:BFElementImageHalftoneNumberSimpleThreshold];
    [self convertCheckingCppToOcBFElementImageHalftone:bf::element::ImageHalftone::Number::SimpleThreshold];
    [self convertCheckingBFElementImageHalftone:BFElementImageHalftoneNumberDither];
    [self convertCheckingOcToCppBFElementImageHalftone:BFElementImageHalftoneNumberDither];
    [self convertCheckingCppToOcBFElementImageHalftone:bf::element::ImageHalftone::Number::Dither];
    [self convertCheckingBFElementImageHalftone:BFElementImageHalftoneNumberErrorDiffusion];
    [self convertCheckingOcToCppBFElementImageHalftone:BFElementImageHalftoneNumberErrorDiffusion];
    [self convertCheckingCppToOcBFElementImageHalftone:bf::element::ImageHalftone::Number::ErrorDiffusion];
    [self convertCheckingBFElementImageHalftone:BFElementImageHalftoneNumber__Null];
    [self convertCheckingOcToCppBFElementImageHalftone:BFElementImageHalftoneNumber__Null];
    [self convertCheckingCppToOcBFElementImageHalftone:bf::element::ImageHalftone::Number::__Null];
    [self irregularCheckingBFElementImageHalftone];
    NSData* strAsData = [BFElementImageHalftone.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ImageHalftone::key == ocKey);
}

- (void) convertCheckingBFElementImageOrientation: (BFElementImageOrientationNumber)num {
    NSString *str = [BFElementImageOrientation convertToString:num];
    BFElementImageOrientationNumber convertedNum = [BFElementImageOrientation convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementImageOrientation: (BFElementImageOrientationNumber)num {
    NSString *strOc = [BFElementImageOrientation convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ImageOrientation::Number numCpp = bf::element::ImageOrientation::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementImageOrientation: (bf::element::ImageOrientation::Number)num {
    std::string strCpp = std::string(bf::element::ImageOrientation::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementImageOrientationNumber numOc = [BFElementImageOrientation convertToNumber:strOc];
    bf::element::ImageOrientation::Number numCpp = (bf::element::ImageOrientation::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementImageOrientation {
    NSString *str;
    BFElementImageOrientationNumber num;
    str = [BFElementImageOrientation convertToString:BFElementImageOrientationNumber(-1)];
    XCTAssertEqualObjects(str, BFElementImageOrientationString__Null);
    str = [BFElementImageOrientation convertToString:BFElementImageOrientationNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementImageOrientationString__Null);
    num = [BFElementImageOrientation convertToNumber:@""];
    XCTAssertEqual(num, BFElementImageOrientationNumber__Null);
    num = [BFElementImageOrientation convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementImageOrientationNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementImageOrientation
{
    [self convertCheckingBFElementImageOrientation:BFElementImageOrientationNumberPortrait];
    [self convertCheckingOcToCppBFElementImageOrientation:BFElementImageOrientationNumberPortrait];
    [self convertCheckingCppToOcBFElementImageOrientation:bf::element::ImageOrientation::Number::Portrait];
    [self convertCheckingBFElementImageOrientation:BFElementImageOrientationNumberLandscape];
    [self convertCheckingOcToCppBFElementImageOrientation:BFElementImageOrientationNumberLandscape];
    [self convertCheckingCppToOcBFElementImageOrientation:bf::element::ImageOrientation::Number::Landscape];
    [self convertCheckingBFElementImageOrientation:BFElementImageOrientationNumber__Null];
    [self convertCheckingOcToCppBFElementImageOrientation:BFElementImageOrientationNumber__Null];
    [self convertCheckingCppToOcBFElementImageOrientation:bf::element::ImageOrientation::Number::__Null];
    [self irregularCheckingBFElementImageOrientation];
    NSData* strAsData = [BFElementImageOrientation.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ImageOrientation::key == ocKey);
}


@end