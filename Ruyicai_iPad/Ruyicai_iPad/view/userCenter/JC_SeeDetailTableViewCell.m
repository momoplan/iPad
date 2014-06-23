//
//  JC_SeeDetailTableViewCell.m
//  RuYiCai
//
//  Created by ruyicai on 12-12-19.
//
//

#import "JC_SeeDetailTableViewCell.h"
#import "RCLabel.h"

@implementation JC_SeeDetailTableViewCell
@synthesize contentStr = m_contentStr;
@synthesize jc_lotNo;

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    NSString* wanfa = @"玩法：";
    if ([self.contentStr count] > 0) {
        wanfa = [wanfa stringByAppendingFormat:@"%@",KISNullValue(self.contentStr, 0, @"play")];
    }
 
    if ([self.contentHeight count] == 0) {
        return;
    }
    float headHeight = [[self.contentHeight objectAtIndex:0] floatValue] - 30;//剪掉编号行高
    [self drawRectangle:context RECT:CGRectMake(0, headHeight, 300, 30)];
    
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0); //黑
    NSArray* wanFa_array = [wanfa componentsSeparatedByString:@","];
    for (int i = 0; i <= (int)[wanFa_array count]/4; i++) {//玩法所占行数（1行4个）
        if(i != (int)[wanFa_array count]/4)
            [[NSString stringWithFormat:@"%@,%@,%@,%@", [wanFa_array objectAtIndex:4*i], [wanFa_array objectAtIndex:4*i+1], [wanFa_array objectAtIndex:4*i+2],[wanFa_array objectAtIndex:4*i+3]] drawAtPoint:CGPointMake(10, 5 + i * 20) withFont:[UIFont systemFontOfSize:14]];
        else
        {
            int lastLineNum = [wanFa_array count]%4;//最后一行含有元素个数
            NSString* lastLineStr = @"";
            for (int j = 0; j < lastLineNum; j ++) {
                if (j != lastLineNum - 1)
                    lastLineStr = [lastLineStr stringByAppendingFormat:@"%@,", [wanFa_array objectAtIndex:4*i + j]];
                else
                    lastLineStr = [lastLineStr stringByAppendingString:[wanFa_array objectAtIndex:4*i + j]];
            }
            [lastLineStr drawAtPoint:CGPointMake(10, 5 + i * 20) withFont:[UIFont systemFontOfSize:14]];
        }
    }
    
    [@"编号" drawAtPoint:CGPointMake(2,  8 + headHeight) withFont:[UIFont systemFontOfSize:14]];
    [@"对阵" drawAtPoint:CGPointMake(70, 8 + headHeight) withFont:[UIFont systemFontOfSize:14]];
    [@"比分" drawAtPoint:CGPointMake(153, 8 + headHeight) withFont:[UIFont systemFontOfSize:14]];
    [@"您的投注" drawAtPoint:CGPointMake(220, 8 + headHeight) withFont:[UIFont systemFontOfSize:14]];
    [self drawLine:context TOPLEFTPOINT:CGPointMake(30, headHeight) BOTTOMRIGHTPOINT:CGPointMake(30, 30+ headHeight)];
    [self drawLine:context TOPLEFTPOINT:CGPointMake(135, headHeight) BOTTOMRIGHTPOINT:CGPointMake(135, 30+ headHeight)];
    [self drawLine:context TOPLEFTPOINT:CGPointMake(195, headHeight) BOTTOMRIGHTPOINT:CGPointMake(195, 30+ headHeight)];
    
    NSInteger heightIndex = 30 + headHeight;
    for (int i = 0; i < [self.contentStr count]; i++) {
        float currentCellHeight = [[self.contentHeight objectAtIndex:i + 1] floatValue];
        NSString* weekId = @"";
        NSString* bianhao = @"";
        if (![KISNullValue(self.contentStr, i , @"weekId") isEqualToString:@""]) {
            weekId = [NSString stringWithFormat:@"周%@", KISNullValue(self.contentStr, i , @"weekId")];
            bianhao = [NSString stringWithFormat:@"%@\n%@", weekId,KISNullValue(self.contentStr, i, @"teamId")];
        }else{
            bianhao = [NSString stringWithFormat:@"   %@",KISNullValue(self.contentStr, i, @"teamId")];
        }
        
        NSString* homeTeam;
        NSString* guestTeam;
        if ([self.jc_lotNo isEqualToString:kLotNoJCLQ_SF] ||
            [self.jc_lotNo isEqualToString:kLotNoJCLQ_RF] ||
            [self.jc_lotNo isEqualToString:kLotNoJCLQ_SFC] ||
            [self.jc_lotNo isEqualToString:kLotNoJCLQ_DXF] ||
            [self.jc_lotNo isEqualToString:kLotNoJCLQ_CONFUSION] ) {//篮球客队在上
            
            homeTeam = [NSString stringWithFormat:@"%@(客)",KISNullValue(self.contentStr, i,@"guestTeam")];
            guestTeam = [NSString stringWithFormat:@"%@(主)",KISNullValue(self.contentStr, i,@"homeTeam")];
        }
        else{//足球客队在下
            homeTeam = KISNullValue(self.contentStr, i,@"homeTeam");
            guestTeam = KISNullValue(self.contentStr, i,@"guestTeam");
        }
        NSString* duiZhen = KISNullValue(self.contentStr, i,@"letScore");
        /*
         足球胜平负玩法投注详情界面优化，当有让球的场次时将“对阵”一栏中的“VS”改为显示让球数，“比分”一栏中增加胜平负彩果信息（注：“胜平负”玩法的最终彩果信息还需要计算是否有让球）letScore
         
         篮球 大小分，VS 处 显示 预设总分 totalScore（篮球大小分 没有让分）
         */
        if([duiZhen length] == 0)
        {
            if([KISNullValue(self.contentStr, i,@"totalScore") length] == 0)
                duiZhen = @"VS";
            else
                duiZhen = KISNullValue(self.contentStr, i,@"totalScore");
        }
        //让分数
        else if([duiZhen isEqualToString:@"0"])
        {
            duiZhen = @"VS";
        }
        else
        {
            if([KISNullValue(self.contentStr, i,@"totalScore") length] != 0) {
                duiZhen = [duiZhen stringByAppendingFormat:@"\n%@",KISNullValue(self.contentStr, i,@"totalScore")];
            }
        }
        NSString* Score;
        if ([self.jc_lotNo isEqualToString:kLotNoJCLQ_SF] ||
            [self.jc_lotNo isEqualToString:kLotNoJCLQ_RF] ||
            [self.jc_lotNo isEqualToString:kLotNoJCLQ_SFC] ||
            [self.jc_lotNo isEqualToString:kLotNoJCLQ_DXF] ||
            [self.jc_lotNo isEqualToString:kLotNoJCLQ_CONFUSION] )//篮球比分客在前
        {
            Score = KISNullValue(self.contentStr, i,@"guestScore");
            if(![Score isEqualToString:@""])
                Score = [Score stringByAppendingFormat:@":%@",KISNullValue(self.contentStr, i,@"homeScore")];
        }
        else
        {
            Score = KISNullValue(self.contentStr, i,@"homeScore");
            if(![Score isEqualToString:@""])
                Score = [Score stringByAppendingFormat:@":%@",KISNullValue(self.contentStr, i,@"guestScore")];

        }
        NSString* scoreResult = KISNullValue(self.contentStr, i,@"matchResult");
        
        NSString* betContent = KISNullValue(self.contentStr, i,@"betContentHtml");
        NSString* isDanMa = [KISNullValue(self.contentStr, i, @"isDanMa") isEqualToString:@"true"] ? @"<font color='#F4A460'>(胆)</font>" : @"";
        betContent = [betContent stringByAppendingString:isDanMa];
        
        NSString* touString = @"<p style=\"line-height:17px\"><font size = \"1.5\">";
        betContent = [touString stringByAppendingString:betContent];
        betContent = [betContent stringByAppendingString:@"</font></p>"];
        
        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0); //黑
        [bianhao drawInRect:CGRectMake(0, heightIndex + 10, 30, CellHeight) withFont:[UIFont systemFontOfSize:14]lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        
        [homeTeam drawInRect:CGRectMake(30, heightIndex + 4, 105, 20) withFont:[UIFont systemFontOfSize:12]lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];

        
        if (![duiZhen isEqualToString:@"VS"]) {
            CGContextSetRGBFillColor(context, 32.0/255.0, 124.0/255.0, 35.0/255.0, 1.0); //lv
            if ([KISNullValue(self.contentStr, i,@"totalScore") length] != 0 && [KISNullValue(self.contentStr, i,@"letScore") length] != 0) {
                [duiZhen drawInRect:CGRectMake(30, heightIndex + 21, 105, 45) withFont:[UIFont systemFontOfSize:12]lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
            }
            else
            [duiZhen drawInRect:CGRectMake(30, heightIndex + 21, 105, 20) withFont:[UIFont systemFontOfSize:12]lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];

        }
        else
        {
            CGContextSetRGBFillColor(context, 0, 0, 0, 1.0); //hei
            
            [duiZhen drawInRect:CGRectMake(30, heightIndex + 21, 105, 20) withFont:[UIFont systemFontOfSize:12] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        }

        CGContextSetRGBFillColor(context, 0, 0, 0, 1.0); //hei

        if ([KISNullValue(self.contentStr, i,@"totalScore") length] != 0 && [KISNullValue(self.contentStr, i,@"letScore") length] != 0){
            
            [guestTeam drawInRect:CGRectMake(30, heightIndex + 55, 105, 20) withFont:[UIFont systemFontOfSize:12] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        }else{
            
            [guestTeam drawInRect:CGRectMake(30, heightIndex + 41, 105, 20) withFont:[UIFont systemFontOfSize:12] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        }
        
        [Score drawInRect:CGRectMake(135, heightIndex + 5, 60, 30) withFont:[UIFont systemFontOfSize:12] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        
        //赛果
        if ([KISNullValue(self.contentStr, i, @"homeScore") isEqualToString:@""] &&
            [KISNullValue(self.contentStr, i, @"guestScore") isEqualToString:@""]) {
            //没有数据 或 未开赛
        }
        else
        {
//            UITextView* matchResult = [[UITextView alloc] initWithFrame:CGRectMake(128, heightIndex + 20, 72, currentCellHeight - 20)];
//            matchResult.text = scoreResult;
//            matchResult.editable = YES;
//            matchResult.delegate = self;//禁用放大镜功能
//            matchResult.font = [UIFont systemFontOfSize:11];
//            matchResult.showsVerticalScrollIndicator = NO;
//            matchResult.backgroundColor = [UIColor clearColor];
//            matchResult.contentOffset = matchResult.center;
//            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
//                matchResult.textAlignment = NSTextAlignmentCenter;
//            else
//                matchResult.textAlignment = UITextAlignmentCenter;
//            [self addSubview:matchResult];
            RCLabel *matchResult = [[RCLabel alloc] initWithFrame:CGRectMake(128, heightIndex + 20, 70, currentCellHeight)];
            matchResult.textAlignment = RTTextAlignmentCenter;
            RTLabelComponentsStructure *matchResultDS = [RCLabel extractTextStyle:[NSString stringWithFormat:@"<font size = \"1.2\">%@</font>", scoreResult]];
            matchResult.componentsAndPlainText = matchResultDS;
            [self addSubview:matchResult];
        }
        
//        UIWebView*  webView = [[UIWebView alloc] initWithFrame:CGRectMake(196, heightIndex + 2 , 102, currentCellHeight - 4)];
//        [webView loadHTMLString:betContent baseURL:nil];
//        [self addSubview:webView];
//        webView.backgroundColor = [UIColor clearColor];
        RCLabel *tempLabel = [[RCLabel alloc] initWithFrame:CGRectMake(196, heightIndex + 2, 102, currentCellHeight)];
        betContent = [betContent stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:betContent];
        tempLabel.componentsAndPlainText = componentsDS;
        [self addSubview:tempLabel];

        //画线
        //肃
        [self drawLine:context TOPLEFTPOINT:CGPointMake(0, heightIndex) BOTTOMRIGHTPOINT:CGPointMake(0, heightIndex + currentCellHeight)];
        [self drawLine:context TOPLEFTPOINT:CGPointMake(30, heightIndex) BOTTOMRIGHTPOINT:CGPointMake(30, heightIndex + currentCellHeight)];
        [self drawLine:context TOPLEFTPOINT:CGPointMake(135, heightIndex) BOTTOMRIGHTPOINT:CGPointMake(135, heightIndex + currentCellHeight)];
        [self drawLine:context TOPLEFTPOINT:CGPointMake(195, heightIndex) BOTTOMRIGHTPOINT:CGPointMake(195, heightIndex + currentCellHeight)];
        [self drawLine:context TOPLEFTPOINT:CGPointMake(300, heightIndex) BOTTOMRIGHTPOINT:CGPointMake(300, heightIndex + currentCellHeight)];
        //横
        [self drawLine:context TOPLEFTPOINT:CGPointMake(0, heightIndex + currentCellHeight) BOTTOMRIGHTPOINT:CGPointMake(300, heightIndex + currentCellHeight)];
        heightIndex += currentCellHeight;
    }
    
}

- (void)drawText:(CGContextRef)_context RECT:(CGRect)rect  TEXT:(NSString*)text
{
//    // 设置旋转字体
//    CGAffineTransform myTextTransform = CGAffineTransformMakeRotation(radians(270));
//    CGContextSetTextMatrix(_context, myTextTransform);
    
    // 设置字体：为16pt Helvetica
    CGContextSelectFont(_context, "Helvetica", 14, kCGEncodingMacRoman);
    //设置文字绘制模式
    // 3种绘制模式：kCGTextFill 填充, kCGTextStroke 描边, kCGTextFillStroke 既填充又描边
    CGContextSetTextDrawingMode(_context, kCGTextStroke); // set drawing mode
    // 设置文本颜色字符为黑色
    CGContextSetRGBFillColor(_context, 0.0, 0.0, 0.0, 1.0); //黑
    //从文本空间到用户控件的转换矩阵 删除的话数字是倒放的
    CGContextSetTextMatrix(_context, CGAffineTransformMakeScale(1.0, -1.0));
    
    CGContextShowTextAtPoint(_context, rect.origin.x, rect.origin.y, [text UTF8String],
                             text.length);
}
 
- (void)drawRectangle:(CGContextRef)_context RECT:(CGRect)rect
{
    CGContextSetLineWidth(_context, 0.2);
    CGContextSetRGBFillColor(_context, 248.0/255.0, 248.0/255.0, 246.0/255.0, 1);
    CGContextFillRect(_context, rect);
    CGContextStrokePath(_context);
    
    CGContextAddRect(_context,rect);
    CGContextSetLineWidth(_context, 0.5);
    CGContextSetRGBStrokeColor(_context, 221.0/255.0, 221.0/255.0, 221.0/255.0, 1);
    CGContextStrokePath(_context);
}
 
- (void)drawLine:(CGContextRef)_context  TOPLEFTPOINT:(CGPoint)topLeftPoint BOTTOMRIGHTPOINT:(CGPoint)bottomRightPoint
{
    CGContextSetRGBStrokeColor(_context, 120.0/255.0, 120.0/255.0, 120.0/255.0, 1); //笔色
    CGContextSetLineWidth(_context, 0.2);
    
    CGContextMoveToPoint(_context, topLeftPoint.x, topLeftPoint.y);
    CGContextAddLineToPoint(_context, bottomRightPoint.x, bottomRightPoint.y);
    
    CGContextStrokePath(_context);
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}
@end
