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


#import "Utils.h"

#import "MDKUISlider.h"
#import "MDKUISlider+UISliderForwarding.h"

#include <math.h>


@interface MDKUISlider ()

/*!
 * @brief The setp of the slider
 */
@property (nonatomic) float step;

@end

@implementation MDKUISlider
@synthesize targetDescriptors = _targetDescriptors;

//Parameters keys
NSString *const SLIDER_PARAMETER_MAX_VALUE_KEY = @"maxValue";
NSString *const SLIDER_PARAMETER_MIN_VALUE_KEY = @"minValue";
NSString *const SLIDER_PARAMETER_STEP_KEY = @"step";


#pragma mark - Initialization and deallocation

-(void)initialize {
    [super initialize];
    self.step = 1;
    [self setAllTags];
}

-(void)didInitializeOutlets {
    [self.innerSlider addTarget:self action:@selector(sliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];
}


#pragma mark - Custom methods
-(void)sliderValueChangedAction:(id)sender {
    
    //On récupère la valeur en fonction de l'steple spécifié
    //self.slider.value = [self adjustValue:self.slider.value Withstep:self.step];
    //self.sliderValue.text = [NSString stringWithFormat:@"%d", (int)self.slider.value];
    //[self setValue:self.slider.value];
    [self setDisplayComponentValue:@(self.innerSlider.value)];
    [self valueChanged:sender];
    [self becomeFirstResponder];
}

- (float) adjustValue:(float)value withStep:(float)step {
    
    float reste = fmod(value, step);
    if (reste != 0) {
        
        float valueToReturn = value - reste;
        
        //Si la valeur à retourner est inférieure à la valeur minimale du slider, celui va
        //se positionner par défaut sur la valeur minimale, qui ne respecte pas forcément le pas.
        //Cette valeur à retourner est nécessairement un multiple du pas et est la plus grande valeur
        //qui est inférieure à la dernière valeur valide du slider.
        //Il suffit donc d'ajouter le pas à cette valeur à retourner pour obtenir un nombre valide.
        if (valueToReturn < self.innerSlider.minimumValue) {
            return valueToReturn + self.step;
        }
        
        return valueToReturn;
        
    } else {
        return value;
    }
    
}

- (void)setValue:(float)value animated:(BOOL)animated {
    //Mise à jour du slider
    if (animated == YES)
    {
        //Permet l'animation sur iOS 7
        [UIView animateWithDuration:1.0 animations:^{
            [self.innerSlider setValue:[self adjustValue:value withStep:self.step] animated:animated];
        }];
    } else {
        [self.innerSlider setValue:[self adjustValue:value withStep:self.step] animated:animated];
    }
    
    //Mise à jour de la valeur affichée
    NSNumber *number = [NSNumber numberWithFloat:value];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    //Blocage à 3 décimales car le nombre est un float avec un grand nombre de décimales
    numberFormatter.maximumFractionDigits = 3;
    self.innerSliderValueLabel.text = [MDKNumberConverter toString:number withFormatter:numberFormatter];
    [self validate];
}



#pragma mark - Control Data protocol
+(NSString *)getDataType {
    return @"NSNumber";
}

-(void)setData:(id)data {
    if(data) {
        [self setDisplayComponentValue:(NSNumber *)data];
    }
    [super setData:data];
}

-(id)getData {
    return [self displayComponentValue];
}

-(id)displayComponentValue {
    return @(self.innerSlider.value);
}

-(void)setDisplayComponentValue:(id)value {
    [self setValue:[value floatValue] animated:NO];
}



#pragma mark - Tags for automatic testing
-(void) setAllTags {
    if (self.innerSlider.tag == 0) {
        [self.innerSlider setTag:TAG_MFSLIDER_SLIDER];
    }
    if (self.innerSliderValueLabel.tag == 0) {
        [self.innerSliderValueLabel setTag:TAG_MFSLIDER_SLIDERVALUE];
    }
}


#pragma mark - Control attribute
-(void)setControlAttributes:(NSDictionary *)controlAttributes {
    [super setControlAttributes:controlAttributes];
//    CGFloat maximunValue = self.controlAttributes[SLIDER_PARAMETER_MAX_VALUE_KEY] ? [self.controlAttributes[SLIDER_PARAMETER_MAX_VALUE_KEY] floatValue] : 100.0f;
//    CGFloat minimumValue = self.controlAttributes[SLIDER_PARAMETER_MIN_VALUE_KEY] ? [self.controlAttributes[SLIDER_PARAMETER_MIN_VALUE_KEY] floatValue] : 0.0f;
//    self.step = self.controlAttributes[SLIDER_PARAMETER_STEP_KEY] ? [self.controlAttributes[SLIDER_PARAMETER_STEP_KEY] floatValue] : 1.0f;
//    
//    [self setMaximumValue:maximunValue];
//    [self setMinimumValue:minimumValue];
}

-(id)forwardingTargetForSelector:(SEL)aSelector {
    return self.innerSlider;
}


#pragma mark - Control changes

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [self.innerSlider addTarget:self action:@selector(valueChanged:) forControlEvents:controlEvents];
    [self.innerSlider addTarget:self action:@selector(valueChanged:) forControlEvents:controlEvents];
    MDKControlEventsDescriptor *commonCCTD = [MDKControlEventsDescriptor new];
    commonCCTD.target = target;
    commonCCTD.action = action;
    self.targetDescriptors = @{@(self.innerSlider.hash) : commonCCTD};
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"
-(void) valueChanged:(UIView *)sender {
    [self setData:@(((UISlider *)sender).value)];
    MDKControlEventsDescriptor *cctd = self.targetDescriptors[@(sender.hash)];
    [cctd.target performSelector:cctd.action withObject:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:ASK_HIDE_KEYBOARD object:nil];
}
#pragma clang diagnostic pop

@end

#import "MDKUISlider+UISliderForwarding.h"



/******************************************************/
/* INTERNAL/EXTERNAL                                  */
/******************************************************/

@implementation MDKUIExternalSlider
-(NSString *)defaultXIBName {
    return @"MDKUISlider";
}
@end

@implementation MDKUIInternalSlider @end
