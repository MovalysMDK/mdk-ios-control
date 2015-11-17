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

#import "MDKDelegateList.h"
#import "MDKListCell.h"
#import "Helper.h"


@interface MDKDelegateList()

// Model
@property (nonatomic, strong) NSArray *rows;

@end


@implementation MDKDelegateList



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
    return self.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDKListCell *cell = [tableView dequeueReusableCellWithIdentifier:MDKListCellIdentifier];
//    [cell updateCellWithText:self.rows[indexPath.row]];
    cell.textLabel.text = self.rows[indexPath.row];
    return cell;
}


#pragma mark Private API

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
- (void)initializeRowsWithEnumClassName:(NSString *)enumClassName {
    NSString *sEnumClassHelperName = [MDKHelperType getClassHelperOfClassWithKey:enumClassName];
    Class cEnumHelper              = NSClassFromString(sEnumClassHelperName);
    if ([cEnumHelper respondsToSelector:@selector(valuesToTexts)]) {
        self.rows = [NSArray arrayWithArray:[cEnumHelper performSelector:@selector(valuesToTexts) withObject:nil]];
    }
}
#pragma clang diagnostic pop

@end
