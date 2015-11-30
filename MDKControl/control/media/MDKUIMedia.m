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

#import <AssetsLibrary/AssetsLibrary.h>

#import "MDKUIMedia.h"
#import "Helper.h"


#pragma mark - MDKUIMedia - Keys

/*!
 * @brief The key for MDKUIMedia allowing to add control attributes
 */
NSString *const MDKUIMediaKey = @"MDKUIMediaKey";


#pragma mark - MDKUIMedia - Private interface

@interface MDKUIMedia() <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/*!
 * @brief This variable allow to know the current data class name
 */
@property (nonatomic, strong) NSString *controlDataClassName;

/*!
 * @brief This button allow to take a picture
 */
@property (nonatomic, weak) IBOutlet UIButton *buttonPicture;

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

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [self.buttonPicture addTarget:self action:@selector(valueChanged:) forControlEvents:controlEvents];
    MDKControlEventsDescriptor *commonCCTD = [MDKControlEventsDescriptor new];
    commonCCTD.target = target;
    commonCCTD.action = action;
    self.targetDescriptors = @{@(self.picture.hash) : commonCCTD};
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void) valueChanged:(UIView *)sender {
    MDKControlEventsDescriptor *cctd = self.targetDescriptors[@(sender.hash)];
    [cctd.target performSelector:cctd.action withObject:self];
}
#pragma clang diagnostic pop

-(NSDictionary *)targetDescriptors {
    id result = _targetDescriptors;
    if([self conformsToProtocol:@protocol(MDKExternalComponent)]) {
        result = [((MDKRenderableControl <MDKControlChangesProtocol>*)self.internalView) targetDescriptors];
    }
    return result;
}

-(void)setTargetDescriptors:(NSDictionary *)targetDescriptors {
    if([self conformsToProtocol:@protocol(MDKExternalComponent)]) {
        [((MDKRenderableControl <MDKControlChangesProtocol>*)self.internalView) setTargetDescriptors:targetDescriptors];
    }
    else {
        _targetDescriptors = targetDescriptors;
    }
}

#pragma mark - Control Data protocol

+ (NSString *)getDataType {
    return @"NSString";
}

- (void)setData:(id)data {
    if ( data ) {
        [self setDisplayComponentValue:data];
    }
    [super setData:data];
}

- (id)getData {
    return self.controlData;
}

- (void)setEditable:(NSNumber *)editable {
    [super setEditable:editable];
}

- (void)setDisplayComponentValue:(id)value {
    NSString *uri = (NSString *)value;
    
    if(uri) {
        //Affichage de la photo à partir de son URI
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            CGImageRef iref = [myasset aspectRatioThumbnail];
            if (iref) {
                self.picture.image = [UIImage imageWithCGImage:iref];
            } else {
                UIImage* image = [self defaultImage];
                self.picture.image = image;
            }
        };
        
        //Echec de chargement de la photo
        ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
        {
            UIImage* image = [self defaultImage];
            self.picture.image = image;
        };
        
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        NSURL *asseturl = [NSURL URLWithString:uri];
        [assetslibrary assetForURL:asseturl
                       resultBlock:resultblock
                      failureBlock:failureblock];
    }
    else {
        UIImage* image = [self defaultImage];
        self.picture.image = image;
    }
    
}


-(UIImage *) defaultImage {
    return [UIImage imageNamed:@"mdkuimedia_placeholder_btn" inBundle:[NSBundle bundleForClass:NSClassFromString(@"MDKUIMedia")] compatibleWithTraitCollection:nil];
}


#pragma mark - Control attribute

- (void)setControlAttributes:(NSDictionary *)controlAttributes {
    if (controlAttributes && [controlAttributes objectForKey:MDKUIMediaKey]) {
        self.controlDataClassName = [controlAttributes valueForKey:MDKUIMediaKey];
    }
}


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
    
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    
    if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera) {
        //Sauvegarde de la photo dans l'album
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        ALAssetsLibraryWriteImageCompletionBlock imageWriteCompletionBlock =^(NSURL *assetURL, NSError *error) {
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @"Error"
                                      message:@"Saving image has failed"
                                      delegate: nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                
                [alert show];
            }
            else {
                self.controlData = [assetURL absoluteString];
            }
        };
        
        NSMutableDictionary *imageMetadata = [info[UIImagePickerControllerMediaMetadata] mutableCopy];

        //Sauvegarde de la photo avec ses données EXIF + ses éventuelles données de localisation
        [library writeImageToSavedPhotosAlbum:[image CGImage] metadata:imageMetadata completionBlock:imageWriteCompletionBlock];
        
    }
    else if([picker sourceType] == UIImagePickerControllerSourceTypePhotoLibrary) {
        self.controlData = [info[UIImagePickerControllerReferenceURL] absoluteString];
        
    }
    
    
    
    [self handleImage:image];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self valueChanged:self.picture];
}


#pragma mark - Private API

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
- (void)displayData {
    NSString *sMediaClassHelperName = [MDKHelperType getClassHelperOfClassWithKey:self.controlDataClassName];
    Class cHelper                   = NSClassFromString(sMediaClassHelperName);
    
    if ([cHelper respondsToSelector:@selector(imageWithMedia:)] && [cHelper respondsToSelector:@selector(noteWithMedia:)] && [cHelper respondsToSelector:@selector(dateWithMedia:)]
        && [cHelper respondsToSelector:@selector(titleWithMedia:)]) {
        UIImage *image  = [cHelper performSelector:@selector(imageWithMedia:) withObject:self.controlData];
        NSString *note  = [cHelper performSelector:@selector(noteWithMedia:)  withObject:self.controlData];
        NSDate *date    = [cHelper performSelector:@selector(dateWithMedia:)  withObject:self.controlData];
        NSString *title = [cHelper performSelector:@selector(titleWithMedia:) withObject:self.controlData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateDisplayMediaWithImage:image note:note date:date title:title];
        });
    }
}
#pragma clang diagnostic pop

- (void)updateDisplayMediaWithImage:(UIImage *)image note:(NSString *)note date:(NSDate *)date title:(NSString *)title {
    //TODO: Handle another attribut for rich component
    [self handleImage:image];
}

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

- (void)handleImage:(UIImage *)image {
    [self.picture setImage:image];
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