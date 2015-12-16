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


#import "MDKDelegateEnumList.h"
#import "MDKUIList.h"
#import "MDKListCell.h"
#import "Helper.h"
#import "Protocol.h"

#pragma mark - MDKDelegateEnumList - Private interface

@interface MDKDelegateEnumList()

// Model
@property (nonatomic, strong) NSArray *rows;

//EnumHelper
@property (nonatomic, strong) Class<MDKEnumHelperProtocol> enumHelper;


@end


#pragma mark - MDKDelegateEnumList - Implementation

@implementation MDKDelegateEnumList


#pragma mark - Life cycle

- (instancetype)initWithEnumClassName:(NSString *)enumClassName {
    self = [super init];
    if (self) {
        [self initializeRowsWithEnumClassName:enumClassName];
    }
    return self;
}


#pragma mark UITableViewDataSource implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CGRect rect = tableView.frame;
    rect.size.height = 44*self.rows.count;
    tableView.frame = rect;
    return self.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDKListCell *cell   = [tableView dequeueReusableCellWithIdentifier:MDKListCellIdentifier forIndexPath:indexPath];
    [cell updateCellWithText:self.rows[ indexPath.row ]];
    
    if([[self.sourceControl getData] isEqualToNumber:@([self.enumHelper enumFromText:self.rows[ indexPath.row ]])]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}


#pragma mark UITableViewDelegate implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.sourceControl respondsToSelector:@selector(userDidSelectCell:)]) {
        [self.sourceControl userDidSelectCell:self.rows[indexPath.row]];
    }
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
- (void)initializeRowsWithEnumClassName:(NSString *)enumClassName {
    NSString *sEnumClassHelperName = [MDKHelperType getClassHelperOfClassWithKey:enumClassName];
    self.enumHelper = NSClassFromString(sEnumClassHelperName);
    self.rows = [NSArray arrayWithArray:[self.enumHelper valuesToTexts]];
}
#pragma clang diagnostic pop

@end
