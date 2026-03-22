Return-Path: <linux-erofs+bounces-2923-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E5D4FC72AB
	for <linux-erofs@archiver.kernel.org>; Sun, 22 Mar 2026 03:49:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fdj304ytRz2ySb;
	Sun, 22 Mar 2026 14:49:00 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::434" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774151340;
	cv=pass; b=TeQobhhweP5Tt6ZUqB4ShKXD36lKpP4leOCkNMF0MYXHZttK27mCC/Mzn64BY36AZ+3GW3+wll+fXud6xNKfaA24YRPVE77el3Zy4nu8RZUrj3TEySmzXHFmkVmDMrO+0wLD1wVVbhCCnz34JHOFHJC/wmJp7slwPBkFRu6AID/9MCtM4Zlt8EyI2pnWN9dZBbwp6Srvb4XPohT8QZYnW0v49Tpxzv+dwYDg6iN/lePX1Yuo7E0jTW9Rpy3TQimnTt1TG7rXRexiOUlc954YK5QPiXzBUuPqpB7UI5aNyIb02+HqyfuTPxn9wrzO/S5Jo8UHmezAslA/YCvYlwsKwg==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774151340; c=relaxed/relaxed;
	bh=IRdcGTZkkvn0n7pkCOlSmxjFEGUSLk841IU29Vs4hIo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JInmTaXMX4FCCort21/fro2iJrr6ghCipXkfxJsuDBwa/gcbp7iurwK97QPXI8WRVHTRAOnRcDH0uzWVTjtXG15+6VaILm5/JPEkH0pyj31yPLPu7gW5Y0DJhkn56qo3pGXN783d4Kz2XBWT1cbUirSO0zs4HYbBGUkm4yP4RA2JybRKtn/Bk2clsgbXaoOlPiK9OMTdF0vqak941ZgAgK+QZBSyNJ6M/Y0Der+CertYrUpgm0Pug5jiM7qAJftf6LI+h1Vr4rmywEIiZdcRoG2XResCEjpoCxJ+kTnt9715AOi4cR342ymJ9yelwDQ6UnBpkPv4SjvEoZrnIQbN7Q==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=dAsP34FZ; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::434; helo=mail-wr1-x434.google.com; envelope-from=newajay.11r@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=dAsP34FZ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::434; helo=mail-wr1-x434.google.com; envelope-from=newajay.11r@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fdj2y4tCrz2xlr
	for <linux-erofs@lists.ozlabs.org>; Sun, 22 Mar 2026 14:48:57 +1100 (AEDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-43b4915161fso1661723f8f.2
        for <linux-erofs@lists.ozlabs.org>; Sat, 21 Mar 2026 20:48:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774151334; cv=none;
        d=google.com; s=arc-20240605;
        b=Y1R65YTOnA+MFw3nyeFcxJwZXAwmbiolhnINjfCGT5k/VUY1DKOlihtTenqUmeE1QL
         11Wx5ZuPZfPi0dCwGNflw6BtizJqJWD+ahHRpg/YnNtPfkLFOEu3T+rKwnfanG29u/k+
         2eojA3gQUZovWeD1AV7vm/2QhghlA2NeaFC1f3kBZ3qUgWOdClANKIOgQe+1G2rHDRBG
         Zh1lNo5Y8VSxsAeB+iaBDNJfs2FqfD2Sg5MgkKNITkRsXbCMt+zv56as5NGnT0XwV9fb
         vdB7NeOCaCmtAyY9xWy67B0q49CbO3KVQOUrLHv6enST113MKLFRIiVw+p/VWk8UGLcI
         EZig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=IRdcGTZkkvn0n7pkCOlSmxjFEGUSLk841IU29Vs4hIo=;
        fh=h5v5s3sJ8JjoTqamOMCLh4C2o/WjoTYr0jDIbqH17R4=;
        b=STtGN6/WDqngSoSuvalAHNHm4kFc/WZ/HPZSZTKIOcAHDCv2xxL88ELhcFbwYtBtG5
         SKQcMoQ3icRxGKTzIIgpJ0BB0l4kKcf0GXc2OcK0dX1LJKiHSwSIQd4ne5Iiw0yVL4vT
         VN+/kLZQSKdBJyiNDGYfELaNpbysU+fGU1giZ37eHMao8Tjbn3KISeoNCL8ECSKZOWbH
         dokp6ZcJAMfNkxLcVJRHJqU9QJFFMj0o9eSt9RFdCcUwf9fCLBGcjgtZhWCjVSnlgdm2
         rvJzkCwndeIcuMutrBypUd//EES6vpyaqLdhdauJrQodnqOGMG4z9DVXGyW0gZMzlCTJ
         OMJQ==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774151334; x=1774756134; darn=lists.ozlabs.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IRdcGTZkkvn0n7pkCOlSmxjFEGUSLk841IU29Vs4hIo=;
        b=dAsP34FZfmcVV3mLkMgKIVKi/oyQCFToBnShoF9dREgcXGqoilue9difZqRSnrLZsw
         f8fTG7P5Z6Tx6AY/2px+u1G3Ub9XGSZV0R8Dv8TfL7hXJGdQuYo8xiwHu+zfxI0M7BUm
         /6L73ANdeu4IebrCyAeqXWU/xq0Iu8NldHVUoKMC3zxvugZ4zDmcEO64PbU6eKGYFH+b
         DtvMfeRiupzhkPGJXQKG3OzONEiVP8HGsJXMG4JieBs+arSQjMAvuKSai1yTcDSLba4q
         qTK3sxqXf2ToUqo6Z9gkF0prUZrloXI+Ze7j7ggKxW00+9Fv0ITR3uYycjIrJZjemtwL
         Xp7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774151334; x=1774756134;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IRdcGTZkkvn0n7pkCOlSmxjFEGUSLk841IU29Vs4hIo=;
        b=o12DWFEU+IO+l521GUvXwbeprhdxwBBCTmNmTWC2LVJEcYnJ9W1NIv0r6atW+didQU
         H8g8L1nKmkVPv5Ong5xgef08Wqs6P+jHaBfK1rybAwOSnW0zesoC5sVo8jhBZAV3nXB0
         KnR8LcUEPFQU6M6RYOFHKGZfpleW+msf43EY0QyEvz5VNOxsQvU/wJuJt7m6m/PO2Fyq
         3tke064mNDw2EpsIr93Wh96SUvPLvbeIzwGTsKiJhB0We6chpmHBGYixdQ6d63exfd6s
         isZ5pOp0XsYxyJRT+K41TwxkHToanTzdPUAf1g+wO8ZOSaTIbQh1VC/YFxaARVeEzrLh
         rxrQ==
X-Gm-Message-State: AOJu0YxGzujq1ShK02nrEeILhFlk5zHTQxCaS2N+mF01FEveuGxAp1B5
	Fe9m0aXtwZiSiNEB46zdIrypq82FodJSTa6N6UQyNqxsaGGFKeMXZF3X7RShChnci1i65dfZJYu
	PzTZcnKuUEvTZNMaD6LPGfNnjll5oFY6kTkJ6yEA=
X-Gm-Gg: ATEYQzzQKU4mOMhDcf74d7hp6bXlppo3O/l6d//TzgQYnW3YSxoYvSmTSq/Euaeb8SX
	XWhb7bN41QueQyNuiOfMelLmhhpUSUR8ZmISDYgL0lRFbCLBCnLyFgYj8uCabzKil8rrebn+L+P
	esz++pFNLyhx6qczyaunBm46EG+WoJ5EgG1XecGbcPfwcmZKYVfLIBW5hKkjQlN/8x0xod+SxvS
	vs54YceAx6pEUrg7ucPTviCwjJctXmxqMHQ6YlOT29RwVI55PsUWLYrSnWToSIGbwiuJUr/9dFD
	AbjiLDvb7LZB4yGNOxSVQtxqfsusYxdrbdMYs+fL/g==
X-Received: by 2002:a05:6000:40c7:b0:439:ad4a:f40e with SMTP id
 ffacd0b85a97d-43b6427d1b0mr12042032f8f.48.1774151333893; Sat, 21 Mar 2026
 20:48:53 -0700 (PDT)
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
References: <20260321180239.36249-1-ch@vnsh.in>
In-Reply-To: <20260321180239.36249-1-ch@vnsh.in>
From: Ajay Rajera <newajay.11r@gmail.com>
Date: Sun, 22 Mar 2026 09:18:42 +0530
X-Gm-Features: AaiRm51Y7RGjcy1ujtzX-n4BoMGadd5uYGvFuVfjDO6uGHMoDV6wd0wxyB0-upE
Message-ID: <CAMhhD9hYFb0YPu1=pZwf4Ga3_rEKc05Eq_aSo+j-cQd9u2yW2g@mail.gmail.com>
Subject: Re: [PATCH] erofs-utils: mkfs: bound-check s3 passwd_file credentials
To: Vansh Choudhary <ch@vnsh.in>, Gao Xiang <xiang@kernel.org>
Cc: linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"

Hi,
my review: LGTM.
How to test:
To reproduce the crashes locally and check if the patch works on a
system level, you can compile the erofs-utils project and deliberately
pass maliciously sized credential files to it using the --s3 option.
Test Issue 1: Create test1.txt exactly 515 bytes long. Run mkfs.erofs
--s3=127.0.0.1,passwd_file=test1.txt. Without the patch, ASAN will
report a 1-byte OOB write.
Test Issue 2: Create test2.txt with 300 characters, a colon, and 1
character. Run mkfs.erofs --s3=127.0.0.1,passwd_file=test2.txt.
Without the patch, it will trigger a segmentation fault.

On Sat, 21 Mar 2026 at 23:32, Vansh Choudhary <ch@vnsh.in> wrote:
>
> mkfs_parse_s3_cfg_passwd() only checked the total passwd_file size,
> which left two issues in the parser:
>
> - a file exactly as large as the temporary buffer left no room for the
>   trailing NUL byte;
> - either credential could still exceed its destination buffer after the
>   string is split at ':'.
>
> Use sizeof(buf) for the temporary buffer check and reject overlong
> access key or secret key fields before copying them out.
>
> This keeps the existing parsing flow intact while making the bounds
> checks match the actual destination sizes.
>
> Signed-off-by: Vansh Choudhary <ch@vnsh.in>
> ---
>  mkfs/main.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/mkfs/main.c b/mkfs/main.c
> index 58c18f9..eb13aba 100644
> --- a/mkfs/main.c
> +++ b/mkfs/main.c
> @@ -663,7 +663,7 @@ static int mkfs_parse_s3_cfg_passwd(const char *filepath, char *ak, char *sk)
>                 erofs_warn("passwd_file %s should not be accessible by group or others",
>                            filepath);
>
> -       if (st.st_size > S3_ACCESS_KEY_LEN + S3_SECRET_KEY_LEN + 3) {
> +       if (st.st_size >= sizeof(buf)) {
>                 erofs_err("passwd_file %s is too large (size: %llu)", filepath,
>                           st.st_size | 0ULL);
>                 ret = -EINVAL;
> @@ -687,6 +687,12 @@ static int mkfs_parse_s3_cfg_passwd(const char *filepath, char *ak, char *sk)
>         }
>         *colon = '\0';
>
> +       if (strlen(buf) > S3_ACCESS_KEY_LEN ||
> +           strlen(colon + 1) > S3_SECRET_KEY_LEN) {
> +               ret = -EINVAL;
> +               goto err;
> +       }
> +
>         strcpy(ak, buf);
>         strcpy(sk, colon + 1);
>
> --
> 2.43.0
>
>

