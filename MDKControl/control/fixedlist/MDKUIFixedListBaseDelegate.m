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

#import "MDKUIFixedListBaseDelegate.h"

@interface MDKUIFixedListBaseDelegate ()

@property (nonatomic, strong) MDKUIFixedList *fixedList;

@end

@implementation MDKUIFixedListBaseDelegate

-(instancetype)initWithFixedList:(MDKUIFixedList *)fixedList {
    self = [super init];
    if(self) {
        self.fixedList = fixedList;        
    }
    return self;
}

-(NSInteger)fixedList:(MDKUIFixedList *)fixedList numberOfRows:(NSInteger)totalNumberOfRows {
    return totalNumberOfRows;
}

-(void)fixedList:(MDKUIFixedList *)fixedList mapCell:(UITableViewCell *)cell withObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    //Default does notinhg
}

-(CGFloat)fixedList:(MDKUIFixedList *)fixedList heightForFixedListCells:(NSInteger)originalCellHeight {
    return originalCellHeight;
}

-(NSString *)xibNameForFixedListCells {
    return nil;
}


-(void)fixedList:(MDKUIFixedList *)fixedList didSelectRowAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    //Default does nothing
}

-(void)fixedList:(MDKUIFixedList *)fixedList didDeleteRowAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    //Default does nothing
}

-(void)fixedList:(MDKUIFixedList *)fixedList willDeleteRowAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    //Default does notinhg
}

-(void)fixedList:(MDKUIFixedList *)fixedList addItemFromSender:(id)sender {
    // Default does nothing
}
@end
