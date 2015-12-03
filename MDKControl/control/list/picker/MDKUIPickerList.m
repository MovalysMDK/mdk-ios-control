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
#import "Protocol.h"
#import "Helper.h"


#pragma mark - MDKUIPickerList - Keys

/*!
 * @brief The key for MDKUIPickerListKey allowing to handle external delegate
 */
NSString *const MDKUIPickerListDelegateKey = @"listItemBindingDelegate";

/*!
 * @brief The key for MDKUIPickerSelectedKey allowing to handle external delegate
 */
NSString *const MDKUIPickerSelectedDelegateKey = @"selectedItemBindingDelegate";



#pragma mark - MDKUIPickerList - Implementation
@implementation MDKUIPickerList
@synthesize targetDescriptors = _targetDescriptors;
@synthesize selectedView = _selectedView;




#pragma mark - Initialization and deallocation

- (void)initialize {
    [super initialize];
}

- (void)didInitializeOutlets {}

#pragma mark - Control Data protocol

+ (NSString *)getDataType {
    return @"NSObject";
}

- (void)setData:(id)data {
    if (data) {
        [self validate];
        [self setDisplayComponentValue:data];
    }
    
    if([self.userSelectedDelegate respondsToSelector:@selector(computeCellHeightAndDispatchToFormController)]) {
        [self.userSelectedDelegate performSelector:@selector(computeCellHeightAndDispatchToFormController)];
    }
    
    [super setData:data];
}

-(NSString *)controlName {
    return @"MDKPickerList";
}


- (id)getData {
    return self.controlData;
}

- (void)setDisplayComponentValue:(id)value {
    if (!self.controlAttributes[MDKUIPickerSelectedDelegateKey]) {
        return;
    }
    self.userSelectedDelegate = [[NSClassFromString(self.controlAttributes[MDKUIPickerSelectedDelegateKey]) alloc] initWithPickerList:self];
    [self.userSelectedDelegate mappXibViewWithObject:value];
}


#pragma mark - Control Attributes

-(void)setControlAttributes:(NSDictionary *)controlAttributes {
    [super setControlAttributes:controlAttributes];
    
    //Get the delegate used to display the selected item
    NSString *selectedItemBindingDelegate = controlAttributes[@"selectedItemBindingDelegate"];
    if(selectedItemBindingDelegate && !self.userSelectedDelegate) {
        self.userSelectedDelegate = [[NSClassFromString(selectedItemBindingDelegate) alloc] initWithPickerList:self];
        NSString *stringAssert = [NSString stringWithFormat:@"You must implement MDKUIPickerSelectedDelegateKey for %@", self.controlAttributes[MDKUIPickerSelectedDelegateKey]];
        NSAssert([self.userSelectedDelegate conformsToProtocol:@protocol(MDKUIPickerSelectedDataProtocol)], stringAssert);
    }
    else {
        self.userSelectedDelegate.picker = self;
    }
    
    
    //Get the delegate used to display the list of items
    NSString *listItemBindingDelegate = controlAttributes[@"listItemBindingDelegate"];
    if(listItemBindingDelegate && !self.userListDelegate) {
        self.userListDelegate = [[NSClassFromString(listItemBindingDelegate) alloc] initWithPickerList:self];
        NSString *stringAssert = [NSString stringWithFormat:@"You must implement MDKUIPickerListDataProtocol for %@", self.controlAttributes[MDKUIPickerSelectedDelegateKey]];
        NSAssert([self.userListDelegate conformsToProtocol:@protocol(MDKUIPickerListDataProtocol)], stringAssert);
    }
    else {
        self.userListDelegate.picker = self;
    }
    
    //        NSString *filter = controlAttributes[@"filter"];
    //        if(filter && !self.mf.filter) {
    //            self.mf.filter = [NSClassFromString(filter) new];
    //            self.userListDelegate.filter = self.mf.filter;
    //        }
    //
}


#pragma mark - Control changes
-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    MDKControlEventsDescriptor *commonCCTD = [MDKControlEventsDescriptor new];
    commonCCTD.target = target;
    commonCCTD.action = action;
    self.targetDescriptors = @{@(self.button.hash) : commonCCTD};
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"
-(void) valueChanged:(UIView *)sender {
    MDKControlEventsDescriptor *cctd = self.targetDescriptors[@(sender.hash)];
    [cctd.target performSelector:cctd.action withObject:self];
}
#pragma clang diagnostic pop


#pragma mark - Handle user event
- (IBAction)userDidTapOnButton:(id)sender {
    [self initializeMDKUIList];
    [self performConstraintsForUiList];
    [self initializeAnimationForAppearing];
}

- (void)initializeMDKUIList {
    if([self.userListDelegate respondsToSelector:@selector(willDisplayPickerListView)]) {
        [self.userListDelegate performSelector:@selector(willDisplayPickerListView)];
    }
    NSString *xibIdentifier = MDKUIListIdentifier;
    if([self.controlAttributes[PICKER_PARAMETER_SEARCH_KEY] boolValue]) {
        xibIdentifier = MDKUIListWithSearchIdentifier;
    }
    self.uiList = [[[NSBundle bundleForClass:[MDKUIList class]] loadNibNamed:xibIdentifier owner:nil options:nil] firstObject];
    self.uiList.searchBar.delegate = self.userListDelegate;
    self.uiList.translatesAutoresizingMaskIntoConstraints   = NO;
    self.uiList.tableView.layer.cornerRadius                = 10.0f;
    self.uiList.tableView.delegate                          = self.userListDelegate;
    self.uiList.tableView.dataSource                        = self.userListDelegate;
    
    //If delegate owns a table view, set the uilist tableView
    self.userListDelegate.list = self.uiList;
    
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


#pragma mark - Manage the selected View

-(UIView *)selectedView {
    id result = _selectedView;
    if([self conformsToProtocol:@protocol(MDKExternalComponent)]) {
        result = [self.internalView performSelector:@selector(selectedView)];
    }
    return result;
    
}

-(void)setSelectedView:(UIView *)selectedView {
    if([self conformsToProtocol:@protocol(MDKInternalComponent)]) {
        if(!_selectedView || ![_selectedView isEqual:selectedView]) {
            if(_selectedView) {
                [_selectedView removeFromSuperview];
            }
            _selectedView = selectedView;
            _selectedView.backgroundColor = [UIColor clearColor];
            
            [self setNeedsDisplay];
            //Dans la vue sélectionnée, les champs ne sont pas éditables
            for(UIView * view in selectedView.subviews) {
                view.userInteractionEnabled = NO;
            }
            [self addSubview:_selectedView];
            [_selectedView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self bringSubviewToFront:self.button];
            
            [self addCustomConstraints];
            [self updateConstraints];
        }
    }
    else {
        [self.internalView performSelector:@selector(setSelectedView:) withObject:selectedView];
    }
}

-(void) addCustomConstraints {
    if(self.selectedView) {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.selectedView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.selectedView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.selectedView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.selectedView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        
        [self addConstraints:@[topConstraint, leftConstraint, rightConstraint, bottomConstraint]];
        
    }
}


-(NSInteger)validate {
    NSInteger result = [super validate];
    return result;
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




/******************************************************/
/* FILTER                                             */
/******************************************************/
@implementation MDKPickerListDefaultFilter

-(NSArray *)filterItems:(NSArray *)items withString:(NSString *)string {
    NSMutableArray *result = [NSMutableArray array];
    for(id object in items) {
        if([object respondsToSelector:@selector(getBindedProperties)]) {
            for(NSString *bindedProtperty in [object performSelector:@selector(getBindedProperties)]) {
                id object = [object valueForKey:bindedProtperty];
                if([object isKindOfClass:[NSString class]]) {
                    if([(NSString *)object containsString:string]) {
                        [result addObject:object];
                        break;
                    }
                }
            }
        }
    }
    return result;
}



@end
