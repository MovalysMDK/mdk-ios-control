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

#import "Helper.h"
#import "Command.h"

#import "MDKUIMedia.h"
#import "MDKUIDisplayController.h"
#import "MediaDisplayTransition.h"


#pragma mark - MDKUIMedia - Keys

/*!
 * @brief The key for MDKUIMedia allowing to add control attributes
 */
NSString *const MDKUIMediaKey = @"MDKUIMediaKey";


#pragma mark - MDKUIMedia - Private interface

@interface MDKUIMedia() <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIViewControllerTransitioningDelegate, MDKUIDisplayControllerDelegate>

/*!
 * @brief This variable allow to know the current data class name
 */
@property (nonatomic, strong) NSString *controlDataClassName;

/*!
 * @brief This button allow to take a picture
 */
@property (nonatomic, weak) IBOutlet UIButton *buttonPicture;

/*!
 * @brief Allow to know if user has already set his image (Select picture from library or take a picture)
 */
@property (nonatomic, strong) NSNumber *userHasAlreadySetAnImage;

/*!
 * @brief This controller allow to display image on full screen mode.
 */
@property (nonatomic, strong) MDKUIDisplayController *displayController;

/*!
 * @brief The command used to show media picker
 */
@property (nonatomic, strong) id<MDKCommandProtocol> pickMediaCommand;

@end


#pragma mark - MDKUIMedia - Implementation

@implementation MDKUIMedia
@synthesize targetDescriptors = _targetDescriptors;
@synthesize userHasAlreadySetAnImage = _userHasAlreadySetAnImage;

#pragma mark - Initialization and deallocation

- (void)initialize {
    [super initialize];
    self.userHasAlreadySetAnImage = @(0);
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
    [super setData:data];
    if ( data ) {
        [self setDisplayComponentValue:data];
    }
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
                [self handleImage:[UIImage imageWithCGImage:iref]];
            } else {
                UIImage* image = [self defaultImage];
                [self handleImage:image];
            }
        };
        
        //Echec de chargement de la photo
        ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
        {
            UIImage* image = [self defaultImage];
            [self handleImage:image];
        };
        
        UIImage *localImage = [UIImage imageWithContentsOfFile:uri];
        
        //On vérifie si c'est une image locale, sinon une image du device
        if(localImage) {
            [self handleImage:localImage];
        }
        else {
            ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
            NSURL *asseturl = [NSURL URLWithString:uri];
            [assetslibrary assetForURL:asseturl
                           resultBlock:resultblock
                          failureBlock:failureblock];
        }
        
        
    }
    else {
        
        UIImage* image = [self defaultImage];
        [self handleImage:image];
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
    if ([self.userHasAlreadySetAnImage boolValue]) {
        self.displayController = [[MDKUIDisplayController alloc] initWithNibName:@"MDK_MDKUIDisplayController" bundle:[NSBundle bundleForClass:MDKUIMedia.class] image:self.picture.image];
        self.displayController.modalPresentationStyle = UIModalPresentationCustom;
        self.displayController.transitioningDelegate  = self;
        self.displayController.delegate               = self;
        [self.parentNavigationController presentViewController:self.displayController animated:YES completion:NULL];
    }
    else {
        if(self.editable) {
            self.pickMediaCommand = [[MDKCommandHandler commandWithKey:@"PickMediaCommand" withQualifier:@""] executeFromViewController:[self parentViewController] withParameters:self, nil];
        }
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
                [self valueChanged:self.picture];
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


#pragma mark UIViewControllerTransitioningDelegate implementation

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    MediaDisplayTransition *mediaDisplayTransition  = [[MediaDisplayTransition alloc] init];
    mediaDisplayTransition.appearing                = YES;
    mediaDisplayTransition.centerSource             = self.picture.center;
    mediaDisplayTransition.frameSource              = self.picture.frame;
    return mediaDisplayTransition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    MediaDisplayTransition *mediaDisplayTransition  = [[MediaDisplayTransition alloc] init];
    mediaDisplayTransition.appearing                = NO;
    mediaDisplayTransition.centerSource             = self.picture.center;
    mediaDisplayTransition.frameSource              = self.picture.frame;
    return mediaDisplayTransition;
}


#pragma mark MDKUIDisplayControllerDelegate implementation

- (void)userDeletePicture {
    self.controlData = nil;
    [self handleImage:[self defaultImage]];
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



- (void)handleImage:(UIImage *)image {
    self.userHasAlreadySetAnImage = @(self.controlData != nil);
    if([self conformsToProtocol:@protocol(MDKExternalComponent)]) {
        ((MDKUIInternalMedia *)self.internalView).picture.image = image;
    }
    else {
        self.picture.image = image;
    }
}

-(void)setUserHasAlreadySetAnImage:(NSNumber *)userHasAlreadySetAnImage {
    if([self conformsToProtocol:@protocol(MDKExternalComponent)]) {
        [self.internalView performSelector:@selector(setUserHasAlreadySetAnImage:) withObject:userHasAlreadySetAnImage];
    }
    else {
        _userHasAlreadySetAnImage = userHasAlreadySetAnImage;
    }
}


-(NSNumber *)userHasAlreadySetAnImage {
    id result = _userHasAlreadySetAnImage;
    if([self conformsToProtocol:@protocol(MDKExternalComponent)]) {
        [self.internalView performSelector:@selector(userHasAlreadySetAnImage)];
    }
    return result;
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