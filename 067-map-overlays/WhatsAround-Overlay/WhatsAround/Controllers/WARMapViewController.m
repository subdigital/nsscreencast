//
//  WARMapViewController.m
//  WhatsAround
//
//  Created by ben on 4/16/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "WARMapViewController.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "WARAppDelegate.h"
#import "WARMapOverlay.h"
#import "WARMapOverlayView.h"
#import "WARState.h"
#import "shapefil.h"

@interface WARMapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *states;

@end

@implementation WARMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    [self readShapeAttributes];
    [self readShapeData];
    
    for (WARState *state in self.states) {
        for (WARPolygon *polygon in state.polygons) {
            int count = [polygon.coordinates count];
            CLLocationCoordinate2D coords[count];
            
            for (int c=0; c<count; c++) {
                NSValue *coordValue = polygon.coordinates[c];
                CLLocationCoordinate2D coord = [coordValue MKCoordinateValue];
                coords[c] = coord;
            }
            
            MKPolygon *polygon = [MKPolygon polygonWithCoordinates:coords count:count];
            [self.mapView addOverlay:polygon];
        }
    }
}

- (void)readShapeData {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *shpPath = [resourcePath stringByAppendingPathComponent:@"states"];
    
    const char * pszPath = [shpPath cStringUsingEncoding:NSUTF8StringEncoding];
    SHPHandle shp = SHPOpen(pszPath, "rb");
    
    int numEntities;
    int shapeType;
    SHPGetInfo(shp, &numEntities, &shapeType, NULL, NULL);
    
    NSLog(@"%d entities", numEntities);
    NSLog(@"Shape type: %@", [self descriptionForShapeType:shapeType]);
    
    self.states = [NSMutableArray arrayWithCapacity:numEntities];
    for (int i=0; i<numEntities; i++) {
        SHPObject *shpObject = SHPReadObject(shp, i);
        WARState *state = [[WARState alloc] initWithShapeObject:shpObject];
        [self.states addObject:state];
    }
    
    SHPClose(shp);
}

- (NSString *)descriptionForShapeType:(int)shapeType {
    switch (shapeType) {
        case SHPT_POINT:        return @"Point";
        case SHPT_POLYGON:      return @"Polygon";
        case SHPT_ARC:          return @"Arc";
        case SHPT_MULTIPOINT:   return @"Multi-point";
            
        default:
            return @"<unknown>";
    }
}


- (void)readShapeAttributes {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *dbfPath = [resourcePath stringByAppendingPathComponent:@"states.dbf"];
    
    const char * pszPath = [dbfPath cStringUsingEncoding:NSUTF8StringEncoding];
    DBFHandle dbf = DBFOpen(pszPath, "rb");
    
    int fieldCount = DBFGetFieldCount(dbf);
    for (int f=0; f<fieldCount; f++) {
        char fieldName[12];
        int width;
        int numDecimals;
        DBFFieldType type = DBFGetFieldInfo(dbf, f, fieldName, &width, &numDecimals);
        NSString *typeString = [self descriptionForFieldType:type];
        
        NSLog(@"Column %d:  %s (%@)", f, fieldName, typeString);
    }
    
    
    int recordCount = DBFGetRecordCount(dbf);
    for (int r=0; r<recordCount; r++) {
        int nameIndex = DBFGetFieldIndex(dbf, "STATE_NAME");
        const char * fieldName = DBFReadStringAttribute(dbf, r, nameIndex);
        NSLog(@"%s", fieldName);
        
        int seqIndex = DBFGetFieldIndex(dbf, "DRAWSEQ");
        int seq = DBFReadIntegerAttribute(dbf, r, seqIndex);
        NSLog(@"Seq: %d", seq);
    }
    
    
    DBFClose(dbf);
}

- (NSString *)descriptionForFieldType:(DBFFieldType)fieldType {
    switch (fieldType) {
        case FTDouble:
            return @"double";
        case FTInteger:
            return @"integer";
        case FTLogical:
            return @"logical";
        case FTString:
            return @"string";
        case FTInvalid:
            return @"<invalid>";
        default:
            return @"<unknown>";
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Mapview delegate


-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygonView *view = [[MKPolygonView alloc] initWithPolygon:overlay];
        view.strokeColor = [UIColor blueColor];
        view.lineWidth = 2;
        view.lineCap = kCGLineCapRound;
        view.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
        return view;
    } else {
        return nil;
    }
}



@end
