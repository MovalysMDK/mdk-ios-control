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

#import "MDKSignaturePopupView.h"
#import "MDKUISignature.h"
#import "MDKSignatureHelper.h"

@implementation MDKSignaturePopupView

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

- (IBAction)onValidateButtonClick:(id)sender {
    NSMutableArray *data = nil;
    if(self.signatureDrawing.signaturePath.count > 0 ) {
        data = [self.signatureDrawing.signaturePath mutableCopy];
    }
    
    NSString *controlData = [MDKSignatureHelper convertFromLinesToString:data width:self.signatureDrawing.bounds.size.width originX:0 originY:0];
    [self.sourceControl setData:controlData];
    [self dismiss];
    [self.sourceControl valueChanged:self.sourceControl.signatureView];
}

- (IBAction)onCancelButtonClick:(id)sender {
    [self dismiss];
}

- (IBAction)onDeleteButtonClick:(id)sender {
    [self.signatureDrawing clear];
}

@end
