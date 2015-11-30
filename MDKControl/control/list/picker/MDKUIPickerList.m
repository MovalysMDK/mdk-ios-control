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
#import "MDKInheritancePickerList.h"
#import "Protocol.h"
#import "Helper.h"


#pragma mark - MDKUIPickerList - Keys

/*!
 * @brief The key for MDKUIPickerListKey allowing to handle external delegate
 */
NSString *const MDKUIPickerListDelegateKey = @"MDKUIPickerListDelegateKey";

/*!
 * @brief The key for MDKUIPickerSelectedKey allowing to handle external delegate
 */
NSString *const MDKUIPickerSelectedDelegateKey = @"MDKUIPickerSelectedDelegateKey";


#pragma mark - MDKUIPickerList - Private interface

@interface MDKUIPickerList()

/*!
 * @brief The private current data allow to know if the update is necessary
 */
@property (nonatomic, strong) id currentData;

/*!
 * @brief The private use delegate with strong link for maintain the life cycle
 */
@property (nonatomic, strong) id userListDelegate;

@property (nonatomic, strong) id userSelectedDelegate;

@end


#pragma mark - MDKUIPickerList - Implementation

@implementation MDKUIPickerList
@synthesize targetDescriptors = _targetDescriptors;


#pragma mark - Initialization and deallocation

- (void)initialize {
    [super initialize];
    [self initializeVars];
    [self setAllTags];
}

- (void)initializeVars {
    self.currentData = [NSArray array];
}

- (void)didInitializeOutlets {}


#pragma mark - Tags for automatic testing

- (void) setAllTags {
    if (self.button.tag == 0) {
        self.button.tag = TAG_MDKPICKERLIST_BUTTON;
    }
}


#pragma mark - Control attribute

- (void)setControlAttributes:(NSDictionary *)controlAttributes {
    [super setControlAttributes:controlAttributes];
}


#pragma mark MDKControlChangesProtocol implementation

- (void)valueChanged:(UIView *)sender {
    NSLog(@"Value changed: %@", sender);
}


#pragma mark - Control Data protocol

+ (NSString *)getDataType {
    return @"NSObject";
}

- (void)setData:(id)data {
    [super setData:data];
    
    if (data) {
        [self setDisplayComponentValue:data];
    }
}

- (id)getData {
    return self.currentData;
}

- (void)setEditable:(NSNumber *)editable {
    [super setEditable:editable];
}

- (void)setDisplayComponentValue:(id)value {
    if (!self.controlAttributes[MDKUIPickerSelectedDelegateKey]) {
        return;
    }
    
    self.userSelectedDelegate = [[NSClassFromString(self.controlAttributes[MDKUIPickerSelectedDelegateKey]) alloc] initWithPickerList:self];
    NSString *stringAssert = [NSString stringWithFormat:@"You must implement MDKUIPickerSelectedDelegateKey for %@", self.controlAttributes[MDKUIPickerSelectedDelegateKey]];
    NSAssert([self.userSelectedDelegate conformsToProtocol:@protocol(MDKUIPickerSelectedDataProtocol)], stringAssert);
    
    [self.userSelectedDelegate mappXibViewWithObject:value];
}

- (void)setValue:(id)value {
    self.currentData = value;
}


#pragma mark - Handle user event

- (IBAction)userDidTapOnButton:(id)sender {
    [self performUserDelegate];             // NSAssert on this method
    [self initializeMDKUIList];
    [self performConstraintsForUiList];
    [self initializeAnimationForAppearing];
}


#pragma mark Private methods

- (void)performUserDelegate {
    self.userListDelegate = [[NSClassFromString(self.controlAttributes[MDKUIPickerListDelegateKey]) alloc] initWithPickerList:self];
    NSString *stringAssert = [NSString stringWithFormat:@"You must implement MDKUIPickerListDataProtocol for %@", self.controlAttributes[MDKUIPickerListDelegateKey]];
    NSAssert([self.userListDelegate conformsToProtocol:@protocol(MDKUIPickerListDataProtocol)], stringAssert);
}

- (void)initializeMDKUIList {
    self.uiList = [[[NSBundle bundleForClass:[MDKUIList class]] loadNibNamed:MDKUIListIdentifier owner:nil options:nil] firstObject];
    self.uiList.translatesAutoresizingMaskIntoConstraints   = NO;
    self.uiList.tableView.layer.cornerRadius                = 10.0f;
    self.uiList.tableView.delegate                          = self.userListDelegate;
    self.uiList.tableView.dataSource                        = self.userListDelegate;
    
    // Perform identifier
    NSString *cellIdentifier = [self.userListDelegate xibNameForPickerListCells];
    [self.uiList.tableView registerNib:[UINib nibWithNibName:cellIdentifier  bundle:[NSBundle bundleForClass:NSClassFromString(cellIdentifier)]]forCellReuseIdentifier:cellIdentifier];
    
    [self.parentNavigationController.view addSubview:self.uiList];
}

- (void)performConstraintsForUiList {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.uiList attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.parentNavigationController.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.uiList attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.parentNavigationController.view  attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.uiList attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.parentNavigationController.view  attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.uiList attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.parentNavigationController.view  attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    [self.parentNavigationController.view addConstraints:@[right, left, bottom, top]];
}

- (void)initializeAnimationForAppearing {
    // Perform animation
    CGRect finalFrame = self.uiList.tableView.frame;
    CGRect startFrame = CGRectMake(finalFrame.origin.x, self.uiList.frame.size.height, finalFrame.size.width, finalFrame.size.height);
    self.uiList.tableView.frame = startFrame;
    
    // Animation
    [UIView animateWithDuration:0.8f delay:0.0f usingSpringWithDamping:10.0f initialSpringVelocity:18.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.uiList.tableView.frame = finalFrame;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.uiList.tableView reloadData];
        }
    }];
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
