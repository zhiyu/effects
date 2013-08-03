#import "UIView+Effects.h"
#import <CoreImage/CoreImage.h>

@implementation UIView (Effects)

- (void)blur{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *imageToBlur = [CIImage imageWithCGImage:viewImage.CGImage];
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:imageToBlur forKey: @"inputImage"];
    [gaussianBlurFilter setValue:[NSNumber numberWithFloat: 15] forKey: @"inputRadius"];
    CIImage *resultImage = [gaussianBlurFilter valueForKey: @"outputImage"];
    
    CGImageRef cgImage = [context createCGImage:resultImage fromRect:self.bounds];
    UIImage *blurredImage = [UIImage imageWithCGImage:cgImage];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.tag = -1;
    imageView.image = blurredImage;
    
    UIView *overlay = [[UIView alloc] initWithFrame:self.bounds];
    overlay.tag = -2;
    overlay.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    
    [self addSubview:imageView];
    [self addSubview:overlay];
    
    [imageView release];
    [overlay release];
}

-(void)unBlur{
    [[self viewWithTag:-1] removeFromSuperview];
    [[self viewWithTag:-2] removeFromSuperview];
}

@end
