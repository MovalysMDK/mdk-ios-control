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

#import <Foundation/Foundation.h>
/*!
 *  Possible message status.
 */
typedef NS_ENUM(NSInteger, MDKMessageStatus){
    /*!
     *  An info message
     */
    MDKMessageStatusInfo,
    /*!
     *  A warn message
     */
    MDKMessageStatusWarning,
    /*!
     *  An error message.
     */
    MDKMessageStatusError
};


/*!
 * @protocol MDKMessageProtocol
 * @brief Common protocol for any UI messages
 * @discussion These message can have multiple status : error, warn, info ....
 */
@protocol MDKMessageProtocol <NSObject>

#pragma mark - Properties
/*!
 * @brief The status of the message
 * @see MDKMessageStatus
 */
@property (nonatomic) MDKMessageStatus status;


/*!
 * @brief The code of the message
 */
@property (nonatomic, strong) NSString *identifier;


#pragma mark - Methods

@required
-(NSString *) messageTitle;

@required
-(NSString *) messageContent;

@optional
-(NSInteger) messagerCode;

@end


