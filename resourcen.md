---
layout: post
title: Eltern Ressourcen
comments: true
---
Willkommen bei unseren Eltern Ressourcen. Hier sammeln wir Links zu Webseiten, die wir für hilfreich halten. 
Bis jetzt sind schon {{ site.data.resources | size }} zusammengekommen. Wenn du eine Webseite kennst, die hier fehlt, dann schreib uns doch [über unser Kontaktformular](/contact) oder komm [in unseren Slack-Chat](/pages/slack).

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
