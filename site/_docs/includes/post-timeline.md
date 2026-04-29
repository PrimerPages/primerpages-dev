---
title: Post Timeline
category: includes
order: 42
---

This include file generates a timeline of posts with an optional "View all" link at the end. It's designed to be flexible and customizable through various parameters.

## Usage

To use this include in your Jekyll theme, add the following line to your template:

{% raw %}
```liquid
{% include post-timeline.html posts=site.posts %}
```
{% endraw %}

## Parameters

You can customize the behavior of this include by passing the following parameters:

| Parameter    | Default                                      | Description                        |
| ------------ | -------------------------------------------- | ---------------------------------- |
| `posts`      | Required                                     | The posts to display               |
| `index`      | `page.first_page_path`                       | The URL for the "More" link        |
| `limit`      | `page.posts_limit`, `site.paginate`, or `-1` | Number of posts to display         |

Example with parameters:

{% raw %}
```liquid
{% include post-timeline.html posts=site.articles limit=5 index="/articles/" %}
```
{% endraw %}

If the limit is set to a number below 0, all posts will be shown.

### Demo Page

To see `post-timeline.html` in action within the `paginate_timeline` layout, visit our demo page:

[Post Timeline Demo](/demo/timeline){:.btn}

## Functionality

1. The include sets up initial variables based on the provided parameters or fallback values.
2. It sorts the collection by date in reverse order (newest first).
3. It creates a container for the timeline posts.
4. It iterates through the provided posts (limited by `limit` if set) and includes a `post-timeline-card.html` for each post.
5. If there are more posts than the displayed limit, it adds a "More" link at the bottom.

## Dependencies

This include file depends on:

1. `post-timeline-card.html`: Another include file that should define how each post card is displayed.
2. Octicons: The GitHub icon set, used for the chevron-right icon in the "View all" link.

## Customization

To customize the appearance of the timeline:

1. Modify the CSS classes in this file to change the layout and spacing.
2. Edit the `post-timeline-card.html` include to change how individual posts are displayed.
3. Adjust the "View all" link text and styling as needed.

## Notes

- The `posts` parameter must be passed explicitly.
- The `index` parameter is optional. If omitted, the include falls back to `page.first_page_path`.
- The `relative_url` filter is used for the link, which helps generate correct URLs in different site configurations.
- The layout uses responsive design classes (`container-xl`, `p-responsive-blog`, etc.) for optimal display on various screen sizes.
