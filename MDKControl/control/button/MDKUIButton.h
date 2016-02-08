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

#import <UIKit/UIKit.h>
#import "Style.h"
#import "Protocol.h"



@protocol MDKStyleProtocol;



#pragma mark - MDKUIButtonKeyPath: Public interface

@interface MDKUIButtonKeyPath : NSObject

//  Properties
// ============
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *storyboardTargetName;

@end



#pragma mark MDKUIButton: Public interface

/*!
 * @class MDKUIButton
 * @brief The MDKUIButton Control.
 */
IB_DESIGNABLE
@interface MDKUIButton : UIButton <MDKControlCustomStyleProtocol>

//  Properties
// ============
@property (nonatomic, strong, readonly) MDKUIButtonKeyPath *keyPath;

@property (nonatomic) IBInspectable BOOL onError_MDK;
@property (nonatomic, strong) NSMutableArray *errors;
@property (nonatomic, weak) id<MDKControlCustomStyleProtocol> styleDelegate;

@end
