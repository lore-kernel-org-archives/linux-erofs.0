From: dan.carpenter@oracle.com (Dan Carpenter)
Date: Mon, 28 Jan 2019 17:28:38 +0300
Subject: [PATCH v2 2/2] staging: erofs: complete POSIX ACL support
In-Reply-To: <f1fd2c69-0c5b-c655-3712-48169e87fff8@huawei.com>
References: <20190125161007.4447-1-gaoxiang25@huawei.com>
 <20190125161007.4447-2-gaoxiang25@huawei.com>
 <94daa491-40c8-4a09-a0b5-55a7e92dc3fc@huawei.com>
 <20190128133302.GI1795@kadam>
 <f1fd2c69-0c5b-c655-3712-48169e87fff8@huawei.com>
Message-ID: <20190128142837.GJ1795@kadam>

The point is, that people shouldn't recreate core code that already
exists.  At least try it out and have an explanation why the other code
doesn't work.

In other projects, the default is to keep code around once it has been
written but in staging the default choice is to delete the code unless
there is an explanation.

regards,
dan carpenter
