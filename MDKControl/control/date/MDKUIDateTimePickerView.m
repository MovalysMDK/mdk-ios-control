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

- (void) dismiss {
    // Perform animation
    CGRect startFrame = self.frame;
    CGRect finalFrame = CGRectMake(startFrame.origin.x, self.frame.size.height, startFrame.size.width, startFrame.size.height);
    self.frame = startFrame;
    
    // Animation
    [UIView animateWithDuration:0.2f delay:0.0f usingSpringWithDamping:10.0f initialSpringVelocity:18.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = finalFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)didCancel:(id)sender {
    [self dismiss];
}

- (IBAction)didSelectDate:(id)sender {
    [self.sourceComponent setData:self.datePicker.date];
    [self.sourceComponent valueChanged:self.sourceComponent.dateButton];
    [self dismiss];
}


- (void) refreshWithDate:(NSDate *)date andMode:(MDKDateTimeMode)mode {
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
