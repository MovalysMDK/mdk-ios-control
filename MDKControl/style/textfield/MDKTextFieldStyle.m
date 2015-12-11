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

#import "MDKTextFieldStyle+ErrorView.h"
#import "MDKTextField.h"

NSInteger DEFAULT_ACCESSORIES_MARGIN = 2;

@implementation MDKTextFieldStyle
@synthesize messageView;
@synthesize backgroundView;

#pragma mark - Standard Style
-(void)applyStandardStyleOnComponent:(MDKTextField *)component {
    [super applyStandardStyleOnComponent:component];
}

#pragma mark - Error Style

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"
-(void)applyErrorStyleOnComponent:(MDKTextField *)component {
    [super applyErrorStyleOnComponent:component];
    [self performSelector:@selector(addErrorViewOnComponent:) withObject:component];    
}

-(void)applyValidStyleOnComponent:(MDKTextField *) component {
    [super applyValidStyleOnComponent:component];
    [self performSelector:@selector(removeErrorViewOnComponent:) withObject:component];
}
#pragma clang diagnostic pop



-(NSArray *)defineConstraintsForAccessoryView:(UIView *)accessory withIdentifier:(NSString *)identifier onControl:(MDKTextField *)control {
    return @[];
}

-(void)applyDisabledStyleOnComponent:(MDKTextField *)component {
    [super applyDisabledStyleOnComponent:component];
    component.enabled = NO;
}

-(void)applyEnabledStyleOnComponent:(MDKTextField *)component {
    [super applyEnabledStyleOnComponent:component];
    component.enabled = YES;
}

@end

