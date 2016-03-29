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



#import "Theme.h"
#import "Control.h"


#pragma mark - MDKTheme: Custom types

@protocol MDKThemeDelegate <NSObject>

// Status bar
@optional
- (void)applyThemeOnStatusBar;

// Navigation Bar
@optional
- (void)applyThemeOnNavigationBar:(UIViewController *)controller;

// UIButton
@optional
- (void)applyThemeOnUIButton:(UIButton *)button;

// UITableViewCell
@optional
- (void)applyThemeOnUITableViewCell:(UITableViewCell *)cell;

// MDKUIButton
@optional
- (void)applyThemeOnMDKUIButton:(MDKUIButton *)button;

// MDKTextField
@optional
- (void)applyThemeOnMDKUITextField:(MDKTextField *)textField;

// MDKLabel
@optional
- (void)applyThemeOnMDKLabel:(MDKLabel *)label;

// MDKFixedListAddButton
@optional
- (void)applyThemeOnMDKFixedListAddButton:(UIButton *)button;


// MDKFloatingButton
@optional
- (void)applyThemeOnMDKFloatingButton:(UIButton *)button;

@end



#pragma mark - MDKTheme: Public interface

@interface MDKTheme : NSObject <MDKThemeDelegate>

//  Life cycle
// ============
+ (MDKTheme *)sharedTheme;

@end
