# TZHFileManager
文件附件文档下载到本地与查看本地文件
===
本框架支持下载.doc .pdf .docx  Excel 等格式文件 图片也可以下载并本地查看,为项目里有附件下载和查看的开发者们提供了很大便利!本框架的最大优点就是集成和使用简单.只要三四行代码即可.

使用方法:
-----
1.下载TZHFileManager框架,并集成到当前工程目录下

2.导入#import "TZHFileDownload.h" 头文件

3.在字典转模型处,创建TZHDownloadManager 对象,并将你的文件模型中的文件名和文件地址赋值给TZHDownloadManager 对象的相应属性,并将TZHDownloadManager的对象存储在可变数组中

4.在要跳转到文件列表控制器的地方,创建TZHDownloadViewController控制器对象.并把请求网络数据所获得的文件模型数组赋值给TZHDownloadViewController对象的filesArray数组.

P.S. 如我要做到点击下图的查看附件然后跳转到附件列表,就在查看附件按钮的点击事件里写步骤4的代码即可

![gif](http://upload-images.jianshu.io/upload_images/4034316-34161d3ac1035530.gif?imageMogr2/auto-orient/strip)


新增文件占内存数值显示 和删除已下载的文件 两处功能:
---


1.显示下载文件占内存数值:
//显示文件占内存大小

+(NSString *)getFileCacheSize;

调用方法:

NSString *fileSize = [TZHDownloadManager getFileCacheSize];

1.删除所下载的文件:

//删除文件

+(void)deleteFileFromCache;


调用方法:

[TZHDownloadManager deleteFileFromCache];


联系我:
-------
如果你有什么问题或者好的建议欢迎与我联系 我的QQ: 734754688
