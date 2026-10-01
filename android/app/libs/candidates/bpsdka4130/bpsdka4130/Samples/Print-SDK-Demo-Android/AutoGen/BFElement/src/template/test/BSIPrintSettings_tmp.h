//
//  BSIPrintSettings.h
//  MacPrintSDK
//
//
//
//
#import <Foundation/Foundation.h>
#import "BSICommonDefinition.h"
#import "BFModelDefinition.h"
#import "BFElementSetPrintSettingsDefinition.h"

@interface BSIPrintSettings : NSObject<NSCopying>
+ (nonnull BSIPrintSettings*) generateDefaultWithModelNumber:(BFElementModelNameNumber)model;

- (nonnull instancetype) init __unavailable;

- (void) setValue:(nonnull NSNumber*)value forCategory:(BFElementSetPrintSettingsNumber)category;
- (void) setString:(nonnull NSString*)string forCategory:(BFElementSetPrintSettingsNumber)category;

- (nullable NSNumber*) getValueForCategory:(BFElementSetPrintSettingsNumber)category;
- (nullable NSString*) getStringForCategory:(BFElementSetPrintSettingsNumber)category;

{# --- explanation of args --- #}
{# mainNamespace : name of main namespace #}
{# subNamespaceElement : name of sub namespace of element#}
{# subNamespaceElementSet : name of sub namespace of elementSet#}
{# stringClass : name of string identifier class #}
{# enumClass : name of enum identifier class #}
{# elementSetDictionary : Dictionary of (meta: elementSet) #}
{#       　　　　　　　　 * ElementSet - meta : meta key #}
{#       　　　　　　　　              - keys : Array of key #}
{#       　　　　　　　　              - elements : array of Element #}
{#                                      * Element - key : name of element #}
{#                  　　　　　　　　                - type : any one of ( enum, int, float, bool, string ) #}
{#                  　　　　　　　　                - values : array of possible values #}
{% macro prefix(element) -%}
{{ mainNamespace.upper() }}{{ subNamespaceElement.title().replace("_", "") }}{{ element.key }}
{%- endmacro %}
{% for element in elementSetDictionary["PrintSettings"].elements %}
{% if element.type == Type.enum %}
- (void) set{{ element.key }}:({{ prefix(element) }}{{ enumClass }})value;
{% endif %}
{% if element.type == Type.int %}
- (void) set{{ element.key }}:(NSInteger)value;
{% endif %}
{% if element.type == Type.float %}
- (void) set{{ element.key }}:(CGFloat)value;
{% endif %}
{% if element.type == Type.bool %}
- (void) set{{ element.key }}:(BOOL)value;
{% endif %}
{% if element.type == Type.string %}
- (void) set{{ element.key }}:(nullable NSString*)value;
{% endif %}
{% endfor %}
{% for element in elementSetDictionary["PrintSettings"].elements %}
{% if element.type == Type.enum %}
- ({{ prefix(element) }}{{ enumClass }}) get{{ element.key }};
{% endif %}
{% if element.type == Type.int %}
- (nullable NSNumber/*NSInteger*/*) get{{ element.key }};
{% endif %}
{% if element.type == Type.float %}
- (nullable NSNumber/*CGFloat*/*) get{{ element.key }};
{% endif %}
{% if element.type == Type.bool %}
- (nullable NSNumber/*BOOL*/*) get{{ element.key }};
{% endif %}
{% if element.type == Type.string %}
- (nullable NSString*) get{{ element.key }};
{% endif %}
{% endfor %}

@end

