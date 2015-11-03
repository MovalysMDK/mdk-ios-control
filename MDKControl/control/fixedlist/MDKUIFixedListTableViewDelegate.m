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

#import "MDKUIFixedListTableViewDelegate.h"
#import "MDKUIFixedList.h"

@interface MDKUIFixedListTableViewDelegate ()

@property (nonatomic, weak) MDKUIFixedList *fixedList;

@property (nonatomic) CGFloat cellHeight;

@end

@implementation MDKUIFixedListTableViewDelegate

#pragma mark - Initialization

-(instancetype)initWithFixedList:(MDKUIFixedList *)fixedList {
    self = [super init];
    if(self) {
        self.fixedList = fixedList;
        self.cellHeight = CGFLOAT_MIN;
    }
    return self;
}


#pragma mark - TableView DataSource & Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger totalNumberOfRows = [[self.fixedList getData] count];
    return [[self.fixedList fixedListeDelegate] fixedList:self.fixedList numberOfRows:totalNumberOfRows];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44.0f;
    if(self.cellHeight == CGFLOAT_MIN) {
        if([[self.fixedList fixedListeDelegate] xibNameForFixedListCells]) {
            UITableViewCell *aCell = [[[NSBundle bundleForClass:NSClassFromString(@"AppDelegate")]
                                       loadNibNamed:[[self.fixedList fixedListeDelegate] xibNameForFixedListCells]
                                       owner:self
                                       options:nil] firstObject];
            self.cellHeight = aCell.frame.size.height;
        }
    }
    else {
        height = self.cellHeight;
    }
    return [[self.fixedList fixedListeDelegate] fixedList:self.fixedList heightForFixedListCells:height];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    id object = [self.fixedList getData][indexPath.row];
    
    //No re-use in fixedList
    if([[self.fixedList fixedListeDelegate] xibNameForFixedListCells]) {
        cell = [[[NSBundle bundleForClass:NSClassFromString(@"AppDelegate")]
                 loadNibNamed:[[self.fixedList fixedListeDelegate] xibNameForFixedListCells]
                 owner:self
                 options:nil] firstObject];
    }
    else {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    [[self.fixedList fixedListeDelegate] fixedList:self.fixedList mapCell:cell withObject:object atIndexPath:indexPath];
    return cell;
}

@end
