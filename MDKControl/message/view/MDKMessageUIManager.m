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

#import "MDKMessageUIManager.h"
#import "MDKMessageProtocol.h"
#import "MDKMessageButton.h"
#import "MDKAbstractStyle_MDK.h"

@implementation MDKMessageUIManager

+(void)autoStyleMessageButton:(MDKMessageButton *)messageButton forMessages:(NSArray *)messages {
    
    NSInteger higherStatus = MDKMessageStatusInfo;
    for(id<MDKMessageProtocol> message in messages) {
        if(message.status > higherStatus) {
            higherStatus = message.status;
        }
    }
    messages = [MDKMessageUIManager filterMessages:messages givenHigherStatus:higherStatus];
    
    [messageButton setTitle:[@([messages count]) stringValue] forState:UIControlStateNormal];
    UIColor *messageButtonColor = nil;
    switch(higherStatus) {
        case MDKMessageStatusInfo :
            messageButtonColor = [MDKAbstractStyle_MDK infoColor];
            break;
        case MDKMessageStatusWarning :
            messageButtonColor = [MDKAbstractStyle_MDK warnColor];
            break;
        case MDKMessageStatusError :
            messageButtonColor = [MDKAbstractStyle_MDK errorColor];
            break;
    }
    messageButton.color = messageButtonColor;
}

+(NSAttributedString *)formattedMessagesFromArray:(NSArray *)messages {
    NSArray *colors = @[[MDKAbstractStyle_MDK infoColor], [MDKAbstractStyle_MDK warnColor], [MDKAbstractStyle_MDK errorColor]];
    
    NSInteger higherStatus = MDKMessageStatusInfo;
    for(id<MDKMessageProtocol> message in messages) {
        if(message.status > higherStatus) {
            higherStatus = message.status;
        }
    }
    
    messages = [MDKMessageUIManager filterMessages:messages givenHigherStatus:higherStatus];
    
    NSMutableAttributedString *messageText = [NSMutableAttributedString new];
    int messageNumber = 0;
    
    for (id<MDKMessageProtocol> message in messages) {
        
        if(messageNumber > 0){
            [messageText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        }
        
        messageNumber++;
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"[%@]",[message messageTitle]] attributes:@{ NSForegroundColorAttributeName : colors[[message status]], NSFontAttributeName:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]}];
        [messageText appendAttributedString:title];
        
        NSAttributedString *separator = [[NSAttributedString alloc] initWithString:@" "];
        [messageText appendAttributedString:separator];
        
        NSAttributedString *content = [[NSAttributedString alloc] initWithString:[message messageContent] attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor], NSFontAttributeName:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]}];
        [messageText appendAttributedString:content];
    }

    return messageText;
}

+(NSArray *)filterMessages:(NSArray *)messages givenHigherStatus:(MDKMessageStatus)higherStatus {
    NSMutableArray *result = [messages mutableCopy];
    if(higherStatus == MDKMessageStatusError) {
        for(id<MDKMessageProtocol> message in messages) {
            if(message.status < MDKMessageStatusError) {
                [result removeObject:message];
            }
        }
    }
    return result;
}

@end
