# Viwepager
The project realize the infinite by pictures, and can be used by the above pageControl location and style. <br>  该项目实现图片的无限轮播,并且可以设置轮播器上面pageControl的位置及样式。\<br>  

##用法:
    下载后将文件Viwepager拖入项目中,你的项目中要有SDWebImage框架。
##示例:
###(1)默认样式:
//设置要轮播的图片的网址数组
＜/br＞NSArray *arr = @[@"http://e.hiphotos.baidu.com/image/pic/item/2934349b033b5bb5d5f4232f32d3d539b600bc3b.jpg",@"http://g.hiphotos.baidu.com/image/pic/item/6c224f4a20a446230761b9b79c22720e0df3d7bf.jpg",@"http://e.hiphotos.baidu.com/image/pic/item/8d5494eef01f3a29913f38ca9b25bc315c607c3b.jpg",@"http://d.hiphotos.baidu.com/image/pic/item/9825bc315c6034a89ded59a7ce1349540923768d.jpg"];
＜/br＞adView.urlArray = arr;
//创建轮播器
YGADView *adView = [[YGADView alloc]initWithFrame:CGRectMake(40, 40, 260, 260)];
//将轮播器添加到父控件(此处以控制器为例)
[self.view addSubview:adView];
### (2)自定义轮播器pageControl位置及相关属性
//设置颜色
 adView.pageIndicatorColor = [UIColor grayColor];
 adView.currentPageColor = [UIColor redColor];
//设置位置
 CGRect rect = CGRectMake(50, 80, 0, 0);
 adView.pageControlFrame = rect;
###(3)设置pageControl的image
 UIImage *currentImage = [UIImage imageNamed:@"compose_keyboard_dot_selected"];
 adView.currentPageImage = currentImage;
 UIImage *pageImage = [UIImage imageNamed:@"compose_keyboard_dot_normal"];
 adView.pageImage = pageImage;








