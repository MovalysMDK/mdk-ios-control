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

#import "MDKUIButton.h"
#import "MDKTheme.h"
#import <objc/runtime.h>



#pragma mark - MDKUIButtonKeyPath: Implementation

@implementation MDKUIButtonKeyPath
@end



#pragma mark - MDKUIButton: Implementation

@implementation MDKUIButton


#pragma mark Initialization and deallocation

- (instancetype)init {
    self = [super init];
    if(self) { [self initializeComponent]; }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) { [self initializeComponent]; }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) { [self initializeComponent]; }
    return self;
}

- (void)initializeComponent {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setTitle:self.keyPath.title forState:UIControlStateNormal];
    });
    [[MDKTheme sharedTheme] applyThemeOnMDKUIButton:self];
}



const void *mdkuibuttonKeyPath = &mdkuibuttonKeyPath;



#pragma mark Public API

- (MDKUIButtonKeyPath *)keyPath {
    // Retrieve key path available on storyboard or xib
    MDKUIButtonKeyPath *keyPath = objc_getAssociatedObject(self, &mdkuibuttonKeyPath);
    
    if (!keyPath) { // If key path does not exist -> initialize value
        keyPath = [[MDKUIButtonKeyPath alloc] init];
        objc_setAssociatedObject(self, &mdkuibuttonKeyPath, keyPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return keyPath;
}


@end
