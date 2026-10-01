from enum import Enum, auto
from copy import deepcopy
import configparser
import os
import re
import jinja2

stringClass = "String"
enumClass = "Number"
nullName = "__Null"

mainNameSpace = "bf"
subNameSpaceElement = "element"
subNameSpaceElementSet = "element_set"

JinjaEnvDelegate = lambda jinja: 0
JinjaElementCustomizeDelegate = lambda allElement, allElementSets: 0
JinjaEnvInitialValue = {}

class Type(Enum):
    enum = auto()
    int = auto()
    float = auto()
    bool = auto()
    string = auto()
    object = auto()
    struct = auto()
    uint8 = auto()
    array = auto()
    array_of_string = auto()
    dict_of_array = auto()


class Element:
    def __init__(self,key,type):
        self.key = key
        self.type = type
        self.values = []
        self.valuesNonnull = []
        self.nullname = nullName
        self.exif = None

# use in ElementSet
# {element.key, element.value[]}
#
class ArrayOfElement:
    template = "^(.*)\\[\\]$"
    def __init__(self, element):
        self.key = element.key
        self.element = element
        self.type = Type.array
        self.exif = element.exif

# use in ElementSet
# {key_element.key, {extra_key_element, key_element.value[]} }
class DictionaryOfArrayOfElement:
    template = "^(.*){(.*)}\\[\\]$"
    def __init__(self, key_element, extra_key_element):
        self.key = key_element.key
        self.key_element = key_element
        self.extra_key_element = extra_key_element
        self.type = Type.dict_of_array
        self.exif = key_element.exif

class ElementSet:
    def __init__(self,meta,keys):
        self.meta = meta
        self.keys = keys
        self.elements = []
        self.nullname = nullName

class Section:
    def __init__(self,name):
        self.elements = []
        self.name = name

def inSyntax(name):
    return re.sub("\\\\|\\ |\\-|\\.|\\/","_",name)

def snakeCase(name):
    return re.sub("^_","",re.sub("([A-Z])",lambda x:"_" + x.group(1).lower(),name))

def camelCase(name):
    return re.sub("_(.)",lambda x:x.group(1).upper(),name)

def headLower(name):
    return re.sub("^([A-Z])",lambda x:x.group(1).lower(),name)

def headUpper(name):
    return re.sub("^([a-z])",lambda x:x.group(1).upper(),name)

def readElementFile(path):
    inifile = configparser.ConfigParser()
    inifile.read(path)

    section = inifile.sections()[0]
    key = inifile.get(section, "key")
    type = Type[inifile.get(section, "type")]

    element = Element(key,type)

    element.exif = inifile[section].get("exif", None)
    element.exif2 = inifile[section].get("exif2", None)
    element.description = inifile[section].get("description", None)

    if element.type == Type.enum:
        values = inifile.get(section, "values").split()
        element.values = values
        element.valuesNonnull = deepcopy(values)
        element.values.append(element.nullname)

    return (section, element)

def readAllFilesInSection(dirpath, readFileFunc):

    allElements = {}

    if not os.path.exists(dirpath):
        print("readAllFiles: no directory")
        raise NameError('readAllFilesError')

    if os.path.isfile(dirpath):
        print('readAllFiles: not directory')
        raise NameError('readAllFilesError')

    for dirpath, dirnames, filenames in os.walk(dirpath):
        filenames.sort(key=lambda y: y.lower())
        for filename in filenames:
            root, ext = os.path.splitext(filename)
            if ext == ".ini":
                (sectionName, element) = readFileFunc(dirpath + filename)
                if not sectionName in allElements:
                    allElements[sectionName] = Section(sectionName)

                allElements[sectionName].elements.append(element)

    return allElements

def readAllElementFiles(dirpath):
    return readAllFilesInSection(dirpath, readElementFile)

def getAllJinjaTemplateFile(dirpath):
    allJinjaTemplate = {}

    if not os.path.exists(dirpath):
        print("readAllJinjaTemplateFile: no directory:" + dirpath)
        raise NameError('JinjaTemplateFileError')

    if os.path.isfile(dirpath):
        print('readAllJinjaTemplateFile: not directory:' + dirpath)
        raise NameError('JinjaTemplateFileError')

    for dirpath, dirnames, filenames in os.walk(dirpath):
        for filename in filenames:
            root, ext = os.path.splitext(filename)
            if ext == ".jinja":
                allJinjaTemplate[root] = dirpath + filename

    return allJinjaTemplate

def checkJinjaTemplateFile(path):
    if not os.path.exists(path):
        print("getJinjaTemplateFile: no file:" + path)
        raise NameError('JinjaTemplateFileError')

    if not os.path.isfile(path):
        print('getJinjaTemplateFile: not file:' + path)
        raise NameError('getJinjaTemplateFile')

    return path

# element_set

def readElementSetFileAsElement(path):
    inifile = configparser.ConfigParser()
    inifile.read(path)

    section = inifile.sections()[0]
    meta = inifile.get(section, "meta")

    elementSet = Element(meta, Type.enum)
    values = inifile.get(section, "keys").split()
    for value in values:
        result_dict_of_array = re.search(DictionaryOfArrayOfElement.template, value)
        if result_dict_of_array:
            elementSet.values.append(result_dict_of_array.group(1))
            continue
        result_array = re.search(ArrayOfElement.template, value)
        if result_array:
            elementSet.values.append(result_array.group(1))
            continue
        elementSet.values.append(value)
    elementSet.valuesNonnull = deepcopy(elementSet.values)
    elementSet.values.append(elementSet.nullname)

    return (section, elementSet)

def readAllElementSetFilesAsElement(dirpath):
    return readAllFilesInSection(dirpath, readElementSetFileAsElement)

def readElementSetFile(path):
    inifile = configparser.ConfigParser()
    inifile.read(path)

    section = inifile.sections()[0]
    meta = inifile.get(section, "meta")

    elementSet = ElementSet(meta, Type.enum)
    elementSet.keys = inifile.get(section, "keys").split()
    elementSet.keys.append(elementSet.nullname)

    return (section, elementSet)

def readAllElementSetFiles(dirpath):
    allElementSets = {}

    if not os.path.exists(dirpath):
        print("readAllFiles: no directory")
        raise NameError('readAllFilesError')

    if os.path.isfile(dirpath):
        print('readAllFiles: not directory')
        raise NameError('readAllFilesError')

    for dirpath, dirnames, filenames in os.walk(dirpath):
        for filename in filenames:
            root, ext = os.path.splitext(filename)
            if ext == ".ini":
                (sectionName, elementSet) = readElementSetFile(dirpath + filename)

                allElementSets[elementSet.meta] = elementSet;

    return allElementSets

def jinjaEnv():
    jinja = jinja2.Environment(loader=jinja2.FileSystemLoader('/.'), trim_blocks=True, lstrip_blocks=True)
    jinja.globals.update(inSyntax=inSyntax)
    jinja.globals.update(snakeCase=snakeCase)
    jinja.globals.update(camelCase=camelCase)
    jinja.globals.update(headLower=headLower)
    jinja.globals.update(headUpper=headUpper)
    jinja.globals.update(Type=Type)
    JinjaEnvDelegate(jinja)
    jinja.globals.update(JinjaEnvInitialValue)
    return jinja

# make
def defaultNamingRule(outputPrefix, sectionName, templateName, outputExt):
    # c++ style
    return outputPrefix + sectionName + "_" + templateName + outputExt

def makeSource(elementDirPath, templateDirPath, outputDirPath, outputPrefix, outputExt, readAllDataFilesFunc, subNamespace, outputFileNamingRule = defaultNamingRule):
    allElements = readAllDataFilesFunc(elementDirPath);
    allElementsTemplate = getAllJinjaTemplateFile(templateDirPath);
    JinjaElementCustomizeDelegate(allElements, allElementSet);
    jinja = jinjaEnv()
    for sectionName in allElements.keys():
        section = allElements[sectionName]
        for templateKey in allElementsTemplate.keys():
            template = jinja.get_template(allElementsTemplate[templateKey])
            output = template.render({"section":section,
                                      "outputPrefix":outputPrefix,
                                      "outputExt":outputExt,
                                      "templateName":templateKey,
                                      "mainNamespace":mainNameSpace,
                                      "subNamespace":subNamespace,
                                      "stringClass":stringClass,
                                      "enumClass":enumClass})
            filepath = outputDirPath + outputFileNamingRule(outputPrefix, sectionName, templateKey, outputExt)
            file = open(filepath, mode="w")
            file.write(output)
            file.close()

def elementSetContainElement(elementSet, allElementsDictionary):
    for elementKey in elementSet.keys:
        if elementKey == elementSet.nullname:
            continue
        result_dict_of_array = re.search(DictionaryOfArrayOfElement.template, elementKey)
        if result_dict_of_array:
            element_key = allElementsDictionary[result_dict_of_array.group(1)]
            element_extra_key = allElementsDictionary[result_dict_of_array.group(2)]
            dict_of_array_of_element = DictionaryOfArrayOfElement(element_key, element_extra_key)
            elementSet.elements.append(dict_of_array_of_element)
            continue
        result_array = re.search(ArrayOfElement.template, elementKey)
        if result_array:
            element = allElementsDictionary[result_array.group(1)]
            array_of_element = ArrayOfElement(element)
            elementSet.elements.append(array_of_element)
            continue
        elementSet.elements.append(allElementsDictionary[elementKey])

def makeElementAndElementSetSource(elementDirPath, elementSetDirPath, outputPrefixOfElement, outputPrefixOfElementSet, templateDirPath, outputDirPath, outputExt, outputFileNamingRule = defaultNamingRule):
    makeSource(elementDirPath, templateDirPath, outputDirPath, outputPrefixOfElement, outputExt, readAllElementFiles, subNameSpaceElement, outputFileNamingRule)
    makeSource(elementSetDirPath, templateDirPath, outputDirPath, outputPrefixOfElementSet, outputExt, readAllElementSetFilesAsElement, subNameSpaceElementSet, outputFileNamingRule)

def makeElementSetSource(elementSetDirPath, elementDirPath, templatePath, outputPath):
    allElements = readAllElementFiles(elementDirPath);
    allElementSets = readAllElementSetFiles(elementSetDirPath);
    JinjaElementCustomizeDelegate(allElements, allElementSets);
    checkedTemplatePath = checkJinjaTemplateFile(templatePath);
    allElementsDictionary = {}
    for sectionName in allElements.keys():
        section = allElements[sectionName]
        for element in section.elements:
            allElementsDictionary[element.key] = element

    for elementSetKey in allElementSets.keys():
        elementSet = allElementSets[elementSetKey]
        elementSetContainElement(elementSet, allElementsDictionary)

    jinja = jinjaEnv()
    template = jinja.get_template(checkedTemplatePath)
    output = template.render({"elementSetDictionary": allElementSets,
                              "elementDictionary": allElementsDictionary,
                              "mainNamespace":mainNameSpace,
                              "subNamespaceElement":subNameSpaceElement,
                              "subNamespaceElementSet":subNameSpaceElementSet,
                              "stringClass": stringClass,
                              "enumClass": enumClass,
                              "sections": allElements.keys(),
                              "sectionsDictionary": allElements})
    file = open(outputPath, mode="w")
    file.write(output)
    file.close()

def checkElementSetKeyValiable(elementDirPath, elementSetDirPath):
    allElements = readAllElementFiles(elementDirPath)
    allElementSets = readAllElementSetFilesAsElement(elementSetDirPath)

    allElementKeys = []
    for sectionName in allElements.keys():
        section = allElements[sectionName]
        for element in section.elements:
            allElementKeys.append(element.key)
    for sectionName in allElementSets.keys():
        section = allElementSets[sectionName]
        for elementSet in section.elements:
            for key in elementSet.values:
                def searchKey(key):
                    if not key in allElementKeys:
                        if key != elementSet.nullname:
                            print("! ERROR !: " + elementSet.key + " keys: " + key + " is not deifined as element:key")
                result_dict_of_array = re.search(DictionaryOfArrayOfElement.template, key)
                if result_dict_of_array:
                    searchKey(result_dict_of_array.group(1))
                    searchKey(result_dict_of_array.group(2))
                    continue
                result_array = re.search(ArrayOfElement.template, key)
                if result_array:
                    searchKey(result_array.group(1))
                    continue
                searchKey(key)
