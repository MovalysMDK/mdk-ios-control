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


#import "Command.h"
#import "FieldValidator.h"
#import "Error.h"
#import "Utils.h"

#import "MDKPhoneTextField.h"

@implementation MDKPhoneTextField

-(UIKeyboardType)keyboardType {
    return UIKeyboardTypePhonePad;
}


-(void) doAction {
    
    if([self validate] == 0) {
        BOOL canSendMail = NO;
        if (![[[UIDevice currentDevice] model] isEqualToString:@"iPad"] && ([self validate] == 0)){
            MDKPhoneNumber *phone = [MDKPhoneNumber new];
            phone.baseNumber = [[self getData] isKindOfClass:[NSAttributedString class]] ? [[self getData] string] : [self getData];
            [[MDKCommandHandler commandWithKey:@"CallPhoneNumberCommand" withQualifier:@""] executeFromViewController:[self parentViewController] withParameters:phone, nil];
            canSendMail = YES;
        }
        if(!canSendMail)
        {
    
            [self clearErrors];
            MDKInvalidPhoneNumberValueUIValidationError *error = [[MDKCanNotPerformActionError alloc]  initWithLocalizedFieldName:NSStringFromClass([self class]) technicalFieldName:NSStringFromClass([self class]) withObject:@"Phone Call"];
            [self addErrors:@[error]];
        }
    }
    else {
        [self onErrorButtonClick:self];
    }
    
    
    
}


-(NSArray *)controlValidators {
    return @[[MDKPhoneFieldValidator sharedInstance]];
}

@end
