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

#import "MDKUISwitch.h"

@implementation MDKUISwitch
@synthesize targetDescriptors = _targetDescriptors;

//Parameters keys
NSString *const SWITCH_PARAMETER_FIXED_TEXT_KEY = @"fixedText";
NSString *const SWITCH_PARAMETER_ON_TEXT_KEY = @"onText";
NSString *const SWITCH_PARAMETER_OFF_TEXT_KEY = @"offText";


#pragma mark - Initialization and deallocation

-(void)initialize {
    [super initialize];
    self.uiswitch.on = NO;
}

-(void)didInitializeOutlets {
    [self.uiswitch addTarget:self action:@selector(switchValueChangedAction:) forControlEvents:UIControlEventValueChanged];
}


#pragma mark - Custom methods

-(void)switchValueChangedAction:(id)sender {
    
    //On récupère la valeur en fonction de l'steple spécifié
    //self.slider.value = [self adjustValue:self.slider.value Withstep:self.step];
    //self.sliderValue.text = [NSString stringWithFormat:@"%d", (int)self.slider.value];
    //[self setValue:self.slider.value];
    [self setDisplayComponentValue:@(self.uiswitch.on)];
    [self valueChanged:sender];
    [self becomeFirstResponder];
}

-(void) updateText {
    NSString *fixedTextValue = self.controlAttributes[SWITCH_PARAMETER_FIXED_TEXT_KEY];
    if(fixedTextValue) {
        [self.label setText:MDKLocalizedString(fixedTextValue, @"")];
    }
    else {
        NSString *onTextValue = self.controlAttributes[SWITCH_PARAMETER_ON_TEXT_KEY];
        NSString *offTextValue = self.controlAttributes[SWITCH_PARAMETER_OFF_TEXT_KEY];
        if([[self getData] boolValue] && onTextValue) {
            [self.label setText:MDKLocalizedString(onTextValue, @"")];
        }
        else if(![[self getData] boolValue] && offTextValue) {
            [self.label setText:MDKLocalizedString(offTextValue, @"")];
        }
    }
}



#pragma mark - Control Data Protocol

+(NSString *)getDataType {
    return @"BOOL";
}

-(id)getData {
    return [self displayComponentValue];
}

-(void)setData:(id)data {
    if([data isKindOfClass:NSNumber.class]) {
        [super setData:data];
    }
}

-(void)setDisplayComponentValue:(NSNumber *)value {
    [self.uiswitch setOn:[value boolValue] animated:YES];
    [self updateText];
}

-(id)displayComponentValue {
    return @(self.uiswitch.on);
}




#pragma mark - Control changes

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [self.uiswitch addTarget:self action:@selector(valueChanged:) forControlEvents:controlEvents];
    MDKControlEventsDescriptor *commonCCTD = [MDKControlEventsDescriptor new];
    commonCCTD.target = target;
    commonCCTD.action = action;
    self.targetDescriptors = @{@(self.uiswitch.hash) : commonCCTD};
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"
-(void) valueChanged:(UIView *)sender {
    [self setData:@(((UISwitch *)sender).on)];
    MDKControlEventsDescriptor *cctd = self.targetDescriptors[@(sender.hash)];
    [cctd.target performSelector:cctd.action withObject:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:ASK_HIDE_KEYBOARD object:nil];
    [self validate];
}
#pragma clang diagnostic pop

@end



/******************************************************/
/* INTERNAL/EXTERNAL                                  */
/******************************************************/

@implementation MDKUIExternalSwitch
-(NSString *)defaultXIBName {
    return @"MDKUISwitch";
}
@end

@implementation MDKUIInternalSwitch @end
