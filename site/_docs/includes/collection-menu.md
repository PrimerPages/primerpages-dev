---
title: Collection Menu
category: includes
order: 41
---

The **Collection Menu** include file generates a dropdown navigation menu for a Jekyll collection, grouping items by their `category` field. It is particularly useful for displaying structured documentation, guides, or other content collections.

## Usage

To use this include in your Jekyll theme, add the following line to your template:

{% raw %}
```liquid
{% assign docs_index = site.docs | where_exp: "item", "item.url == '/docs/index.html'" | first %}
{% include collection-menu.html collection=site.docs name="Documentation" index=docs_index id="docs-menu" %}
```
{% endraw %}

## Parameters

| Parameter    | Default                         | Description                                                                     |
| ------------ | ------------------------------- | ------------------------------------------------------------------------------- |
| `collection` | Required                        | The Jekyll collection to display in the menu.                                   |
| `name`       | `index.title` or `"Collection"` | Display name for the collection in the menu header.                             |
| `index`      | None                            | Optional collection index document, used as the main link in the menu header.    |
| `id`         | `collection-menu`               | HTML `id` attribute for the `<details>` element; useful for multiple instances. |

## Example

{% raw %}
```liquid
{% assign tutorials_index = site.tutorials | where_exp: "item", "item.url == '/tutorials/index.html'" | first %}
{% include collection-menu.html collection=site.tutorials name="Tutorials" index=tutorials_index id="tutorials-menu" %}
```
{% endraw %}

## Functionality

1. **Dropdown Menu:**
   - Uses Primer CSS's `details-overlay` pattern to create a dropdown.
   - Clicking the burger icon opens the menu; clicking outside or pressing the close button closes it.

2. **Collection Items Grouped by Category:**
   - The menu groups collection documents by their `category` front matter field.
   - Each category is displayed as a section header.

3. **Current Page Highlighting:**
   - The current page is marked with `aria-current="page"` when its URL matches the menu item.

4. **Optional Index Link:**
   - If `index` is provided, the collection name in the header becomes a link to the index page.
   - If `name` is not provided, the include falls back to `index.title` or `"Collection"`.

## Dependencies

This include relies on:

1. **Primer CSS:** Classes like `details-overlay`, `SelectMenu`, `SideNav` are part of Primer’s styling system.
2. **Octicons:** For the close button icon.
3. **jQuery:** Required for the custom close button behavior.

## Customization

1. **Change Menu Appearance:**
   - Adjust Primer CSS classes like `SideNav`, `SelectMenu`, or `AppHeader-link`.

2. **Adjust Categories:**
   - Ensure your collection items have a `category` field in their front matter for grouping.

3. **Modify Close Behavior:**
   - The script attached to the close button can be adapted or replaced with custom behavior if needed.

## Notes

- The `collection` parameter should be passed explicitly when using this include.
- Pass `index` as a document object, not a string path.
- The `id` parameter allows multiple instances of this menu to coexist on a page without conflicts.
- The `aria-haspopup` and `aria-current` attributes enhance accessibility for the dropdown menu and navigation links.
- Ensure your site includes **Primer CSS** and **jQuery** for proper styling and behavior.

By integrating `collection-menu.html`, you can create a well-structured and accessible collection menu that enhances site navigation.
