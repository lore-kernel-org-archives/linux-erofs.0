From: pratikshinde320@gmail.com (Pratik Shinde)
Date: Fri,  2 Aug 2019 00:48:09 +0530
Subject: [PATCH] erofs-utils: error handling for incorrect dbg lvl &
 compression algorithm
Message-ID: <20190801191809.13675-1-pratikshinde320@gmail.com>

handling the case of incorrect debug level.
also, an early check for valid compression algorithm.

Signed-off-by: Pratik Shinde <pratikshinde320 at gmail.com>
---
 mkfs/main.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mkfs/main.c b/mkfs/main.c
index fdb65fd..4231d13 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -105,10 +105,22 @@ static int mkfs_parse_options_cfg(int argc, char *argv[])
 				}
 			}
 			cfg.c_compr_alg_master = strndup(optarg, i);
+			if (strcmp(cfg.c_compr_alg_master, "lz4")
+			    && strcmp(cfg.c_compr_alg_master, "lz4hc")) {
+				erofs_err("invalid compressor algorithm %s",
+					  cfg.c_compr_alg_master);
+				return -EINVAL;
+			}
 			break;
 
 		case 'd':
 			cfg.c_dbg_lvl = parse_num_from_str(optarg);
+			if (cfg.c_dbg_lvl < 0 || cfg.c_dbg_lvl > 9) {
+				fprintf(stderr,
+					"invalid debug level %d\n",
+					cfg.c_dbg_lvl);
+				return -EINVAL;
+			}
 			break;
 
 		case 'E':
-- 
2.9.3
