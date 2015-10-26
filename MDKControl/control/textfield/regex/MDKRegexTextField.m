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

#import "MDKRegexTextField.h"
#import "MDKNoMatchingValueUIValidationError.h"

@implementation MDKRegexTextField
@synthesize customStyleClass;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"
-(void)initializeComponent {
    [super initializeComponent];
    [self.styleClass performSelector:@selector(addButtonOnTextField:) withObject:self];
    [self addTarget:self action:@selector(innerTextDidChange:) forControlEvents:UIControlEventEditingChanged];
}
#pragma clang diagnostic pop


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"
-(void)dealloc {
    [self removeTarget:self action:@selector(innerTextDidChange:) forControlEvents:UIControlEventEditingChanged];
}
#pragma clang diagnostic pop

-(void) doAction {
//    [MFEMDKxception throwNotImplementedExceptionOfMethodName:@"doAction" inClass:[self class] andUserInfo:nil];
}


@end
