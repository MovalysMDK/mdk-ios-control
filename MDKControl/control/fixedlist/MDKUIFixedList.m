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


NSString *const FIXEDLIST_PARAMETER_DATA_DELEGATE_KEY = @"dataDelegate";
NSString *const FIXEDLIST_PARAMETER_CAN_MOVE_KEY = @"canMove";
NSString *const FIXEDLIST_PARAMETER_CAN_DELETE_KEY = @"canDelete";
NSString *const FIXEDLIST_PARAMETER_CAN_SELECT_KEY = @"canSelect";


@interface MDKUIFixedList ()

@property (nonatomic, strong) MDKUIFixedListTableViewDelegate *tableDelegate;
@property (nonatomic, strong) id<MDKUIFixedListDataProtocol> privateFixedListDataDelegate;
@property (nonatomic, strong) id<MDKUIFixedListDataProtocol> baseFixedListDelegate;

@end


@implementation MDKUIFixedList

#pragma mark - Initialization and deallocation

-(void)initialize {
    [super initialize];
}

-(void)didInitializeOutlets {
    self.baseFixedListDelegate = [[MDKUIFixedListBaseDelegate alloc] init];
    self.tableDelegate = [[MDKUIFixedListTableViewDelegate alloc] initWithFixedList:self];
    self.tableView.delegate = self.tableDelegate;
    self.tableView.dataSource = self.tableDelegate;
    [self.addButton addTarget:self.privateFixedListDataDelegate action:@selector(addItemOnFixedList:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Control Data protocol
+(NSString *)getDataType {
    return @"NSArray";
}

-(void)setData:(id)data {
    if(data) {
        [self setDisplayComponentValue:(NSArray *)data];
    }
    [super setData:data];
}

-(id)getData {
    return [self displayComponentValue];
}

-(id)displayComponentValue {
    return self.controlData;
}

-(void)setDisplayComponentValue:(id)value {
    [self.tableView reloadData];
}

-(void)setControlAttributes:(NSDictionary *)controlAttributes {
    [super setControlAttributes:controlAttributes];
    [self.tableDelegate refreshEditionProperties];
}

-(id<MDKUIFixedListDataProtocol>) fixedListDelegate {
    if(!_privateFixedListDataDelegate) {
        if(self.controlAttributes[FIXEDLIST_PARAMETER_DATA_DELEGATE_KEY]) {
            id object = [[NSClassFromString(self.controlAttributes[FIXEDLIST_PARAMETER_DATA_DELEGATE_KEY]) alloc] init];
            _privateFixedListDataDelegate = object;
        }
        else {
            return self.baseFixedListDelegate;
        }
    }
    return _privateFixedListDataDelegate;
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