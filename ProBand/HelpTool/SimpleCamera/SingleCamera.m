//
//  SingleCamera.m
//  SimpleCamera
//
//  Created by star.zxc on 15/2/5.
//  Copyright (c) 2015年 star.zxc. All rights reserved.
//

#import "SingleCamera.h"
#import "UIView+category.h"
#import <MobileCoreServices/MobileCoreServices.h>
//@property (strong, nonatomic)UIImage *pickedImage;
@implementation SingleCamera
{
    UIImagePickerController *imagePicker;
    UIImage *_pickedImage;
}

+ (SingleCamera *)sharedIntance
{
    static SingleCamera *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc]init];
    });
    return shared;
}

- (id)init
{
    self = [super init];
    if (self) {
        //初始化
        imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        
        _pickedImage = [UIImage new];
    }
    return self;
}

- (void)cameraFromControl:(UIView *)sender cameraType:(cameraType)type
{
    //获取sender所在的UIVIewController
    UIViewController *viewController = [sender viewController];
    //访问权限
    switch (type) {
        case camera:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
        }
            break;
        case photoLibrary:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
        }
            break;
        case photosAlbum:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
            break;
        default:
            break;
    }
    [viewController presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark-UIImagePickerControllerDelegate协议中的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取媒体类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //判断是静态图像还是视频
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        //获取用户编辑之后的图
        UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
        //完成后调用使用图片的block
        _pickedImage = image;
        //必须退出相机
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        //使用block传递消息
//        if (self.block)
//        {
//            self.block(_pickedImage);
//        }
        
        //改为使用协议传值
        [self.delegate useImageFromCamera:_pickedImage];
    }
}
//左下角cancel按钮调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
