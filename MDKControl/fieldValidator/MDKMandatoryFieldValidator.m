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

#import "MDKMandatoryFieldValidator.h"
#import "MDKMandatoryFieldUIValidationError.h"
#import "MDKUIDataPositionProtocol.h"

NSString *FIELD_VALIDATOR_ATTRIBUTE_MANDATORY = @"mandatory";

@implementation MDKMandatoryFieldValidator

+(instancetype)sharedInstance{
    static MDKMandatoryFieldValidator *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

-(NSArray *)recognizedAttributes {
    return @[FIELD_VALIDATOR_ATTRIBUTE_MANDATORY];
}

-(NSError *)validate:(id)value withCurrentState:(NSDictionary *)currentState withParameters:(NSDictionary *)parameters {
    NSError *result = nil;
    if([parameters[FIELD_VALIDATOR_ATTRIBUTE_MANDATORY] boolValue] && ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSAttributedString class]])) {
        NSString *stringValue = (NSString *)value;
        if(!stringValue || stringValue.length == 0) {
            result = [[MDKMandatoryFieldUIValidationError alloc] initWithLocalizedFieldName:parameters[@"componentName"] technicalFieldName:parameters[@"componentName"]];
        }
    }
    else if([value isKindOfClass:NSClassFromString(@"NSArray")]) {
        if(!value || ((NSArray *)value).count == 0) {
            result = [[MDKMandatoryFieldUIValidationError alloc] initWithLocalizedFieldName:parameters[@"componentName"] technicalFieldName:parameters[@"componentName"]];
        }
    }
    else if([value conformsToProtocol:@protocol(MDKUIDataPositionProtocol)]) {
        if(!value || !((id<MDKUIDataPositionProtocol>) value).latitude || !((id<MDKUIDataPositionProtocol>) value).longitude
           || [((id<MDKUIDataPositionProtocol>) value).latitude length] == 0 | [((id<MDKUIDataPositionProtocol>) value).longitude length] == 0) {
            result = [[MDKMandatoryFieldUIValidationError alloc] initWithLocalizedFieldName:parameters[@"componentName"] technicalFieldName:parameters[@"componentName"]];
        }
    }
    else {
        if(!value) {
            result = [[MDKMandatoryFieldUIValidationError alloc] initWithLocalizedFieldName:parameters[@"componentName"] technicalFieldName:parameters[@"componentName"]];
        }
    }
    
    return result;
}

-(BOOL)canValidControl:(UIView *)control {
    BOOL canValid = YES;
    canValid = canValid && ([control isKindOfClass:NSClassFromString(@"MDKTextField")] ||
                            [control isKindOfClass:NSClassFromString(@"MDKBaseControl")] ||
                            [control isKindOfClass:NSClassFromString(@"MFUIOldBaseComponent")] ||
                            [control isKindOfClass:NSClassFromString(@"MFUIBaseComponent")]);
    return canValid;
}

-(BOOL)isBlocking {
    return YES;
}

@end
