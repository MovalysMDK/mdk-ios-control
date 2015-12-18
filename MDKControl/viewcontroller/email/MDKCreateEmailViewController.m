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

#import "MDKCreateEmailViewController.h"

@implementation MDKCreateEmailViewController

-(id) init
{
    self = [super init];
    if(self)
    {
        [self initialize];
    }
    return self;
}

-(void) initialize
{
    // By default, the delegate is itself.
    self.mailComposeDelegate = self;
}

/**
 * Default delegate.
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    UIAlertView *alert = nil;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"'Send mail' action result: canceled");
            if(self.createMailDelegate == nil
               || (self.createMailDelegate != nil && [self.createMailDelegate mailComposeController:controller didCancelWithError:error]))
            {
            }
            break;
        case MFMailComposeResultSaved:
            NSLog(@"'Send mail' action result: saved");
            if(self.createMailDelegate == nil
               || (self.createMailDelegate != nil && [self.createMailDelegate mailComposeController:controller didSaveWithError:error]))
            {
            }
            break;
        case MFMailComposeResultSent:
            NSLog(@"'Send mail' action result: Sent");
            if(self.createMailDelegate == nil
               || (self.createMailDelegate != nil && [self.createMailDelegate mailComposeController:controller didSendWithError:error]))
            {
            }
            break;
        case MFMailComposeResultFailed:
            NSLog(@"'Send mail' action result: failed. Error : %@", error);
            if(self.createMailDelegate == nil
               || (self.createMailDelegate != nil && [self.createMailDelegate mailComposeController:controller didFailWithError:error]))
            {
            }
            break;
        default:
            NSLog(@"'Send mail' action result: not sent");
            if(self.createMailDelegate == nil
               || (self.createMailDelegate != nil && [self.createMailDelegate mailComposeController:controller didNotSendWithError:error]))
            {
            }
            break;
    }
    [alert show];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
