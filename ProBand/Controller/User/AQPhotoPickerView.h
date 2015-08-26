#import <UIKit/UIKit.h>

@class AQPhotoPickerView;
@protocol AQPhotoPickerViewDelegate
-(void)photoFromImagePickerView:(UIImage*)photo;
@end

@interface AQPhotoPickerView : UIView <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

+(void)presentInViewController:(UIViewController<AQPhotoPickerViewDelegate>*) viewController
                   photoSource:(NSString*) imagePath;

@end