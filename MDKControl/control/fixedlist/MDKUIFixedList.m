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

#import "MDKUIFixedList.h"
#import "MDKUIFixedListTableViewDelegate.h"
#import "MDKUIFixedListBaseDelegate.h"
#import "Theme.h"



NSString *const FIXEDLIST_PARAMETER_DATA_DELEGATE_KEY = @"dataDelegate";
NSString *const FIXEDLIST_PARAMETER_CAN_MOVE_KEY = @"canMove";
NSString *const FIXEDLIST_PARAMETER_CAN_DELETE_KEY = @"canDelete";
NSString *const FIXEDLIST_PARAMETER_CAN_SELECT_KEY = @"canSelect";
NSString *const FIXEDLIST_PARAMETER_IS_PHOTO_KEY = @"isPhotoFixedList";


@interface MDKUIFixedList ()

@property (nonatomic, strong) MDKUIFixedListTableViewDelegate *tableDelegate;
@property (nonatomic, strong) id<MDKUIFixedListDataProtocol> privateFixedListDataDelegate;
@property (nonatomic, strong) id<MDKUIFixedListDataProtocol> baseFixedListDelegate;

@end


@implementation MDKUIFixedList
@synthesize targetDescriptors = _targetDescriptors;

#pragma mark - Initialization and deallocation

-(void)initialize {
    [super initialize];
}

-(void)didInitializeOutlets {
    [super didInitializeOutlets];
    [[MDKTheme sharedTheme] applyThemeOnMDKFixedListAddButton:self.addButton];
    
    self.baseFixedListDelegate = [[MDKUIFixedListBaseDelegate alloc] init];
    self.tableDelegate = [[MDKUIFixedListTableViewDelegate alloc] initWithFixedList:self];
    self.tableView.delegate = self.tableDelegate;
    self.tableView.dataSource = self.tableDelegate;
    self.tableView.scrollEnabled = NO;
}



#pragma mark - Control Data protocol
+(NSString *)getDataType {
    return @"NSArray";
}

-(void)setData:(id)data {
    [super setData:data];
    
    //Must be executed after super setData to adapt the tableView size to the current data
    if(data) {
        [self setDisplayComponentValue:(NSArray *)data];
    }
}

-(id)getData {
    return [self displayComponentValue];
}

-(id)displayComponentValue {
    return self.controlData;
}

-(void)setDisplayComponentValue:(id)value {
    [self.tableView reloadData];
    if([[self fixedListDelegate] respondsToSelector:@selector(computeCellHeightAndDispatchToFormController)]) {
        [[self fixedListDelegate] performSelector:@selector(computeCellHeightAndDispatchToFormController)];
    }
}

#pragma mark - Control Attributes

-(void)setControlAttributes:(NSDictionary *)controlAttributes {
    [super setControlAttributes:controlAttributes];
    [self.addButton setTitle:NSLocalizedStringFromTableInBundle(controlAttributes[@"title"], @"Localizable-project", [NSBundle bundleForClass:NSClassFromString(@"AppDelegate")], nil) forState:UIControlStateNormal];
    [self.addButton setImage:[UIImage imageNamed:@"fixedlist_add"inBundle:[NSBundle bundleForClass:MDKUIFixedList.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    CGSize size = [[self.addButton titleForState:UIControlStateNormal] sizeWithFont:self.addButton.titleLabel.font];
    self.addButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -size.width);
    self.addButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, self.addButton.imageView.image.size.width + 16);
    [self.tableDelegate refreshEditionProperties];
}


#pragma mark - FixedList Data Delegate
-(id<MDKUIFixedListDataProtocol>) fixedListDelegate {
    if(!_privateFixedListDataDelegate) {
        if(self.controlAttributes[FIXEDLIST_PARAMETER_DATA_DELEGATE_KEY]) {
            id object = [[NSClassFromString(self.controlAttributes[FIXEDLIST_PARAMETER_DATA_DELEGATE_KEY]) alloc] initWithFixedList:self];
            _privateFixedListDataDelegate = object;
        }
        else {
            return self.baseFixedListDelegate;
        }
    }
    return _privateFixedListDataDelegate;
}



#pragma mark - Control changes
-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    MDKControlEventsDescriptor *commonCCTD = [MDKControlEventsDescriptor new];
    commonCCTD.target = target;
    commonCCTD.action = action;
    self.targetDescriptors = @{@(self.tableView.hash) : commonCCTD};
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"
-(void) valueChanged:(UIView *)sender {
    MDKControlEventsDescriptor *cctd = self.targetDescriptors[@(sender.hash)];
    [cctd.target performSelector:cctd.action withObject:self];
}
#pragma clang diagnostic pop


#pragma mark - Add Item action
- (IBAction)addButtonAction:(id)sender {
    [[self fixedListDelegate] fixedList:self addItemFromSender:sender];
}

-(BOOL)isPhotoFixedList {
    return [self.controlAttributes[FIXEDLIST_PARAMETER_IS_PHOTO_KEY] isEqualToNumber:@1];
}

-(NSInteger)validate {
    return [super validate];
}

-(void)setTintColor:(UIColor *)tintColor {
    self.addButton.tintColor = tintColor;
    [super setTintColor:tintColor];
}
@end



/******************************************************/
/* INTERNAL/EXTERNAL                                  */
/******************************************************/

@implementation MDKUIExternalFixedList

-(NSString *)defaultXIBName {
    return @"MDKUIFixedList";
}

@end

@implementation MDKUIInternalFixedList @end