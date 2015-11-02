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


#import "MDKUIEnumImage.h"
#import "Helper.h"


#pragma mark - MDKUIEnumImage - Keys

/*!
 * @brief The key for MDKUIEnumImage allowing to add control attributes
 */
NSString *const MDKUIEnumImageKey = @"MDKUIEnumImageKey";


#pragma mark - MDKUIEnumImage - Private interface

@interface MDKUIEnumImage()

/*!
 * @brief The private current data allow to know if the update is necessary
 */
@property (nonatomic, strong) id currentData;

/*!
 * @brief This variable allow to know the current enum class name
 */
@property (nonatomic, strong) NSString *currentEnumClassName;

/*!
 * @brief The image mode allow to know if enum image must display an image or a label
 */
@property (nonatomic, assign) BOOL imageMode;

@end


#pragma mark - MDKUIEnumImage - Implementation

@implementation MDKUIEnumImage
@synthesize targetDescriptors = _targetDescriptors;


#pragma mark - Initialization and deallocation

- (void)initialize {
    [super initialize];
    [self initializeVars];
    [self setAllTags];
}

- (void)initializeVars {
    self.currentData = @(0);
    self.imageMode   = NO;
}

- (void)didInitializeOutlets {
    self.imageView.hidden = [self checkIfImageViewNeeded];
}


#pragma mark - Tags for automatic testing

- (void) setAllTags {
    if (self.imageView.tag == 0) {
        self.imageView.tag = TAG_MDKENUMIMAGE_IMAGEVIEW;
    }
    if (self.label.tag == 0) {
        self.label.tag = TAG_MDKENUMIMAGE_LABEL;
    }
}


#pragma mark MDKControlChangesProtocol implementation

- (void)valueChanged:(UIView *)sender {
    NSLog(@"Value changed: %@", sender);
}


#pragma mark - Control Data protocol

+ (NSString *)getDataType {
    return @"NSNumber";
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


#pragma mark - Control attribute

- (void)setControlAttributes:(NSDictionary *)controlAttributes {
    if (controlAttributes && [controlAttributes objectForKey:MDKUIEnumImageKey]) {
        self.currentEnumClassName = [controlAttributes valueForKey:MDKUIEnumImageKey];
    }
}


#pragma mark - Live Rendering

- (void)prepareForInterfaceBuilder {
    UILabel *innerDescriptionLabel = [[UILabel alloc] initWithFrame:self.bounds];
    innerDescriptionLabel.text = [[self class] description];
    innerDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    innerDescriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    [self addSubview:innerDescriptionLabel];
    self.backgroundColor = [UIColor colorWithRed:0.98f green:0.98f blue:0.34f alpha:0.5f];
}


#pragma mark - Custom methods

- (void)setValue:(id)value {
    self.currentData = value;
}

- (BOOL)checkIfImageViewNeeded {
    return ( self.imageView.image ? NO : YES );
}

- (void)displayData {
    NSString *sEnumClassHelperName = [MDKHelperType getClassHelperOfClassWithKey:self.currentEnumClassName];
    Class cEnumHelper              = NSClassFromString(sEnumClassHelperName);
    
    if ([cEnumHelper respondsToSelector:@selector(textFromEnum:)]) {
        NSString *text = [cEnumHelper performSelector:@selector(textFromEnum:) withObject:self.currentData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateDisplayFromText:text];
        });
    }
}

- (void)updateDisplayFromText:(NSString *)text {
    [self initializeImageViewWithText:text];
    
    self.imageView.hidden = [self checkIfImageViewNeeded];
    self.label.hidden     = ( !self.imageView.hidden );
    
    if(self.imageView.hidden) {
        self.label.text = text;
    }
}

- (void)initializeImageViewWithText:(NSString *)text {
    NSString *imageName  = [[NSString stringWithFormat:@"enum_%@_%@", self.currentEnumClassName, text] lowercaseString];
    self.imageView.image = [UIImage imageNamed:imageName];
}

@end



/******************************************************/
/* INTERNAL/EXTERNAL                                  */
/******************************************************/

@implementation MDKUIExternalEnumImage

- (NSString *)defaultXIBName {
    return @"MDKUIEnumImage";
}

@end

@implementation MDKUIInternalEnumImage @end
