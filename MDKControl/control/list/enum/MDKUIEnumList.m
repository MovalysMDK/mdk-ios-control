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

#import "MDKUIEnumList.h"
#import "MDKListCell.h"
#import "MDKDelegateEnumList.h"
#import "MDKUIList.h"
#import "Helper.h"


#pragma mark - MDKUIEnumList - Keys

/*!
 * @brief The key for MDKUIEnumList allowing to add control attributes
 */
NSString *const MDKUIEnumListKey = @"MDKUIEnumListKey";


#pragma mark - MDKUIEnumList - Private interface

@interface MDKUIEnumList() <MDKUIEnumListProtocol>

/*!
 * @brief The private current data allow to know if the update is necessary
 */
@property (nonatomic, strong) id currentData;

/*!
 * @brief This variable allow to know the current enum class name
 */
@property (nonatomic, strong) NSString *currentEnumClassName;

/*!
 * @brief Delegate for enum list
 */
@property (nonatomic, strong) MDKDelegateEnumList *delegate;

/*!
 * @brief View allow to display the table view
 */
@property (nonatomic, strong) MDKUIList *uiList;

@end


#pragma mark - MDKUIEnumList - Implementation

@implementation MDKUIEnumList
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

- (void) setAllTags {
    if (self.button.tag == 0) {
        self.button.tag = TAG_MDKUILIST_BUTTON;
    }
}


#pragma mark - Control attribute

- (void)setControlAttributes:(NSDictionary *)controlAttributes {
    if (controlAttributes && [controlAttributes objectForKey:MDKUIEnumListKey]) {
        self.currentEnumClassName = [controlAttributes valueForKey:MDKUIEnumListKey];
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

- (void)setValue:(id)value {
    self.currentData = value;
}


#pragma mark - Handle user event

- (IBAction)userDidTapOnEnumButton:(id)sender {
    // Perform delegate
    self.delegate          = [[MDKDelegateEnumList alloc] initWithEnumClassName:self.currentEnumClassName];
    self.delegate.protocol = self;
    
    // Initialize: MDKUIList
    self.uiList = [[[NSBundle bundleForClass:[MDKUIList class]] loadNibNamed:MDKUIListIdentifier owner:nil options:nil] firstObject];
    self.uiList.translatesAutoresizingMaskIntoConstraints = NO;
    self.uiList.tableView.layer.cornerRadius = 10.0f;
    self.uiList.tableView.delegate   = self.delegate;
    self.uiList.tableView.dataSource = self.delegate;
    [self.parentNavigationController.view addSubview:self.uiList];
    
    // Perform constraints
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.uiList attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.parentNavigationController.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.uiList attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.parentNavigationController.view  attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.uiList attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.parentNavigationController.view  attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.uiList attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.parentNavigationController.view  attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.parentNavigationController.view addConstraints:@[right, left, bottom, top]];
    
    
    [self.uiList.tableView registerNib:[UINib nibWithNibName:MDKListCellIdentifier bundle:[NSBundle bundleForClass:NSClassFromString(@"MDKListCell")]] forCellReuseIdentifier:MDKListCellIdentifier];

    
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


#pragma mark MDKUIListDelegate implementation

- (void)userDidSelectCell:(NSString *)text {
    [self.uiList dismiss];
    [self updateDisplayFromText:text];
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


#pragma mark - Private methods

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
    NSString *imageName  = [[NSString stringWithFormat:@"enum_%@_%@", self.currentEnumClassName, text] lowercaseString];
    UIImage *image = [UIImage imageNamed:imageName];
    
    if (image) {
        [self.button setTitle:@"" forState:UIControlStateNormal];
        [self.button setImage:image forState:UIControlStateNormal];
    }
    else {
        [self.button setImage:nil forState:UIControlStateNormal];
        [self.button setTitle:text forState:UIControlStateNormal];
    }
}

@end


/******************************************************/
/* INTERNAL/EXTERNAL                                  */
/******************************************************/

@implementation MDKUIExternalEnumList

- (NSString *)defaultXIBName {
    return @"MDKUIEnumList";
}

@end

@implementation MDKUIInternalEnumList @end
