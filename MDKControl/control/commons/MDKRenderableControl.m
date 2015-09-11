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

#import "MDKRenderableControl.h"
#import "MDKDefaultStyle.h"
#import "MDKTooltipView.h"
#import "Utils.h"

@interface MDKRenderableControl ()

/**
 * @brief The view used to display that the component is in an invalid state
 */
@property (nonatomic, strong) MDKErrorView *errorView;

/**
 * @brief This dictionary contains the name of the XIBs used to load base MDK iOS components.
 * @discussion It is loaded from the "Framework-components.plist" file from the generated project
 * @discussion The developer can modify this file to use a custom XIB for a MDK Component Type.
 */
@property (nonatomic, strong) NSDictionary *baseMDKComponentsXIBsName;

/**
 * @brief The constraints applied to the internalView to this component.
 * @discussion These constraints can be modified by this class to display/hide the errorView
 */
@property (nonatomic, weak) NSLayoutConstraint *leftConstraint, *topConstraint, *rightConstraint, *bottomConstraint;

/**
 * @brief The constraints applied to the errorView to this component
 * @discussion These constraints can be modified by this class to display/hide the errorView
 */
@property (nonatomic, weak) NSLayoutConstraint *errorRightConstraint, *errorCenterYConstraint, *errorWidthConstraint, *errorHeightConstraint;

@end

/******************************************************/
/* CONSTANTS                                          */
/******************************************************/

const struct ErrorPositionParameters_Struct ErrorPositionParameters = {
    .ErrorView = @"ErrorView",
    .ParentView = @"ParentView",
    .InternalViewLeftConstraint = @"InternalViewLeftConstraint",
    .InternalViewTopConstraint = @"InternalViewTopConstraint",
    .InternalViewRightConstraint = @"InternalViewRightConstraint",
    .InternalViewBottomConstraint = @"InternalViewbottomConstraint"
};


@implementation MDKRenderableControl

/******************************************************/
/* SYNTHESIZE                                         */
/******************************************************/

#pragma mark - Synthesize
@synthesize editable = _editable;
@synthesize styleClass = _styleClass;
@synthesize tooltipView = _tooltipView;


/******************************************************/
/* INITITALISATION                                    */
/******************************************************/

#pragma mark - Initialization and deallocation
-(void)initialize {
    NSMutableDictionary *xibFrameworkDict = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle bundleForClass:NSClassFromString(@"MDKRenderableControl")] pathForResource:@"Framework-components" ofType:@"plist"]];
    
    NSMutableDictionary *xibProjectDict = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle bundleForClass:NSClassFromString(@"AppDelegate")] pathForResource:@"Project-components" ofType:@"plist"]];
    
    if(xibProjectDict) {
        [xibFrameworkDict addEntriesFromDictionary:xibProjectDict];
    }
    
    self.baseMDKComponentsXIBsName = xibFrameworkDict;
    [super initialize];
}

-(void) commonInit {
    if([self conformsToProtocol:@protocol(MDKExternalComponent)]) {
        
        if(self.internalView) {
            [self.internalView removeFromSuperview];
        }
        @try {
            Class bundleClass = [[self retrieveCustomXIB] hasPrefix:MDK_XIB_IDENTIFIER] ?  NSClassFromString(@"MDKRenderableControl") : NSClassFromString(@"AppDelegate");
            
            
            self.internalView = [[[NSBundle bundleForClass:bundleClass] loadNibNamed:[self retrieveCustomXIB] owner:self options:nil] firstObject];
            
            [self.internalView performSelector:@selector(setExternalView:) withObject:self];
            
        }
        @catch(NSException *e) {
            NSLog(@"%@", e.description);
        }
        
        [self addSubview:self.internalView];
        if(self.internalView) {
            [self setNeedsUpdateConstraints];
        }
        [self setDisplayComponentValue:self.controlData];
        [self forwardBaseRenderableProperties];
        [self forwardSpecificRenderableProperties];
        
    }
    else if([self conformsToProtocol:@protocol(MDKInternalComponent)]){
        [self applyStandardStyle];
        [self renderComponent:self];
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    [self computeStyleClass];
}

-(void) didInitializeOutlets {
    NSLog(@"[MDKControl - INFO] : \"didInitializeOutlets\" method is unimplement for the class %@", [self class]);
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
    [self didInitializeOutlets];
}




/******************************************************/
/* CUSTOM METHODES                                    */
/******************************************************/

#pragma mark - Custom Methods

-(NSString *)className {
    return [self respondsToSelector:@selector(defaultXIBName)] ? [[self performSelector:@selector(defaultXIBName)] stringByReplacingOccurrencesOfString:MDK_XIB_IDENTIFIER withString:@""] : nil;
}

-(void)setEditable:(NSNumber *)editable {
    [super setEditable:editable];
    self.internalView.userInteractionEnabled = [editable isEqual:@1];
}

-(void)setDisplayComponentValue:(id)value {
    NSLog(@"[MDKControl - WARNING] : \"setDisplayComponentValue:\" method is unimplemend for the control %@", [self class]);
}

-(id)displayComponentValue {
    NSLog(@"[MDKControl - WARNING] : \"displayComponentValue\" method is unimplemend for the control %@", [self class]);
    return nil;
}


/******************************************************/
/* CONTRAINTES INT/EXT                                */
/******************************************************/


#pragma mark - Constraints
/**
 * @brief Defines the constraints of the internal view in the external view
 */
-(void) defineInternalViewConstraints {
    
    self.leftConstraint = nil;
    self.bottomConstraint = nil;
    self.rightConstraint = nil;
    self.topConstraint = nil;
    
    //S'il y a internalView, alors on applique les contraintes entre la vue externe et la vue interne
    if(self.internalView) {
        [self computeInternalLeftConstraint];
        [self computeInternalRightConstraint];
        [self computeInternalTopConstraint];
        [self computeInternalBottomConstraint];
        
    }
    
    //Animation des changements
    [UIView animateWithDuration:0.0
                     animations:^{
                         self.errorView.alpha = 1.0;
                         [self layoutIfNeeded]; // Called on parent view
                     }];
}

-(void) removeErrorViewConstraints {
    if(self.errorWidthConstraint) [self removeConstraint:self.errorWidthConstraint];
    if(self.errorRightConstraint) [self removeConstraint:self.errorRightConstraint];
    if(self.errorHeightConstraint) [self removeConstraint:self.errorHeightConstraint];
    if(self.errorCenterYConstraint) [self removeConstraint:self.errorCenterYConstraint];
    
    self.errorCenterYConstraint = nil;
    self.errorHeightConstraint = nil;
    self.errorRightConstraint = nil;
    self.errorWidthConstraint = nil;
    self.rightConstraint.constant  = 0;
}

-(void) computeInternalLeftConstraint {

    if(!self.leftConstraint) {
        self.leftConstraint = [NSLayoutConstraint constraintWithItem:self.internalView attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft
                                                          multiplier:1 constant:0];
        [self addConstraint:self.leftConstraint];
    }
}

-(void) computeInternalTopConstraint {
    if(!self.topConstraint) {
        self.topConstraint = [NSLayoutConstraint constraintWithItem:self.internalView attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop
                                                         multiplier:1 constant:0];
        [self addConstraint:self.topConstraint];
    }
}

-(void) computeInternalRightConstraint {
    if(!self.rightConstraint) {
        self.rightConstraint = [NSLayoutConstraint constraintWithItem:self.internalView attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight
                                                           multiplier:1 constant:0];
        [self addConstraint:self.rightConstraint];
    }
}

-(void) computeInternalBottomConstraint {
    if(!self.bottomConstraint) {
        self.bottomConstraint = [NSLayoutConstraint constraintWithItem:self.internalView attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom
                                                            multiplier:1 constant:0];
        [self addConstraint:self.bottomConstraint];
    }
}

/**
 * @brief Defines the constraints of the error view in the external view
 */
-(void) defineErrorViewConstraints {
//#if !TARGET_INTERFACE_BUILDER
    self.errorView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if(!self.errorRightConstraint) {
        self.errorRightConstraint = [NSLayoutConstraint constraintWithItem:self.errorView attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight
                                                               multiplier:1 constant:0];
    }
    
    if(!self.errorCenterYConstraint) {
        self.errorCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.errorView attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1 constant:0];
    }
    
    if(!self.errorHeightConstraint) {
        self.errorHeightConstraint = [NSLayoutConstraint constraintWithItem:self.errorView attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight
                                                                 multiplier:1 constant:0];
    }
    
    if(!self.errorWidthConstraint) {
        self.errorWidthConstraint = [NSLayoutConstraint constraintWithItem:self.errorView attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0 constant:self.errorView.frame.size.width];
        
        [self addConstraint:self.errorWidthConstraint];
        [self addConstraint:self.errorHeightConstraint];
        [self addConstraint:self.errorCenterYConstraint];
        [self addConstraint:self.errorRightConstraint];
    }
}

-(void)updateConstraints {
    [self defineInternalViewConstraints];
    [super updateConstraints];
}




/******************************************************/
/* XIBs                                               */
/******************************************************/

#pragma mark - Retrieving XIBs
/**
 * @brief Retrieves a custom XIB if defined in InterfaceBuilder.
 * @return The name of the custom XIB to load
 */
-(NSString *)retrieveCustomXIB {
    if([((id<MDKExternalComponent>)self) customXIBName]) {
        return [((id<MDKExternalComponent>)self) customXIBName];
    }
    else {
        return [self.baseMDKComponentsXIBsName objectForKey:[((id<MDKExternalComponent>)self) defaultXIBName]];
    }
}

/**
 * @brief Retrieves a custom XIB if defined in InterfaceBuilder.
 * @return The name of the custom XIB to load
 */
-(NSString *)retrieveCustomErrorXIB {
    if([((id<MDKExternalComponent>)self) customErrorXIBName]) {
        return [((id<MDKExternalComponent>)self) customErrorXIBName];
    }
    else {
        return [((id<MDKExternalComponent>)self) defaultErrorXIBName];
    }
}

/**
 * @brief Returns the name of the default XIB file to render the error view
 */
-(NSString *)defaultErrorXIBName {
    return @"MDK_MDKErrorView";
}

-(NSString *)defaultXIBName {
    return NSStringFromClass(self.class);
}



/******************************************************/
/* LIVE RENDERING                                     */
/******************************************************/

#pragma mark - Live Rendering
/**
 * @brief Renders the component using the specific renderable properties.
 * @discussion In this MFBaseRenderableComoponent class, the base inspectable properties are used
 * to render the global appearence of the component.
 * @discussion This method should be used to increase the rendering on components that intherits from
 * this base class
 * @discussion This method is called in the (drawRect:) UIView's method
 * @param view The renderable component view to render using specific inspectable properties
 */
-(void)renderComponent:(MDKRenderableControl *)view {
    view.layer.borderWidth = self.borderWidth_MDK;
    view.layer.borderColor = self.borderColor_MDK.CGColor;
    view.layer.cornerRadius = self.cornerRadius_MDK;
    view.layer.masksToBounds = YES;
    view.tooltipView.tooltipBackgroundColour = self.tooltipColor_MDK;
}

/**
 * @brief This required method must forward specific renderable properties on
 * the internal view.
 * @discussion Due to the different possible types for IBInspectable attributes, it's actually not possible
 * to forward automatically the IBInspectable attributes from the external view to the internal view.
 * @discussion Forwarding these properties allows you to used them both on the XIB that represents the Internal view
 * and the Storyboard that contains the external view.
 * @discussion This method is called when this MFBaseRenderableComponent is an external view only.
 */
-(void)forwardSpecificRenderableProperties {
    //Exception
}


/**
 * @brief Forwards the the base renderable properties on the intenal view
 */
-(void) forwardBaseRenderableProperties {
    if(self.borderColor_MDK) {
        self.internalView.borderColor_MDK = self.borderColor_MDK;
    }
    if(self.borderWidth_MDK) {
        self.internalView.borderWidth_MDK = self.borderWidth_MDK;
    }
    if(self.cornerRadius_MDK) {
        self.internalView.cornerRadius_MDK = self.cornerRadius_MDK;
    }
    if(self.tooltipColor_MDK) {
        self.internalView.tooltipColor_MDK = self.tooltipColor_MDK;
    }
    if(self.styleClass) {
        self.internalView.styleClass = self.styleClass;
    }
    [self.internalView renderComponent:self.internalView];
}

-(void)prepareForInterfaceBuilder {
    
    [super prepareForInterfaceBuilder];
    [self commonInit];
    [self computeStyleClass];
    if(self.onError_MDK) {
        [self applyStandardStyle];
        [self applyErrorStyle];
    }
    else {
        [self applyStandardStyle];
        [self applyValidStyle];
    }
    [self showError:self.onError_MDK];
}



/******************************************************/
/* STYLE                                              */
/******************************************************/


#pragma mark - Style
-(void) computeStyleClass {
    /**
     * Style priority :
     * 1. User Defined Runtime Attribute named "styleClass"
     * 2. Class style based on the component class name
     * 3. Class style defined as a bean base on the component class name
     * 4. Default Movalys style
     */
    NSString *componentClassStyleName = [NSString stringWithFormat:@"%@Style", [self class]];
    
    if(self.styleClassName) {
        self.styleClass = [NSClassFromString(self.styleClassName) new];
    }
    else if(componentClassStyleName){
        self.styleClass = [NSClassFromString(componentClassStyleName) new];
    }
    //TODO: Style via BeanLoader
    else {
        self.styleClass = [NSClassFromString(@"MFDefaultStyle") new];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"
//-(void)setStyleClass:(NSString *)styleClass {
//    _styleClass = styleClass;
//    if(_styleClass) {
//        [[[NSClassFromString(self.styleClass) alloc] init] performSelector:@selector(applyStyleOnView:) withObject:self];
//    }
//}
#pragma clang diagnostic pop


/******************************************************/
/* ERROR                                              */
/******************************************************/

#pragma mark - Managing error
/**
 * @brief Allows to display or not the view that indicates that the component is in an invalid state
 * @param showErrorView A BOOL value that indicates if the component is in an invalid state or not
 */
-(void) showError:(BOOL)showError {
    
    if([self conformsToProtocol:@protocol(MDKExternalComponent) ]) {
        if(showError) {
            if(!self.errorView) {
                Class errorBundleClass = [[self retrieveCustomErrorXIB] hasPrefix:MDK_XIB_IDENTIFIER] ?  NSClassFromString(@"MDKRenderableControl") : NSClassFromString(@"AppDelegate");
                self.errorView = [[[NSBundle bundleForClass:errorBundleClass] loadNibNamed:[self retrieveCustomErrorXIB] owner:nil options:nil] firstObject];
            }
            self.errorView.userInteractionEnabled = YES;
            [self addSubview:self.errorView];
            self.tooltipView = [[MDKTooltipView alloc] initWithTargetView:self.errorView.errorButton
                                                                 hostView:self tooltipText:@""
                                                           arrowDirection:MDKTooltipViewArrowDirectionUp
                                                                    width:self.frame.size.width];
            
            if([self respondsToSelector:@selector(definePositionOfErrorViewWithParameters:whenShown:)]) {
#if !TARGET_INTERFACE_BUILDER
                NSDictionary *errorPositionParameters = [self createErrorPositionParameters];
                [self definePositionOfErrorViewWithParameters:errorPositionParameters whenShown:showError];
#endif
            }
            else {
                [self defineErrorViewConstraints];
            }

        }
        else {
            [self.tooltipView hideAnimated:YES];
            [self.errorView removeFromSuperview];
            if([self respondsToSelector:@selector(definePositionOfErrorViewWithParameters:whenShown:)]) {
#if !TARGET_INTERFACE_BUILDER
                if(!self.errorView) {
                    Class errorBundleClass = [[self retrieveCustomErrorXIB] hasPrefix:MDK_XIB_IDENTIFIER] ?  NSClassFromString(@"MDKRenderableControl") : NSClassFromString(@"AppDelegate");
                    self.errorView = [[[NSBundle bundleForClass:errorBundleClass] loadNibNamed:[self retrieveCustomErrorXIB] owner:nil options:nil] firstObject];
                }

                NSDictionary *errorPositionParameters = [self createErrorPositionParameters];
                [self definePositionOfErrorViewWithParameters:errorPositionParameters whenShown:showError];
#endif
            }
            else {
                [self removeErrorViewConstraints];
            }
        }
        [self bringSubviewToFront:self.errorView];
    }
}

-(NSDictionary *) createErrorPositionParameters {
    return [NSDictionary dictionaryWithObjects:@[self.errorView,
                                                 self,
                                                 self.leftConstraint,
                                                 self.topConstraint,
                                                 self.rightConstraint,
                                                 self.bottomConstraint]
                                       forKeys:@[ErrorPositionParameters.ErrorView,
                                                 ErrorPositionParameters.ParentView,
                                                 ErrorPositionParameters.InternalViewLeftConstraint,
                                                 ErrorPositionParameters.InternalViewTopConstraint,
                                                 ErrorPositionParameters.InternalViewRightConstraint,
                                                 ErrorPositionParameters.InternalViewBottomConstraint]];
}

/**
 * @brief This method describes the treatment to do when the user click the error button of this component
 * @discussion By default, this method displays the error information
 */
-(void)doOnErrorButtonClicked {
    if(![self.tooltipView superview]) {
        NSString *errorText = @"";
        
        int errorNumber = 0;
        for (NSError *error in self.errors) {
            if(errorNumber > 0){
                errorText = [errorText stringByAppendingString: @"\n"];
            }
            errorNumber++;
            errorText= [errorText stringByAppendingString: [error localizedDescription]];
        }
        //Passage de la vue au premier plan
        UIView *currentView = self;
        do {
            UIView *superView = currentView.superview;
            [superView setClipsToBounds:NO];
            [superView bringSubviewToFront:currentView];
            currentView = superView;
        } while (currentView.tag != FORM_BASE_TABLEVIEW_TAG && currentView.tag != FORM_BASE_VIEW_TAG && currentView.superview != nil);
        [currentView bringSubviewToFront:self.tooltipView];
        [currentView bringSubviewToFront:self.errorView];
        self.tooltipView.tooltipText = errorText;
        self.tooltipView.tooltipBackgroundColour = self.tooltipColor_MDK ? self.tooltipColor_MDK : [self defaultTooltipBackgroundColor];
        
        [self.tooltipView show];
        [self bringSubviewToFront:self.tooltipView];
    }
    else {
        [self.tooltipView hideAnimated:YES];
    }
    [self bringSubviewToFront:self.tooltipView];
}

-(UIColor *) defaultTooltipBackgroundColor {
    return [UIColor colorWithRed:0.8 green:0.1 blue:0.1 alpha:1];
}

-(void)addErrors:(NSArray *)errors {
    [super addErrors:errors];
    [self applyErrorStyle];
}

-(void)clearErrors {
    [super clearErrors];
    [self applyValidStyle];
}


@end
