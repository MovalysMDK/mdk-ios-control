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
#import "MDKControlProtocol.h"

#import "MDKControlDelegate.h"
#import "MDKStyleProtocol.h"
#import "UIView+Styleable.h"
//#import "MFUIOldBaseComponent.h"
//#import "UIView+Binding.h"

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


-(void)clearErrors {
    [self.control setIsValid:YES];
    self.control.errors = [@[] mutableCopy];
}

-(NSMutableArray *) getErrors {
    return [@[] mutableCopy];
}

-(void)addErrors:(NSArray *)errors {
    if(errors) {
        [self.control.errors addObjectsFromArray:errors];
    }
    if([self.control isKindOfClass:NSClassFromString(@"MFUIOldBaseComponent")]) {
        [self.control performSelector:@selector(showErrorButtons)];
        
    }else {
        [self.control showError:self.control.errors.count];
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

-(void) onErrorButtonClick:(id)sender {
    if(![self.control.tooltipView superview]){
        //Récupération du texte des erreurs
        NSString *errorText = @"";
        int errorNumber = 0;
        for (NSError *error in self.control.errors) {
            if(errorNumber > 0){
                errorText = [errorText stringByAppendingString: @"\n"];
            }
            errorNumber++;
            errorText= [errorText stringByAppendingString: [error localizedDescription]];
        }
        //Passage de la vue au premier plan
        UIView *currentView = self.control;
        do {
            UIView *superView = currentView.superview;
            [superView setClipsToBounds:NO];
            [superView bringSubviewToFront:currentView];
            currentView = superView;
        } while (currentView.tag != FORM_BASE_TABLEVIEW_TAG && currentView.tag != FORM_BASE_VIEW_TAG);
        
        //Création et affichage de la bulle
        self.control.tooltipView = [[JDFTooltipView alloc] initWithTargetView:((id<MDKErrorViewProtocol>)self.control.styleClass).errorView hostView:currentView tooltipText:@"" arrowDirection:JDFTooltipViewArrowDirectionUp width:self.control.frame.size.width];
        [currentView bringSubviewToFront:self.control.tooltipView];
        self.control.tooltipView.tooltipText = errorText;
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
    return [UIColor colorWithRed:0.8 green:0.1 blue:0.1 alpha:1];
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

-(NSInteger)validate {
    [self clearErrors];
    NSMutableArray *validators = [NSMutableArray array];
    NSMutableDictionary *validationState = [NSMutableDictionary dictionary];
    
    //Mandatory validator
    id mandatoryError = nil;
    id<MDKFieldValidatorProtocol> mandatoryValidator = nil;
    if([self.control mandatory]) {
        
        mandatoryValidator = [[MDKFieldValidatorHandler fieldValidatorsForAttributes:@[FIELD_VALIDATOR_ATTRIBUTE_MANDATORY] forControl:[self control]] firstObject];
        mandatoryError = [mandatoryValidator validate:[self.control getData] withCurrentState:validationState withParameters:@{FIELD_VALIDATOR_ATTRIBUTE_MANDATORY : self.control.mandatory}];
    }
    if(!mandatoryError && self.control.controlAttributes) {
        
        //Component Validators
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
//            if([self.control bindedName]) {
//                validatorParameters[@"componentName"] = [self.control bindedName];
//            }
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
    else {
        if(mandatoryError) {
            validationState[NSStringFromClass([mandatoryValidator class])] = mandatoryError;
        }
    }
    
    int numberOfErrors = 0;
    [self clearErrors];
    for(id result in validationState.allValues) {
        if(![result isKindOfClass:[NSNull class]]) {
            numberOfErrors++;
            [self addErrors:@[result]];
        }
    }
    
    return numberOfErrors;
}

-(void)addControlAttribute:(id)controlAttribute forKey:(NSString *)key {
    NSMutableDictionary *mutableControlAttributes = [self.control.controlAttributes mutableCopy];
    mutableControlAttributes[key] = controlAttribute;
    self.control.controlAttributes = mutableControlAttributes;
}
@end
