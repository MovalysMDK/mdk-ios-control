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

@interface MDKUIFixedList ()

@property (nonatomic, strong) NSMutableArray *source;

@end


@implementation MDKUIFixedList

#pragma mark - Initialization and deallocation

-(void)initialize {
    [super initialize];
//    self.source = [NSMutableArray array];
}

-(void)didInitializeOutlets {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}


#pragma mark - Control Data protocol
+(NSString *)getDataType {
    return @"NSArray";
}

-(void)setData:(id)data {
    if(data) {
        self.source = [data mutableCopy];
        [self setDisplayComponentValue:(NSArray *)data];
    }
    [super setData:data];
}

-(id)getData {
    return [self displayComponentValue];
}

-(id)displayComponentValue {
    return self.source;
}

-(void)setDisplayComponentValue:(id)value {
    [self.tableView reloadData];
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