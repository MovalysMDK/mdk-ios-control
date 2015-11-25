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

@property (nonatomic) BOOL canMove;
@property (nonatomic) BOOL canDelete;
@property (nonatomic) BOOL canSelect;

@property (nonatomic) BOOL hasRegisterNib;

@end

@implementation MDKUIFixedListTableViewDelegate

#pragma mark - Initialization

-(instancetype)initWithFixedList:(MDKUIFixedList *)fixedList {
    self = [super init];
    if(self) {
        
        //Intiailization
        self.fixedList = fixedList;
        self.cellHeight = CGFLOAT_MIN;
        self.hasRegisterNib = NO;
        [[self.fixedList tableView] setEditing:YES animated:YES];
    }
    return self;
}


#pragma mark - Custom Methods

/**
 * @brief This method is used to refresh the edition properties of the tableView in the FixedList.
 */
-(void)refreshEditionProperties {
    [self.fixedList.tableView beginUpdates];
    self.canMove = [self.fixedList.controlAttributes[FIXEDLIST_PARAMETER_CAN_MOVE_KEY] isEqualToNumber:@1];
    self.canDelete = [self.fixedList.controlAttributes[FIXEDLIST_PARAMETER_CAN_DELETE_KEY] isEqualToNumber:@1];
    self.canSelect = [self.fixedList.controlAttributes[FIXEDLIST_PARAMETER_CAN_SELECT_KEY] isEqualToNumber:@1];
    self.fixedList.tableView.editing = self.canDelete || self.canMove;
    [self.fixedList.tableView endUpdates];
}

/**
 * @brief Register the nib used to re-use cells if not already done
 */
-(void) registerNibWithCellIdentifier:(NSString *)cellIdentifier {
    
    //If a register hasn't already done, do it.
    if(cellIdentifier && !self.hasRegisterNib) {
        [self.fixedList.tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
        self.hasRegisterNib = YES;
    }
}

#pragma mark - TableView DataSource & Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [self registerNibWithCellIdentifier:[[self.fixedList fixedListDelegate] xibNameForFixedListCells]];
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger totalNumberOfRows = [[self.fixedList getData] count];
    return [[self.fixedList fixedListDelegate] fixedList:self.fixedList numberOfRows:totalNumberOfRows];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44.0f;
    if(self.cellHeight == CGFLOAT_MIN) {
        if([[self.fixedList fixedListDelegate] xibNameForFixedListCells]) {
            UITableViewCell *aCell = [[[NSBundle bundleForClass:NSClassFromString(@"AppDelegate")]
                                       loadNibNamed:[[self.fixedList fixedListDelegate] xibNameForFixedListCells]
                                       owner:self
                                       options:nil] firstObject];
            self.cellHeight = aCell.frame.size.height;
        }
    }
    else {
        height = self.cellHeight;
    }
    return [[self.fixedList fixedListDelegate] fixedList:self.fixedList heightForFixedListCells:height];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    id object = [self.fixedList getData][indexPath.row];
    
    //Get a cell : if a delegate specifies a custom XIB, use it, otherwhise use a default cell
    if([[self.fixedList fixedListDelegate] xibNameForFixedListCells]) {
        //Try to dequeue a reusable cell
        cell = [tableView dequeueReusableCellWithIdentifier:[[self.fixedList fixedListDelegate] xibNameForFixedListCells]];
        if(!cell) {
            cell = [[[NSBundle bundleForClass:NSClassFromString(@"AppDelegate")]
                     loadNibNamed:[[self.fixedList fixedListDelegate] xibNameForFixedListCells]
                     owner:self
                     options:nil] firstObject];
        }
    }
    else {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    
    //map the cell to the data for the given indexPath
    [[self.fixedList fixedListDelegate] fixedList:self.fixedList mapCell:cell withObject:object atIndexPath:indexPath];
    cell.showsReorderControl = YES;
    
    //Selection state of the current cell
    if(self.canSelect) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.canDelete) {
        return UITableViewCellEditingStyleDelete;
    }
    else {
        return UITableViewCellEditingStyleNone;
    }
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.canDelete;
}


- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.canMove;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSMutableArray *mutableData = [[self.fixedList getData] mutableCopy];
    id retainObject = mutableData[sourceIndexPath.row];
    [mutableData removeObjectAtIndex:sourceIndexPath.row];
    [mutableData insertObject:retainObject atIndex:destinationIndexPath.row];
    [self.fixedList setData:mutableData];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        id object = [self.fixedList getData][indexPath.row];
        [[self.fixedList fixedListDelegate] fixedList:self.fixedList willDeleteRowAtIndexPath:indexPath withObject:object];
        NSMutableArray *mutableData = [[self.fixedList getData] mutableCopy];
        [mutableData removeObjectAtIndex:indexPath.row];
        [self.fixedList setControlData:mutableData];
        [[self.fixedList fixedListDelegate] fixedList:self.fixedList didDeleteRowAtIndexPath:indexPath withObject:object];
    }
    [tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[self.fixedList fixedListDelegate] fixedList:self.fixedList didSelectRowAtIndexPath:indexPath withObject:[self.fixedList getData][indexPath.row]];
    
}


@end
