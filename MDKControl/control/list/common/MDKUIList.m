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

#import "MDKUIList.h"
#import "MDKListCell.h"
#import "Helper.h"


#pragma mark - MDKUIList - Keys

/*!
 * @brief The key for MDKUIListIdentifier allowing to name component identifier
 */
NSString *const MDKUIListIdentifier = @"MDK_MDKUIList";


#pragma mark - MDKUIList - Private interface

@interface MDKUIList() <UITableViewDataSource, UITableViewDelegate>

// Model
@property (nonatomic, strong) NSArray *rows;

@end


#pragma mark - MDKUIList - Implementation

@implementation MDKUIList


#pragma mark Life cycle

- (instancetype)initWithEnumClassName:(NSString *)enumClassName {
    self = [super init];
    if (self) {
        [self initializeRowsWithEnumClassName:enumClassName];
    }
    return self;
}

- (void)awakeFromNib {
    [self.tableView registerClass:[MDKListCell class] forCellReuseIdentifier:MDKListCellIdentifier];
//    [self.tableView registerNib:[UINib nibWithNibName:MDKListCellIdentifier bundle:[NSBundle bundleForClass:NSClassFromString(@"MDKUIEnumList")]] forCellReuseIdentifier:MDKListCellIdentifier];
}


#pragma mark Handle user event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}


#pragma mark UITableViewDataSource implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDKListCell *cell = [tableView dequeueReusableCellWithIdentifier:MDKListCellIdentifier];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = self.rows[indexPath.row];
    return cell;
}


#pragma mark UITableViewDelegate implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(userDidSelectCell:)]) {
        [self.delegate userDidSelectCell:self.rows[indexPath.row]];
        [self dismiss];
    }
}


#pragma mark Private methods

- (void) dismiss {
    // Perform animation
    CGRect startFrame = self.tableView.frame;
    CGRect finalFrame = CGRectMake(startFrame.origin.x, self.frame.size.height, startFrame.size.width, startFrame.size.height);
    self.tableView.frame = startFrame;
    
    // Animation
    [UIView animateWithDuration:0.2f delay:0.0f usingSpringWithDamping:10.0f initialSpringVelocity:18.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tableView.frame = finalFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

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
