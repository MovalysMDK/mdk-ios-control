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

@class MDKMessageButton;

/*!
 * @class MDKMessageUIManager
 * @brief Class with statics methods to prepare message view and tooltip to be displayed
 */
@interface MDKMessageUIManager : NSObject

#pragma mark - Methods

/*!
 * @brief Apply an automatic style on messageButton given the list of messages
 * @param messageButton The message button to style
 * @param messages The list of message
 */
+(void)autoStyleMessageButton:(MDKMessageButton *)messageButton forMessages:(NSArray *)messages;

+(NSAttributedString *) formattedMessagesFromArray:(NSArray *)messages;

@end
