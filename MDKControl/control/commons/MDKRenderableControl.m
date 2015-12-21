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
@property (nonatomic, strong) MDKMessageView *messageView;

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

const struct MDKMessagePositionParameters_Struct MDKMessagePositionParameters = {
    .MessageView = @"MessageView",
    .ParentView = @"ParentView",
    .InternalViewLeftConstraint = @"InternalViewLeftConstraint",
    .InternalViewTopConstraint = @"InternalViewTopConstraint",
    .InternalViewRightConstraint = @"InternalViewRightConstraint",
    .InternalViewBottomConstraint = @"InternalViewbottomConstraint"
};

const struct MDKRenderableForwarding_Struct MDKRenderableForwarding = {
    .ToInternal = @"ToInternal",
    .ToExternal = @"ToExternal"
};


@implementation MDKRenderableControl

/******************************************************/
/* SYNTHESIZE                                         */
/******************************************************/

#pragma mark - Synthesize
@synthesize editable = _editable;
@synthesize styleClass = _styleClass;
@synthesize controlData = _controlData;
@synthesize tooltipView = _tooltipView;
@synthesize controlAttributes = _controlAttributes;

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
    [self.internalView forwardOutlets:self];
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

-(void)forwardProperty:(NSString *)propertyName withDirection:(NSString *)direction {
    NSString *firstCharUppercasedPropertyName = [NSString stringWithFormat:@"%@%@", [[propertyName substringToIndex:1] uppercaseString], [propertyName substringFromIndex:1]];
    NSString *selectorAsString = [NSString stringWithFormat:@"set%@:", firstCharUppercasedPropertyName];
    
    if([direction isEqualToString:MDKRenderableForwarding.ToInternal]) {
        id object = [self.externalView performSelector:NSSelectorFromString(propertyName)];
        
        [self.internalView performSelector:NSSelectorFromString(selectorAsString) withObject:object];
    }
    else {
        id object = [self.internalView performSelector:NSSelectorFromString(propertyName)];
        
        [self.externalView performSelector:NSSelectorFromString(selectorAsString) withObject:object];
    }
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
    [UIView animateWithDuration:0.25f
                     animations:^{
                         self.messageView.alpha = 1.0;
                         [self.internalView layoutIfNeeded]; // Called on parent view
                     }];
}

-(void) removeMessageViewConstraints {
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
        
        //Uncomment to improve the display of the message view.
//        self.rightConstraint = [NSLayoutConstraint constraintWithItem:self.internalView attribute:NSLayoutAttributeRight
//                                                            relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight
//                                                           multiplier:1 constant:(self.messageView != nil) ? -self.messageView.frame.size.width : 0];
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
-(void) defineMessageViewConstraints {
    //#if !TARGET_INTERFACE_BUILDER
    self.messageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if(!self.errorRightConstraint) {
        self.errorRightConstraint = [NSLayoutConstraint constraintWithItem:self.messageView attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight
                                                                multiplier:1 constant:0];
    }
    
    if(!self.errorCenterYConstraint) {
        self.errorCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.messageView attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1 constant:0];
    }
    
    if(!self.errorHeightConstraint) {
        self.errorHeightConstraint = [NSLayoutConstraint constraintWithItem:self.messageView attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight
                                                                 multiplier:1 constant:0];
    }
    
    if(!self.errorWidthConstraint) {
        self.errorWidthConstraint = [NSLayoutConstraint constraintWithItem:self.messageView attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0 constant:self.messageView.frame.size.width];
        
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
-(NSString *)retrieveCustomMessageXIB {
    if([((id<MDKExternalComponent>)self) customMessageXIBName]) {
        return [((id<MDKExternalComponent>)self) customMessageXIBName];
    }
    else {
        return [((id<MDKExternalComponent>)self) defaultMessageXIBName];
    }
}

/**
 * @brief Returns the name of the default XIB file to render the error view
 */
-(NSString *)defaultMessageXIBName {
    return @"MDK_MDKMessageView";
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
    if([self controlRenderableProperties]) {
        for(NSString* propertyName in [self controlRenderableProperties]) {
            NSString *firstCharUppercasedPropertyName = [NSString stringWithFormat:@"%@%@", [[propertyName substringToIndex:1] uppercaseString], [propertyName substringFromIndex:1]];
            NSString *selectorAsString = [NSString stringWithFormat:@"set%@:", firstCharUppercasedPropertyName];
            [self.internalView performSelector:NSSelectorFromString(selectorAsString) withObject:[self performSelector:NSSelectorFromString(propertyName)]];
        }
    }
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
    [self forwardSpecificRenderableProperties];
    [self.internalView renderComponent:self.internalView];
}

-(NSArray *)controlRenderableProperties {
    //Default return is nil.
    //Should be implemented in subclasses to decalres specific renderable properties name.
    return nil;
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
    [self showMessage:self.onError_MDK];
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
    NSString *componentClassStyleName = [NSString stringWithFormat:@"%@Style", [self controlName]];
    
    if(self.styleClassName) {
        self.styleClass = [NSClassFromString(self.styleClassName) new];
    }
    else if(componentClassStyleName){
        self.styleClass = [NSClassFromString(componentClassStyleName) new];
    }
    //TODO: Style via BeanLoader
    else {
        self.styleClass = [NSClassFromString(@"MDKDefaultStyle") new];
    }
    [self applyStandardStyle];
}

-(NSString *)controlName {
    Class c = self.class;
    if([self conformsToProtocol:@protocol(MDKInternalComponent)]) {
        c = self.externalView.class;
    }
    return NSStringFromClass(c);
}


-(void)setStyleClass:(NSString *)styleClass {
    if([self conformsToProtocol:@protocol(MDKExternalComponent)]) {
        self.internalView.styleClass = styleClass;
    }
    else {
        _styleClass = styleClass;
    }
}

-(NSString *)styleClass {
    if ([self conformsToProtocol:@protocol(MDKExternalComponent)]) {
        return self.internalView.styleClass;
    }
    else {
        return _styleClass;
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
 * @param showMessageView A BOOL value that indicates if the component is in an invalid state or not
 */
-(void) showMessage:(BOOL)showMessage {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self conformsToProtocol:@protocol(MDKExternalComponent) ]) {
            if(showMessage) {
                if(!self.messageView) {
                    Class errorBundleClass = [[self retrieveCustomMessageXIB] hasPrefix:MDK_XIB_IDENTIFIER] ?  NSClassFromString(@"MDKRenderableControl") : NSClassFromString(@"AppDelegate");
                    self.messageView = [[[NSBundle bundleForClass:errorBundleClass] loadNibNamed:[self retrieveCustomMessageXIB] owner:nil options:nil] firstObject];
                }
                self.messageView.userInteractionEnabled = YES;
                [self addSubview:self.messageView];
                
                [MDKMessageUIManager autoStyleMessageButton:self.messageView.messageButton forMessages:[self messages]];
                self.tooltipView = [[MDKTooltipView alloc] initWithTargetView:self.messageView.messageButton
                                                                     hostView:[self parentViewController].view tooltipText:@""
                                                               arrowDirection:MDKTooltipViewArrowDirectionUp
                                                                        width:self.frame.size.width];
                
                if([self respondsToSelector:@selector(definePositionOfMessageViewWithParameters:whenShown:)]) {
#if !TARGET_INTERFACE_BUILDER
                    NSDictionary *errorPositionParameters = [self createMessagePositionParameters];
                    [self definePositionOfMessageViewWithParameters:errorPositionParameters whenShown:showMessage];
#endif
                }
                else {
                    [self defineMessageViewConstraints];
                }
                
            }
            else {
                [self.tooltipView hideAnimated:YES];
                [self.messageView removeFromSuperview];
                if([self respondsToSelector:@selector(definePositionOfMessageViewWithParameters:whenShown:)]) {
#if !TARGET_INTERFACE_BUILDER
                    if(!self.messageView) {
                        Class errorBundleClass = [[self retrieveCustomMessageXIB] hasPrefix:MDK_XIB_IDENTIFIER] ?  NSClassFromString(@"MDKRenderableControl") : NSClassFromString(@"AppDelegate");
                        self.messageView = [[[NSBundle bundleForClass:errorBundleClass] loadNibNamed:[self retrieveCustomMessageXIB] owner:nil options:nil] firstObject];
                    }
                    
                    NSDictionary *errorPositionParameters = [self createMessagePositionParameters];
                    [self definePositionOfMessageViewWithParameters:errorPositionParameters whenShown:showMessage];
#endif
                }
                else {
                    [self removeMessageViewConstraints];
                }
            }
            [self bringSubviewToFront:self.messageView];
        }
        else {
            [self.externalView showMessage:showMessage];
        }
        
    });
}

-(NSDictionary *) createMessagePositionParameters {
    return [NSDictionary dictionaryWithObjects:@[self.messageView,
                                                 self,
                                                 self.leftConstraint,
                                                 self.topConstraint,
                                                 self.rightConstraint,
                                                 self.bottomConstraint]
                                       forKeys:@[MDKMessagePositionParameters.MessageView,
                                                 MDKMessagePositionParameters.ParentView,
                                                 MDKMessagePositionParameters.InternalViewLeftConstraint,
                                                 MDKMessagePositionParameters.InternalViewTopConstraint,
                                                 MDKMessagePositionParameters.InternalViewRightConstraint,
                                                 MDKMessagePositionParameters.InternalViewBottomConstraint]];
}

/**
 * @brief This method describes the treatment to do when the user click the error button of this component
 * @discussion By default, this method displays the error information
 */
-(void)doOnMessageButtonClicked {
    if(![self.tooltipView superview]) {
        NSString *messageText = @"";
        
        int messageNumber = 0;
        for (id<MDKMessageProtocol> message in self.messages) {
            if(messageNumber > 0){
                messageText = [messageText stringByAppendingString: @"\n"];
            }
            messageNumber++;
            messageText= [messageText stringByAppendingString: [message messageContent]];
        }
        //Passage de la vue au premier plan
        UIView *currentView = [self parentViewController].view;
        
        [currentView bringSubviewToFront:self.tooltipView];
        self.tooltipView.tooltipText = messageText;
        self.tooltipView.tooltipBackgroundColour = self.tooltipColor_MDK ? self.tooltipColor_MDK : [self defaultTooltipBackgroundColor];
        
        [self.tooltipView show];
    }
    else {
        [self.tooltipView hideAnimated:YES];
    }
}

-(UIColor *) defaultTooltipBackgroundColor {
    return [UIColor colorWithRed:0.8 green:0.1 blue:0.1 alpha:1];
}

-(void)addMessages:(NSArray *)errors {
    [super addMessages:errors];
    [self applyErrorStyle];
}

-(void)clearMessages {
    [super clearMessages];
    [self applyValidStyle];
}

-(void) refreshControl {
    //    [self.externalView setData:self.externalView.privateData];
    [self.internalView setData:self.internalView.controlData];
}


#pragma mark - FOWARDING
-(void)setControlAttributes:(NSDictionary *)controlAttributes {
    [super setControlAttributes:controlAttributes];
    if([self conformsToProtocol:@protocol(MDKExternalComponent)]) {
        [self.internalView setControlAttributes:controlAttributes];
    }
    else {
        _controlAttributes = controlAttributes;
    }
}

-(NSDictionary *)controlAttributes {
    if([self conformsToProtocol:@protocol(MDKExternalComponent)]) {
        return [self.internalView controlAttributes];
    }
    else {
        return _controlAttributes;
    }
}

-(id)controlData {
    if([self conformsToProtocol:@protocol(MDKInternalComponent)]) {
        return (id<MDKInternalComponent>)self.externalView.controlData;
    }
    return _controlData;
}

-(void)setControlData:(id)controlData {
    if([self conformsToProtocol:@protocol(MDKInternalComponent)]) {
        [((MDKRenderableControl *)self.externalView) setControlData:controlData];
    }
    _controlData = controlData;
}

-(NSUInteger)hash {
    NSUInteger result = [super hash];
    if([self conformsToProtocol:@protocol(MDKInternalComponent)]) {
        result = self.externalView.hash;
    }
    return result;
}

-(void) forwardOutlets:(id)external {
    //Let empty
}

@end


