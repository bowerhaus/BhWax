// UIImage+Save
// Created by Andy Bower on 17 Sep 2012
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Helper methods for scaling and saving an UIImage to disk

#include "gideros.h"

@interface UIImage (Save)
- (UIImage *)resize:(CGSize)maxSize;
- (bool)savePNG:(NSString*)filename;
@end


@implementation UIImage (Save)

-(UIImage*)resize: (CGSize) size {    
    CGSize currentSize=[self size];
    float scaleX=size.width/currentSize.width;
    float scaleY=size.height/currentSize.height;
    float scale=MIN(scaleX, scaleY);
    CGSize newSize=CGSizeMake(currentSize.width*scale, currentSize.height*scale);
    
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

-(bool)savePNG: (NSString*) filename {
    NSData* imageData = UIImagePNGRepresentation(self);
    NSString* fullPath=[NSString stringWithUTF8String:g_pathForFile([filename UTF8String])];
    return [imageData writeToFile:fullPath atomically:false];
}

@end
