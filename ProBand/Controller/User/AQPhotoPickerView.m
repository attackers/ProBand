#import "AQPhotoPickerView.h"

@interface AQPhotoPickerViewOwner : NSObject
@property (nonatomic, weak) IBOutlet AQPhotoPickerView *decoupledView;
@end

@implementation AQPhotoPickerViewOwner
@end


@interface AQPhotoPickerView ()

@property (nonatomic, weak) UIViewController <AQPhotoPickerViewDelegate> *delegateViewController;
@property (nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation AQPhotoPickerView

+(void)presentInViewController:(UIViewController<AQPhotoPickerViewDelegate>*) viewController
                   photoSource:(NSString*) imagePath
{
    AQPhotoPickerViewOwner *owner = [AQPhotoPickerViewOwner new];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:owner options:nil];

    owner.decoupledView.delegateViewController = viewController;

    [viewController.view addSubview:owner.decoupledView];
    
    if([imagePath isEqualToString:@"Camera"])
        [owner.decoupledView performSelector:@selector(takePhoto)];
    else
        [owner.decoupledView performSelector:@selector(selectPhoto)];
}

- (void)selectPhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self.delegateViewController presentViewController:picker animated:YES completion:nil];
}

- (void)takePhoto {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        return;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self.delegateViewController presentViewController:picker animated:YES completion:nil];
    [self.imagePickerController takePicture];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self.delegateViewController photoFromImagePickerView:chosenImage];
    [self removeFromSuperview];    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self.delegateViewController photoFromImagePickerView:nil];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self removeFromSuperview];
}

#pragma mark - Utility methods 

- (IBAction)backgroundViewTapped:(id)sender {
    
    [self removeFromSuperview];
}

@end
