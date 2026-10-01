
#import <XCTest/XCTest.h>
#include <string>

#include "bf_element_set_print_settings_definition.hpp"
#import "BFElementSetPrintSettingsDefinition.h"
#include "bf_element_set_model_spec_legacy_definition.hpp"
#import "BFElementSetModelSpecLegacyDefinition.h"
#include "bf_element_image_definition.hpp"
#import "BFElementImageDefinition.h"
#include "bf_element_media_definition.hpp"
#import "BFElementMediaDefinition.h"
#include "bf_element_model_capability_definition.hpp"
#import "BFElementModelCapabilityDefinition.h"
#include "bf_element_model_definition.hpp"
#import "BFElementModelDefinition.h"
#include "bf_element_model_spec_legacy_definition.hpp"
#import "BFElementModelSpecLegacyDefinition.h"
#include "bf_element_print_definition.hpp"
#import "BFElementPrintDefinition.h"

#include "bsi_print_settings_structs.hpp"
#import "BSIPrintSettingsStructs.h"

@interface BFElementSetTest : XCTestCase

@end

@implementation BFElementSetTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testElementSetPrintSettingsKeyCheck {
    XCTAssert([BFElementMediaSize.key isEqualToString:BFElementSetPrintSettingsStringMediaSize], @"BFElementSetPrintSettingsStringMediaSize is mismach");
    XCTAssert(bf::element::MediaSize::key == bf::element_set::PrintSettings::String::MediaSize, @"bf::element_set::PrintSettings::String::MediaSize is mismach");
    XCTAssert([BFElementImageOrientation.key isEqualToString:BFElementSetPrintSettingsStringImageOrientation], @"BFElementSetPrintSettingsStringImageOrientation is mismach");
    XCTAssert(bf::element::ImageOrientation::key == bf::element_set::PrintSettings::String::ImageOrientation, @"bf::element_set::PrintSettings::String::ImageOrientation is mismach");
    XCTAssert([BFElementPrintScalingMode.key isEqualToString:BFElementSetPrintSettingsStringPrintScalingMode], @"BFElementSetPrintSettingsStringPrintScalingMode is mismach");
    XCTAssert(bf::element::PrintScalingMode::key == bf::element_set::PrintSettings::String::PrintScalingMode, @"bf::element_set::PrintSettings::String::PrintScalingMode is mismach");
    XCTAssert([BFElementImageHalftone.key isEqualToString:BFElementSetPrintSettingsStringImageHalftone], @"BFElementSetPrintSettingsStringImageHalftone is mismach");
    XCTAssert(bf::element::ImageHalftone::key == bf::element_set::PrintSettings::String::ImageHalftone, @"bf::element_set::PrintSettings::String::ImageHalftone is mismach");
    XCTAssert([BFElementImageBrightness.key isEqualToString:BFElementSetPrintSettingsStringImageBrightness], @"BFElementSetPrintSettingsStringImageBrightness is mismach");
    XCTAssert(bf::element::ImageBrightness::key == bf::element_set::PrintSettings::String::ImageBrightness, @"bf::element_set::PrintSettings::String::ImageBrightness is mismach");
    XCTAssert([BFElementImageContrast.key isEqualToString:BFElementSetPrintSettingsStringImageContrast], @"BFElementSetPrintSettingsStringImageContrast is mismach");
    XCTAssert(bf::element::ImageContrast::key == bf::element_set::PrintSettings::String::ImageContrast, @"bf::element_set::PrintSettings::String::ImageContrast is mismach");
    XCTAssert([BFElementImageRedEnhancement.key isEqualToString:BFElementSetPrintSettingsStringImageRedEnhancement], @"BFElementSetPrintSettingsStringImageRedEnhancement is mismach");
    XCTAssert(bf::element::ImageRedEnhancement::key == bf::element_set::PrintSettings::String::ImageRedEnhancement, @"bf::element_set::PrintSettings::String::ImageRedEnhancement is mismach");
    XCTAssert([BFElementImageGreenEnhancement.key isEqualToString:BFElementSetPrintSettingsStringImageGreenEnhancement], @"BFElementSetPrintSettingsStringImageGreenEnhancement is mismach");
    XCTAssert(bf::element::ImageGreenEnhancement::key == bf::element_set::PrintSettings::String::ImageGreenEnhancement, @"bf::element_set::PrintSettings::String::ImageGreenEnhancement is mismach");
    XCTAssert([BFElementImageBlueEnhancement.key isEqualToString:BFElementSetPrintSettingsStringImageBlueEnhancement], @"BFElementSetPrintSettingsStringImageBlueEnhancement is mismach");
    XCTAssert(bf::element::ImageBlueEnhancement::key == bf::element_set::PrintSettings::String::ImageBlueEnhancement, @"bf::element_set::PrintSettings::String::ImageBlueEnhancement is mismach");
    XCTAssert([BFElementPrintHorizontalAlign.key isEqualToString:BFElementSetPrintSettingsStringPrintHorizontalAlign], @"BFElementSetPrintSettingsStringPrintHorizontalAlign is mismach");
    XCTAssert(bf::element::PrintHorizontalAlign::key == bf::element_set::PrintSettings::String::PrintHorizontalAlign, @"bf::element_set::PrintSettings::String::PrintHorizontalAlign is mismach");
    XCTAssert([BFElementPrintVerticalAlign.key isEqualToString:BFElementSetPrintSettingsStringPrintVerticalAlign], @"BFElementSetPrintSettingsStringPrintVerticalAlign is mismach");
    XCTAssert(bf::element::PrintVerticalAlign::key == bf::element_set::PrintSettings::String::PrintVerticalAlign, @"bf::element_set::PrintSettings::String::PrintVerticalAlign is mismach");
    XCTAssert([BFElementPrintTopMargin.key isEqualToString:BFElementSetPrintSettingsStringPrintTopMargin], @"BFElementSetPrintSettingsStringPrintTopMargin is mismach");
    XCTAssert(bf::element::PrintTopMargin::key == bf::element_set::PrintSettings::String::PrintTopMargin, @"bf::element_set::PrintSettings::String::PrintTopMargin is mismach");
    XCTAssert([BFElementPrintLeftMargin.key isEqualToString:BFElementSetPrintSettingsStringPrintLeftMargin], @"BFElementSetPrintSettingsStringPrintLeftMargin is mismach");
    XCTAssert(bf::element::PrintLeftMargin::key == bf::element_set::PrintSettings::String::PrintLeftMargin, @"bf::element_set::PrintSettings::String::PrintLeftMargin is mismach");
    XCTAssert([BFElementMediaTextColor.key isEqualToString:BFElementSetPrintSettingsStringMediaTextColor], @"BFElementSetPrintSettingsStringMediaTextColor is mismach");
    XCTAssert(bf::element::MediaTextColor::key == bf::element_set::PrintSettings::String::MediaTextColor, @"bf::element_set::PrintSettings::String::MediaTextColor is mismach");
    XCTAssert([BFElementMediaBackgroundColor.key isEqualToString:BFElementSetPrintSettingsStringMediaBackgroundColor], @"BFElementSetPrintSettingsStringMediaBackgroundColor is mismach");
    XCTAssert(bf::element::MediaBackgroundColor::key == bf::element_set::PrintSettings::String::MediaBackgroundColor, @"bf::element_set::PrintSettings::String::MediaBackgroundColor is mismach");
    XCTAssert([BFElementPrintScalingValue.key isEqualToString:BFElementSetPrintSettingsStringPrintScalingValue], @"BFElementSetPrintSettingsStringPrintScalingValue is mismach");
    XCTAssert(bf::element::PrintScalingValue::key == bf::element_set::PrintSettings::String::PrintScalingValue, @"bf::element_set::PrintSettings::String::PrintScalingValue is mismach");
    XCTAssert([BFElementPrintAutoCutLast.key isEqualToString:BFElementSetPrintSettingsStringPrintAutoCutLast], @"BFElementSetPrintSettingsStringPrintAutoCutLast is mismach");
    XCTAssert(bf::element::PrintAutoCutLast::key == bf::element_set::PrintSettings::String::PrintAutoCutLast, @"bf::element_set::PrintSettings::String::PrintAutoCutLast is mismach");
    XCTAssert([BFElementPrintAutoCutEvery.key isEqualToString:BFElementSetPrintSettingsStringPrintAutoCutEvery], @"BFElementSetPrintSettingsStringPrintAutoCutEvery is mismach");
    XCTAssert(bf::element::PrintAutoCutEvery::key == bf::element_set::PrintSettings::String::PrintAutoCutEvery, @"bf::element_set::PrintSettings::String::PrintAutoCutEvery is mismach");
    XCTAssert([BFElementPrintAutoCutEveryCyclePerPage.key isEqualToString:BFElementSetPrintSettingsStringPrintAutoCutEveryCyclePerPage], @"BFElementSetPrintSettingsStringPrintAutoCutEveryCyclePerPage is mismach");
    XCTAssert(bf::element::PrintAutoCutEveryCyclePerPage::key == bf::element_set::PrintSettings::String::PrintAutoCutEveryCyclePerPage, @"bf::element_set::PrintSettings::String::PrintAutoCutEveryCyclePerPage is mismach");
    XCTAssert([BFElementPrintAutoCutDisableForSpecialTape.key isEqualToString:BFElementSetPrintSettingsStringPrintAutoCutDisableForSpecialTape], @"BFElementSetPrintSettingsStringPrintAutoCutDisableForSpecialTape is mismach");
    XCTAssert(bf::element::PrintAutoCutDisableForSpecialTape::key == bf::element_set::PrintSettings::String::PrintAutoCutDisableForSpecialTape, @"bf::element_set::PrintSettings::String::PrintAutoCutDisableForSpecialTape is mismach");
    XCTAssert([BFElementPrintAutoHalfCut.key isEqualToString:BFElementSetPrintSettingsStringPrintAutoHalfCut], @"BFElementSetPrintSettingsStringPrintAutoHalfCut is mismach");
    XCTAssert(bf::element::PrintAutoHalfCut::key == bf::element_set::PrintSettings::String::PrintAutoHalfCut, @"bf::element_set::PrintSettings::String::PrintAutoHalfCut is mismach");
    XCTAssert([BFElementPrintDensity.key isEqualToString:BFElementSetPrintSettingsStringPrintDensity], @"BFElementSetPrintSettingsStringPrintDensity is mismach");
    XCTAssert(bf::element::PrintDensity::key == bf::element_set::PrintSettings::String::PrintDensity, @"bf::element_set::PrintSettings::String::PrintDensity is mismach");
    XCTAssert([BFElementPrintSpeed.key isEqualToString:BFElementSetPrintSettingsStringPrintSpeed], @"BFElementSetPrintSettingsStringPrintSpeed is mismach");
    XCTAssert(bf::element::PrintSpeed::key == bf::element_set::PrintSettings::String::PrintSpeed, @"bf::element_set::PrintSettings::String::PrintSpeed is mismach");
    XCTAssert([BFElementPrintDashLine.key isEqualToString:BFElementSetPrintSettingsStringPrintDashLine], @"BFElementSetPrintSettingsStringPrintDashLine is mismach");
    XCTAssert(bf::element::PrintDashLine::key == bf::element_set::PrintSettings::String::PrintDashLine, @"bf::element_set::PrintSettings::String::PrintDashLine is mismach");
    XCTAssert([BFElementPrintUsingCarbonCopyPaper.key isEqualToString:BFElementSetPrintSettingsStringPrintUsingCarbonCopyPaper], @"BFElementSetPrintSettingsStringPrintUsingCarbonCopyPaper is mismach");
    XCTAssert(bf::element::PrintUsingCarbonCopyPaper::key == bf::element_set::PrintSettings::String::PrintUsingCarbonCopyPaper, @"bf::element_set::PrintSettings::String::PrintUsingCarbonCopyPaper is mismach");
    XCTAssert([BFElementPrintFeedMode.key isEqualToString:BFElementSetPrintSettingsStringPrintFeedMode], @"BFElementSetPrintSettingsStringPrintFeedMode is mismach");
    XCTAssert(bf::element::PrintFeedMode::key == bf::element_set::PrintSettings::String::PrintFeedMode, @"bf::element_set::PrintSettings::String::PrintFeedMode is mismach");
    XCTAssert([BFElementPrintQuality.key isEqualToString:BFElementSetPrintSettingsStringPrintQuality], @"BFElementSetPrintSettingsStringPrintQuality is mismach");
    XCTAssert(bf::element::PrintQuality::key == bf::element_set::PrintSettings::String::PrintQuality, @"bf::element_set::PrintSettings::String::PrintQuality is mismach");
    XCTAssert([BFElementMediaPJRollCase.key isEqualToString:BFElementSetPrintSettingsStringMediaPJRollCase], @"BFElementSetPrintSettingsStringMediaPJRollCase is mismach");
    XCTAssert(bf::element::MediaPJRollCase::key == bf::element_set::PrintSettings::String::MediaPJRollCase, @"bf::element_set::PrintSettings::String::MediaPJRollCase is mismach");
    XCTAssert([BFElementMediaPaperInsertionPosition.key isEqualToString:BFElementSetPrintSettingsStringMediaPaperInsertionPosition], @"BFElementSetPrintSettingsStringMediaPaperInsertionPosition is mismach");
    XCTAssert(bf::element::MediaPaperInsertionPosition::key == bf::element_set::PrintSettings::String::MediaPaperInsertionPosition, @"bf::element_set::PrintSettings::String::MediaPaperInsertionPosition is mismach");
    XCTAssert([BFElementMediaPJPaperType.key isEqualToString:BFElementSetPrintSettingsStringMediaPJPaperType], @"BFElementSetPrintSettingsStringMediaPJPaperType is mismach");
    XCTAssert(bf::element::MediaPJPaperType::key == bf::element_set::PrintSettings::String::MediaPJPaperType, @"bf::element_set::PrintSettings::String::MediaPJPaperType is mismach");
    XCTAssert([BFElementMediaPJCustomSize.key isEqualToString:BFElementSetPrintSettingsStringMediaPJCustomSize], @"BFElementSetPrintSettingsStringMediaPJCustomSize is mismach");
    XCTAssert(bf::element::MediaPJCustomSize::key == bf::element_set::PrintSettings::String::MediaPJCustomSize, @"bf::element_set::PrintSettings::String::MediaPJCustomSize is mismach");
    XCTAssert([BFElementMediaPJForceStretchPrintableArea.key isEqualToString:BFElementSetPrintSettingsStringMediaPJForceStretchPrintableArea], @"BFElementSetPrintSettingsStringMediaPJForceStretchPrintableArea is mismach");
    XCTAssert(bf::element::MediaPJForceStretchPrintableArea::key == bf::element_set::PrintSettings::String::MediaPJForceStretchPrintableArea, @"bf::element_set::PrintSettings::String::MediaPJForceStretchPrintableArea is mismach");
    XCTAssert([BFElementPrintExtraFeedDots.key isEqualToString:BFElementSetPrintSettingsStringPrintExtraFeedDots], @"BFElementSetPrintSettingsStringPrintExtraFeedDots is mismach");
    XCTAssert(bf::element::PrintExtraFeedDots::key == bf::element_set::PrintSettings::String::PrintExtraFeedDots, @"bf::element_set::PrintSettings::String::PrintExtraFeedDots is mismach");
    XCTAssert([BFElementPrintCopies.key isEqualToString:BFElementSetPrintSettingsStringPrintCopies], @"BFElementSetPrintSettingsStringPrintCopies is mismach");
    XCTAssert(bf::element::PrintCopies::key == bf::element_set::PrintSettings::String::PrintCopies, @"bf::element_set::PrintSettings::String::PrintCopies is mismach");
    XCTAssert([BFElementPrintBidirectionalCommunication.key isEqualToString:BFElementSetPrintSettingsStringPrintBidirectionalCommunication], @"BFElementSetPrintSettingsStringPrintBidirectionalCommunication is mismach");
    XCTAssert(bf::element::PrintBidirectionalCommunication::key == bf::element_set::PrintSettings::String::PrintBidirectionalCommunication, @"bf::element_set::PrintSettings::String::PrintBidirectionalCommunication is mismach");
    XCTAssert([BFElementImageTrimBlankDataFromTail.key isEqualToString:BFElementSetPrintSettingsStringImageTrimBlankDataFromTail], @"BFElementSetPrintSettingsStringImageTrimBlankDataFromTail is mismach");
    XCTAssert(bf::element::ImageTrimBlankDataFromTail::key == bf::element_set::PrintSettings::String::ImageTrimBlankDataFromTail, @"bf::element_set::PrintSettings::String::ImageTrimBlankDataFromTail is mismach");
    XCTAssert([BFElementPrintPolicyOfProcessingPrintData.key isEqualToString:BFElementSetPrintSettingsStringPrintPolicyOfProcessingPrintData], @"BFElementSetPrintSettingsStringPrintPolicyOfProcessingPrintData is mismach");
    XCTAssert(bf::element::PrintPolicyOfProcessingPrintData::key == bf::element_set::PrintSettings::String::PrintPolicyOfProcessingPrintData, @"bf::element_set::PrintSettings::String::PrintPolicyOfProcessingPrintData is mismach");
    XCTAssert([BFElementPrintCollate.key isEqualToString:BFElementSetPrintSettingsStringPrintCollate], @"BFElementSetPrintSettingsStringPrintCollate is mismach");
    XCTAssert(bf::element::PrintCollate::key == bf::element_set::PrintSettings::String::PrintCollate, @"bf::element_set::PrintSettings::String::PrintCollate is mismach");
    XCTAssert([BFElementPrintCheckMediaTextColor.key isEqualToString:BFElementSetPrintSettingsStringPrintCheckMediaTextColor], @"BFElementSetPrintSettingsStringPrintCheckMediaTextColor is mismach");
    XCTAssert(bf::element::PrintCheckMediaTextColor::key == bf::element_set::PrintSettings::String::PrintCheckMediaTextColor, @"bf::element_set::PrintSettings::String::PrintCheckMediaTextColor is mismach");
    XCTAssert([BFElementPrintCheckMediaBackgroundColor.key isEqualToString:BFElementSetPrintSettingsStringPrintCheckMediaBackgroundColor], @"BFElementSetPrintSettingsStringPrintCheckMediaBackgroundColor is mismach");
    XCTAssert(bf::element::PrintCheckMediaBackgroundColor::key == bf::element_set::PrintSettings::String::PrintCheckMediaBackgroundColor, @"bf::element_set::PrintSettings::String::PrintCheckMediaBackgroundColor is mismach");
    XCTAssert([BFElementPrintCutPause.key isEqualToString:BFElementSetPrintSettingsStringPrintCutPause], @"BFElementSetPrintSettingsStringPrintCutPause is mismach");
    XCTAssert(bf::element::PrintCutPause::key == bf::element_set::PrintSettings::String::PrintCutPause, @"bf::element_set::PrintSettings::String::PrintCutPause is mismach");
}

- (void)testElementSetModelSpecLegacyKeyCheck {
    XCTAssert([BFElementModelMajor.key isEqualToString:BFElementSetModelSpecLegacyStringModelMajor], @"BFElementSetModelSpecLegacyStringModelMajor is mismach");
    XCTAssert(bf::element::ModelMajor::key == bf::element_set::ModelSpecLegacy::String::ModelMajor, @"bf::element_set::ModelSpecLegacy::String::ModelMajor is mismach");
    XCTAssert([BFElementModelInterface.key isEqualToString:BFElementSetModelSpecLegacyStringModelInterface], @"BFElementSetModelSpecLegacyStringModelInterface is mismach");
    XCTAssert(bf::element::ModelInterface::key == bf::element_set::ModelSpecLegacy::String::ModelInterface, @"bf::element_set::ModelSpecLegacy::String::ModelInterface is mismach");
    XCTAssert([BFElementModelSpecLegacyBatteryCommandType.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyBatteryCommandType], @"BFElementSetModelSpecLegacyStringModelSpecLegacyBatteryCommandType is mismach");
    XCTAssert(bf::element::ModelSpecLegacyBatteryCommandType::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyBatteryCommandType, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyBatteryCommandType is mismach");
    XCTAssert([BFElementModelSpecLegacyBitOrderOfBitmapIsLittle.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyBitOrderOfBitmapIsLittle], @"BFElementSetModelSpecLegacyStringModelSpecLegacyBitOrderOfBitmapIsLittle is mismach");
    XCTAssert(bf::element::ModelSpecLegacyBitOrderOfBitmapIsLittle::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyBitOrderOfBitmapIsLittle, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyBitOrderOfBitmapIsLittle is mismach");
    XCTAssert([BFElementModelSpecLegacyChangeStatusMode.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyChangeStatusMode], @"BFElementSetModelSpecLegacyStringModelSpecLegacyChangeStatusMode is mismach");
    XCTAssert(bf::element::ModelSpecLegacyChangeStatusMode::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyChangeStatusMode, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyChangeStatusMode is mismach");
    XCTAssert([BFElementModelSpecLegacyFirmUpdateShouldChangeCommandMode.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyFirmUpdateShouldChangeCommandMode], @"BFElementSetModelSpecLegacyStringModelSpecLegacyFirmUpdateShouldChangeCommandMode is mismach");
    XCTAssert(bf::element::ModelSpecLegacyFirmUpdateShouldChangeCommandMode::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyFirmUpdateShouldChangeCommandMode, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyFirmUpdateShouldChangeCommandMode is mismach");
    XCTAssert([BFElementModelSpecLegacyGraphicCommandType.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyGraphicCommandType], @"BFElementSetModelSpecLegacyStringModelSpecLegacyGraphicCommandType is mismach");
    XCTAssert(bf::element::ModelSpecLegacyGraphicCommandType::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyGraphicCommandType, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyGraphicCommandType is mismach");
    XCTAssert([BFElementModelSpecLegacyHeadPin.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyHeadPin], @"BFElementSetModelSpecLegacyStringModelSpecLegacyHeadPin is mismach");
    XCTAssert(bf::element::ModelSpecLegacyHeadPin::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyHeadPin, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyHeadPin is mismach");
    XCTAssert([BFElementModelSpecLegacyHeadPinWhenPrintTube.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyHeadPinWhenPrintTube], @"BFElementSetModelSpecLegacyStringModelSpecLegacyHeadPinWhenPrintTube is mismach");
    XCTAssert(bf::element::ModelSpecLegacyHeadPinWhenPrintTube::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyHeadPinWhenPrintTube, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyHeadPinWhenPrintTube is mismach");
    XCTAssert([BFElementModelSpecLegacyIgnorePaperEmptyWhenPrintEnd.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyIgnorePaperEmptyWhenPrintEnd], @"BFElementSetModelSpecLegacyStringModelSpecLegacyIgnorePaperEmptyWhenPrintEnd is mismach");
    XCTAssert(bf::element::ModelSpecLegacyIgnorePaperEmptyWhenPrintEnd::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyIgnorePaperEmptyWhenPrintEnd, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyIgnorePaperEmptyWhenPrintEnd is mismach");
    XCTAssert([BFElementModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty], @"BFElementSetModelSpecLegacyStringModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty is mismach");
    XCTAssert(bf::element::ModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyWaitForPaperInsertionWhenPaperEmpty is mismach");
    XCTAssert([BFElementModelSpecLegacyImageHalftoneShouldGammaAdjust.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyImageHalftoneShouldGammaAdjust], @"BFElementSetModelSpecLegacyStringModelSpecLegacyImageHalftoneShouldGammaAdjust is mismach");
    XCTAssert(bf::element::ModelSpecLegacyImageHalftoneShouldGammaAdjust::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyImageHalftoneShouldGammaAdjust, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyImageHalftoneShouldGammaAdjust is mismach");
    XCTAssert([BFElementModelSpecLegacyMainVersionCommandType.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyMainVersionCommandType], @"BFElementSetModelSpecLegacyStringModelSpecLegacyMainVersionCommandType is mismach");
    XCTAssert(bf::element::ModelSpecLegacyMainVersionCommandType::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyMainVersionCommandType, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyMainVersionCommandType is mismach");
    XCTAssert([BFElementModelSpecLegacyMediaSizeShouldCheck.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyMediaSizeShouldCheck], @"BFElementSetModelSpecLegacyStringModelSpecLegacyMediaSizeShouldCheck is mismach");
    XCTAssert(bf::element::ModelSpecLegacyMediaSizeShouldCheck::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyMediaSizeShouldCheck, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyMediaSizeShouldCheck is mismach");
    XCTAssert([BFElementModelSpecLegacyMinPrintMerginPerTenthMM.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyMinPrintMerginPerTenthMM], @"BFElementSetModelSpecLegacyStringModelSpecLegacyMinPrintMerginPerTenthMM is mismach");
    XCTAssert(bf::element::ModelSpecLegacyMinPrintMerginPerTenthMM::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyMinPrintMerginPerTenthMM, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyMinPrintMerginPerTenthMM is mismach");
    XCTAssert([BFElementModelSpecLegacyMinPrintPaperLengthPerTenthMM.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyMinPrintPaperLengthPerTenthMM], @"BFElementSetModelSpecLegacyStringModelSpecLegacyMinPrintPaperLengthPerTenthMM is mismach");
    XCTAssert(bf::element::ModelSpecLegacyMinPrintPaperLengthPerTenthMM::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyMinPrintPaperLengthPerTenthMM, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyMinPrintPaperLengthPerTenthMM is mismach");
    XCTAssert([BFElementModelSpecLegacyMode9CompressionMaxByteSize.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyMode9CompressionMaxByteSize], @"BFElementSetModelSpecLegacyStringModelSpecLegacyMode9CompressionMaxByteSize is mismach");
    XCTAssert(bf::element::ModelSpecLegacyMode9CompressionMaxByteSize::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyMode9CompressionMaxByteSize, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyMode9CompressionMaxByteSize is mismach");
    XCTAssert([BFElementModelSpecLegacyMode9ShouldFlipHorizontal.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyMode9ShouldFlipHorizontal], @"BFElementSetModelSpecLegacyStringModelSpecLegacyMode9ShouldFlipHorizontal is mismach");
    XCTAssert(bf::element::ModelSpecLegacyMode9ShouldFlipHorizontal::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyMode9ShouldFlipHorizontal, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyMode9ShouldFlipHorizontal is mismach");
    XCTAssert([BFElementModelSpecLegacyModelCode.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyModelCode], @"BFElementSetModelSpecLegacyStringModelSpecLegacyModelCode is mismach");
    XCTAssert(bf::element::ModelSpecLegacyModelCode::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyModelCode, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyModelCode is mismach");
    XCTAssert([BFElementModelSpecLegacyModelName.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyModelName], @"BFElementSetModelSpecLegacyStringModelSpecLegacyModelName is mismach");
    XCTAssert(bf::element::ModelSpecLegacyModelName::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyModelName, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyModelName is mismach");
    XCTAssert([BFElementModelSpecLegacyNullCommandLength.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyNullCommandLength], @"BFElementSetModelSpecLegacyStringModelSpecLegacyNullCommandLength is mismach");
    XCTAssert(bf::element::ModelSpecLegacyNullCommandLength::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyNullCommandLength, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyNullCommandLength is mismach");
    XCTAssert([BFElementModelSpecLegacyPageEndCommandType.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyPageEndCommandType], @"BFElementSetModelSpecLegacyStringModelSpecLegacyPageEndCommandType is mismach");
    XCTAssert(bf::element::ModelSpecLegacyPageEndCommandType::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPageEndCommandType, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPageEndCommandType is mismach");
    XCTAssert([BFElementModelSpecLegacyPaperListKind.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyPaperListKind], @"BFElementSetModelSpecLegacyStringModelSpecLegacyPaperListKind is mismach");
    XCTAssert(bf::element::ModelSpecLegacyPaperListKind::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPaperListKind, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPaperListKind is mismach");
    XCTAssert([BFElementModelSpecLegacyPrintCompressType.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyPrintCompressType], @"BFElementSetModelSpecLegacyStringModelSpecLegacyPrintCompressType is mismach");
    XCTAssert(bf::element::ModelSpecLegacyPrintCompressType::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPrintCompressType, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPrintCompressType is mismach");
    XCTAssert([BFElementModelSpecLegacyPrinterSettingCategoryBluetooth.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyPrinterSettingCategoryBluetooth], @"BFElementSetModelSpecLegacyStringModelSpecLegacyPrinterSettingCategoryBluetooth is mismach");
    XCTAssert(bf::element::ModelSpecLegacyPrinterSettingCategoryBluetooth::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPrinterSettingCategoryBluetooth, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPrinterSettingCategoryBluetooth is mismach");
    XCTAssert([BFElementModelSpecLegacyPrinterSettingCategoryNetwork.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyPrinterSettingCategoryNetwork], @"BFElementSetModelSpecLegacyStringModelSpecLegacyPrinterSettingCategoryNetwork is mismach");
    XCTAssert(bf::element::ModelSpecLegacyPrinterSettingCategoryNetwork::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPrinterSettingCategoryNetwork, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPrinterSettingCategoryNetwork is mismach");
    XCTAssert([BFElementModelSpecLegacyPrinterSettingCategoryPower.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyPrinterSettingCategoryPower], @"BFElementSetModelSpecLegacyStringModelSpecLegacyPrinterSettingCategoryPower is mismach");
    XCTAssert(bf::element::ModelSpecLegacyPrinterSettingCategoryPower::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPrinterSettingCategoryPower, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPrinterSettingCategoryPower is mismach");
    XCTAssert([BFElementModelSpecLegacyPrinterSettingCategoryPrint.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyPrinterSettingCategoryPrint], @"BFElementSetModelSpecLegacyStringModelSpecLegacyPrinterSettingCategoryPrint is mismach");
    XCTAssert(bf::element::ModelSpecLegacyPrinterSettingCategoryPrint::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPrinterSettingCategoryPrint, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPrinterSettingCategoryPrint is mismach");
    XCTAssert([BFElementModelSpecLegacyPrintPageCommandType.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyPrintPageCommandType], @"BFElementSetModelSpecLegacyStringModelSpecLegacyPrintPageCommandType is mismach");
    XCTAssert(bf::element::ModelSpecLegacyPrintPageCommandType::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPrintPageCommandType, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPrintPageCommandType is mismach");
    XCTAssert([BFElementModelSpecLegacyPrintShouldDensityCommand.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyPrintShouldDensityCommand], @"BFElementSetModelSpecLegacyStringModelSpecLegacyPrintShouldDensityCommand is mismach");
    XCTAssert(bf::element::ModelSpecLegacyPrintShouldDensityCommand::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPrintShouldDensityCommand, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPrintShouldDensityCommand is mismach");
    XCTAssert([BFElementModelSpecLegacyPrintShouldPrinterInfoCommand.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyPrintShouldPrinterInfoCommand], @"BFElementSetModelSpecLegacyStringModelSpecLegacyPrintShouldPrinterInfoCommand is mismach");
    XCTAssert(bf::element::ModelSpecLegacyPrintShouldPrinterInfoCommand::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPrintShouldPrinterInfoCommand, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPrintShouldPrinterInfoCommand is mismach");
    XCTAssert([BFElementModelSpecLegacyPrintShouldSpaceCommand.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyPrintShouldSpaceCommand], @"BFElementSetModelSpecLegacyStringModelSpecLegacyPrintShouldSpaceCommand is mismach");
    XCTAssert(bf::element::ModelSpecLegacyPrintShouldSpaceCommand::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPrintShouldSpaceCommand, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyPrintShouldSpaceCommand is mismach");
    XCTAssert([BFElementModelSpecLegacySeriesCode.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacySeriesCode], @"BFElementSetModelSpecLegacyStringModelSpecLegacySeriesCode is mismach");
    XCTAssert(bf::element::ModelSpecLegacySeriesCode::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySeriesCode, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySeriesCode is mismach");
    XCTAssert([BFElementModelSpecLegacyStatusIndexOfPaperBackgroundColor.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyStatusIndexOfPaperBackgroundColor], @"BFElementSetModelSpecLegacyStringModelSpecLegacyStatusIndexOfPaperBackgroundColor is mismach");
    XCTAssert(bf::element::ModelSpecLegacyStatusIndexOfPaperBackgroundColor::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyStatusIndexOfPaperBackgroundColor, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyStatusIndexOfPaperBackgroundColor is mismach");
    XCTAssert([BFElementModelSpecLegacyStatusIndexOfPaperTextColor.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyStatusIndexOfPaperTextColor], @"BFElementSetModelSpecLegacyStringModelSpecLegacyStatusIndexOfPaperTextColor is mismach");
    XCTAssert(bf::element::ModelSpecLegacyStatusIndexOfPaperTextColor::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyStatusIndexOfPaperTextColor, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyStatusIndexOfPaperTextColor is mismach");
    XCTAssert([BFElementModelSpecLegacyStatusIndexOfTubeRibbon.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyStatusIndexOfTubeRibbon], @"BFElementSetModelSpecLegacyStringModelSpecLegacyStatusIndexOfTubeRibbon is mismach");
    XCTAssert(bf::element::ModelSpecLegacyStatusIndexOfTubeRibbon::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyStatusIndexOfTubeRibbon, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyStatusIndexOfTubeRibbon is mismach");
    XCTAssert([BFElementModelSpecLegacySupportAdjustPaperPosition.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacySupportAdjustPaperPosition], @"BFElementSetModelSpecLegacyStringModelSpecLegacySupportAdjustPaperPosition is mismach");
    XCTAssert(bf::element::ModelSpecLegacySupportAdjustPaperPosition::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportAdjustPaperPosition, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportAdjustPaperPosition is mismach");
    XCTAssert([BFElementModelSpecLegacySupportAdvanceModeCommand.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacySupportAdvanceModeCommand], @"BFElementSetModelSpecLegacyStringModelSpecLegacySupportAdvanceModeCommand is mismach");
    XCTAssert(bf::element::ModelSpecLegacySupportAdvanceModeCommand::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportAdvanceModeCommand, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportAdvanceModeCommand is mismach");
    XCTAssert([BFElementModelSpecLegacySupportChangeDpi.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacySupportChangeDpi], @"BFElementSetModelSpecLegacyStringModelSpecLegacySupportChangeDpi is mismach");
    XCTAssert(bf::element::ModelSpecLegacySupportChangeDpi::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportChangeDpi, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportChangeDpi is mismach");
    XCTAssert([BFElementModelSpecLegacySupportCommandProtocolVersion.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacySupportCommandProtocolVersion], @"BFElementSetModelSpecLegacyStringModelSpecLegacySupportCommandProtocolVersion is mismach");
    XCTAssert(bf::element::ModelSpecLegacySupportCommandProtocolVersion::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportCommandProtocolVersion, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportCommandProtocolVersion is mismach");
    XCTAssert([BFElementModelSpecLegacySupportFunc.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacySupportFunc], @"BFElementSetModelSpecLegacyStringModelSpecLegacySupportFunc is mismach");
    XCTAssert(bf::element::ModelSpecLegacySupportFunc::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportFunc, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportFunc is mismach");
    XCTAssert([BFElementModelSpecLegacySupportGetBatteryWeak.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacySupportGetBatteryWeak], @"BFElementSetModelSpecLegacyStringModelSpecLegacySupportGetBatteryWeak is mismach");
    XCTAssert(bf::element::ModelSpecLegacySupportGetBatteryWeak::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportGetBatteryWeak, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportGetBatteryWeak is mismach");
    XCTAssert([BFElementModelSpecLegacySupportGetMediaInfoVersion.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacySupportGetMediaInfoVersion], @"BFElementSetModelSpecLegacyStringModelSpecLegacySupportGetMediaInfoVersion is mismach");
    XCTAssert(bf::element::ModelSpecLegacySupportGetMediaInfoVersion::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportGetMediaInfoVersion, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportGetMediaInfoVersion is mismach");
    XCTAssert([BFElementModelSpecLegacySupportGetSerialNumber.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacySupportGetSerialNumber], @"BFElementSetModelSpecLegacyStringModelSpecLegacySupportGetSerialNumber is mismach");
    XCTAssert(bf::element::ModelSpecLegacySupportGetSerialNumber::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportGetSerialNumber, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportGetSerialNumber is mismach");
    XCTAssert([BFElementModelSpecLegacySupportMode9Compression.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacySupportMode9Compression], @"BFElementSetModelSpecLegacyStringModelSpecLegacySupportMode9Compression is mismach");
    XCTAssert(bf::element::ModelSpecLegacySupportMode9Compression::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportMode9Compression, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportMode9Compression is mismach");
    XCTAssert([BFElementModelSpecLegacySupportMultiColorLabel.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacySupportMultiColorLabel], @"BFElementSetModelSpecLegacyStringModelSpecLegacySupportMultiColorLabel is mismach");
    XCTAssert(bf::element::ModelSpecLegacySupportMultiColorLabel::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportMultiColorLabel, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportMultiColorLabel is mismach");
    XCTAssert([BFElementModelSpecLegacySupportPJFeedMode.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacySupportPJFeedMode], @"BFElementSetModelSpecLegacyStringModelSpecLegacySupportPJFeedMode is mismach");
    XCTAssert(bf::element::ModelSpecLegacySupportPJFeedMode::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportPJFeedMode, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportPJFeedMode is mismach");
    XCTAssert([BFElementModelSpecLegacySupportPJRollCase.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacySupportPJRollCase], @"BFElementSetModelSpecLegacyStringModelSpecLegacySupportPJRollCase is mismach");
    XCTAssert(bf::element::ModelSpecLegacySupportPJRollCase::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportPJRollCase, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportPJRollCase is mismach");
    XCTAssert([BFElementModelSpecLegacySupportPJSpeedCommand.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacySupportPJSpeedCommand], @"BFElementSetModelSpecLegacyStringModelSpecLegacySupportPJSpeedCommand is mismach");
    XCTAssert(bf::element::ModelSpecLegacySupportPJSpeedCommand::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportPJSpeedCommand, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportPJSpeedCommand is mismach");
    XCTAssert([BFElementModelSpecLegacySupportTube.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacySupportTube], @"BFElementSetModelSpecLegacyStringModelSpecLegacySupportTube is mismach");
    XCTAssert(bf::element::ModelSpecLegacySupportTube::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportTube, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportTube is mismach");
    XCTAssert([BFElementModelSpecLegacySupportVariousModeCommand.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacySupportVariousModeCommand], @"BFElementSetModelSpecLegacyStringModelSpecLegacySupportVariousModeCommand is mismach");
    XCTAssert(bf::element::ModelSpecLegacySupportVariousModeCommand::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportVariousModeCommand, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacySupportVariousModeCommand is mismach");
    XCTAssert([BFElementModelSpecLegacyTemplateLimited.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyTemplateLimited], @"BFElementSetModelSpecLegacyStringModelSpecLegacyTemplateLimited is mismach");
    XCTAssert(bf::element::ModelSpecLegacyTemplateLimited::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyTemplateLimited, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyTemplateLimited is mismach");
    XCTAssert([BFElementModelSpecLegacyTemplateLimitedFirmName.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyTemplateLimitedFirmName], @"BFElementSetModelSpecLegacyStringModelSpecLegacyTemplateLimitedFirmName is mismach");
    XCTAssert(bf::element::ModelSpecLegacyTemplateLimitedFirmName::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyTemplateLimitedFirmName, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyTemplateLimitedFirmName is mismach");
    XCTAssert([BFElementModelSpecLegacyTemplateLimitedFirmType.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyTemplateLimitedFirmType], @"BFElementSetModelSpecLegacyStringModelSpecLegacyTemplateLimitedFirmType is mismach");
    XCTAssert(bf::element::ModelSpecLegacyTemplateLimitedFirmType::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyTemplateLimitedFirmType, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyTemplateLimitedFirmType is mismach");
    XCTAssert([BFElementModelSpecLegacyTemplateMaxObjectSize.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyTemplateMaxObjectSize], @"BFElementSetModelSpecLegacyStringModelSpecLegacyTemplateMaxObjectSize is mismach");
    XCTAssert(bf::element::ModelSpecLegacyTemplateMaxObjectSize::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyTemplateMaxObjectSize, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyTemplateMaxObjectSize is mismach");
    XCTAssert([BFElementModelSpecLegacyTemplateShouldChangeCommandMode.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyTemplateShouldChangeCommandMode], @"BFElementSetModelSpecLegacyStringModelSpecLegacyTemplateShouldChangeCommandMode is mismach");
    XCTAssert(bf::element::ModelSpecLegacyTemplateShouldChangeCommandMode::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyTemplateShouldChangeCommandMode, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyTemplateShouldChangeCommandMode is mismach");
    XCTAssert([BFElementModelSpecLegacyUSBDeviceProductID.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyUSBDeviceProductID], @"BFElementSetModelSpecLegacyStringModelSpecLegacyUSBDeviceProductID is mismach");
    XCTAssert(bf::element::ModelSpecLegacyUSBDeviceProductID::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyUSBDeviceProductID, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyUSBDeviceProductID is mismach");
    XCTAssert([BFElementModelSpecLegacyValidCommunicationBidirectional.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyValidCommunicationBidirectional], @"BFElementSetModelSpecLegacyStringModelSpecLegacyValidCommunicationBidirectional is mismach");
    XCTAssert(bf::element::ModelSpecLegacyValidCommunicationBidirectional::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyValidCommunicationBidirectional, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyValidCommunicationBidirectional is mismach");
    XCTAssert([BFElementModelSpecLegacyValidResponseAfterFirmUpdate.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyValidResponseAfterFirmUpdate], @"BFElementSetModelSpecLegacyStringModelSpecLegacyValidResponseAfterFirmUpdate is mismach");
    XCTAssert(bf::element::ModelSpecLegacyValidResponseAfterFirmUpdate::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyValidResponseAfterFirmUpdate, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyValidResponseAfterFirmUpdate is mismach");
    XCTAssert([BFElementModelSpecLegacyXdpi.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyXdpi], @"BFElementSetModelSpecLegacyStringModelSpecLegacyXdpi is mismach");
    XCTAssert(bf::element::ModelSpecLegacyXdpi::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyXdpi, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyXdpi is mismach");
    XCTAssert([BFElementModelSpecLegacyYdpi.key isEqualToString:BFElementSetModelSpecLegacyStringModelSpecLegacyYdpi], @"BFElementSetModelSpecLegacyStringModelSpecLegacyYdpi is mismach");
    XCTAssert(bf::element::ModelSpecLegacyYdpi::key == bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyYdpi, @"bf::element_set::ModelSpecLegacy::String::ModelSpecLegacyYdpi is mismach");
}

@end