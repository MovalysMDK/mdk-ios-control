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

// View
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) id<MDKUIDisplayControllerDelegate> delegate;

// Methods
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle image:(UIImage *)image;

@end
