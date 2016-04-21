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


#import "MDKTheme.h"



#pragma mark - MDKTheme: Private interface

@interface MDKTheme()

// Model
@property (nonatomic) NSMutableArray *userThemes;

@end



#pragma mark - MDKTheme: Implementation

@implementation MDKTheme



#pragma mark Life cycle

+ (MDKTheme *)sharedTheme {
    static dispatch_once_t onceToken;
    static MDKTheme *sharedTheme = nil;
    dispatch_once(&onceToken, ^{
        sharedTheme = [MDKTheme new];
    });
    return sharedTheme;
}

- (id)init {
    self = [super init];
    if (self) {
        self.userThemes = [NSMutableArray array];
        
        [self checkPresenceOfUserTheme];
    }
    return self;
}



#pragma mark MDKThemeDelegate implemenatation

- (void)applyThemeOnStatusBar {
    if ([self checkIfAnotherThemeAlreadyExist]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (id userTheme in self.userThemes) {
                if ([userTheme respondsToSelector:@selector(applyThemeOnStatusBar)]) {
                    [userTheme performSelector:@selector(applyThemeOnStatusBar) withObject:nil];
                }
                else {
                    // Nothing
                }
            }
        });
    }
}

- (void)applyThemeOnNavigationBar:(UIViewController *)controller {
    if ([self checkIfAnotherThemeAlreadyExist]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (id userTheme in self.userThemes) {
                if ([userTheme respondsToSelector:@selector(applyThemeOnNavigationBar:)]) {
                    [userTheme performSelector:@selector(applyThemeOnNavigationBar:) withObject:controller];
                }
                else {
                    // Nothing
                }
            }
        });
    }
}

- (void)applyThemeOnMDKUIButton:(MDKUIButton *)button {
    if ([self checkIfAnotherThemeAlreadyExist]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (id userTheme in self.userThemes) {
                if ([userTheme respondsToSelector:@selector(applyThemeOnMDKUIButton:)]) {
                    [userTheme performSelector:@selector(applyThemeOnMDKUIButton:) withObject:button];
                }
                else {
                    [self standardThemeForMDKUIButton:button];
                }
            }
        });
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self standardThemeForMDKUIButton:button];
    });
    
}

- (void)applyThemeOnUITableViewCell:(UITableViewCell *)cell {
    if ([self checkIfAnotherThemeAlreadyExist]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (id userTheme in self.userThemes) {
                if ([userTheme respondsToSelector:@selector(applyThemeOnUITableViewCell:)]) {
                    [userTheme performSelector:@selector(applyThemeOnUITableViewCell:) withObject:cell];
                }
                else {
                    // Nothing
                }
            }
        });
    }
}

- (void)applyThemeOnUIButton:(UIButton *)button {
    if ([self checkIfAnotherThemeAlreadyExist]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (id userTheme in self.userThemes) {
                if ([userTheme respondsToSelector:@selector(applyThemeOnUIButton:)]) {
                    [userTheme performSelector:@selector(applyThemeOnUIButton:) withObject:button];
                }
                else {
                    // Nothing
                }
            }
        });
    }
}

- (void)applyThemeOnMDKFixedListAddButton:(UIButton *)button {
    if ([self checkIfAnotherThemeAlreadyExist]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (id userTheme in self.userThemes) {
                if ([userTheme respondsToSelector:@selector(applyThemeOnMDKFixedListAddButton:)]) {
                    [userTheme performSelector:@selector(applyThemeOnMDKFixedListAddButton:) withObject:button];
                }
                else {
                    // Nothing
                }
            }
        });
    }
}

- (void)applyThemeOnMDKFloatingButton:(UIButton *)button {
    if ([self checkIfAnotherThemeAlreadyExist]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (id userTheme in self.userThemes) {
                if ([userTheme respondsToSelector:@selector(applyThemeOnMDKFloatingButton:)]) {
                    [userTheme performSelector:@selector(applyThemeOnMDKFloatingButton:) withObject:button];
                }
                else {
                    // Nothing
                }
            }
        });
    }
}

- (void)applyThemeOnMDKUITextField:(MDKTextField *)textField {
    if ([self checkIfAnotherThemeAlreadyExist]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (id userTheme in self.userThemes) {
                if ([userTheme respondsToSelector:@selector(applyThemeOnMDKUITextField:)]) {
                    [userTheme performSelector:@selector(applyThemeOnMDKUITextField:) withObject:textField];
                }
                else {
                    // Nothing
                }
            }
        });
    }
}

- (void)applyThemeOnMDKLabel:(MDKLabel *)label {
    if ([self checkIfAnotherThemeAlreadyExist]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (id userTheme in self.userThemes) {
                if ([userTheme respondsToSelector:@selector(applyThemeOnMDKLabel:)]) {
                    [userTheme performSelector:@selector(applyThemeOnMDKLabel:) withObject:label];
                }
                else {
                    // Nothing
                }
            }
        });
    }
}

- (void)applyThemeOnMDKUIAlertController:(MDKUIAlertController *)alertController {
    if ([self checkIfAnotherThemeAlreadyExist]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (id userTheme in self.userThemes) {
                if ([userTheme respondsToSelector:@selector(applyThemeOnMDKUIAlertController:)]) {
                    [userTheme performSelector:@selector(applyThemeOnMDKUIAlertController:) withObject:alertController];
                }
                else {
                    // Nothing
                }
            }
        });
    }
}



#pragma mark Private API

- (void)checkPresenceOfUserTheme {
    NSDictionary *themeDictionary = [self themeDictionary];     // Initialize
    
    // Exits ?
    if (!themeDictionary) { return; }
    
    // Add user theme: if conform MDKThemeDelegate and not contains in userThemes
    for (NSString *className in themeDictionary.allValues) {
        id userTheme = [NSClassFromString(className) new];
        if ([userTheme conformsToProtocol:@protocol(MDKThemeDelegate)] && ![self.userThemes containsObject:userTheme]) {
            [self.userThemes addObject:userTheme];
        }
    }
}

- (BOOL)checkIfAnotherThemeAlreadyExist {
    return ( self.userThemes.count > 0 );
}

- (NSDictionary *)themeDictionary {
    NSString *plistFileThemeName = [[NSBundle bundleForClass:NSClassFromString(@"AppDelegate")] pathForResource:@"Framework-theme" ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:plistFileThemeName];
}

- (void)standardThemeForMDKUIButton:(MDKUIButton *)button {
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}

@end
