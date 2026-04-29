---
title: Profile Layout
category: layouts
order: 21
---

The **profile** layout is designed for creating a personal or organizational profile page in your Jekyll site. It provides a structured format to showcase a profile image, bio, social links, blog posts, and repositories.

## Usage

To use the Profile layout in your Jekyll site, create a new file with the following front matter:

```yaml
---
layout: profile
---
```

## Parameters

The Profile layout accepts several parameters in the front matter:

| Parameter     | Default                                             | Description                                                |
| ------------- | --------------------------------------------------- | ---------------------------------------------------------- |
| `layout`      | Required                                            | Must be set to `profile`                                   |
| `style`       | `site.style`                                        | Layout style (`topbar`, `appbar`, `sidebar`, or `stacked`) |
| `user_image`  | `site.user_image` or `site.github.owner.avatar_url` | Site-wide profile image configured in `_config.yml`        |
| `links`       | `site.links`                                        | An array of link card objects                              |
| `posts`       | `site.posts`                                        | Posts to display in the blog section                       |
| `posts_limit` | `site.paginate`                                     | Number of posts to display                                 |

Each link object in the `links` array can have the following properties:

| Property    | Description                                                  |
| ----------- | ------------------------------------------------------------ |
| `name`      | The text to display for the link                             |
| `url`       | The URL the link should point to                             |
| `thumbnail` | A custom image for the link (optional)                       |
| `octicon`   | An Octicon name to display instead of a thumbnail (optional) |

## Functionality

1. Displays a profile section with an image and name.
2. Includes social/profile links if provided.
3. Shows a timeline of blog posts from the specified posts list.
4. Optionally displays repositories if `site.repositories` is enabled.
5. Supports different layout styles (`topbar`, `appbar`, `sidebar`, and `stacked`).

## Example Usage

This example shows a basic Profile page with user information and links:

```yaml
---
layout: profile
style: sidebar
links:
  - name: GitHub
    url: https://github.com/username
    octicon: mark-github
  - name: Twitter
    url: https://twitter.com/username
    octicon: mention
posts: site.posts
posts_limit: 5
---
```

[Live demo](/demo/profile){:.btn}

## Notes

- Ensure all image URLs are correct and accessible.
- Set `user_image` in `_config.yml` if you want to override the default GitHub profile avatar.
- Octicons can be used for simple link icons, or you can provide `thumbnail` images instead.
- The layout is responsive and should work well across different screen sizes.
- Custom styling can be added using additional CSS overrides in your theme.

## Dependencies

This layout may depend on:

1. `masthead.html` include for rendering the profile header.
2. `social.html` include for displaying social links.
3. `post-timeline.html` include for listing blog posts.
4. `repositories.html` include for rendering repositories.

Ensure these dependencies are properly set up in your Jekyll theme for the Profile layout to function correctly.
