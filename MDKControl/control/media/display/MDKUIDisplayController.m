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


#import "MDKUIDisplayController.h"


#pragma mark - MDKUIDisplayController - Private interface

@interface MDKUIDisplayController ()

@property (nonatomic, strong) UIImage *image;

@end


#pragma mark - MDKUIDisplayController - Implementation

@implementation MDKUIDisplayController


#pragma mark Life cycle

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle image:(UIImage *)image {
    self = [super initWithNibName:nibName bundle:bundle];
    if (self) {
        self.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image       = self.image;
    self.deleteButton.hidden = !self.isEditable;
}


#pragma mark Handle user event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)didTapOnDeleteButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(userDeletePicture)]) {
        [self.delegate userDeletePicture];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
