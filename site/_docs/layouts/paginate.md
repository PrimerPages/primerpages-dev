---
title: Paginate Layout
category: layouts
order: 26
---

The **paginate** layout displays paginated posts as cards. It is useful for a traditional blog index where featured posts and standard post cards are shown in a grid.

## Usage

To use the Paginate layout, create an index page for your blog:

```yaml
---
layout: paginate
title: Blog
---
```

## Configuration

Enable Jekyll pagination in `_config.yml`:

```yaml
paginate: 5
paginate_path: "/blog/page/:num"
```

For the example above, the page using `layout: paginate` should live at `blog/index.html`.

## Functionality

1. Renders the page content before the list of posts.
2. Iterates through `paginator.posts`.
3. Uses `post-feature-card.html` for featured posts and the first post in the collection.
4. Uses `post-card.html` for the remaining posts.
5. Adds pagination controls with `paginator_nav.html`.

## Example Usage

```yaml
---
layout: paginate
title: Blog
---
Latest posts from the site.
```

## Demo

[Live demo](/blog/){:.btn}

## Notes

- Use [Paginate Timeline](paginate_timeline.md) if you prefer the timeline-style list instead of cards.
- This layout depends on Jekyll pagination being enabled.
