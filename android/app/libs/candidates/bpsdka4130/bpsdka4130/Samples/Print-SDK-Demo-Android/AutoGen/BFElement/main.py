import os
exeDir = (os.path.dirname(os.path.abspath(__file__))) + "/"
import sys
sys.path.append(exeDir + "src")
import create_definition

print("Start BFElement with Jinja2")


elementDirName = "element/"
elementSetDirName = "element_set/"

outputdir = exeDir + 'output/'
databasedir = exeDir + "src/database/"

def objectiveCNamingRule(outputPrefix, sectionName, templateName, outputExt):
    return outputPrefix + create_definition.camelCase(sectionName.title()) + create_definition.camelCase(templateName.title()) + outputExt

def makeElementSource(databaseDirPath, templateDirPath, outputDirPath, outputExt, elementPrefix, elementSetPrefix, outputFileNamingRule = create_definition.defaultNamingRule):
    create_definition.makeElementAndElementSetSource(databaseDirPath + elementDirName, databaseDirPath + elementSetDirName, elementPrefix, elementSetPrefix, templateDirPath, outputDirPath, outputExt, outputFileNamingRule)

makeElementSource(databasedir,
                     exeDir + "src/template/cpp/",
                      outputdir+"cpp/", ".cpp", "bf_element_", "bf_element_set_")

makeElementSource(databasedir,
                     exeDir + "src/template/hpp/",
                      outputdir+"cpp/", ".hpp", "bf_element_", "bf_element_set_")

makeElementSource(databasedir,
                     exeDir + "src/template/och/",
                      outputdir+"oc/", ".h", "BFElement", "BFElementSet", objectiveCNamingRule)

makeElementSource(databasedir,
                     exeDir + "src/template/ocm/",
                      outputdir+"oc/", ".m", "BFElement", "BFElementSet", objectiveCNamingRule)
                      
makeElementSource(databasedir,
                     exeDir + "src/template/java/",
                      outputdir+"java/", ".java", "BFElement", "BFElementSet", objectiveCNamingRule)

create_definition.checkElementSetKeyValiable(databasedir + elementDirName, databasedir + elementSetDirName)

create_definition.makeElementSetSource(databasedir+elementSetDirName, databasedir+elementDirName, exeDir + "src/template/test/BSIPrintSettings_tmp.h", outputdir + "test/BSIPrintSettings.h")
create_definition.makeElementSetSource(databasedir+elementSetDirName,
                                       databasedir+elementDirName,
                                       exeDir + "src/template/UnitTest_set_mm/BFElementSetPrintSettingsTest.jinja",
                                       outputdir + "UnitTest_mm/BFElementSetPrintSettingsTest.mm")

makeElementSource(databasedir,
                     exeDir + "src/template/UnitTest_mm/",
                      outputdir+"UnitTest_mm/", ".mm", "BFElement", "BFElementSet", objectiveCNamingRule)
