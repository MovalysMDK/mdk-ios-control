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

#import "MDKManagerPosition.h"


#pragma mark - Settings var

#define END_SEARCH_LOCATION -1
#define DELAY_IN_SECONDS    5


#pragma mark - MDKManagerPosition - Private interface

@interface MDKManagerPosition() <CLLocationManagerDelegate>

/*!
 * @brief The location manager allowing to retrieve user location
 */
@property (nonatomic, strong) CLLocationManager *locationManager;

/*!
 * @brief This variable allow to know how many research has made.
 */
@property (nonatomic, assign) int countSearchLocation;

/*!
 * @brief This variable content the last longitude founded
 */
@property (nonatomic, strong) NSNumber *lastLongitude;

/*!
 * @brief This variable content the last latitude founded
 */
@property (nonatomic, strong) NSNumber *lastLatitude;

/*!
 * @brief User's current location
 */
@property (nonatomic, strong) CLLocation *currentLocation;

@end


#pragma mark - MDKManagerPosition - Implementation

@implementation MDKManagerPosition


#pragma mark - Lifecycle

+ (MDKManagerPosition *)sharedManager {
    static dispatch_once_t onceToken;
    static MDKManagerPosition *sharedManager;
    dispatch_once(&onceToken, ^{
        sharedManager = [MDKManagerPosition new];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _countSearchLocation = 0;
        self.lastLongitude   = @( 0 );
        self.lastLatitude    = @( 0 );
        self.currentLocation = [CLLocation new];
    }
    return self;
}


#pragma mark - Public API

- (BOOL)hasLocationAlreadyDetected {
    return ( ![@( 0 ) isEqual:self.lastLatitude] && ![@( 0 ) isEqual:self.lastLongitude] );
}

- (void)resetCurrentLocation {
    self.lastLatitude  = @( 0 );
    self.lastLongitude = @( 0 );
    [self.locationManager stopUpdatingLocation];
}

- (void)searchCurrentLocation {
    self.locationManager                 = [[CLLocationManager alloc] init];
    self.locationManager.delegate        = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    int64_t delayInSeconds = DELAY_IN_SECONDS;
    _countSearchLocation   = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (_countSearchLocation != END_SEARCH_LOCATION && _countSearchLocation > 0) {
            [self.locationManager stopUpdatingLocation];
        }
    });
}

- (void)searchAddressAccordingLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude completionHandler:(MDKManagerPositionCompletionHandler)completionHandler {
    CLLocationDegrees degreesLatitude  = [latitude floatValue];
    CLLocationDegrees degreesLongitude = [longitude floatValue];
    CLLocation *location               = [[CLLocation alloc] initWithLatitude:degreesLatitude longitude:degreesLongitude];
    CLGeocoder *geocoder               = [CLGeocoder new];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (completionHandler && error) {
            completionHandler( nil, error );
            return;
        }
        
        // Perform completion handler
        if (completionHandler) {
            CLPlacemark *placemark = placemarks.lastObject;
            NSArray *formattedAddressLine = [NSArray arrayWithArray:placemark.addressDictionary[@"FormattedAddressLines"]];
            NSString *address = @"";
            for (NSString *element in formattedAddressLine) {
                address = [address stringByAppendingString:element];
                address = [address stringByAppendingString:@" "];
            }
            completionHandler( address, nil );
        }
    }];
}


#pragma mark - CLLocationManagerDelegate implementation

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(searchLocationFailed)]) {
        [self.delegate searchLocationFailed];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.currentLocation = locations.lastObject;
    _countSearchLocation = _countSearchLocation + 1;
    
    if ([self.delegate respondsToSelector:@selector(locationUpdatedWithLongitude:latitude:)]) {
        self.lastLatitude  = @( self.currentLocation.coordinate.latitude  );
        self.lastLongitude = @( self.currentLocation.coordinate.longitude );
        [self.delegate locationUpdatedWithLongitude:self.lastLongitude latitude:self.lastLatitude];
        [manager stopUpdatingLocation];
    }
}


#pragma mark - Private API

- (BOOL)locationAlreadyFoundedWithLocation:(CLLocation *)location {
    return ( [self.lastLatitude isEqual:@( location.coordinate.latitude )] && [self.lastLongitude isEqual:@( location.coordinate.longitude )] );
}

@end
