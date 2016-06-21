//
//  CollectionCells.h
//  MyHelper
//
//  Created by mingzhi on 14/12/29.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#ifndef MyHelper_CollectionCells_h
#define MyHelper_CollectionCells_h

#import "MyServerRequestManager.h"//请求
#import "SDImageCache.h"//异步加载图片
#import "CollectionViewBack.h"//界面菊花
#import "MyCollectionViewFlowLayout.h"
#import "LoadingCollectionCell.h"//家在更多cell
#import "SearchViewController_my.h"//搜索
#import "CarouselView.h" //轮播

typedef enum{
    limiteCharge_App = 800,
    free_App,
    charge_App
}MenuType;

#define MULTIPLE [[UIScreen mainScreen] bounds].size.width/375//适配倍数
#define ThestartX ((MainScreen_Width-MULTIPLE*140*2)/4)/2   //140为按钮像素 精品展示

//横滑最多显示个数（限免、免费、收费）
#define HORIZONTAL 12

#define NavColor    hllColor(247, 247, 247, 1.0)
//公用cell值
#define BottomColor hllColor(165, 165, 165, 1)
#define CellBottomColor hllColor(188, 188, 188, 1)
#define titleFontSize 15.0f*MULTIPLE
#define subtitleFontSize 13.0f*MULTIPLE
#define _downButtonColor hllColor(150, 150, 150, 1.0)
#define subtitleColor hllColor(80, 80, 80, 1.0)
#define namelableColor hllColor(50, 50, 50, 1.0)

#define TitleFont [UIFont systemFontOfSize:15.0f*MULTIPLE]

#endif
