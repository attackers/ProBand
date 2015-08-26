//
//  SingleCamera.h
//  SimpleCamera
//
//  Created by star.zxc on 15/2/5.
//  Copyright (c) 2015年 star.zxc. All rights reserved.
//
/*
 *该封装类由Star于2015年2月5日完成
 *该类主要用于使用简单的拍照或者获取相册中的图片
 *使用该类需要实现CameraDelegate协议
 *使用该类需要由一个继承UIView的控件（比如UIButton）调用，并需要指定访问相机的类型
 *相机的类型有三种：camera(照相),photoLibrary(所有本地图片)，photosAlbum(本地照片，比photoLibrary范围略小)
 *需要添加UIView的扩展类，如果已经有该类可以直接将本包中的viewController方法复制过去
 *本类的使用需要添加以下框架
 *<UIKit/UIKit.h>
 *<Foundation/Foundation.h>
 *<MobileCoreServices/MobileCoreServices.h>
 *
 *
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 *该协议用于在拍照后使用照片
 */
@protocol CameraDelegate<NSObject>

- (void)useImageFromCamera:(UIImage *)image;

@end
/*
 *定义了相机的几种类型，调用相机时需要使用该类型
 */
typedef enum{
    camera,
    photoLibrary,
    photosAlbum,
}cameraType;
@interface SingleCamera : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak)id<CameraDelegate>delegate;

+ (SingleCamera *)sharedIntance;

/*
 *本类的主要接口：调用该方法直接进入照相页面或者相册页面，使用照片则需要实现
 *CameraDelegate协议
 */
- (void)cameraFromControl:(UIView *)sender cameraType:(cameraType)type;

@end
