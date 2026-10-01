import os
import shutil
import filecmp
import datetime
import logging
import re
from stat import (S_IRUSR , S_IRGRP , S_IROTH , S_IWUSR)
rootDir = (os.path.dirname(os.path.abspath(__file__))) + "/"
bfElementDir = rootDir + "BFElement/"
import sys
sys.path.append(bfElementDir + "src")
import create_definition
print("Start preprocessTemplate with Jinja2")
elementDirName = "element/"
elementSetDirName = "element_set/"
databaseDir = rootDir + "brlmprinterkit-printsettings-materials/"
elementDir = databaseDir + elementDirName
elementSetDir = databaseDir + elementSetDirName

# ---------- custom
def withoutPrefix(name):
    return re.sub(r'^BRLM(PJ|RJ|QL|PT|MW|TD|)(PrintSettings|)', '', name)
def withoutSurfix(name):
    return re.sub(r'(PJ|RJ|QL|PT|MW|TD)$', '', name)
def headLowerForKT(name):
    A5match = re.match(r'^[A-Z0-9]+$',name) # A5など
    if A5match:
        return name
    else:
        def changeLowerExEnd(match):
            return match.group(1)[:-1].lower() + match.group(1)[-1]
        result = re.sub(r'(^[A-Z0-9]{2,})', changeLowerExEnd, name)
        return create_definition.headLower(result)
def removeDuplicates(list_value):
    return sorted(set(list_value))
def setCustomFunction(jinja):
    jinja.globals.update(withoutPrefix=withoutPrefix)
    jinja.globals.update(withoutSurfix=withoutSurfix)
    jinja.globals.update(headLowerForKT=headLowerForKT)
    jinja.globals.update(removeDuplicates=removeDuplicates)
create_definition.JinjaEnvDelegate = lambda jinja:setCustomFunction(jinja)
def customizeElement(allElement, allElementSets):
    allElementSets["GeneralPrintSettings"].keys.append("BRLMPrintSettingsWorkPath")
    allElementSets["BRLMPrintImageSettings"].keys.append("BRLMPrintSettingsWorkPath")
create_definition.JinjaElementCustomizeDelegate = lambda allElement, allElementSets:customizeElement(allElement, allElementSets)
# ----------

def processGen(templatePath, outputPath):
    os.chmod(outputPath, S_IRUSR | S_IRGRP | S_IROTH | S_IWUSR )
    outputPathSplit = os.path.split(outputPath)
    backupDir = outputPathSplit[0] + "/BACKUP"
    backupFile = backupDir + "/" + datetime.datetime.now().strftime("%Y%m%d%H%M%S_") + outputPathSplit[1]
    os.makedirs(backupDir, exist_ok=True)
    shutil.copyfile(outputPath, backupFile)
    create_definition.makeElementSetSource(elementSetDir,
                                           elementDir,
                                           templatePath,
                                           outputPath)
    if filecmp.cmp(outputPath, backupFile, shallow=False):
        os.remove(backupFile)
    os.chmod(outputPath, S_IRUSR | S_IRGRP | S_IROTH)

           
processGen(rootDir + "template/SimplePrintSettings.template.kt",
           rootDir + "../app/src/main/java/com/brother/ptouch/sdk/printdemo/model/printsettings/SimplePrintSettings.kt")
processGen(rootDir + "template/MWModelPrintSettings.template.kt",
           rootDir + "../app/src/main/java/com/brother/ptouch/sdk/printdemo/model/printsettings/MWModelPrintSettings.kt")
processGen(rootDir + "template/PJModelPrintSettings.template.kt",
           rootDir + "../app/src/main/java/com/brother/ptouch/sdk/printdemo/model/printsettings/PJModelPrintSettings.kt")
processGen(rootDir + "template/PTModelPrintSettings.template.kt",
           rootDir + "../app/src/main/java/com/brother/ptouch/sdk/printdemo/model/printsettings/PTModelPrintSettings.kt")
processGen(rootDir + "template/QLModelPrintSettings.template.kt",
           rootDir + "../app/src/main/java/com/brother/ptouch/sdk/printdemo/model/printsettings/QLModelPrintSettings.kt")
processGen(rootDir + "template/RJModelPrintSettings.template.kt",
           rootDir + "../app/src/main/java/com/brother/ptouch/sdk/printdemo/model/printsettings/RJModelPrintSettings.kt")
processGen(rootDir + "template/TDModelPrintSettings.template.kt",
           rootDir + "../app/src/main/java/com/brother/ptouch/sdk/printdemo/model/printsettings/TDModelPrintSettings.kt")



