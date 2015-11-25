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

#import "MDKUIPickerList.h"
#import "Helper.h"


#pragma mark - MDKUIEnumList - Keys

/*!
 * @brief The key for MDKUIEnumList allowing to add control attributes
 */
NSString *const MDKUIPickerListKey = @"MDKUIPickerListKey";


@interface MDKUIPickerList()

/*!
 * @brief The private current data allow to know if the update is necessary
 */
@property (nonatomic, strong) id currentData;

/*!
 * @brief This variable allow to know the current enum class name
 */
@property (nonatomic, strong) NSString *currentEnumClassName;

@end

@implementation MDKUIPickerList
@synthesize targetDescriptors = _targetDescriptors;


#pragma mark - Initialization and deallocation

- (void)initialize {
    [super initialize];
    [self initializeVars];
    [self setAllTags];
}

- (void)initializeVars {
    self.currentData = @(0);
}

- (void)didInitializeOutlets {}


#pragma mark - Tags for automatic testing

- (void) setAllTags {}


#pragma mark - Control attribute

- (void)setControlAttributes:(NSDictionary *)controlAttributes {
    if (controlAttributes && [controlAttributes objectForKey:MDKUIPickerListKey]) {
        self.currentEnumClassName = [controlAttributes valueForKey:MDKUIPickerListKey];
    }
}


#pragma mark MDKControlChangesProtocol implementation

- (void)valueChanged:(UIView *)sender {
    NSLog(@"Value changed: %@", sender);
}


#pragma mark - Control Data protocol

+ (NSString *)getDataType {
    return @"NSArray";
}

- (void)setData:(id)data {
    if (data && ![self.currentData isEqual:data]) {
        self.currentData = data;
        [self displayData];
    }
    [super setData:data];
}

- (id)getData {
    return self.currentData;
}

- (void)setEditable:(NSNumber *)editable {
    [super setEditable:editable];
}

- (void)setDisplayComponentValue:(id)value {
    [self setValue:value];
}

- (void)setValue:(id)value {
    self.currentData = value;
}


#pragma mark - Private methods

- (void)displayData {
    NSString *sEnumClassHelperName = [MDKHelperType getClassHelperOfClassWithKey:self.currentEnumClassName];
    Class cEnumHelper              = NSClassFromString(sEnumClassHelperName);
    
    if ([cEnumHelper respondsToSelector:@selector(textFromEnum:)]) {
        NSString *text = [cEnumHelper performSelector:@selector(textFromEnum:) withObject:self.currentData];
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self updateDisplayFromText:text];
        });
    }
}

@end


/******************************************************/
/* INTERNAL/EXTERNAL                                  */
/******************************************************/

@implementation MDKUIExternalPickerList

- (NSString *)defaultXIBName {
    return @"MDKUIPickerList";
}

@end

@implementation MDKUIInternalPickerList @end
