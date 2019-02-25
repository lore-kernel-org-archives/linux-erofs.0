From: willy@infradead.org (Matthew Wilcox)
Date: Mon, 25 Feb 2019 10:27:54 -0800
Subject: [PATCH for-4.19 1/2] xarray: Replace exceptional entries
In-Reply-To: <20190225175809.13427-1-hsiangkao@aol.com>
References: <20190225155120.GA12525@kroah.com>
 <20190225175809.13427-1-hsiangkao@aol.com>
Message-ID: <20190225182754.GF2496@bombadil.infradead.org>

On Tue, Feb 26, 2019@01:58:08AM +0800, Gao Xiang wrote:
> +/**
> + * xa_tag_pointer() - Create an XArray entry for a tagged pointer.
> + * @p: Plain pointer.
> + * @tag: Tag value (0, 1 or 3).
> + *
> + * If the user of the XArray prefers, they can tag their pointers instead
> + * of storing value entries.  Three tags are available (0, 1 and 3).
> + * These are distinct from the xa_mark_t as they are not replicated up
> + * through the array and cannot be searched for.
> + *
> + * Context: Any context.
> + * Return: An XArray entry.
> + */
> +static inline void *xa_tag_pointer(void *p, unsigned long tag)
> +{
> +	return (void *)((unsigned long)p | tag);
> +}

I think we have to diverge from upstream here.  Part of the original
commit is changing the format of internal & exceptional entries to give
us an extra bit.  This implementation of xa_tag_pointer would transform
a pointer tagged with value 1 into an internal pointer, which would
break the radix tree.

I would suggest:

+/**
+ * xa_tag_pointer() - Create an XArray entry for a tagged pointer.
+ * @p: Plain pointer.
+ * @tag: Tag value (0 or 1).
+ *
+ * If the user of the XArray prefers, they can tag their pointers instead
+ * of storing value entries.  Two tags are available (0 and 1).
+ * These are distinct from the xa_mark_t as they are not replicated up
+ * through the array and cannot be searched for.
+ *
+ * Context: Any context.
+ * Return: An XArray entry.
+ */
+static inline void *xa_tag_pointer(void *p, unsigned long tag)
+{
+	BUG_ON(tag > 1);
+	return (void *)((unsigned long)p | (tag << 1));
+}

xa_untag_pointer() and xa_pointer_tag() will need corresponding changes.
