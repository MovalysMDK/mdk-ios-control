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



/*!
 * @protocol MDKUIDisplayControllerDelegate
 * @brief This protocol allow to handle user action on picture
 */
@protocol MDKUIDisplayControllerDelegate <NSObject>
/*!
 * @brief Notify when user want delete picture present on this controller
 */
- (void)userDeletePicture;
@end





/*!
 * @class MDKUIDisplayControllerDelegate
 * @brief This class allow to display image on MDKUIMedia in full screen
 */
@interface MDKUIDisplayController : UIViewController

#pragma mark - Propertie
/*!
 * @brief The imageView outlet used to display the picture
 */
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

/*!
 * @brief The delete button outlet used to delete the picture
 */
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

/*!
 * @brief The delegate object that displays this controller.
 */
@property (nonatomic, weak) id<MDKUIDisplayControllerDelegate> delegate;

/*!
 * @brief The delegate object that displays this controller.
 */
@property (nonatomic) BOOL isEditable;


#pragma mark - Methods

/*!
 * @brief Builds a new instance of MDKUIDisplayController
 * @discussion This constructor builds a new instance of MDKUIDisplayController with
 * base on a XIB file and the umage to display
 * @param nibName The XIB file name to load for this Controller
 * @param bundle The bundle to use to load the associated XIB file
 * @param image The image to display
 * @return The new built instance of MDKUIDisplayController
 */
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle image:(UIImage *)image;

@end
