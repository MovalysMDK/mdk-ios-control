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

#import "MDKBarCodeScanTextField.h"

@interface MDKBarCodeScanTextField () <UITextFieldDelegate>

@end

@implementation MDKBarCodeScanTextField
@synthesize editable = _editable;


-(void)initializeComponent {
    [super initializeComponent];
    self.delegate = self;
}

-(UIKeyboardType)keyboardType {
    return UIKeyboardTypeDefault;
}

-(void) doAction {
    if([self validate] == 0) {
        // Create and MDKURL composer
        [[MDKCommandHandler commandWithKey:@"OpenScanCommand" withQualifier:@""] executeFromViewController:[self parentViewController] withParameters:self, nil];
    }
    else {
        [self onMessageButtonClick:self];
    }
}

-(NSArray *)controlValidators {
    return @[];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

-(void) updateValueFromExternalSource:(NSString *)string {
    self.text = string;
    [self valueChanged:self];
}

@end
