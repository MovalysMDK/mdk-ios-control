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

#import "MDKFieldValidatorHandler.h"
#import "MDKFieldValidatorProtocol.h"
#import "MDKComponentApplicationProtocol.h"
#import "MDKSimpleComponentProvider.h"
#import "MDKMessageInfo.h"

@implementation MDKFieldValidatorHandler

+(NSArray *)fieldValidatorsForAttributes:(NSArray *)attributes forControl:(UIView *)control{
    NSMutableArray *result = [NSMutableArray array];
    
    [MDKFieldValidatorHandler checkForMessagesInfoForAttributes:attributes onControl:control];
    
    id<UIApplicationDelegate> appDelegate =  [[UIApplication sharedApplication] delegate];
    NSDictionary *completeFieldValidatorDict = nil;
    if([appDelegate conformsToProtocol:@protocol(MDKComponentApplicationProtocol)]) {
        completeFieldValidatorDict = ((id<MDKComponentApplicationProtocol>)appDelegate).fieldValidatorsByAttributes;
    }
    if(!completeFieldValidatorDict){
        completeFieldValidatorDict = [MDKFieldValidatorHandler loadFieldValidatorByAttributes];
    }
    
    [attributes enumerateObjectsUsingBlock:^(NSString *attribute, NSUInteger idx, BOOL *stop) {
        id<MDKFieldValidatorProtocol> fieldValidatorInstance = completeFieldValidatorDict[attribute];
        if(fieldValidatorInstance && [fieldValidatorInstance canValidControl:control]) {
            [result addObject:fieldValidatorInstance];
        }
    }];
    
    return result;
}

+(NSDictionary *)loadFieldValidatorByAttributes {
    NSBundle *mdkControlBundle = [NSBundle bundleForClass:[MDKFieldValidatorHandler class]];
    NSBundle *appBundle = [NSBundle bundleForClass:NSClassFromString(@"AppDelegate")];
    
    NSMutableDictionary *completeValidatorList = [[NSDictionary dictionaryWithContentsOfFile:[mdkControlBundle pathForResource:@"MDKFieldValidatorList" ofType:@"plist"]] mutableCopy];
    
    NSString *appResourcePath = [appBundle pathForResource:@"AppFieldValidatorList" ofType:@"plist"];
    
    if(appResourcePath) {
        [completeValidatorList addEntriesFromDictionary:[[NSDictionary dictionaryWithContentsOfFile:appResourcePath] mutableCopy]];
    }
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for(NSString *fieldValidatorKey in completeValidatorList.allKeys) {
        
        id<MDKFieldValidatorProtocol> fieldValidatorInstance = nil;
        id<MDKComponentProviderProtocol> componentProvider = nil;
        id<UIApplicationDelegate> appDelegate =  [[UIApplication sharedApplication] delegate];
        
        if([appDelegate conformsToProtocol:@protocol(MDKComponentApplicationProtocol)]) {
            componentProvider = [((id<MDKComponentApplicationProtocol>)appDelegate) componentProvider];
        }
        else {
            componentProvider = [MDKSimpleComponentProvider new];
        }
        fieldValidatorInstance = [componentProvider fieldValidatorWithKey:fieldValidatorKey];
        
        
        if(fieldValidatorInstance) {
            if([fieldValidatorInstance conformsToProtocol:@protocol(MDKFieldValidatorProtocol)]) {
                NSArray *validatorRecognizedAttributes = [fieldValidatorInstance recognizedAttributes];
                for(NSString *recognizedParameter in validatorRecognizedAttributes) {
                    if(!result[recognizedParameter]) {
                        result[recognizedParameter] = fieldValidatorInstance;
                    }
                }
            }
            else {
                @throw [NSException exceptionWithName:@"Incorrect FieldValidator"
                                               reason:[NSString stringWithFormat:@"The declared FieldValidator with key %@ does not conform MFFieldValidatorProtocol", fieldValidatorKey]userInfo:nil];
            }
        }
    }
    id<UIApplicationDelegate> appDelegate =  [[UIApplication sharedApplication] delegate];
    if([appDelegate conformsToProtocol:@protocol(MDKComponentApplicationProtocol)]) {
        ((id<MDKComponentApplicationProtocol>)appDelegate).fieldValidatorsByAttributes = result;
    }
    
    return result;
}

+(void) checkForMessagesInfoForAttributes:(NSArray *)attributes onControl:(UIView *)control {
    for(NSString *controlAttributeName in attributes) {
        NSString *formatName = [NSString stringWithFormat:@"%@%@", [[controlAttributeName substringToIndex:1] uppercaseString], [controlAttributeName substringFromIndex:1]];
        
        NSString *messageInfoClassName = [NSString stringWithFormat:@"MDK%@Info", formatName];
        if(NSClassFromString(messageInfoClassName)) {
            NSString *componentName = ((NSDictionary *)[control performSelector:@selector(controlAttributes)])[@"componentName"];
            MDKMessageInfo *messageInfo = [[NSClassFromString(messageInfoClassName) alloc] initWithLocalizedFieldName:componentName technicalFieldName:componentName withObject:((NSDictionary *)[control performSelector:@selector(controlAttributes)])[controlAttributeName]];
            BOOL alreadyExist = NO;
            for(id<MDKMessageProtocol> message in [control performSelector:@selector(messages)]) {
                if(message.status == MDKMessageStatusInfo && [message.identifier isEqualToString:messageInfo.identifier]) {
                    alreadyExist = YES;
                }
            }
            if(!alreadyExist) {
                [control performSelector:@selector(addMessages:) withObject:@[messageInfo]];
            }
        }
    }
}

@end
