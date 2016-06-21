//
//  Layout.m
//  33
//
//  Created by niu_o0 on 14-4-29.
//  Copyright (c) 2014年 niu_o0. All rights reserved.
//

#import "CollectionViewLayout.h"


@implementation CollectionViewLayout

//- (id)init
//{
//    self = [super init];
//    if (self) {
//        DecorationArray = [[NSMutableArray alloc] init];
//    }
//    return self;
//}

//- (void)prepareLayout{
//    
//    [super prepareLayout];
//    
//    if (!self.registBackground) return;
//    
//    [DecorationArray removeAllObjects];
//    
//    for (int i=0; i< (self.collectionBackground ? 1 : self.collectionView.numberOfSections); i++) {
//        
//        UIEdgeInsets  inset = UIEdgeInsetsZero;
//        
//        if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
//            
//            inset = [((id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate) collectionView:self.collectionView layout:(UICollectionViewLayout *)self insetForSectionAtIndex:i];
//        }
//        
//        UICollectionViewLayoutAttributes * attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionBackground withIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
//        
//        if (self.collectionBackground) {
//            attri.frame = self.collectionView.bounds;//CGRectMake(0, 0, [self collectionViewContentSize].width, [self collectionViewContentSize].height);
//        }else{
//            UICollectionViewLayoutAttributes * att = nil;
//            
//            att = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
//            
//            CGRect rect = att.frame;
//            
//            rect.origin.x = 0;
//            rect.origin.y -= inset.top ? inset.top : self.sectionInset.top;
//            
//            if (![self.collectionView numberOfItemsInSection:i]) return ;
//            
//            NSUInteger index = [self.collectionView numberOfItemsInSection:i]-1;
//            
//            att = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:i]];
//            
//            rect.size = CGSizeMake(self.collectionView.bounds.size.width, att.frame.origin.y-rect.origin.y+att.size.height+(inset.bottom ? inset.bottom : self.sectionInset.bottom));
//            
//            attri.frame = rect;
//        }
//        
//        attri.zIndex = 1;
//        
//        
//        [DecorationArray addObject:attri];
//    }
//    
//}


//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
//    
//    //if (!self.registBackground) return [super layoutAttributesForElementsInRect:rect];
//    
//    NSMutableArray * array = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
//    
//    UICollectionViewLayoutAttributes * att = nil;
//    for (int i=0; i<array.count; i++) {
//        att = [array objectAtIndex:i];
//        if ([att.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]) {
//            att.frame = self.collectionView.bounds;
//        }
//    }
//    
//    
////    for (int i=0; i<DecorationArray.count; i++) {
////        
////        att = [DecorationArray objectAtIndex:i];
////        
////        
////        
////        if (CGRectIntersectsRect(rect, att.frame)) {
////            
////            [array addObject:att];
////        }
////    }
//    
//    return array;
//}

//- (CGSize)collectionViewContentSize{
//    return CGSizeMake(self.collectionView.bounds.size.width, [super collectionViewContentSize].height+49);
//}


- (CGSize)collectionViewContentSize{
    
    return CGSizeMake(self.collectionView.bounds.size.width, (([super collectionViewContentSize].height<= self.collectionView.bounds.size.height) ? self.collectionView.bounds.size.height : ([super collectionViewContentSize].height+49)));
}

- (void)dealloc{
    
}

@end
