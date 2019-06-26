From: gregkh@linuxfoundation.org (Greg KH)
Date: Wed, 26 Jun 2019 09:43:43 +0800
Subject: [PATCH] staging: erofs: return the error value if
 fill_inline_data() fails
In-Reply-To: <20190625172912.00002d55.zbestahu@gmail.com>
References: <20190625075943.2420-1-zbestahu@gmail.com>
 <b724c331-5338-d827-6618-1bded956c41d@aol.com>
 <20190625172912.00002d55.zbestahu@gmail.com>
Message-ID: <20190626014343.GA16013@kroah.com>

On Tue, Jun 25, 2019@05:29:12PM +0800, Yue Hu wrote:
> On Tue, 25 Jun 2019 17:19:36 +0800
> Gao Xiang <hsiangkao@aol.com> wrote:
> 
> > On 2019/6/25 ????3:59, Yue Hu Wrote:
> > > From: Yue Hu <huyue2 at yulong.com>
> > > 
> > > We should consider the error returned by fill_inline_data() when filling
> > > last page in fill_inode(). If not getting inode will be successful even
> > > though last page is bad. That is illogical. Also change -EAGAIN to 0 in
> > > fill_inline_data() to stand for successful filling.
> > > 
> > > Signed-off-by: Yue Hu <huyue2 at yulong.com>  
> > 
> > looks good to me, yet I think you need to Cc staging mailing list at
> > least if you want to upstream quickly (including your older patches...)
> > 
> > 
> > Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
> > 
> > 
> > (Don't forget to add 'PATCH RESEND' tag at the subject line if you
> > resend these patches.)
> 
> Ok, got it.

Yes, please resend all of these patches as I am not quite sure which
ones are the "latest".

thanks,

greg k-h
