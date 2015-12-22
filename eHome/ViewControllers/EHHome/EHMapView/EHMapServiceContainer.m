//
//  EHMapServiceContainer.m
//  eHome
//
//  Created by 孟希羲 on 15/6/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapServiceContainer.h"
#import "EHUserDevicePosition.h"
#import "EHPositionAnnotation.h"
#import "EHDeviceStatusCenter.h"
#import "MAAnnotationView+WebCache.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+ImageProcess.h"

#define image_scale (1.0)

#define MAP_USE_WEB_HEADER_IMAGE

@interface EHMapServiceContainer()

@property (nonatomic, strong) EHLocationService *            listService;

@property (nonatomic, strong) EHLocationService *            refreshLocationService;

/*!
 *  @brief  图片image
 *
 *  @since 1.0
 */
@property (nonatomic, strong) UIImage           *            footprint_initalpoint_boy;

@property (nonatomic, strong) UIImage           *            footprint_initalpoint_girl;

@property (nonatomic, strong) UIImage           *            boy_baby_map_header_image;

@property (nonatomic, strong) UIImage           *            girl_baby_map_header_image;

@property (nonatomic, strong) UIImage           *            boy_baby_map_current_point_image;

@property (nonatomic, strong) UIImage           *            girl_baby_map_current_point_image;

@property (nonatomic, strong) UIImage           *            default_baby_map_header_image;

@property (nonatomic, strong) UIImage           *            footprint_caution;

@property (nonatomic, strong) UIImage           *            footprint_common_boy;

@property (nonatomic, strong) UIImage           *            footprint_common_girl;

@property (nonatomic, strong) UIImage           *            footprint_press_image;

@end

@implementation EHMapServiceContainer

-(void)setupView{
    [super setupView];
    [self initImage];
}

-(void)initImage{
    self.footprint_initalpoint_boy = [UIImage imageNamed:@"footpoint_initial"];
    self.footprint_initalpoint_boy = [self.footprint_initalpoint_boy scaleImage:self.footprint_initalpoint_boy toScale:image_scale];
    
    self.footprint_initalpoint_girl = [UIImage imageNamed:@"footpoint_initial"];
    self.footprint_initalpoint_girl = [self.footprint_initalpoint_girl scaleImage:self.footprint_initalpoint_girl toScale:image_scale];

    self.boy_baby_map_header_image = [UIImage imageNamed:@"public_headportrait_map_dorpdown_boy_80"];
    self.boy_baby_map_header_image = [self.boy_baby_map_header_image resizedImage:CGSizeMake(MAP_HEADER_ANNOTATION_IMAGE_VIEW_WIDTH, MAP_HEADER_ANNOTATION_IMAGE_VIEW_HEIGHT) interpolationQuality:kCGInterpolationHigh];
    self.boy_baby_map_header_image = [self.boy_baby_map_header_image getCirleBoaderWithBorderColor:UINAVIGATIONBAR_COMMON_COLOR withBorderWidth:map_header_image_border];

    
    self.boy_baby_map_current_point_image = [UIImage imageNamed:@"footpoint_finish"];
    
    self.girl_baby_map_header_image = [UIImage imageNamed:@"public_headportrait_map_dorpdown_girl_80"];
    self.girl_baby_map_header_image = [self.girl_baby_map_header_image resizedImage:CGSizeMake(MAP_HEADER_ANNOTATION_IMAGE_VIEW_WIDTH, MAP_HEADER_ANNOTATION_IMAGE_VIEW_HEIGHT) interpolationQuality:kCGInterpolationHigh];
    self.girl_baby_map_header_image = [self.girl_baby_map_header_image getCirleBoaderWithBorderColor:UINAVIGATIONBAR_COMMON_COLOR withBorderWidth:map_header_image_border];
    
    self.girl_baby_map_current_point_image = [UIImage imageNamed:@"footpoint_finish"];

    self.default_baby_map_header_image = [UIImage imageNamed:@"public_headportrait_map_dorpdown_boy_80"];
    self.default_baby_map_header_image = [self.default_baby_map_header_image resizedImage:CGSizeMake(MAP_HEADER_ANNOTATION_IMAGE_VIEW_WIDTH, MAP_HEADER_ANNOTATION_IMAGE_VIEW_HEIGHT) interpolationQuality:kCGInterpolationHigh];
    self.default_baby_map_header_image = [self.default_baby_map_header_image getCirleBoaderWithBorderColor:UINAVIGATIONBAR_COMMON_COLOR withBorderWidth:map_header_image_border];


    self.footprint_caution = [UIImage imageNamed:@"footpoint_sos"];
    self.footprint_caution = [self.footprint_caution scaleImage:self.footprint_caution toScale:image_scale];

    self.footprint_common_boy = [UIImage imageNamed:@"footpoint_common"];
    self.footprint_common_boy = [self.footprint_common_boy scaleImage:self.footprint_common_boy toScale:image_scale];

    self.footprint_common_girl = [UIImage imageNamed:@"footpoint_common"];
    self.footprint_common_girl =[self.footprint_common_girl scaleImage:self.footprint_common_girl toScale:image_scale];
    
    self.footprint_press_image = [UIImage imageNamed:@"footpoint_press"];

}

-(void)reloadData{
    [self resetCurrentPositionIndex];
    [super reloadData];
    if ([self.positionArray count] > 0 && self.currentPositionIndex >= [self.positionArray count]) {
        self.currentPositionIndex = [self.positionArray count] - 1;
    }
    if (self.currentPositionIndex == 0) {
        for (EHUserDevicePosition* position in self.positionArray) {
            if ([position.locationType isEqualToString:current_LocationType]) {
                self.currentPositionIndex = [self.positionArray indexOfObject:position];
                break;
            }
        }
    }
    if (self.currentPositionIndex == 0) {
        self.currentPositionIndex = [self.positionArray count] - 1;
    }
    
    // 设置当前宝贝位置
    if (self.positionArray && [self.positionArray count] > self.currentPositionIndex && [self.positionArray objectAtIndex:self.currentPositionIndex]) {
        EHUserDevicePosition* position = [self.positionArray objectAtIndex:self.currentPositionIndex];
        [[EHBabyListDataCenter sharedCenter] setCurrentBabyPosition:position];
    }
    
    if (self.shouldSelectAnnotationViewAfterRefreshMap == nil
        || (self.shouldSelectAnnotationViewAfterRefreshMap && self.shouldSelectAnnotationViewAfterRefreshMap(self))) {
        [self selectAnnotationViewWithIndex:self.currentPositionIndex];
    }else{
        [self selectCurrentCoordinatePosition];
    }
}

-(void)selectCurrentCoordinatePosition{
    if([[EHDeviceStatusCenter sharedCenter] didGetCurrentLoaction]){
        [_mapView setCenterCoordinate:[[EHDeviceStatusCenter sharedCenter] currentPhoneCoordinate] animated:YES];
    }
}

-(void)selectAnnotationViewWithPositionList:(NSArray*)positionList withIndex:(NSUInteger)index{
    self.positionArray = positionList;
    [self resetMapAnnotation];
    [self setupMapAnnotation];
    [self reloadData];
    [self selectAnnotationViewWithIndex:index];
}

-(void)selectAnnotationViewWithIndex:(NSUInteger)index{
    [self selectAnnotationViewWithIndex:index withAnimation:NO];
}

-(void)selectAnnotationViewWithIndex:(NSUInteger)index withAnimation:(BOOL)animation{
    if (index >= [self.annotationArray count]) {
        [self selectCurrentCoordinatePosition];
        return;
    }
    EHPositionAnnotation *pointAnnotation = [self.annotationArray objectAtIndex:index];
    CLLocationCoordinate2D coordinate;                                   //设置坐标
    coordinate.latitude = [pointAnnotation.position.location_latitude doubleValue];      //经度
    coordinate.longitude = [pointAnnotation.position.location_longitude doubleValue];    //纬度
    [_mapView setCenterCoordinate:coordinate animated:animation];                           //地图设置中心点
    [_mapView selectAnnotation:pointAnnotation animated:NO];
    /*
     * 缩放比例
     [_mapView setZoomLevel:MAP_DEFAULT_ZOOM_SCALE animated:YES];                //地图设置缩放级别，3~20
     */
}

-(void)resetMapAnnotation{
    [_mapView removeAnnotations:self.annotationArray];
    [self.annotationArray removeAllObjects];
}

-(void)resetCurrentPositionIndex{
    self.currentPositionIndex = 0;;
}

-(void)resetHistoryPositionArray{
    self.positionArray = nil;;
}


-(void)resetMap{
    [super resetMap];
    [self resetCurrentPositionIndex];
    [self resetMapAnnotation];
}

-(void)regreshLocationWithBabyUserInfo:(EHGetBabyListRsp*)babyUserInfo{
    _babyUserInfo = babyUserInfo;
    [self regreshLocationWithBabyId:[NSString stringWithFormat:@"%@",babyUserInfo.babyId]];
}

-(void)loadBabyMapListWithBabyUserInfo:(EHGetBabyListRsp*)babyUserInfo{
    _babyUserInfo = babyUserInfo;
    [self loadLocationListWithBabyUserInfo:babyUserInfo];
}

-(void)loadLocationListWithBabyUserInfo:(EHGetBabyListRsp*)babyUserInfo{
    _babyUserInfo = babyUserInfo;
    [self loadLocationListWithBabyId:[NSString stringWithFormat:@"%@",babyUserInfo.babyId]];
}

-(void)regreshLocationWithBabyId:(NSString*)babyId{
    [self showLoadingView];
    [self.refreshLocationService loadCurruntLocationWithBabyId:babyId];
}

-(void)loadLocationListWithBabyId:(NSString*)babyId{
    [self showLoadingView];
    [self.listService loadLocationTraceHistoryWithBabyId:babyId];
}

-(void)setupMapAnnotation{
    for (EHUserDevicePosition* position in self.positionArray) {
        if (![position isKindOfClass:[EHUserDevicePosition class]]) {
            continue;
        }
        
        EHPositionAnnotation *pointAnnotation = [[EHPositionAnnotation alloc] init];
        pointAnnotation.position = position;
        pointAnnotation.coordinate = CLLocationCoordinate2DMake([position.location_latitude doubleValue], [position.location_longitude doubleValue]);//大头针标注坐标
        pointAnnotation.title = position.location_Des;     //点击大头针标注出现的弹框的标题
        pointAnnotation.subtitle = position.location_Des;  //子标题
        [self.annotationArray addObject:pointAnnotation];
    }
}

-(EHLocationService *)listService{
    if (!_listService) {
        _listService = [EHLocationService new];
        WEAKSELF
        _listService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            if (service && service.dataList) {
                strongSelf.positionArray = service.dataList;
                if ([(KSViewController*)strongSelf.viewController isViewAppeared]) {
                    [strongSelf resetMapAnnotation];
                    [strongSelf setupMapAnnotation];
                    [strongSelf reloadData];
                }
            }else{
                strongSelf.positionArray = nil;
                if ([(KSViewController*)strongSelf.viewController isViewAppeared]) {
                [strongSelf resetMapAnnotation];
                [strongSelf reloadData];
                }
            }
            [strongSelf hideLoadingView];
            if (strongSelf.finishedRefreshService) {
                strongSelf.finishedRefreshService(strongSelf);
            }
        };
        
        _listService.serviceDidFailLoadBlock = ^(WeAppBasicService* service, NSError* error){
            STRONGSELF
            [strongSelf hideLoadingView];
            [WeAppToast toast:service_error_message];
        };
    }
    return _listService;
}

-(EHLocationService *)refreshLocationService{
    if (!_refreshLocationService) {
        _refreshLocationService = [EHLocationService new];
        WEAKSELF
        _refreshLocationService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            if (service && service.item) {
                strongSelf.positionArray = @[service.item];
                [strongSelf resetMapAnnotation];
                [strongSelf setupMapAnnotation];
                [strongSelf reloadData];
            }
            [strongSelf hideLoadingView];
        };
        
        _refreshLocationService.serviceDidFailLoadBlock = ^(WeAppBasicService* service, NSError* error){
            STRONGSELF
            [strongSelf hideLoadingView];
        };
    }
    return _refreshLocationService;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    EHBabyLocationAnnotationView* annotationView = (EHBabyLocationAnnotationView*)[super mapView:mapView viewForAnnotation:annotation];
    if ([annotationView isKindOfClass:[EHBabyLocationAnnotationView class]] && [annotation isKindOfClass:[EHPositionAnnotation class]])
    {
        EHPositionAnnotation* pointAnnotation = (EHPositionAnnotation*)annotation;
        annotationView.position = pointAnnotation.position;
        annotationView.annotationImageView.image = nil;
        annotationView.annotationImageView.hidden = YES;
        /*!
         *  @brief 默认为common足迹，第一个点展示为起始位置图标，警告点展示，当前位置展示头像
         *
         *  @since 1.0
         */
        if([pointAnnotation.position.locationType isEqualToString:current_LocationType]
        /*[self.annotationArray indexOfObject:annotation] == self.annotationArray.count - 1*/){
            annotationView.calloutOffset = CGPointMake(0, 5);
            // 当前位置展示头像
            /*if ([KSAuthenticationCenter isTestAccount]) {
                [annotationView setAnnotationImage:self.default_baby_map_header_image];
                [annotationView.annotationImageView setImage:self.default_baby_map_header_image];
                annotationView.annotationImageView.hidden = NO;
            }else*/
            {

#ifdef MAP_USE_WEB_HEADER_IMAGE
                __typeof(annotationView) __weak __block weakAnnotationView = annotationView;
                [annotationView sd_setImageWithURL:[NSURL URLWithString:self.babyUserInfo.babyHeadImage] placeholderImage:[EHUtils getBabyHeadPlaceHolderImage:self.babyUserInfo.babyId newPlaceHolderImagePath:self.babyUserInfo.babyHeadImage defaultHeadImage:([self.babyUserInfo.babySex integerValue]== EHBabySexType_girl ? self.girl_baby_map_header_image : self.boy_baby_map_header_image)] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    __typeof(annotationView) __strong strongAnnotationView = weakAnnotationView;
                    if (image) {
                        image = [image roundedCornerImage:image.size.width/2 borderSize:0];
                        image = [image getCirleBoaderWithBorderColor:UINAVIGATIONBAR_COMMON_COLOR withBorderWidth:map_header_image_border];
                        [strongAnnotationView setAnnotationImage:image];
                    }
                } imageSize:self.boy_baby_map_header_image.size];
                
                __typeof(UIImageView*) __weak __block weakAnnotationImageView = annotationView.annotationImageView;
                [annotationView.annotationImageView sd_setImageWithURL:[NSURL URLWithString:self.babyUserInfo.babyHeadImage] placeholderImage:([self.babyUserInfo.babySex integerValue]== EHBabySexType_girl ? self.girl_baby_map_header_image : self.boy_baby_map_header_image) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image && weakAnnotationImageView) {
                        image = [image roundedCornerImage:image.size.width/2 borderSize:0];
                        image = [image getCirleBoaderWithBorderColor:UINAVIGATIONBAR_COMMON_COLOR withBorderWidth:map_header_image_border];
                        weakAnnotationImageView.image = image;
                    }
                }];
                annotationView.annotationImageView.hidden = NO;
#else
                [annotationView setAnnotationImage:([self.babyUserInfo.babySex integerValue]== EHBabySexType_girl ? self.girl_baby_map_current_point_image : self.boy_baby_map_current_point_image)];
                __typeof(UIImageView*) __weak __block weakAnnotationImageView = annotationView.annotationImageView;
                [annotationView.annotationImageView sd_setImageWithURL:[NSURL URLWithString:self.babyUserInfo.babyHeadImage] placeholderImage:([self.babyUserInfo.babySex integerValue]== EHBabySexType_girl ? self.girl_baby_map_header_image : self.boy_baby_map_header_image) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image && weakAnnotationImageView) {
                        image = [image roundedCornerImage:image.size.width/2 borderSize:0];
                        weakAnnotationImageView.image = image;
                    }
                }];
                annotationView.annotationImageView.hidden = NO;
#endif
            }
            self.currentPositionIndex = [self.annotationArray indexOfObject:pointAnnotation];
        }else if ([self.annotationArray indexOfObject:pointAnnotation] == 0) {
            annotationView.calloutOffset = CGPointMake(0, 0);
            // 第一个点展示为起始位置图标
            /*if ([KSAuthenticationCenter isTestAccount]) {
                [annotationView setAnnotationImage:self.footprint_initalpoint_boy];
            }else*/
            {
                [annotationView setAnnotationImage:[self.babyUserInfo.babySex integerValue] == EHBabySexType_girl ? self.footprint_initalpoint_girl :self.footprint_initalpoint_boy];
            }
        }else if([pointAnnotation.position.locationType isEqualToString:SOS_LocationType]){
            // 警告点展示
            [annotationView setAnnotationImage:self.footprint_caution];
            [annotationView.annotationImageView setImage:[UIImage imageNamed:@"ico_map_SOS"]];
            annotationView.annotationImageView.hidden = NO;
        }else{
            // 默认为common足迹
            /*if ([KSAuthenticationCenter isTestAccount]) {
                [annotationView setAnnotationImage:self.footprint_common_boy];
            }else*/
            {
                [annotationView setAnnotationImage:[self.babyUserInfo.babySex integerValue] == EHBabySexType_girl ? self.footprint_common_girl : self.footprint_common_boy];
            }
        }
        annotationView.selectImageView.image = self.footprint_press_image;
    }
    annotationView.calloutOffset = CGPointMake(-2, annotationView.calloutOffset.y);
    return annotationView;
}

@end
