//
//  TTTAttributedLabel+DCWeex.h
//  CarpoolBusiness
//
//  Created by Lux on 2020/4/29.
//

#import "TTTAttributedLabel.h"
#import "CMLNoteInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTTAttributedLabel (DCWeex)

/*!
 支持直接塞入富文本对象
 */
- (void)setDCNoteInfo:(CMLNoteInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
