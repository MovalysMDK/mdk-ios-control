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

#import "MDKPickMediaCommand.h"
#import "AlertView.h"

@interface MDKPickMediaCommand ()

/*!
 * @brief The source that called this command. It must implements UINavigationControllerDelegate
 * and UIImagePickerControllerDelegate to be able to show the media picker
 */
@property (nonatomic, strong) id<UINavigationControllerDelegate, UIImagePickerControllerDelegate> source;

/*!
 * @brief The parentViewController used to show the ImagePickerController
 */
@property (nonatomic, strong) UIViewController *parentViewController;

@end


@implementation MDKPickMediaCommand

+(MDKPickMediaCommand *)sharedInstance{
    static MDKPickMediaCommand *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id) executeFromViewController:(UIViewController *)viewController withParameters:(id)parameters, ... NS_REQUIRES_NIL_TERMINATION {
    va_list args;
    va_start(args, parameters);
    
    if([parameters conformsToProtocol:@protocol(UIImagePickerControllerDelegate)] && [parameters conformsToProtocol:@protocol(UINavigationControllerDelegate)]) {
        self.source = parameters;
    }
    else {
        @throw [NSException exceptionWithName:@"Missing Delegates" reason:[NSString stringWithFormat:@"%@ must implement UIImagePickerControllerDelegate and UINavigationControllerDelegate to execute this command", parameters] userInfo:nil];
    }
    
    
    [self computeParentNavigationControllerForObject:self.source];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select an action" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a picture", @"Select a picture in your photos", nil];
    [actionSheet showInView:self.parentViewController.view];
    
    return self;
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {         // Take a picture
        [self openImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else if(buttonIndex == 1) {     // Select a picture in your photos
        [self openImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else {                          // Cancel
        // Nothing ...
    }
}

- (void)openImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    if (sourceType == UIImagePickerControllerSourceTypeCamera && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        MDKUIAlertController *alertController = [MDKUIAlertController alertControllerWithTitle:@"Information" message:@"Camera is not available on simulator" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:NULL];
        [alertController addAction:cancelAction];
        [self.parentViewController presentViewController:alertController animated:true completion:NULL];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate                 = self.source;
    picker.sourceType               = sourceType;
    
    [self.parentViewController presentViewController:picker animated:YES completion:nil];
    
    
}

#pragma mark - Custom methods

-(void)computeParentNavigationControllerForObject:(id)object {
    if([object respondsToSelector:@selector(parentViewController)]) {
        self.parentViewController = [object performSelector:@selector(parentViewController)];
    }
    else if([object isKindOfClass:NSClassFromString(@"MDKFixedListDataDelegate")]) {
        object = [object performSelector:@selector(fixedList)];
        self.parentViewController = [object performSelector:@selector(parentViewController)];
    }
    
    
    //Other ways to compute a parentViewController
    //...
    
    // Throws exception if no parent view controller was found
    if(!self.parentViewController) {
        @throw [NSException exceptionWithName:@"ViewController not found" reason:[NSString stringWithFormat:@"No Parent ViewController was found for object %@", self.source] userInfo:nil];
    }
    
    
}
@end
