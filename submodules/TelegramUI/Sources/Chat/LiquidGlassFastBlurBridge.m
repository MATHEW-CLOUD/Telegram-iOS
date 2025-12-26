
#import "LiquidGlassFastBlurBridge.h"
#import <FastBlur/FastBlur.h>

UIImage * TGLiquidGlassFastBlurImage(UIImage * image) {
    CGImageRef cgImage = image.CGImage;
    if (!cgImage) return image;

    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    size_t bytesPerRow = width * 4;

    uint8_t *data = calloc(height * bytesPerRow, 1);
    if (!data) return image;

    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(data, width, height, 8, bytesPerRow, cs,
        kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(cs);
    if (!ctx) { free(data); return image; }

    CGContextDrawImage(ctx, CGRectMake(0, 0, width, height), cgImage);
    imageFastBlur((int)width, (int)height, (int)bytesPerRow, data);

    CGImageRef outImage = CGBitmapContextCreateImage(ctx);
    UIImage *result = [UIImage imageWithCGImage:outImage scale:image.scale orientation:image.imageOrientation];

    CGImageRelease(outImage);
    CGContextRelease(ctx);
    free(data);
    return result;
}
