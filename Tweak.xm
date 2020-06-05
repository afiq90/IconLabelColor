
// Change text icon text color
@interface SBIconLabelImageParameters : NSObject {
	UIColor* _textColor;
	NSString* _text;
	UIFont* _font;

}
@property (nonatomic,copy,readonly) NSString *text; 
@property (nonatomic,readonly) UIColor *_textColor;
- (UIImage *)gradientImage;
@end

%hook SBIconLabelImageParameters 

//this will change the app name
-(NSString *)text {
	return %orig;
}

-(UIFont *)font {
	// set desired font
	return %orig;
}

-(UIColor *)textColor {
	//return whatever color u want

	//normal color
	return [UIColor cyanColor];

	//gradient color
	// return [UIColor colorWithPatternImage:[self gradientImage]];
}

-(BOOL)colorspaceIsGrayscale {
	return false;
}

// gradient textColor 
%new 
- (UIImage *)gradientImage {

	UIFont *font = MSHookIvar<UIFont *>(self, "_font");
    CGSize textSize = [self.text sizeWithFont:font];
    CGFloat width = textSize.width;         // max 1024 due to Core Graphics limitations
    CGFloat height = textSize.height;       // max 1024 due to Core Graphics limitations

    // create a new bitmap image context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));

    // get context
    CGContextRef context = UIGraphicsGetCurrentContext();       

    // push context to make it current (need to do this manually because we are not drawing in a UIView)
    UIGraphicsPushContext(context);                             

    //draw gradient    
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 0.0, 1.0, 1.0, 1.0,  // Start color
                            1.0, 1.0, 0.0, 1.0 }; // End color
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    CGPoint topCenter = CGPointMake(0, 0);
    CGPoint bottomCenter = CGPointMake(0, textSize.height);
    CGContextDrawLinearGradient(context, glossGradient, topCenter, bottomCenter, 0);

    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace); 

    // pop context 
    UIGraphicsPopContext();                             

    // get a UIImage from the image context
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();

    // clean up drawing environment
    UIGraphicsEndImageContext();

    return  gradientImage;
}

%end