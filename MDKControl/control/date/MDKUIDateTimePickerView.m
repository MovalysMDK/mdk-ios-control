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

#import "MDKUIDateTimePickerView.h"
#import "MDKUIDateTime.h"

@implementation MDKUIDateTimePickerView

-(void)drawRect:(CGRect)rect {
    self.contentView.layer.cornerRadius = 10;
    self.contentView.clipsToBounds = YES;
}

-(void) dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)didCancel:(id)sender {
    [self dismiss];
}

- (IBAction)didSelectDate:(id)sender {
    [self.sourceComponent setData:self.datePicker.date];
    [self dismiss];
}


-(void) refreshWithDate:(NSDate *)date andMode:(MDKDateTimeMode)mode {
    self.datePicker.date = date;
    [self setDateTimeMode:mode];
}


-(void)setDateTimeMode:(int)dateTimeMode {
    switch(dateTimeMode) {
        case MDKDateTimeModeDate :
            self.datePicker.datePickerMode = UIDatePickerModeDate;
            break;
        case MDKDateTimeModeTime :
            self.datePicker.datePickerMode = UIDatePickerModeTime;
            break;
        case MDKDateTimeModeDateTime :
            self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            break;
        default:
            self.datePicker.datePickerMode = UIDatePickerModeDate;
            break;
    }

}

@end
