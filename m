Return-Path: <linux-erofs+bounces-3022-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 573BC10A1E62
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Mar 2026 10:47:38 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fhL8908NWz2yhP;
	Thu, 26 Mar 2026 21:47:37 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774522056;
	cv=none; b=SEXIBUDPUmsonoxXWNs342a/HCzLx9ZpLzHIcGRFORG4r07N3UthLLIiyOaXKK1FYzZ0TqyxMgtU9dd0L9bvuQKEU+wj06Jq9PtCKdM+Yo0m9PxvcP80LDjCFS/MUkcSzQMRVH1yopvTrWD3ekqEj8d3qYNUox2a1b+puOjPsdjxmicLSeUO/DO8mhJ3SYb4eGPpH/OVivslqm9WKgO3glN5M4iQnQpKeEB2lrJbPu46FLm+W7Airpt5eai+wJGG7tbq0Inm2ddbqzT+Rmh4YiLwveyfEU9xTvoPkZHpmfSAvKUvQ7Z5zjLDgktbLkwrzaoOCpKSmw9P2RoajSYH0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774522056; c=relaxed/relaxed;
	bh=vmw7T0PnOLgxIpELQ9rQpU7AHBZsSNPxjlfKpKQj97s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Nd8HfTIhDyDZQJuOnrsH+1LNfKq4zvYuMQsx0zGskTTMNyyXMmP+bkzyNW6eDBg+fWu6+MEtH9uw6PnZF6eH2KxROx5R8wUP80EulOaS+GEAm5nC421LKfygp7bix5Mzy0B+N6GvbucG0PvQxfeD54FeMOUlaT5elyABMUDPjE70efCsx2tvsFSF7BZdD9JWIlr9uyDnzvsnRotX2opbiNTw8F7whJqsZP9MZvbTJviqkDnsR/GDu7GaL9fBjy+T3MZiz+Pt4x6MVLa+YD+I25DDAE5p1PN05GBmbawxX9yE2HKamV5coBbbtlywksTh2F6y++RtWpVTnYAvjCdfow==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=I4cYYS2t; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=I4cYYS2t; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=I4cYYS2t;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=I4cYYS2t;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fhL881R4hz2yVB
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Mar 2026 21:47:35 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774522053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vmw7T0PnOLgxIpELQ9rQpU7AHBZsSNPxjlfKpKQj97s=;
	b=I4cYYS2tJiXFrnm3Axu9wLRFEOb6APFRem7cAqKgCv9pTvB5lm7uRJjdOOzvSqpD9cigAJ
	xXlNU2s5YQmgWwFp44Xhwb1tHUinidE+q/COmK3nIGScals6rMt5LaMh4QpHziPoZK18ad
	2ZRYIjQh5nEmme7lI/SFHKpgynw/9Ds=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774522053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vmw7T0PnOLgxIpELQ9rQpU7AHBZsSNPxjlfKpKQj97s=;
	b=I4cYYS2tJiXFrnm3Axu9wLRFEOb6APFRem7cAqKgCv9pTvB5lm7uRJjdOOzvSqpD9cigAJ
	xXlNU2s5YQmgWwFp44Xhwb1tHUinidE+q/COmK3nIGScals6rMt5LaMh4QpHziPoZK18ad
	2ZRYIjQh5nEmme7lI/SFHKpgynw/9Ds=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694-jGSoJECHMrekBUYeanVpuA-1; Thu,
 26 Mar 2026 06:47:29 -0400
X-MC-Unique: jGSoJECHMrekBUYeanVpuA-1
X-Mimecast-MFC-AGG-ID: jGSoJECHMrekBUYeanVpuA_1774522046
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 483F218005B2;
	Thu, 26 Mar 2026 10:47:26 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.121])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8E95019560B1;
	Thu, 26 Mar 2026 10:47:19 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Jens Axboe <axboe@kernel.dk>,
	Leon Romanovsky <leon@kernel.org>,
	Steve French <sfrench@samba.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Trond Myklebust <trondmy@kernel.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	linux-mm@kvack.org
Subject: [PATCH 09/26] mm: Make readahead store folio count in readahead_control
Date: Thu, 26 Mar 2026 10:45:24 +0000
Message-ID: <20260326104544.509518-10-dhowells@redhat.com>
In-Reply-To: <20260326104544.509518-1-dhowells@redhat.com>
References: <20260326104544.509518-1-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: QHHo9_tS8muFvFRHbyPX7vVC2lsvQAcz7xUSxzPFCtc_1774522046
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Make readahead store folio count in readahead_control so that the
filesystem can know in advance how many folios it needs to keep track of.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-mm@kvack.org
cc: linux-fsdevel@vger.kernel.org
---
 include/linux/pagemap.h | 1 +
 mm/readahead.c          | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index ec442af3f886..3c3e34e5fe8a 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1361,6 +1361,7 @@ struct readahead_control {
 	struct file_ra_state *ra;
 /* private: use the readahead_* accessors instead */
 	pgoff_t _index;
+	unsigned int _nr_folios;
 	unsigned int _nr_pages;
 	unsigned int _batch_count;
 	bool dropbehind;
diff --git a/mm/readahead.c b/mm/readahead.c
index 7b05082c89ea..53134c9d9fe9 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -292,6 +292,7 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 		if (i == mark)
 			folio_set_readahead(folio);
 		ractl->_workingset |= folio_test_workingset(folio);
+		ractl->_nr_folios++;
 		ractl->_nr_pages += min_nrpages;
 		i += min_nrpages;
 	}
@@ -459,6 +460,7 @@ static inline int ra_alloc_folio(struct readahead_control *ractl, pgoff_t index,
 		return err;
 	}
 
+	ractl->_nr_folios++;
 	ractl->_nr_pages += 1UL << order;
 	ractl->_workingset |= folio_test_workingset(folio);
 	return 0;
@@ -802,6 +804,7 @@ void readahead_expand(struct readahead_control *ractl,
 			ractl->_workingset = true;
 			psi_memstall_enter(&ractl->_pflags);
 		}
+		ractl->_nr_folios++;
 		ractl->_nr_pages += min_nrpages;
 		ractl->_index = folio->index;
 	}
@@ -831,6 +834,7 @@ void readahead_expand(struct readahead_control *ractl,
 			ractl->_workingset = true;
 			psi_memstall_enter(&ractl->_pflags);
 		}
+		ractl->_nr_folios++;
 		ractl->_nr_pages += min_nrpages;
 		if (ra) {
 			ra->size += min_nrpages;


