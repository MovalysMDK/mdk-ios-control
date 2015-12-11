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

#import "Protocol.h"
#import "Utils.h"
#import "Message.h"

#import "MDKControlProtocol.h"

#import "MDKControlDelegate.h"
#import "MDKStyleProtocol.h"
#import "UIView+Styleable.h"

@interface MDKControlDelegate ()

@property (nonatomic, weak) UIView<MDKControlProtocol> *control;

@end

@implementation MDKControlDelegate


-(instancetype)initWithControl:(UIView<MDKControlProtocol> *)control {
    self = [super init];
    if(self) {
        self.control = control;
        [self computeStyleClass];
    }
    return self;
}


-(void)clearMessages {
    NSMutableArray *modifiedCopy = [self.control.messages mutableCopy];
    for(id<MDKMessageProtocol> message in self.control.messages) {
        if([message status] > 0) {
            [modifiedCopy removeObject:message];
        }
    }
    
    [self.control setIsValid:(modifiedCopy.count == 0)];
    self.control.messages = modifiedCopy;
}

-(NSMutableArray *) getMessages {
    return [@[] mutableCopy];
}

-(void)addMessages:(NSArray *)errors {
    if(errors) {
        [self.control.messages addObjectsFromArray:errors];
    }
    if([self.control isKindOfClass:NSClassFromString(@"MFUIOldBaseComponent")]) {
        [self.control performSelector:@selector(showMessageButtons)];
        
    }else {
        [self.control showMessage:self.control.messages.count];
    }
    
    [self setIsValid:(errors.count == 0)];
}

-(void)setIsValid:(BOOL)isValid {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.control applyStandardStyle];
    });
    if(isValid) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.control applyValidStyle];
        });
        [self.control.tooltipView hideAnimated:YES];
        
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.control applyErrorStyle];
        });
    }
}

-(void) onMessageButtonClick:(id)sender {
    if(![self.control.tooltipView superview]){
        //Récupération du texte des erreurs
        NSAttributedString *messageText = @"";
        messageText = [MDKMessageUIManager formattedMessagesFromArray:self.control.messages];
        
        //Passage de la vue au premier plan
        UIView *controllerView = [self.control parentViewController].view;
        
        //Création et affichage de la bulle
        self.control.tooltipView = [[MDKTooltipView alloc] initWithTargetView:((id<MDKMessageViewProtocol>)self.control.styleClass).messageView
                                                                     hostView:controllerView tooltipText:@""
                                                               arrowDirection:MDKTooltipViewArrowDirectionUp
                                                                        width:self.control.frame.size.width];
        
        [controllerView bringSubviewToFront:self.control.tooltipView];
        self.control.tooltipView.tooltipAttributedText = messageText;
        self.control.tooltipView.tooltipBackgroundColour = [self defaultTooltipBackgroundColor];
        [self.control.tooltipView show];
        [self.control.tooltipView performSelector:@selector(hideAnimated:) withObject:@1 afterDelay:2];
    }
    else {
        [self.control.tooltipView hideAnimated:YES];
    }
    [self.control bringSubviewToFront:self.control.tooltipView];
}


-(UIColor *) defaultTooltipBackgroundColor {
    return [UIColor colorWithWhite:0.90 alpha:1];
}

-(void) computeStyleClass {
    /**
     * Style priority :
     * 1. User Defined Runtime Attribute named "styleClass"
     * 2. Class style based on the component class name
     * 3. Class style defined as a bean base on the component class name
     * 4. Default Movalys style
     */
    NSString *componentClassStyleName = [NSString stringWithFormat:@"%@Style", [self.control class]];
    
    if(self.control.styleClassName) {
        self.control.styleClass = [NSClassFromString(self.control.styleClassName) new];
    }
    else if(componentClassStyleName){
        self.control.styleClass = [NSClassFromString(componentClassStyleName) new];
    }
    //TODO: Style via BeanLoader
    else {
        self.control.styleClass = [NSClassFromString(@"MFDefaultStyle") new];
    }
}

-(void)setVisible:(NSNumber *)visible {
    if([visible integerValue] == 1) {
        self.control.hidden = NO;
    }
    else {
        self.control.hidden = YES;
    }
}


#pragma mark - Validation
-(NSInteger)validate {
    [self clearMessages];
    NSMutableArray *validators = [NSMutableArray array];
    NSMutableDictionary *validationState = [NSMutableDictionary dictionary];
    
    //Mandatory validator
    id mandatoryMessage = nil;
    id<MDKFieldValidatorProtocol> mandatoryValidator = nil;
    if([self.control mandatory]) {
        
        mandatoryValidator = [[MDKFieldValidatorHandler fieldValidatorsForAttributes:@[FIELD_VALIDATOR_ATTRIBUTE_MANDATORY] forControl:[self control]] firstObject];
        mandatoryMessage = [mandatoryValidator validate:[self.control getData] withCurrentState:validationState
                                       withParameters:@{FIELD_VALIDATOR_ATTRIBUTE_MANDATORY : self.control.mandatory, @"componentName" : NSStringFromClass(self.control.class)}];
    }
    if(mandatoryMessage) {
        validationState[NSStringFromClass([mandatoryValidator class])] = mandatoryMessage;
    }
    else {
        [self processValidationWithValidators:validators withValidationState:validationState];
    }
    return [self computeNumberOfMessagesFromValidationState:validationState];
}

-(NSInteger) computeNumberOfMessagesFromValidationState:(NSDictionary *)validationState {
    NSInteger numberOfMessages = 0;
    [self clearMessages];
    for(id result in validationState.allValues) {
        if(![result isKindOfClass:[NSNull class]]) {
            numberOfMessages++;
            [self addMessages:@[result]];
        }
    }
    return numberOfMessages;
}


-(void)processValidationWithValidators:(NSMutableArray *)validators withValidationState:(NSMutableDictionary *)validationState {
    
    //Component Validators
    [validators addObjectsFromArray:[self.control performSelector:@selector(userFieldValidators)]];
    [validators addObjectsFromArray:[self.control controlValidators]];
    
    //Other validatos
    [validators addObjectsFromArray:[MDKFieldValidatorHandler fieldValidatorsForAttributes:self.control.controlAttributes.allKeys forControl:[self control]]];
    
    for(id<MDKFieldValidatorProtocol> fieldValidator in validators) {
        if(validationState[NSStringFromClass([fieldValidator class])]) {
            continue;
        }
        NSMutableDictionary *validatorParameters = [NSMutableDictionary dictionary];
        for(NSString *recognizedAttribute in [fieldValidator recognizedAttributes]) {
            if(self.control.controlAttributes[recognizedAttribute]) {
                validatorParameters[recognizedAttribute] = self.control.controlAttributes[recognizedAttribute];
            }
        }
    
        
        //On ajoute le nom du composant
        validatorParameters[@"componentName"] = NSStringFromClass([self.control class]);
        id errorResult = [fieldValidator validate:[self.control getData] withCurrentState:validationState withParameters:validatorParameters];
        if(errorResult) {
            validationState[NSStringFromClass([fieldValidator class])] = errorResult;
            if([fieldValidator isBlocking]) { break; }
        }
        else {
            validationState[NSStringFromClass([fieldValidator class])] = [NSNull null];
        }
    }
}

#pragma mark - Control Attributes
-(void)addControlAttribute:(id)controlAttribute forKey:(NSString *)key {
    NSMutableDictionary *mutableControlAttributes = [NSMutableDictionary dictionary];
    [mutableControlAttributes addEntriesFromDictionary:self.control.controlAttributes];
    mutableControlAttributes[key] = controlAttribute;
    self.control.controlAttributes = mutableControlAttributes;
}

-(void)setCustomStyleClass:(Class)customStyleClass {
    self.control.styleClass = [customStyleClass new];
}


@end
