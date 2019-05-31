From: zbestahu@gmail.com (Yue Hu)
Date: Fri, 31 May 2019 17:27:22 +0800
Subject: [PATCH] erofs-utils: correct --with-lz4 example in README
Message-ID: <20190531092722.6708-1-zbestahu@gmail.com>

From: Yue Hu <huyue2@yulong.com>

Option --with-lz4 means LZ4 install directory rather than LZ4 lib
directory. We will meet configuration error due to wrong path if
setting --with-lz4 to /usr/local/lib. Also stay the same with LZ4
help in configure shell script.

Signed-off-by: Yue Hu <huyue2 at yulong.com>
---
 README | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/README b/README
index 9014268..97eb228 100644
--- a/README
+++ b/README
@@ -19,8 +19,8 @@ Dependencies
 
 How to build with lz4 static library
 	./configure --with-lz4=<lz4 install path>
-eg. if lz4 lib has been installed into fold of /usr/local/lib
-	./configure --with-lz4=/usr/local/lib && make
+eg. if lz4 has been installed into fold of /usr/local
+	./configure --with-lz4=/usr/local && make
 On Fedora, static lz4 can be installed using:
 	yum install lz4-static.x86_64
 To build you should run this first:
-- 
1.9.1
