//
//  ThirdPartyUserModel.h
//  LenovoVB10
//
//  Created by star.zxc on 15/4/14.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThirdPartyUserModel : NSObject
/*
 *登录服务器实际上只需要userId
 */
@property (nonatomic, strong)NSString *userId;//id,不是注册号码
@property (nonatomic, strong)NSString *nickName;//昵称
@property (nonatomic, strong)NSString *headImageUrl;//用户头像（网络）路径


/*
 *以下信息属于可选内容，可能不需要上传服务器
 *下面有很多信息获取时为空，无法上传需要注意
 */
@property (nonatomic, strong)NSString *birthDay;//用户生日
//用户原始数据，包含用户id，地址等诸多信息，
@property (nonatomic, strong)NSDictionary *sourceData;
//用户所属平台类型
@property (nonatomic, assign)ShareType type;
//性别
@property (nonatomic, assign)NSInteger gender;
//个人主页地址
@property (nonatomic, strong)NSString *personalUrl;
//用户个人信息
@property (nonatomic, strong)NSString *personalInfo;


/*
 *以下内容基本不用，留个接口需要时再用
 */

/**
 *	@brief	获取用户认证类型
 *
 *	@return	认证类型：－1 未知； 0 未认证； 1 认证。
 */
@property (nonatomic, assign)NSInteger verifyType;
/**
 *	@brief	获取用户认证信息
 *
 *	@return	认证信息
 */
@property (nonatomic, strong)NSString *verifyReason;
/**
 *	@brief	获取用户粉丝数
 *
 *	@return	粉丝数量
 */
@property (nonatomic, assign)NSInteger followerCount;
/**
 *	@brief	获取用户关注数
 *
 *	@return	关注数量
 */
@property (nonatomic, assign)NSInteger friendCount;
/**
 *	@brief	获取用户分享数
 *
 *	@return	分享数量
 */
@property (nonatomic, assign)NSInteger shareCount;
/**
 *	@brief	获取用户的注册时间（单位：秒）
 *
 *	@return	注册时间
 */
@property (nonatomic, assign)NSTimeInterval regAt;
/**
 *	@brief	获取用户等级
 *
 *	@return	等级
 */
@property (nonatomic, assign)NSInteger level;
/**
 *	@brief	获取用户的教育信息列表
 *
 *	@return	教育信息列表
 */
@property (nonatomic, strong)NSArray *educations;
/**
 *	@brief	获取用户的职业信息列表
 *
 *	@return	职业信息列表
 */
@property (nonatomic, strong)NSArray *works;


@end
