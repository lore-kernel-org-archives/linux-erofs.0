Return-Path: <linux-erofs+bounces-3884-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A052C43458
	for <linux-erofs@archiver.kernel.org>; Mon, 13 Jul 2026 08:34:11 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gzG1s39tRz2xqM;
	Mon, 13 Jul 2026 18:34:09 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=80.241.56.151
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1783931649;
	cv=none; b=UJT+v7pSpsvaVaLukWAxy0oDiQqTshZ5mh0cKIUj9IjQ0V2gdcgXFkvfVFBg8tbt4d4kHBjKfEf1G/Ww21+KKTsnxFlfuAPz+UQr57HTAkfJYedsrpvb0/LI9JvMoXikLOJbL6V1JBk+c+Rekqzui6Me1Egra9yFBjjj/tUZSK6y+uHdCdEGXkxiCUiTu4jOXhM1oyofI4FRgcsAI4BMH4MJ5W7+zdtOiiBSRWQkz/M/bBVolSdfr4zd5QRZouqN/bWiZFjxWejVwbMuo3YRfll0vF5jRs4Jx7hDmdVSfmD/EG3ISIGK7gPawiwfZs7NPzRkflh6LRYIQu6hEFi9Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1783931649; c=relaxed/relaxed;
	bh=dQrejtZL2XpWthMXrLnlYMslhFK2mQqBx561esiUod8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OjEZEUsmhfxzVkBVRnG7n8VJmhQAXXr4i4jskmJX47cd3JYPGnwWnCnZJ+JsQGA1xv0AA+7PdvH+v8pE9na4dDgbQYMZaXSszFXSHdIBwUWjWgc3D/TkMmn+rX74fiUEH+8lJb0c6ZcLWM1bx+DUO7P42pZv/By1ugN56+A4SOu+d6owUnVfvWHVGUSHwcwQoGEe5U5gO10sjT7lHiAvPssPavfv2nvvffXBoM379n63/wcAtjT7yEAxrRlI4bc+N748xq+Qn4LHXoddpf9tYy4LudDDXPx++0KwSPsW8ShK3yW7IJgYeYc9K/m6SXRnmbFoj+D65NY1rsVTndz/VA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=cyphar.com; dkim=pass (2048-bit key; secure) header.d=cyphar.com header.i=@cyphar.com header.a=rsa-sha256 header.s=MBO0001 header.b=I5+PyxN8; dkim-atps=neutral; spf=pass (client-ip=80.241.56.151; helo=mout-p-101.mailbox.org; envelope-from=cyphar@cyphar.com; receiver=lists.ozlabs.org) smtp.mailfrom=cyphar.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=cyphar.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=cyphar.com header.i=@cyphar.com header.a=rsa-sha256 header.s=MBO0001 header.b=I5+PyxN8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=cyphar.com (client-ip=80.241.56.151; helo=mout-p-101.mailbox.org; envelope-from=cyphar@cyphar.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 13286 seconds by postgrey-1.37 at boromir; Mon, 13 Jul 2026 18:34:07 AEST
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bit raw public key) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gzG1q41cRz2xlv
	for <linux-erofs@lists.ozlabs.org>; Mon, 13 Jul 2026 18:34:06 +1000 (AEST)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4gzG1j24yKz8v1b;
	Mon, 13 Jul 2026 10:34:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyphar.com; s=MBO0001;
	t=1783931641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dQrejtZL2XpWthMXrLnlYMslhFK2mQqBx561esiUod8=;
	b=I5+PyxN82JKgfclxtg+PPrrj2ER91pazH2ZU9kS9r+WEgvik+Ave6jv/pXQYE5Ah8ERFvr
	1pJZCGAYc+jh/3NtWzZk3Vq6NWTDc1Nt7e86bXaBg4GgYN35HYQTgPfKEGIzDpYKWHeOb7
	3APQ1MqxrB4IA/j6A2S6mxyegvBO/J7q/vZSgi9aGG3AX/HA5icZqYx+UbnljeChhjP68J
	XB4Roo7iGoXc6i0txuBdTXMajeriKpAtJTpWySw6io6rjbiFEufNXk4iLOFQ+SufIZRItl
	eamh5OWddIbwoCuevomiiJ8twimwLTsN/F9oPPosbHmIrnUIEiHML+CCgn0ocA==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of cyphar@cyphar.com designates 2001:67c:2050:b231:465::202 as permitted sender) smtp.mailfrom=cyphar@cyphar.com
Date: Mon, 13 Jul 2026 18:33:51 +1000
From: Aleksa Sarai <cyphar@cyphar.com>
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v2] erofs: accept source file descriptor via fsconfig
Message-ID: <2026-07-13-chief-single-carnival-graders-7dI4ue@cyphar.com>
References: <20260711071137.4130824-1-gscrivan@redhat.com>
 <2026-07-13-dandy-better-exposure-wager-9hBmfv@cyphar.com>
 <871pd748kh.fsf@redhat.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7kt63rygclyrr7ul"
Content-Disposition: inline
In-Reply-To: <871pd748kh.fsf@redhat.com>
X-Rspamd-Queue-Id: 4gzG1j24yKz8v1b


--7kt63rygclyrr7ul
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2] erofs: accept source file descriptor via fsconfig
MIME-Version: 1.0

On 2026-07-13, Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index 3040d4cf9b85..7818872ab1e5 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -386,7 +386,6 @@ static void erofs_default_options(struct erofs_sb_inf=
o *sbi)
>  enum {
>  	Opt_user_xattr, Opt_acl, Opt_cache_strategy, Opt_dax, Opt_dax_enum,
>  	Opt_device, Opt_domain_id, Opt_directio, Opt_fsoffset, Opt_inode_share,
> -	Opt_source_fd,
>  };
> =20
>  static const struct constant_table erofs_param_cache_strategy[] =3D {
> @@ -414,7 +413,6 @@ static const struct fs_parameter_spec erofs_fs_parame=
ters[] =3D {
>  	fsparam_flag_no("directio",	Opt_directio),
>  	fsparam_u64("fsoffset",		Opt_fsoffset),
>  	fsparam_flag("inode_share",	Opt_inode_share),
> -	fsparam_fd("source",		Opt_source_fd),
>  	{}
>  };
> =20
> @@ -447,6 +445,14 @@ static int erofs_fc_parse_param(struct fs_context *f=
c,
>  	struct erofs_device_info *dif;
>  	int opt, ret;
> =20
> +	if (strcmp(param->key, "source") =3D=3D 0 &&
> +	    param->type =3D=3D fs_value_is_file) {
> +		if (sbi->dif0.file || fc->source)
> +			return -EINVAL;
> +		sbi->dif0.file =3D get_file(param->file);
> +		return 0;
> +	}
> +
>  	opt =3D fs_parse(fc, erofs_fs_parameters, param, &result);
>  	if (opt < 0)
>  		return opt;

Shortcutting parsing this way is not really idiomatic, the better way is
to create a helper -- in this case you can almost certainly just use
very similar logic to proc_parse_pidns_param() to get something minimal
working.

Defining your own version of "source" in fs_parameter_spec is fine, you
just need to make sure you handle FSCONFIG_SET_STRING properly -- there
are some other examples in the tree you can look at for inspiration
(mostly remote filesystems AFAICS). You could even return -ENOPARAM to
fallback to the basic implementation if that makes it easier for you,
but it would probably be better to handle it all in one place.

> @@ -526,11 +532,6 @@ static int erofs_fc_parse_param(struct fs_context *f=
c,
>  		else
>  			set_opt(&sbi->opt, INODE_SHARE);
>  		break;
> -	case Opt_source_fd:
> -		if (sbi->dif0.file)
> -			return -EINVAL;
> -		sbi->dif0.file =3D get_file(param->file);
> -		break;
>  	}
>  	return 0;
>  }
> @@ -779,6 +780,18 @@ static int erofs_fc_get_tree(struct fs_context *fc)
>  			return PTR_ERR(file);
>  		sbi->dif0.file =3D file;
>  	}
> +	if (!fc->source) {
> +		char *buf, *p;
> +
> +		buf =3D kmalloc(PATH_MAX, GFP_KERNEL);
> +		if (!buf)
> +			return -ENOMEM;
> +		p =3D file_path(file, buf, PATH_MAX);
> +		fc->source =3D kstrdup(IS_ERR(p) ? "(fd)" : p, GFP_KERNEL);
> +		kfree(buf);
> +		if (!fc->source)
> +			return -ENOMEM;
> +	}

And this would also live in the parser helper.

--=20
Aleksa Sarai
Founding Engineer at Amutable
https://www.cyphar.com/

--7kt63rygclyrr7ul
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQS2TklVsp+j1GPyqQYol/rSt+lEbwUCalSi7xsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQKJf60rfpRG+vhwEAiFSYqF08CeLLtVUDLjNb
ncp6rg3QO5mNJp22FzyGYZ8BAL6raaBMvcPxESgSSj//uSKMGbjXxYxTzGzFXiwe
56UG
=Qlfm
-----END PGP SIGNATURE-----

--7kt63rygclyrr7ul--

