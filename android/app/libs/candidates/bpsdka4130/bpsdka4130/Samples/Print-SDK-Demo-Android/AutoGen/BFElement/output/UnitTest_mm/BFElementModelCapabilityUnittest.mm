

#import <XCTest/XCTest.h>
#include <string>
#include "bf_element_model_capability_definition.hpp"
#import "BFElementModelCapabilityDefinition.h"

@interface BFElementModelCapabilityTest : XCTestCase

@end

@implementation BFElementModelCapabilityTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) convertCheckingBFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse: (BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalseNumber)num {
    NSString *str = [BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse convertToString:num];
    BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalseNumber convertedNum = [BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse convertToNumber:str];
    XCTAssertEqual(num, convertedNum);
}
- (void) convertCheckingOcToCppBFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse: (BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalseNumber)num {
    NSString *strOc = [BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse convertToString:num];
    NSData* strAsData = [strOc dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string strCpp = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    bf::element::ModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse::Number numCpp = bf::element::ModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse::convertToNumber(strCpp.c_str());
    NSInteger numOc = (NSInteger)numCpp;
    XCTAssertEqual(num, numOc);
}
- (void) convertCheckingCppToOcBFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse: (bf::element::ModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse::Number)num {
    std::string strCpp = std::string(bf::element::ModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse::convertToString(num));
    NSString *strOc = [[NSString alloc] initWithBytes:(char*)strCpp.data() length:(strCpp.size() * sizeof(char)) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalseNumber numOc = [BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse convertToNumber:strOc];
    bf::element::ModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse::Number numCpp = (bf::element::ModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse::Number)numOc;
    XCTAssertEqual(num, numCpp);
}
- (void) irregularCheckingBFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse {
    NSString *str;
    BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalseNumber num;
    str = [BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse convertToString:BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalseNumber(-1)];
    XCTAssertEqualObjects(str, BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalseString__Null);
    str = [BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse convertToString:BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalseNumber(1000000)];
    XCTAssertEqualObjects(str, BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalseString__Null);
    num = [BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse convertToNumber:@""];
    XCTAssertEqual(num, BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalseNumber__Null);
    num = [BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse convertToNumber:@"hogehogehogehogehoge"];
    XCTAssertEqual(num, BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalseNumber__Null);
}
- (void)testPrintSettingDefinitionCheckBFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse
{
    [self convertCheckingBFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse:BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalseNumberPrioritizeAutoCutEveryTrue];
    [self convertCheckingOcToCppBFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse:BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalseNumberPrioritizeAutoCutEveryTrue];
    [self convertCheckingCppToOcBFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse:bf::element::ModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse::Number::PrioritizeAutoCutEveryTrue];
    [self convertCheckingBFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse:BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalseNumberPrioritizeAutoCutLastFalse];
    [self convertCheckingOcToCppBFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse:BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalseNumberPrioritizeAutoCutLastFalse];
    [self convertCheckingCppToOcBFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse:bf::element::ModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse::Number::PrioritizeAutoCutLastFalse];
    [self convertCheckingBFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse:BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalseNumber__Null];
    [self convertCheckingOcToCppBFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse:BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalseNumber__Null];
    [self convertCheckingCppToOcBFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse:bf::element::ModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse::Number::__Null];
    [self irregularCheckingBFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse];
    NSData* strAsData = [BFElementModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse.key dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    std::string ocKey = std::string((char*)[strAsData bytes], [strAsData length] / sizeof(char));
    XCTAssertTrue(bf::element::ModelCapabilityAutoCutSettingPriorityWhenEveryTrueLastFalse::key == ocKey);
}


@end