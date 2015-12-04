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

#import "MDKUIPosition.h"
#import "MDKManagerPosition.h"

#import "Helper.h"
#import "Protocol.h"


#pragma mark - MDKUIPosition - Keys

/*!
 * @brief The key for MDKUIPosition allowing to handle location button animation
 */
NSString *const MDKUIPositionAnimationKey = @"LOADING_LOCATION";


#pragma mark - MDKUIPosition - Private interface

@interface MDKUIPosition() <UITextFieldDelegate, UIAlertViewDelegate, MDKManagerPositionDelegate>

/*!
 * @brief The private animation for location button
 */
@property (nonatomic, strong) CABasicAnimation *animationForLocationButton;

/*!
 * @brief Know the search location mode
 */
@property (nonatomic, assign) BOOL navigationMode;

@end



#pragma mark - MDKUIPosition - Implementation

@implementation MDKUIPosition
@synthesize targetDescriptors = _targetDescriptors;


#pragma mark - Initialization and deallocation

- (void)initialize {
    [super initialize];
    [self setAllTags];
    self.navigationMode = NO;
#if !TARGET_INTERFACE_BUILDER
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
#endif
}

- (void)didInitializeOutlets {
    [self handleLocationEmpty];
    [self displayLocationFoundedIfNeeded];
}

#if !TARGET_INTERFACE_BUILDER
- (void)dealloc {
    @try{
        [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillHideNotification];
    } @catch(id anException){
        // Nothing ...
    }
}
#endif


#pragma mark - Tags for automatic testing

- (void) setAllTags {
    if (self.textFieldLatitude.tag == 0) {
        self.textFieldLatitude.tag = TAG_MDKPOSITION_LATITUDE;
    }
    if (self.textFieldLongitude.tag == 0) {
        self.textFieldLongitude.tag = TAG_MDKPOSITION_LONGITUDE;
    }
    if (self.buttonCancel.tag == 0) {
        self.buttonCancel.tag = TAG_MDKPOSITION_CANCEL;
    }
    if (self.buttonLocationFounded.tag == 0) {
        self.buttonLocationFounded.tag = TAG_MDKPOSITION_LOCATION_FOUNDED;
    }
    if (self.buttonLocationNotFound.tag == 0) {
        self.buttonLocationNotFound.tag = TAG_MDKPOSITION_LOCATION_NOT_FOUND;
    }
    if (self.buttonMap.tag == 0) {
        self.buttonMap.tag = TAG_MDKPOSITION_MAP;
    }
    if (self.buttonNavigation.tag == 0) {
        self.buttonNavigation.tag = TAG_MDKPOSITION_NAVIGATION;
    }
}


#pragma mark MDKControlChangesProtocol implementation

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [self.textFieldLatitude addTarget:self action:@selector(valueChanged:) forControlEvents:controlEvents];
    [self.textFieldLongitude addTarget:self action:@selector(valueChanged:) forControlEvents:controlEvents];
    MDKControlEventsDescriptor *commonCCTD = [MDKControlEventsDescriptor new];
    commonCCTD.target = target;
    commonCCTD.action = action;
    self.targetDescriptors = @{@(self.textFieldLatitude.hash) : commonCCTD, @(self.textFieldLongitude.hash) : commonCCTD};
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void) valueChanged:(UIView *)sender {
    MDKControlEventsDescriptor *cctd = self.targetDescriptors[@(sender.hash)];
    [cctd.target performSelector:cctd.action withObject:self];
}
#pragma clang diagnostic pop


#pragma mark - Control Data protocol

+ (NSString *)getDataType {
    return @"NSObject";
}

- (void)setData:(id)data {
    if ( data && ![self.controlData isEqual:data] ) {
        [self setDisplayComponentValue:data];
    }
    [super setData:data];
}

- (id)getData {
    return [self displayComponentValue];
}

- (void)setEditable:(NSNumber *)editable {
    [super setEditable:editable];
}

- (void)setDisplayComponentValue:(id<MDKUIDataPositionProtocol>)value {
    self.textFieldLatitude.text  = value.latitude;
    self.textFieldLongitude.text = value.longitude;
    [self handleLocationEmpty];
}

-(id)displayComponentValue {
    [self.controlData setLatitude:self.textFieldLatitude.text];
    [self.controlData setLongitude:self.textFieldLongitude.text];
    return self.controlData;
}

#pragma mark - Control attribute

- (void)setControlAttributes:(NSDictionary *)controlAttributes {
[super setControlAttributes:controlAttributes];
}


#pragma mark - Handle user event

- (IBAction)userDidTapOnMapButton:(id)sender {
    NSNumber *numberLongitude = [NSNumber numberWithFloat:[self.textFieldLongitude.text floatValue]];
    NSNumber *numberLatitude  = [NSNumber numberWithFloat:[self.textFieldLatitude.text floatValue]];
    
    [[MDKManagerPosition sharedManager] searchAddressAccordingLatitude:numberLatitude longitude:numberLongitude completionHandler:^(NSString *address, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"We cannot retrieve your address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        NSURL *urlMap = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?q=%@", [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [[UIApplication sharedApplication] openURL:urlMap];
    }];
}

- (IBAction)userDidTapOnNavigationButton:(id)sender {
    if ([self textFieldEmpty]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please enter latitude longitude" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    self.navigationMode = YES;
    [[MDKManagerPosition sharedManager] setDelegate:self];
    [[MDKManagerPosition sharedManager] searchCurrentLocation];
}

- (IBAction)userDidTapOnLocationButton:(id)sender {
    self.navigationMode = NO;
    [self startLocationButtonAnimation];
    [[MDKManagerPosition sharedManager] setDelegate:self];
    [[MDKManagerPosition sharedManager] searchCurrentLocation];
}

- (IBAction)userDidTapOnCancelButton:(id)sender {
    self.textFieldLatitude.text  = @"";
    self.textFieldLongitude.text = @"";
    [self valueChanged:self.textFieldLongitude];
}


#pragma mark - UITextFieldDelegate implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self valueChanged:self.textFieldLongitude];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length == 1 && range.location == 0) {
        [self reset];
    }
    else {
        [self handleLocationEmpty];
    }
    return YES;
}

#pragma mark - MDKManagerPositionDelegate implementation

- (void)locationUpdatedWithLongitude:(NSNumber *)longitude latitude:(NSNumber *)latitude {
    if (self.navigationMode) {
        
        NSString *stringNavigation = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f", latitude.floatValue, longitude.floatValue, self.textFieldLatitude.text.floatValue, self.textFieldLongitude.text.floatValue];
        NSURL *urlNavigation = [NSURL URLWithString:stringNavigation];
        [[UIApplication sharedApplication] openURL:urlNavigation];
    }
    else {
        
        NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
        [numberFormatter setLocale:[NSLocale currentLocale]];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setGroupingSeparator:@""];
        self.textFieldLongitude.text = [numberFormatter stringFromNumber:longitude];
        self.textFieldLatitude.text  = [numberFormatter stringFromNumber:latitude];
        [self stopLocationButtonAnimation];
        [self valueChanged:self.textFieldLongitude];
    }
}

- (void)searchLocationFailed {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"We cannot retrieve your location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // For while, we have just used an ok button for issue on search location 
    [self removeCurrentLocation];
}


#pragma mark - UIKeyboardWillHideNotification implementation

- (void)keyboardWillHide {
    [self handleLocationEmpty];
}

-(UITextField *)textFieldLongitude {
    if([self conformsToProtocol:@protocol(MDKExternalComponent)]) {
        return [((MDKUIInternalPosition *)[self internalView]) textFieldLongitude];
    }
    return _textFieldLongitude;
}

-(UITextField *)textFieldLatitude {
    if([self conformsToProtocol:@protocol(MDKExternalComponent)]) {
        return [((MDKUIInternalPosition *)[self internalView]) textFieldLatitude];
    }
    return _textFieldLatitude;
}

#pragma mark - Custom methods


- (void)startLocationButtonAnimation {
    self.animationForLocationButton                = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    self.animationForLocationButton.delegate       = self;
    self.animationForLocationButton.byValue        = @( M_PI );
    self.animationForLocationButton.duration       = 0.8f;
    self.animationForLocationButton.repeatCount    = HUGE_VALF;
    self.animationForLocationButton.beginTime      = CACurrentMediaTime();
    self.animationForLocationButton.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self.buttonLocationNotFound.layer addAnimation:self.animationForLocationButton forKey:MDKUIPositionAnimationKey];
    [self.buttonLocationFounded.layer addAnimation:self.animationForLocationButton forKey:MDKUIPositionAnimationKey];
}

- (void)stopLocationButtonAnimation {
    [self displayLocationFoundedIfNeeded];
    
    CFTimeInterval elapsedTime = CACurrentMediaTime() - self.animationForLocationButton.beginTime;
    float dispatch_time_wait   = ( ceilf(elapsedTime) - elapsedTime );
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, dispatch_time_wait * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.buttonLocationNotFound.layer removeAnimationForKey:MDKUIPositionAnimationKey];
        [self.buttonLocationFounded.layer removeAnimationForKey:MDKUIPositionAnimationKey];
        [self handleLocationEmpty];
    });
}

- (void)displayLocationFoundedIfNeeded {
    float animationDuration = 0.3f;
    
    if ( [[MDKManagerPosition sharedManager] hasLocationAlreadyDetected] ) {
        [UIView animateWithDuration:animationDuration animations:^{
            self.buttonLocationFounded.alpha = 1.0f;
        } completion:^(BOOL finished) {
            if (finished) {
                self.buttonLocationNotFound.hidden = YES;
            }
        }];
    }
    else {
        self.buttonLocationNotFound.hidden = NO;
        [UIView animateWithDuration:animationDuration animations:^{
            self.buttonLocationFounded.alpha = 0.0f;
        }];
    }
}

- (void)handleLocationEmpty {
    if ( ![self textFieldEmpty] ) {
        self.buttonCancel.enabled     = YES;
        self.buttonMap.enabled        = YES;
        self.buttonNavigation.enabled = YES;
    }
    else {
        [self reset];
    }
}

- (void)reset {
    self.buttonCancel.enabled     = NO;
    self.buttonMap.enabled        = NO;
    self.buttonNavigation.enabled = NO;
}

- (BOOL)textFieldEmpty {
    return ( [@"" isEqualToString:self.textFieldLatitude.text] || [@"" isEqualToString:self.textFieldLongitude.text] );
}

- (void)removeCurrentLocation {
    [[MDKManagerPosition sharedManager] resetCurrentLocation];
    [self displayLocationFoundedIfNeeded];
    [self stopLocationButtonAnimation];
}


@end


/******************************************************/
/* INTERNAL/EXTERNAL                                  */
/******************************************************/

@implementation MDKUIExternalPosition

- (NSString *)defaultXIBName {
    return @"MDKUIPosition";
}

@end

@implementation MDKUIInternalPosition @end
