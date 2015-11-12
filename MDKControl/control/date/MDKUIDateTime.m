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


#import "MDKUIDateTime.h"
#import "MDKDateConverter.h"
#import "MDKControlChangesProtocol.h"
#import "MDKUIDateTimePickerView.h"
#import "Utils.h"

const NSString *PARAMETER_DATE_TIME_MODE = @"dateTimeMode";
const NSString *PARAMETER_DATE_FORMAT = @"dateFormat";


@interface MDKUIDateTime()

/**
 * @brief The custom-view used to display the DatePicker
 */
@property (nonatomic, strong) MDKUIDateTimePickerView *pickerView;


@end


@implementation MDKUIDateTime
@synthesize targetDescriptors = _targetDescriptors;

#pragma mark - Initialization and deallocation

-(void)initialize {
    [super initialize];
    [self setAllTags];
}

-(void)didInitializeOutlets {
    [super didInitializeOutlets];
    [self.dateButton addTarget:self action:@selector(onDateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self setData:[NSDate date]];
}


#pragma mark - Custom methods

-(void)onDateButtonClick:(id)sender {
    NSString *xibIdentifier = @"MDK_MDKUIDateTimePicker";
    self.pickerView = [[[NSBundle bundleForClass:[MDKUIDateTimePickerView class]] loadNibNamed:xibIdentifier owner:self options:nil] firstObject];
    self.pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.pickerView.sourceComponent = self;
    [self.pickerView refreshWithDate:[self getData] andMode:self.MDK_dateTimeMode];
    [self.parentNavigationController.view addSubview:self.pickerView];
    
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.pickerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.parentNavigationController.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.pickerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.parentNavigationController.view  attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.pickerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.parentNavigationController.view  attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.pickerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.parentNavigationController.view  attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    [self.parentNavigationController.view addConstraints:@[right, left, bottom, top]];
    self.pickerView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerView.alpha = 1;
    }];
}


#pragma mark - Control Data protocol

-(void)setData:(id)data {
    [super setData:data];
    [self setDisplayComponentValue:data];
}

-(id)getData {
    return self.controlData;
}

-(void)setDisplayComponentValue:(id)value {
    NSDate *dateValue = value;
    NSString *stringDate = [MDKDateConverter toString:value withMode:self.MDK_dateTimeMode];
    if(self.MDK_dateFormat) {
        stringDate = [MDKDateConverter toString:value withCustomFormat:self.MDK_dateFormat];
    }

    [self.dateButton setTitle:stringDate forState:UIControlStateNormal];
}

-(id)displayComponentValue {
    return self.dateButton.titleLabel.text;
}

+(NSString *)getDataType {
    return @"NSDate";
}



#pragma mark - Tags for automatic testing
-(void) setAllTags {
    if (self.dateButton.tag == 0) {
        [self.dateButton setTag:TAG_MFDATEPICKER_DATEBUTTON];
    }
}

#pragma mark - Control changes
-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    MDKControlEventsDescriptor *commonCCTD = [MDKControlEventsDescriptor new];
    commonCCTD.target = target;
    commonCCTD.action = action;
    self.targetDescriptors = @{@(self.dateButton.hash) : commonCCTD};
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"
-(void) valueChanged:(UIView *)sender {
    MDKControlEventsDescriptor *cctd = self.targetDescriptors[@(sender.hash)];
    [cctd.target performSelector:cctd.action withObject:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:ASK_HIDE_KEYBOARD object:nil];
}
#pragma clang diagnostic pop



#pragma mark - Control Attributes

-(void)setControlAttributes:(NSDictionary *)controlAttributes {
    if(controlAttributes[PARAMETER_DATE_TIME_MODE]) {
        self.MDK_dateTimeMode = [controlAttributes[PARAMETER_DATE_TIME_MODE] integerValue];
    }
    if(controlAttributes[PARAMETER_DATE_FORMAT]) {
        self.MDK_dateFormat = controlAttributes[PARAMETER_DATE_FORMAT];
    }
    [super setControlAttributes:controlAttributes];
}


-(NSArray *)controlRenderableProperties {
    return @[@"MDK_dateFormat", @"MDK_dateTimeMode"];
}


@end




/******************************************************/
/* INTERNAL/EXTERNAL                                  */
/******************************************************/

@implementation MDKUIExternalDateTime
-(NSString *)defaultXIBName {
    return @"MDKUIDateTime";
}
@end

@implementation MDKUIInternalDateTime


@end