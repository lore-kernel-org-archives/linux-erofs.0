From: valdis.kletnieks@vt.edu (valdis.kletnieks@vt.edu)
Date: Wed, 13 Mar 2019 02:41:20 -0400
Subject: [PATCH 1/1] staging: erofs: Add function comment for erofs/super.c
In-Reply-To: <2d0544aa-cc99-f1dd-3b83-9f06a307dfc7@aol.com>
References: <CAKsu7qwsSeN3XT=f-cz6wOMdwAHHhDJpWnNk_2epHu5J+F0+VA@mail.gmail.com>
 <2d0544aa-cc99-f1dd-3b83-9f06a307dfc7@aol.com>
Message-ID: <26452.1552459280@turing-police>

On Wed, 13 Mar 2019 08:48:26 +0800, Gao Xiang said:
(Reversing order of  comments)
> "Release slab Memory" is not a very useful description for this function.

Agreed.

> i_callback is used to free inode structure and other memory related to this inode

However, that's not a bad description at all. :)

(Though I'd consider renaming the function to 'reap_inode_mem()' or something
like that so no description is needed. :)
