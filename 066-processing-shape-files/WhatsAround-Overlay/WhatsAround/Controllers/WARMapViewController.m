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
@property (nonatomic, strong) NSArray *venues;

@end

@implementation WARMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    [self readShapeAttributes];
    [self readShapeData];
}

- (void)readShapeData {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *shpPath = [resourcePath stringByAppendingPathComponent:@"states"];
    
    const char * pszPath = [shpPath cStringUsingEncoding:NSUTF8StringEncoding];
    SHPHandle shp = SHPOpen(pszPath, "rb");
    
    SHPObject *shpObject = SHPReadObject(shp, 40);
    int numVertices = shpObject->nVertices;
    int numParts = shpObject->nParts;
    
    NSLog(@"Shape 40 has %d vertices across %d parts", numVertices, numParts);
    WARState *state = [[WARState alloc] initWithShapeObject:shpObject];
    NSLog(@"Created %@", state);
    NSLog(@"State has %d polygons", state.polygons.count);
    NSLog(@"First polygon has %d vertices", [[state.polygons[0] coordinates] count]);
    
    
    SHPClose(shp);
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

@end
