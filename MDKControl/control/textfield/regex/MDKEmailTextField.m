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
#import "Error.h"
#import "Utils.h"
#import "FieldValidator.h"

#import "MDKEmailTextField.h"
#import <MessageUI/MessageUI.h>

@interface MDKEmailTextField ()

@end

@implementation MDKEmailTextField

-(void) doAction {
    BOOL canSendMail = NO;
    if ([MFMailComposeViewController canSendMail] && ([self validate] == 0)){
        canSendMail = YES;
        // Create and show composer
        MDKEmail *email = [MDKEmail new];
        email.to = [self getData];
        [[MDKCommandHandler commandWithKey:@"SendEmailCommand" withQualifier:nil] executeFromViewController:[self parentViewController] withParameters:email, nil];
    }
    if(!canSendMail)
    {
        
        [self clearErrors];
        [self addErrors:@[[[MDKInvalidEmailValueUIValidationError alloc] initWithCode:500 localizedDescriptionKey:@"MFCantSendMailTechnicalError"localizedFieldName:NSStringFromClass(self.class) technicalFieldName:NSStringFromClass(self.class)]]];
    }
}

-(UIKeyboardType)keyboardType {
    return UIKeyboardTypeEmailAddress;
}


-(NSArray *)controlValidators {
    return @[[MDKEmailFieldValidator sharedInstance]];
}

@end
