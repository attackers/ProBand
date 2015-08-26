//
//  FileManage.h
//  BusMap
//
//  Created by zhu xian on 11-12-5.
//  Copyright 2011 z. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileManage : NSObject {

	
}
+(BOOL)saveCrash:(NSString *)str;
+(NSString *)getCrash;
+(NSString *) getFilePathByFileName:(NSString*)fileName;
+(BOOL) delWithImagesArray:(NSArray *)imageArray;
+(int) getFileSizeByPath:(NSString*)filePath;
+(BOOL)saveImg:(UIImage *)theImg imageName:(NSString *)imageName;
+(UIImage*) getImageWithName:(NSString*)aFileName;
+(BOOL) delWithImageName:(NSString*)aFileName;
+(BOOL) delWithFolderName:(NSString*)folderName fileName:(NSString *)fileName;
+(int) getFileSize:(NSString*)folderName fileName:(NSString*)fileName;
+(BOOL) delWithAudioName:(NSString *)fileName;
+ (BOOL)writeToTextFile:(NSString *)str  FileName:(NSString *)fileName;
+ (NSString *)readFromTextFile:(NSString *)fileName;
@end
