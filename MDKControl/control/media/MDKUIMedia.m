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

#import "MDKUIMedia.h"
#import "Helper.h"


#pragma mark - MDKUIMedia - Private interface

@interface MDKUIMedia() <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end


#pragma mark - MDKUIMedia - Implementation

@implementation MDKUIMedia
@synthesize targetDescriptors = _targetDescriptors;


#pragma mark - Initialization and deallocation

- (void)initialize {
    [super initialize];
}

- (void)didInitializeOutlets {
}


#pragma mark - Tags for automatic testing

- (void) setAllTags {
    if (self.buttonPicture.tag == 0) {
        self.buttonPicture.tag = TAG_MDKMEDIA_PICTURE_BUTTON;
    }
}


#pragma mark MDKControlChangesProtocol implementation

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {}
- (void) valueChanged:(UIView *)sender {}


#pragma mark - Control Data protocol

+ (NSString *)getDataType {
    return @"UIImage";
}

- (void)setData:(id)data {
    if ( data ) {}
    [super setData:data];
}

- (id)getData {
    return nil;
}

- (void)setEditable:(NSNumber *)editable {
    [super setEditable:editable];
}

- (void)setDisplayComponentValue:(id)value {}


#pragma mark - Handle user events

- (IBAction)userDidTapOnPictureButton:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select an action" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a picture", @"Select a picture in your photos", nil];
    [actionSheet showInView:self.parentViewController.view];
}


#pragma mark - UIActionSheetDelegate implementation

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
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


#pragma mark - UIImagePickerControllerDelegate implementation

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image        = info[@"UIImagePickerControllerOriginalImage"];
    UIImage *imageCropped = [image squareCropImageWithSideLength:self.buttonPicture.frame.size.height];
    
    [self.buttonPicture setBackgroundImage:imageCropped forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Private API

- (void)openImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    if (sourceType == UIImagePickerControllerSourceTypeCamera && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Camera is not available on simulator" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate                 = self;
    picker.sourceType               = sourceType;
    [self.parentViewController presentViewController:picker animated:YES completion:NULL];
}

@end

/******************************************************/
/* INTERNAL/EXTERNAL                                  */
/******************************************************/

@implementation MDKUIExternalMedia

- (NSString *)defaultXIBName {
    return @"MDKUIMedia";
}

@end

@implementation MDKUIInternalMedia @end