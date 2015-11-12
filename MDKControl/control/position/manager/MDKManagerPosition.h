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
#import <CoreLocation/CoreLocation.h>


#pragma mark - MDKManagerPosition - Completion Handler

typedef void(^MDKManagerPositionCompletionHandler)(NSString *address, NSError *error);
typedef void(^MDKManagerLocationCompletionHandler)(CLLocation *location, NSError *error);


#pragma mark - MDKManagerPosition - Protocol

@protocol MDKManagerPositionDelegate <NSObject>

@optional
/*!
 * @brief Current location is updated
 */
- (void)locationUpdatedWithLongitude:(NSNumber *)longitude latitude:(NSNumber *)latitude;

/*!
 * @brief Search current location failed
 */
- (void)searchLocationFailed;

@end


#pragma mark - MDKManagerPosition - Public interface

@interface MDKManagerPosition : NSObject

/*!
 * @brief The delegate allow to use MDKManagerPositionDelegate
 */
@property (nonatomic, weak) id<MDKManagerPositionDelegate> delegate;

/*!
 * @brief The instance of MDKManagerPosition
 */
+ (MDKManagerPosition *)sharedManager;

/*!
 * @brief Return boolean allowing to kwnow if current has already detected
 */
- (BOOL)hasLocationAlreadyDetected;

/*!
 * @brief Retrieve current location
 */
- (CLLocation *)currentLocation;

/*!
 * @brief Reset current location
 */
- (void)resetCurrentLocation;

/*!
 * @brief Search current location
 */
- (void)searchCurrentLocation;

/*!
 * @brief Retrieve address with latitude and longitude
 */
- (void)searchAddressAccordingLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude completionHandler:(MDKManagerPositionCompletionHandler)completionHandler;

@end
