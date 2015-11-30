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

#import "MDKLengthFieldValidator.h"
#import "MDKTooLongStringUIValidationError.h"
#import "MDKTooShortStringUIValidationError.h"
#import "MDKTooLongListUIValidationError.h"
#import "MDKTooShortListUIValidationError.h"


NSString *FIELD_VALIDATOR_MIN_LENGTH = @"minLength";
NSString *FIELD_VALIDATOR_MAX_LENGTH = @"maxLength";

@implementation MDKLengthFieldValidator

+(instancetype)sharedInstance{
    static MDKLengthFieldValidator *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        
    });
    return instance;
}


-(NSArray *)recognizedAttributes {
    return @[FIELD_VALIDATOR_MIN_LENGTH, FIELD_VALIDATOR_MAX_LENGTH];
}

-(NSError *)validate:(id)value withCurrentState:(NSDictionary *)currentState withParameters:(NSDictionary *)parameters {
    if([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSAttributedString class]]) {
        NSString *stringValue = (NSString *)value;
        if(!stringValue || parameters[FIELD_VALIDATOR_MAX_LENGTH] && stringValue.length > [parameters[FIELD_VALIDATOR_MAX_LENGTH] intValue]) {
            return [[MDKTooLongStringUIValidationError alloc] initWithLocalizedFieldName:parameters[@"componentName"] technicalFieldName:parameters[@"componentName"] withObject:parameters[FIELD_VALIDATOR_MAX_LENGTH]];
        }
        else if( parameters[FIELD_VALIDATOR_MIN_LENGTH] && stringValue.length < [parameters[FIELD_VALIDATOR_MIN_LENGTH] intValue]) {
            return [[MDKTooShortStringUIValidationError alloc] initWithLocalizedFieldName:parameters[@"componentName"] technicalFieldName:parameters[@"componentName"] withObject:parameters[FIELD_VALIDATOR_MIN_LENGTH]];
        }
    }
    else if([value isKindOfClass:NSClassFromString(@"NSArray")]) {
        NSArray *arrayValue = (NSArray *)value;
        if(!arrayValue || parameters[FIELD_VALIDATOR_MAX_LENGTH] && arrayValue.count > [parameters[FIELD_VALIDATOR_MAX_LENGTH] intValue]) {
            return [[MDKTooLongListUIValidationError alloc] initWithLocalizedFieldName:parameters[@"componentName"] technicalFieldName:parameters[@"componentName"] withObject:parameters[FIELD_VALIDATOR_MAX_LENGTH]];
        }
        else if(parameters[FIELD_VALIDATOR_MIN_LENGTH] && arrayValue.count < [parameters[FIELD_VALIDATOR_MIN_LENGTH] intValue]) {
            return [[MDKTooShortListUIValidationError alloc] initWithLocalizedFieldName:parameters[@"componentName"] technicalFieldName:parameters[@"componentName"] withObject:parameters[FIELD_VALIDATOR_MIN_LENGTH]];
        }
        
    }
    return nil;
}

-(BOOL)canValidControl:(UIView *)control {
    BOOL canValid = YES;
    canValid = canValid && ([control isKindOfClass:NSClassFromString(@"UITextField")] ||
    [control isKindOfClass:NSClassFromString(@"MDKUIFixedList")]);
    return canValid;
}

-(BOOL)isBlocking {
    return NO;
}
@end
