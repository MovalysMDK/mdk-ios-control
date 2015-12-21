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

#import "MDKUINumberPicker.h"

@implementation MDKUINumberPicker
@synthesize targetDescriptors = _targetDescriptors;
@synthesize stepper = _stepper;

//Parameters keys
NSString *const NUMBER_PICKER_PARAMETER_MAX_VALUE_KEY = @"maxValue";
NSString *const NUMBER_PICKER_PARAMETER_MIN_VALUE_KEY = @"minValue";
NSString *const NUMBER_PICKER_PARAMETER_STEP_KEY = @"step";
NSString *const NUMBER_PICKER_PARAMETER_FORMAT_KEY = @"format";

#pragma mark - Initialization and deallocation

-(void)initialize {
    [super initialize];
    self.stepper.value = 0.0f;
    self.stepper.maximumValue = 1000.0f;
    self.stepper.stepValue = 1.0f;
    self.stepper.minimumValue = -1000.0f;
}

-(void)didInitializeOutlets {
    [super didInitializeOutlets];
    [self.stepper addTarget:self action:@selector(stepperValueChangedAction:) forControlEvents:UIControlEventValueChanged];
    [self updateText];
}

-(void)forwardSpecificRenderableProperties {
    [super forwardSpecificRenderableProperties];
}

#pragma mark - Custom methods

-(void)stepperValueChangedAction:(id)sender {
    
    //On récupère la valeur en fonction de l'steple spécifié
    //self.slider.value = [self adjustValue:self.slider.value Withstep:self.step];
    //self.sliderValue.text = [NSString stringWithFormat:@"%d", (int)self.slider.value];
    //[self setValue:self.slider.value];
    [self setDisplayComponentValue:@(self.stepper.value)];
    [self valueChanged:sender];
    [self becomeFirstResponder];
}

-(void) updateText {
    NSString *format = self.controlAttributes[NUMBER_PICKER_PARAMETER_FORMAT_KEY];
    if(!format) {
        format = @"%@";
    }
    [self.label setText:[NSString stringWithFormat:format, @([@(self.stepper.value) integerValue])]];
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
    [self.stepper setValue:[value doubleValue]];
    [self updateText];
}

-(id)displayComponentValue {
    return @(self.stepper.value);
}


#pragma mark - Control Attributes 

-(void)setControlAttributes:(NSDictionary *)controlAttributes {
    [super setControlAttributes:controlAttributes];
    
    if(self.controlAttributes[NUMBER_PICKER_PARAMETER_MAX_VALUE_KEY]) {
        self.stepper.maximumValue = [self.controlAttributes[NUMBER_PICKER_PARAMETER_MAX_VALUE_KEY] doubleValue];
    }
    
    if(self.controlAttributes[NUMBER_PICKER_PARAMETER_MIN_VALUE_KEY]) {
        self.stepper.minimumValue = [self.controlAttributes[NUMBER_PICKER_PARAMETER_MIN_VALUE_KEY] doubleValue];
    }
    
    if(self.controlAttributes[NUMBER_PICKER_PARAMETER_STEP_KEY]) {
        self.stepper.stepValue = [self.controlAttributes[NUMBER_PICKER_PARAMETER_STEP_KEY] doubleValue];
    }
    [self updateText];
}



#pragma mark - Control Changes Protocol

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [self.stepper addTarget:self action:@selector(valueChanged:) forControlEvents:controlEvents];
    MDKControlEventsDescriptor *commonCCTD = [MDKControlEventsDescriptor new];
    commonCCTD.target = target;
    commonCCTD.action = action;
    self.targetDescriptors = @{@(self.stepper.hash) : commonCCTD};
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"
-(void) valueChanged:(UIView *)sender {
    [self setData:@(((UIStepper *)sender).value)];
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

@implementation MDKUIExternalNumberPicker
-(NSString *)defaultXIBName {
    return @"MDKUINumberPicker";
}

@end

@implementation MDKUIInternalNumberPicker
-(void)forwardOutlets:(MDKUIExternalNumberPicker *)receiver {
    [receiver setStepper:self.stepper];
    [receiver setLabel:self.label];
}
@end


