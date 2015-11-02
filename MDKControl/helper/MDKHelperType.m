/**
 * Copyright (C) 2010 Sopra (support_movalys@sopra.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */


#import "MDKHelperType.h"
#import <objc/runtime.h>

@implementation MDKHelperType

+(NSString *) getClassOfObjectWithKey:(NSString *)key inClass:(Class)classOfModel{
    
    NSString *returnType = nil;
    Class currentClass = classOfModel ;
    for( NSString *part in [key componentsSeparatedByString:@"."] ) {
        objc_property_t theProperty = class_getProperty(currentClass, [part UTF8String]);
        if(theProperty != NULL) {
            const char * propertyAttrs = property_getAttributes(theProperty);
            NSString *typeAttribute = [[[NSString stringWithFormat:@"%s", propertyAttrs] componentsSeparatedByString:@","] objectAtIndex:0];
            if(typeAttribute) {
                returnType = [self processTypeFromString:typeAttribute];
                currentClass = NSClassFromString(returnType);
            }
        }
        else {
            break;
        }
    }
    return returnType;
}


/**
 * @brief Cette méthode permet de retourner sous forme d'une chaîne de caractère le nom d'une classe avec "Helper" à la fin
 * @param key Le nom de la classe
 * @return Un objet NSString contenant le nom de la classe avec "Helper" à la fin
 */
+(NSString *) getClassHelperOfClassWithKey:(NSString *)key {
    return [key stringByAppendingString:@"Helper"];
}


/**
 * @brief Cette méthode permet de retourner le type de l'object à partir du premier élément de ses attributs
 * retournées par la fonction @function property_getAttributes de la bibliothèque Runtime.h
 * @param typeAttribute Le premier attribut (celui du type de l'objet) retournée par property_getAttributes
 * @return le type de l'objet sous forme d'une chaîne de caractère
 */
+(NSString *)processTypeFromString:(NSString *)typeAttribute {
    NSString *returnType = nil;
    if([typeAttribute rangeOfString:@"@\""].location != NSNotFound) {
        returnType = [[typeAttribute componentsSeparatedByString:@"\""] objectAtIndex:1];
    }
    else {
        typeAttribute = [typeAttribute substringFromIndex:1];
        returnType = [self processPrimitiveTypeWithKey:typeAttribute];
    }
    
    return returnType;
}


/**
 * @brief Dans le cas d'un type primitif, il est nécessaire de détecter quel type est représenté.
 * Cette méthode permet de retourner le bon type de l'objet en fonction de son type extrait de la fonction
 * property_getAttributes.
 * @param primitiveTypeKey La clé du type primitf retournée par la fonction processTypeFromString
 * @return Le nom du type primitf (int, unsigned, float, double etc ...)
 */
+(NSString *)processPrimitiveTypeWithKey:(NSString *)primitiveTypeKey {
    if([primitiveTypeKey isEqualToString:@"c"]) {
        return @"char";
    }
    else if([primitiveTypeKey isEqualToString:@"d"]) {
        return @"double";
    }
    else if([primitiveTypeKey isEqualToString:@"i"]) {
        return @"int";
    }
    else if([primitiveTypeKey isEqualToString:@"f"]) {
        return @"float";
    }
    else if([primitiveTypeKey isEqualToString:@"l"]) {
        return @"long";
    }
    else if([primitiveTypeKey isEqualToString:@"s"]) {
        return @"short";
    }
    else if([primitiveTypeKey isEqualToString:@"I"]) {
        return @"unsigned";
    }
    else {
        return nil;
    }
}

/**
 * @brief Renvoie le type d'une vue sous forme d'une chaîne de caractère
 * @param primitiveTypeKey La clé du type primitf retournée par la fonction processTypeFromString
 * @return Le nom du type primitf (int, unsigned, float, double etc ...)
 */
+(NSString *)processViewTypeFromView:(id)view {
    if([view isKindOfClass:NSClassFromString(@"UIButton")] || [view isKindOfClass:NSClassFromString(@"MFButton")]) {
        return @"Button";
    }
    else if([view isKindOfClass:NSClassFromString(@"UITextField")] || [view isKindOfClass:NSClassFromString(@"MFTextField")]) {
        return @"TextField";
    }
    else if([view isKindOfClass:NSClassFromString(@"UILabel")] || [view isKindOfClass:NSClassFromString(@"MFLabel")]) {
        return @"Label";
    }
    else if([view isKindOfClass:NSClassFromString(@"UITableView")]) {
        return @"TableView";
    }
    else if([view isKindOfClass:NSClassFromString(@"UISwitch")] || [view isKindOfClass:NSClassFromString(@"MFSwitch")]) {
        return @"Switch";
    }
    else if([view isKindOfClass:NSClassFromString(@"UISlider")] || [view isKindOfClass:NSClassFromString(@"MFSlider")]) {
        return @"Slider";
    }
    else if([view isKindOfClass:NSClassFromString(@"UINavigationItem")]) {
        return @"NavigationItem";
    }
    else if([view isKindOfClass:NSClassFromString(@"UITabBarItem")]) {
        return @"TabBarItem";
    }
    else if([view isKindOfClass:NSClassFromString(@"UIButtonBarItem")]) {
        return @"ButtonBar";
    }
    return @"View";
}

/**
 * @brief Renvoie le type élagué de tout préfixe Objective-C ou Framework
 */
+ (NSString *)primaryType:(NSString *)type {
    if([type length] > 2 && [[type substringToIndex:2] isEqualToString:@"MF"]) {
        type = [type substringFromIndex:2];
    } else if([type length] > 2 && [[type substringToIndex:2] isEqualToString:@"NS"]) {
        type = [type substringFromIndex:2];
    } else if([type length] > 2 && [[type substringToIndex:2] isEqualToString:@"UI"]) {
        type = [type substringFromIndex:2];
    } else if([type length] > 6 && [[type substringToIndex:6] isEqualToString:@"__NSCF"]) {
        type = [type substringFromIndex:6];
    } else if([type length] > 14 && [[type substringToIndex:14] isEqualToString:@"__NSCFConstant"]) {
        type = [type substringFromIndex:14];
    }
    return type;
}


@end
