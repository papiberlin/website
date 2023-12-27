---
layout: post
title: Eltern Resourcen
comments: true
---
Willkommen bei unseren Eltern-Resourcen. Hier sammeln wir Links zu Webseiten, die wir für hilfreich halten. Wenn du eine Webseite kennst, die hier fehlt, dann schreib uns doch [über unser Kontaktformular](/contact).

### Kategorien

{% assign sortedItems = site.data.resource_categories | sort: "title" %}

<ul>
{% for category in sortedItems %}
  <li>
    <a href="/resourcen/{{ category.id }}">
      {{ category.title }}
    </a>
    <p>
    {{ category.description}}
    </p>
  </li>
{% endfor %}
</ul>