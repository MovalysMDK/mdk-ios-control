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

#import "MDKBaseControl.h"
#import "MDKRenderableControl.h"
#import "MDKLabel.h"


/**
 * Constante indiquant la durée de l'animation du bouton d'erreur
 */
NSTimeInterval const ERROR_BUTTON_ANIMATION_DURATION = 0.2f;

/**
 * @brief Constante indiquant la taille (largeur et hauteur) du bouton d'erreur
 */
CGFloat const ERROR_BUTTON_SIZE = 30;


@interface MDKBaseControl()

@property (nonatomic, strong) NSMutableArray *userFieldValidators;

@end


@implementation MDKBaseControl


@synthesize isValid = _isValid;
@synthesize mandatory = _mandatory;
@synthesize visible = _visible;
@synthesize editable = _editable;
@synthesize lastUpdateSender = _lastUpdateSender;
@synthesize errors = _errors;
@synthesize inInitMode = _inInitMode;
@synthesize styleClass = _styleClass;
@synthesize styleClassName = styleClassName;
@synthesize controlAttributes = _controlAttributes;
@synthesize associatedLabel = _associatedLabel;
@synthesize controlDelegate = _controlDelegate;
@synthesize tooltipView = _tooltipView;
@synthesize privateData = _privateData;
@synthesize customStyleClass = _customStyleClass;


#pragma mark - Constructeurs et initialisation
-(id)init {
    self = [super init];
    if(self) {
        //        Initialisation des éléments communs
        self.sender = self;
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //Initialisation des éléments communs
        //        self.sender = self;
        [self initialize];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //Initialisation des éléments communs
        //        self.sender = self;
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withSender:(MDKBaseControl *)sender
{
    self = [super initWithFrame:frame];
    if (self) {
        //Initialisation des éléments communs
        self.sender = sender;
        [self initialize];
    }
    return self;
}


-(void)initialize {
    
    self.controlDelegate = [[MDKControlDelegate alloc] initWithControl:self];

#if !TARGET_INTERFACE_BUILDER
    self.userFieldValidators = [NSMutableArray new];
    [self initErrors];
    self.controlAttributes = [NSMutableDictionary dictionary];
    //Par défaut tout composant est éditable.
    self.editable = @1;
    self.sender = self;
    
#endif
}

-(void) initErrors {
    self.errors = [[NSMutableArray alloc] init];
}

#pragma mark - Méthodes communes à tous les composants

-(void)setIsValid:(BOOL)isValid {
    if (self.isValid != isValid) {
        _isValid = isValid;
        [self showError:!isValid];
    }
}


-(NSInteger)validate {
    [self showError:NO];
    return [self.controlDelegate validate];
}



-(id)getData {
    
    NSLog(@"The component %@ should have implemented the method called \"getData\"",self.class);
    return nil;
}

-(void)setData:(id)data {
    //Here the data has been potentially fixed by the component
    self.controlData = data;
    
    //Update the component with this value
    [self performSelector:@selector(setDisplayComponentValue:) withObject:self.controlData];
}

+ (NSString *) getDataType {
    NSLog(@"The component %@ should have implemented the method called \"getDataType\"",self.class);
    return nil;
}

-(void) selfCustomization {
    //Nothing to do here.
}

#pragma mark - Méthodes du protocole mais non implémentées ici


-(CGRect)getErrorButtonFrameForInvalid {
    CGFloat errorButtonSize = MIN(MIN(self.bounds.size.width, self.bounds.size.height), ERROR_BUTTON_SIZE);
    
    return CGRectMake(0,
                      (self.bounds.size.height - errorButtonSize)/2.0f,
                      errorButtonSize,
                      errorButtonSize);
}

-(CGRect)getErrorButtonFrameForValid {
    CGFloat errorButtonSize = MIN(MIN(self.bounds.size.width, self.bounds.size.height), ERROR_BUTTON_SIZE);
    
    return CGRectMake(-errorButtonSize,
                      (self.bounds.size.height - errorButtonSize)/2.0f,
                      errorButtonSize,
                      errorButtonSize);
}

-(void)hideErrorTooltips {
    if (nil != self.baseTooltipView)
    {
        [self.baseTooltipView removeFromSuperview];
        self.baseTooltipView = nil;
    }
}

-(NSMutableArray *) getErrors {
    return self.errors;
}

-(void) clearErrors{
    [self clearErrors:YES];
}

-(void) clearErrors:(BOOL)anim {
    [self.errors removeAllObjects];
    [self hideErrorTooltips];
    [self setIsValid:YES];
}

-(void) addErrors:(NSArray *) errors{
    if(errors != nil && [errors count]) {
        [self setIsValid:NO];
        
        NSMutableArray *newErrors = [errors mutableCopy];
        for(NSError *error in errors) {
            if([self.errors containsObject:error]) {
                [newErrors removeObject:error];
            }
        }
        [self.errors addObjectsFromArray:newErrors];
    }
}


- (void)dealloc
{
    self.sender = nil;
}

- (void)setI18nKey:(NSString *) defaultValue {
    [self setData:defaultValue];
}


-(void)showError:(BOOL)showErrorView {
    if(![self isKindOfClass:[MDKRenderableControl class]]) {
        if(showErrorView){
            [self showErrorTooltips];
        }
        else {
            [self hideErrorTooltips];
        }
    }
}

-(void)showErrorTooltips {
    [self.tooltipView show];
}

-(UIView *) baseErrorButton {
    return ((id<MDKErrorViewProtocol>)self.styleClass).errorView;
}

-(void)setControlAttributes:(NSDictionary *)controlAttributes {
    _controlAttributes = controlAttributes;
    self.mandatory = controlAttributes[@"mandatory"] ? controlAttributes[@"mandatory"] : @1;
    if(self.associatedLabel) {
        self.associatedLabel.mandatory = self.mandatory;
    }
    self.editable = controlAttributes[@"editable"] ? controlAttributes[@"editable"] : @1;
    self.visible = controlAttributes[@"visible"] ? controlAttributes[@"visible"] : @1;
    if([self isKindOfClass:NSClassFromString(@"MDKRenderableControl")]) {
        [self performSelector:@selector(forwardSpecificRenderableProperties)];
    }
}



#pragma mark - Properties
-(void)setMandatory:(NSNumber *)mandatory {
    _mandatory = mandatory;
    if(self.associatedLabel) {
        self.associatedLabel.mandatory = _mandatory;
    }
}

-(void)setEditable:(NSNumber *)editable {
    _editable = editable;
    if([@0 isEqualToNumber:editable]) {
        [self applyDisabledStyle];
    }
    else {
        [self applyEnabledStyle];
    }
    self.userInteractionEnabled = ([editable isEqualToNumber:@1]) ? YES : NO;
}

-(void)setVisible:(NSNumber *)visible {
    _visible = visible;
    [self setHidden:[visible isEqualToNumber:@0]];
    [self setNeedsDisplay];
}




#pragma mark - Associated Label
-(void)setAssociatedLabel:(MDKLabel *)associatedLabel {
    _associatedLabel = associatedLabel;
    self.associatedLabel.mandatory = self.mandatory;
}


-(NSArray *)controlValidators {
    return @[];
}

-(void)addControlAttribute:(id)controlAttribute forKey:(NSString *)key {
    [self.controlDelegate addControlAttribute:controlAttribute forKey:key];
}

-(void)addFieldValidator:(id<MDKFieldValidatorProtocol>)fieldValidator {
    [self.userFieldValidators addObject:fieldValidator];
}

@end
